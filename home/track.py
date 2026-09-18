#!/usr/bin/env python3
from dataclasses import dataclass
from typing import Dict, List, Tuple
import sqlite3
from argparse import ArgumentParser
import os
import time
import functools
import math
from datetime import datetime, date, timedelta
import requests

VERSION = "0.0.1"

args = None

@dataclass
class Daydata:
    amount: timedelta
    active: bool

def setup_args():
    home = os.environ.get("HOME", "~/")
    parser = ArgumentParser(prog="track.py")
    parser.add_argument("--db",type=str, 
                        default=os.path.join(home, ".worktimes/track.db"),
                        help="db file path", required=False)
    parser.add_argument("--version",action="store_true")
    parser.add_argument("action", nargs='*', type=str)
    return parser.parse_args()

def setup_con(db: str) -> sqlite3.Connection:
   return sqlite3.connect(db)

def init_database(conn: sqlite3.Connection):
    cursor = conn.cursor()
    cursor.execute("CREATE TABLE activity(activity_id integer primary key, name text)")
    cursor.execute("CREATE TABLE times(time_id integer primary key, start integer, end integer, fk_activity integer, foreign key(fk_activity) references activity(activity_id))")
    cursor.execute("create table running(running_id integer primary key, start integer, fk_activity integer, foreign key(fk_activity) references activity(activity_id))")
    cursor.execute("INSERT INTO activity(name) VALUES ('basic')")
    conn.commit()

def secs_to_string(secs: int):
    days = secs // 86400
    hours = (secs := secs % 86400) // 3600
    mins = (secs := secs % 3600) // 60
    secs = secs % 60
    d = f"{days} days, " if days > 0 else "" 
    h = f"{hours} hours, "if hours > 0 else ""
    m = f"{mins} minutes, "if mins > 0 else ""
    return f"{d}{h}{m}{math.floor(secs)} seconds"

def running_seconds(cursor, task) -> timedelta | None:
    res = cursor.execute("select start from running join activity on fk_activity = activity_id where name = ?", (task,))
    if (activity := res.fetchone()) is None:
        return None
    start = activity[0]
    st = datetime.fromtimestamp(start)
    now = datetime.now()
    return (now - st)
    
def day_summary(cursor, date, time_suffix = "today", silent = False) -> Dict[datetime, Dict[str, Daydata]] | None:
    res = cursor.execute("select start, end, name from times join activity on fk_activity = activity_id")
    if (times := res.fetchall()) is None:
        print("Task list still empty")
        return None
    times.sort(key = lambda t: int(t[0]))
    taskdict: Dict[str, Daydata] = {}
    today = datetime.now().date()
    for (start, end, name) in times:
        start = datetime.fromtimestamp(start)
        if date != start.date():
            continue
        end = datetime.fromtimestamp(end)
        amount = end - start
        if name in taskdict:
            taskdict[name].amount += amount
        else:
            taskdict[name] = Daydata(amount, False)
            if date == today:
                am = running_seconds(cursor, name)
                if am is not None:
                    taskdict[name].amount += am
                    taskdict[name].active = True
    if not silent:
        for k in taskdict:
            print ( f"{k} : \n \
                    {secs_to_string(int(taskdict[k].amount.total_seconds()))} {time_suffix}", " - currently running" if taskdict[k].active else "" )
    return {date: taskdict}

def days_summary(cursor,date_from,num_days,time_suffix="this week", silent=False) -> Dict[str, timedelta]:
    totals = {}
    for i in range(0,num_days):
        d = (date_from + timedelta(days=i))
        if not silent:
            print("###### " + d.isoformat() + " ######")
        r = day_summary(cursor, d, time_suffix="", silent=silent)
        if r is not None:
            totals = totals | r
    summary = {}
    for date in totals:
        for key in totals[date]:
            if key in summary:
                summary[key] += totals[date][key].amount
            else:
                summary[key] = totals[date][key].amount
    if not silent:
        print("###### SUMMARY #####")
        for k in summary:
            if k is not None and summary[k] is not None:
                print ( f"{k} : \n \
                        {secs_to_string(int(summary[k].total_seconds()))} {time_suffix}" )
    return summary

