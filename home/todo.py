#!/usr/bin/python3
from argparse import ArgumentParser
import sqlite3
import os
from datetime import datetime


def setup_args():
    home = os.environ.get("HOME", "~/")
    parser = ArgumentParser(prog="todo.py")
    parser.add_argument("--db", type=str,
                        default=os.path.join(home, ".todo/todo.db"))
    parser.add_argument("action", nargs='*', type=str)
    return parser.parse_args()

def init_db(conn: sqlite3.Connection):
    cur = conn.cursor()
    cur.execute("CREATE TABLE todos(todo_id integer primary key, name text, description text, date text, complete text, priority float)")
    conn.commit()


def add_task(conn: sqlite3.Connection, name: str, description = None, priority: float = 0.0, date: datetime | None = None):
    cur = conn.cursor()
    stamp = datetime.now().isoformat() if date == None else date.isoformat()
    r = cur.execute("select * from todos where name = ? and complete = 'False'", (name,))
    if len(r.fetchall()) != 0:
        raise ValueError("Task already exists and is not completed")
    cur.execute("insert into todos(name, date, description, priority, complete) values (?,?,?,?, 'False')", (name, stamp, description, priority))
    conn.commit()

def print_task(name, date, description: str, priority, complete): 
    if complete == False:
        print(f" -- {priority} {name}: started {datetime.fromisoformat(date).strftime('%d.%m.%Y %H:%M')}")
    else:
        print(f" -- {priority} {name}: completed {datetime.fromisoformat(complete).strftime('%d.%m.%Y %H:%M')}" )
    for d in [" "*4 + x for x in description.split("\n")]:
        print(d)

def list_tasks(conn: sqlite3.Connection, list_incomplete = True, list_complete = False):
    cur = conn.cursor()

    if list_incomplete and not list_complete:
        res = cur.execute("Select name, date, description, priority, complete from todos where complete = 'False'")
    elif list_complete and not list_incomplete:
        res = cur.execute("Select name, date, description, priority, complete from todos where complete != 'False'")
    else:
        res = cur.execute("Select name, date, description, priority, complete from todos")

    data = res.fetchall()
    for (name, date, description, priority, complete) in data:
        print_task(name, date, description, priority, complete=False if complete == "False" else complete)
        print("")

def get_description():
    print("Enter a description and terminate with an empty line.")
    res = []
    while True:
        data = input()
        if data.isspace() or data == "":
            break
        res.append(data)
    return "\n".join(res)

def finish_task(conn: sqlite3.Connection, task):
    cur = conn.cursor()
    res = cur.execute("Select name from todos where name = ? and complete = 'False'", (task,))
    r = res.fetchall()
    if len(r) > 1:
        raise ValueError("Multiple tasks with the same name!")
    if len(r) == 1:
        cur.execute("update todos set complete = ? where name = ?", (datetime.now().isoformat(), task,))
        conn.commit()
        print("Finished task '", task, "' successfully!")
    else:
        print("There's no such task...")

def main():
    args = setup_args()
    conn = sqlite3.connect(args.db)
    print("ACTION: ", args.action)
    match args.action:
        case None:
            print("No action...")
            return

        case ["add", name]:
            add_task(conn, name, description=get_description())

        case ["add", name, priority]:
            try:
                p = float(priority)
            except:
                print("Please specify a priority that is a number")
                return
            add_task(conn, name, description=get_description(), priority=p)

        case ["list"]:
            list_tasks(conn)

        case ["list", "complete"]:
            list_tasks(conn, list_incomplete=False, list_complete=True)

        case ["list", "all"]:
            list_tasks(conn, list_incomplete=True, list_complete=True)

        case ["finish", task]:
            finish_task(conn, task)

        case ["init"]:
            init_db(conn)

        
if __name__ == "__main__":
    main()
