{ config, lib, pkgs, modulesPath, ... }: {
  networking.interfaces.tap-agent = {
    virtual = true;
    virtualType = "tap";
    virtualOwner = "elias";
    ipv4.addresses = [{ address = "192.168.77.1"; prefixLength = 24; }];
  };

  networking.nat = {
    enable = true;
    internalInterfaces = [ "tap-agent" ];
    externalInterface = "wlp1s0";         # your uplink
  };

  networking.nftables.enable = true;
  networking.nftables.tables.agentvm = {
  family = "inet";
  content = ''
    set blocked4 {
      type ipv4_addr
      flags interval
      elements = {
        0.0.0.0/8, 10.0.0.0/8, 100.64.0.0/10, 127.0.0.0/8, 169.254.0.0/16,
        172.16.0.0/12, 192.0.0.0/24, 192.0.2.0/24, 192.168.0.0/16,
        198.18.0.0/15, 198.51.100.0/24, 203.0.113.0/24,
        224.0.0.0/4, 240.0.0.0/4
      }
    }

    chain input {
      type filter hook input priority -10; policy accept;
      iifname "tap-agent" drop                       # guest cannot talk to the host at all
    }

    chain forward {
      type filter hook forward priority -10; policy accept;
      oifname "tap-agent" ct state new drop          # no new inbound connections to the guest
      iifname "tap-agent" ip saddr != 192.168.77.2 drop
      iifname "tap-agent" meta nfproto ipv6 drop     # NAT is IPv4-only; don't forward IPv6
      iifname "tap-agent" oifname != "wlp1s0" drop   # only out via the uplink, not VPNs/bridges
      iifname "tap-agent" ip daddr @blocked4 drop
    }
  '';
};
}