def add_minutes(conn: sqlite3.Connection, num: int, date: date, activity: str):
    stamp_start = int(time.mktime(date.timetuple()))
    stamp_end = stamp_start + (60 * num)
    act_id = get_activity_id(conn, activity)
    cursor = conn.cursor()
    cursor.execute("insert into times(start, end, fk_activity) values (?, ?, ?)", (stamp_start, stamp_end, act_id))
    conn.commit()
   
def parse_day(s: str) -> date | None:
    parts = s.split(".")
    if not 0 < len(parts) < 4:
        return None
    try:
        els = functools.reduce(lambda l, st: l + [int(st)], parts, [])
        if len(els) == 1:
            [d] = els
            y = datetime.now().date().year
            m = datetime.now().date().month
        elif len(els) == 2:
            d, m = els
            y = datetime.now().date().year
        else:
            d, m, y = els
    except ValueError:
        return None
    if d < 1 or d > 31 or m < 1 or m > 12 or y < 2000 or y > 3000:
        return None
    return date(year=y, month=m, day=d)

def get_activity_id(conn: sqlite3.Connection, activity: str) -> int:
    cursor = conn.cursor()
    res = cursor.execute("select activity_id from activity where name=?", [(activity)])
    if (act_id := res.fetchone()) is None:
        res = cursor.execute("insert into activity(name) values (?) returning activity_id", [(activity)])
        act_id = res.fetchone() 
        conn.commit()
    return act_id[0]

def parse_comma_list(comma_list: str) -> List[str]:
    return [x.strip() for x in comma_list.strip().split(sep=",")]

def parse_hours(hours: str) -> Tuple[int,int,int] | None: 
    h = hours.strip().split(":")
    if len(h) == 1:
        return (int(hours.strip()), 0, 0)
    elif len(h) == 2:
        return (int(h[0].strip()), int(h[1].strip()), 0)
    elif len(h) == 3:
        return (int(h[0].strip()), int(h[1].strip()), int(h[2].strip()))
    else: 
        return None

def get_holidays(state = "mv") -> List[date] | None:
    holidays = requests.get("https://get.api-feiertage.de?states=mv").json()
    if not holidays["status"] == "success":
        return None
    return [date.fromisoformat(x["date"]) for x in holidays["feiertage"] if int(x[state]) == 1]

def is_holiday(day: date) -> bool:
    holidays = get_holidays()
    if holidays is not None:
        for holiday in holidays:
            if day.isoformat() == holiday.isoformat():
                return True
    return False

def do_balance(cursor: sqlite3.Cursor, start: str, end: str, work: str, vacation: str, hours: str, silent=False):
  begin = parse_day(start)
  end: date| None = parse_day(end)
  work_types = parse_comma_list(work)
  vacation_types = parse_comma_list(vacation)
  day_hours = parse_hours(hours)
  if begin is None or end is None or day_hours is None:
      print("please enter something correct")
      return
  hours: timedelta = timedelta(hours= day_hours[0], minutes= day_hours[1], seconds=day_hours[2])
  days = (end - begin).days
  work_amount = timedelta(0)
  vacation_amount = timedelta(0)
  summary = days_summary(cursor,begin, int(days), silent=True)
  for k in summary:
      if k in work_types:
          work_amount += summary[k]
      elif k in vacation_types:
          vacation_amount += summary[k]
  should_hours = timedelta(0)
  for d in range(0, days):
      day = begin + timedelta(days=d)
      if day.isoweekday() <= 5 and not is_holiday(day):
          should_hours += hours
  should_hours -= vacation_amount
  if not silent:
      if should_hours.total_seconds() > work_amount.total_seconds():
        delta = "\nTo work: ", secs_to_string(int((should_hours - work_amount).total_seconds()))
      else:
        delta = "\nOverhours: ", secs_to_string(int((work_amount - should_hours ).total_seconds()))
      print("Should work: " + secs_to_string(int(should_hours.total_seconds())) +
            "\nhave worked: " + secs_to_string(int(work_amount.total_seconds())) +
            delta)
  return {"should": should_hours, "work": work_amount, "vacation": vacation_amount}

