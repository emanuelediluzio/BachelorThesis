#!/usr/bin/env python
import random

from scapy.all import send, get_if_list, get_if_hwaddr
from scapy.all import Ether, IP, TCP

def get_if():
    iface=None 
    for i in get_if_list():
        if "eth0" in i:
            iface=i
            break
    if not iface:
        print("Cannot find eth0 interface")
        exit(1)
    return iface

def main():

    addr = "192.168.1.61"
    iface = "wlan0"
    payload = "--Info--\nCPU Usage:100%;\nTemperature: 90°;\nHumidity: 70%;"

    print("Sending on interface %s to %s" % (iface, str(addr)))
    
    pkt = Ether(src=get_if_hwaddr(iface), dst='ff:ff:ff:ff:ff:ff')
    pkt = IP(dst="192.168.56.101")/TCP(dport=8082, sport=random.randint(49152,65535))/payload
    pkt.show2()
    send(pkt)


if __name__ == '__main__':
    main()