def main():
    global args
    args = setup_args()
    conn = setup_con(args.db)
    cursor = conn.cursor()
    if args.version:
        print(f"Worktime tracker version {VERSION}")
    match args.action:
        case None:
            return
        case ["init"]:
            init_database(conn)
            return
        case ["start", activity]:
            act_id = get_activity_id(conn, activity)
            res = cursor.execute("select running_id from running where fk_activity=?", (act_id,))
            if res.fetchone() is not None:
                print("That Activity is already running! Run 'update' to set another start time or stop the activity with 'stop'")
                conn.close()
                return

            cursor.execute("insert into running(start, fk_activity) values (?,?)", (int(time.time()), act_id) )
            conn.commit()
            return
        case ["running"]:
            res = cursor.execute("select start, name from running join activity on fk_activity = activity_id")
            activities = res.fetchall()
            if len(activities) == 0:
                print("nothing running")
                return
            for (start, name) in activities:
                lt = time.localtime(start)
                started = time.strftime('%d.%m.%y %H:%M:%S', lt)
                st = datetime.fromtimestamp(start)
                now = datetime.now()
                amount = now - st 
                print (f"{name}:\n    started {started}\
                \n        running since {secs_to_string(int(amount.total_seconds()))}")
        case ["stop", activity]:
            res = cursor.execute("select activity_id, start from running join activity on fk_activity = activity_id where name = ?", [activity])
            if (running := res.fetchone()) is None:
                print(f"{activity} is not running at the moment")
                return
            (act_id, start) = running
            cursor.execute("insert into times(start, end, fk_activity) values (?, ?, ?)", [start, int(time.time()), act_id])
            cursor.execute("delete from running where fk_activity = ?", [act_id]) 
            conn.commit()
        case ["list"]:
            res = cursor.execute("select start, end, name from times join activity on fk_activity = activity_id")
            times = res.fetchall()
            if len(times) == 0:
                print("Task list still empty")
                return
            times.sort(key = lambda t: int(t[0]))
            for (start, end, name) in times: 
                lt = time.localtime(start)
                started = time.strftime('%d.%m.%y %H:%M:%S', lt)
                st = datetime.fromtimestamp(start)
                end = datetime.fromtimestamp(end)
                amount = end - st 
                print (f"{name}:\n    started {started}\
                \n        ran for {secs_to_string(int(amount.total_seconds()))}")
        case ["summary", "today"]:
            day_summary(cursor, datetime.now().date())
        case ["summary", "day"]:
            day_summary(cursor, datetime.now().date())
        case ["summary", "yesterday"]:
            yesterday = (datetime.now() - timedelta(days=1)).date()
            day_summary(cursor, yesterday, "yesterday")
        case ["summary", "day", x]:
            d = parse_day(x)
            if x == None:
                print("This is not a correctly formated date. Please use dd.mm.yyyy")
            else:
                day_summary(cursor,d,"on " + str(d))
        case ["summary", x]:
            d = parse_day(x)
            if x == None:
                print("This is not a correctly formated date. Please use dd.mm.yyyy")
            else:
                day_summary(cursor,d,"on " + str(d))
        case ["summary", "week"]:
            d = (datetime.now() - timedelta(days=6)).date()
            days_summary(cursor,d,7)
        case ["summary", "last", x, "days"]:
            try:
                i = int(x)
                d = (datetime.now() - timedelta(days=(i - 1))).date()
                days_summary(cursor,d,i,f"in the last {i} days")
            except ValueError:
                print("Please use a number... example: > track last 6 days")
        case ["summary", "from", x, "to", y]:
            begin = parse_day(x)
            end = parse_day(y)
            if end == None or begin == None:
                print("please enter a valid date")
                return
            days = (end - begin).days
            days_summary(cursor,begin,int(days),f"between {begin.isoformat()} and {end.isoformat()}")
        case ["add", num, "minutes", "to" , to , "on", on]:
            d = parse_day(on)
            if d == None:
                print("Please enter a valid date after on")
                return
            try:
                num = int(num)
            except ValueError:
                print("The number of minutes should be a valid integer number")
                return
            add_minutes(conn, num, d, to)
            conn.close()
        case ["balance", "from", start, "to", end, "where", "work", "is", work, "and", "vacation", "is", vacation, "with", hours, "hours"]: 
            do_balance(cursor, start, end, work, vacation, hours)
        case _:
            print("Unknown command.")

if __name__ == "__main__":
    main()



