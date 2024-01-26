#!/usr/bin/env python2

import datetime
import socketserver
import socket
import time
import threading
from dnslib import QTYPE, CNAME, RR, DNSRecord, NS, AAAA, TXT, A

zone = 'oldqmin.lab.'
ttl = 10
fst_addr = '10.0.53.7'
snd_addr = '10.0.53.8'

class QnameminTest(socketserver.BaseRequestHandler):
    def handle(self):
        query = DNSRecord.parse(self.request[0])
        #print("QUERY\n", query)
        qname = str(query.q.qname).lower()
        qnlst = qname.split('.')
        qtype = query.q.qtype
        reply = query.reply()
        raddr = None
        reply.header.bitmap = 0
        reply.header.set_qr(True)
        reply.header.set_aa(True)

        if not qname.endswith(zone):
            pass

        elif qtype == QTYPE.TXT:
            self.handle_txt(reply, qname)

        elif qnlst[0] == 'ns':
            if qname == 'ns.' + zone:
                addr = fst_addr
            else:
                addr = snd_addr

            if qtype == QTYPE.A:
                reply.add_answer(RR(qname, QTYPE.A, ttl = ttl, rdata = A(addr)))
            else: 
                pass # skip AAAA

        elif qtype != QTYPE.NS and qtype != QTYPE.A:
            pass

        # Web page for info
        #elif qtype == QTYPE.A and (qname == zone or qname == 'www.' + zone):
        #    reply.add_answer(RR( qname, QTYPE.A, ttl = 3600, rdata = A('193.10.227.202')))

        elif qnlst[0] != 'ns' and qnlst[0] != 'a':
            raddr = snd_addr
        
        if raddr:
            reply.header.set_aa(False)
            reply.add_auth(RR( qname, QTYPE.NS, ttl = ttl, rdata = NS('ns.' + qname)))
            #reply.add_ar(RR( 'ns.' + qname, QTYPE.AAAA, ttl = ttl, rdata = AAAA(raddr[0])))
            reply.add_ar(RR( 'ns.' + qname, QTYPE.A, ttl = ttl, rdata = A(raddr)))

        print(str(datetime.datetime.now()) + ' ' + str(self.client_address) + ' -> ' + self.addr + ' ' + qname + ' ' + str(qtype) + ' ' + str(raddr))
        #print("REPLY\n", reply)
        return self.request[1].sendto(reply.pack(), self.client_address)

def First(self, reply, qname):
    reply.add_answer(RR( qname, QTYPE.TXT, ttl = ttl, rdata = TXT([ 'NO - QNAME minimisation is NOT enabled on your resolver :(', repr(self.client_address)])))

def Second(self, reply, qname):
    reply.add_answer(RR( qname, QTYPE.TXT, ttl = ttl, rdata = TXT([ 'HOORAY - QNAME minimisation is enabled on your resolver :)!', repr(self.client_address)])))

class ThreadingUDPServer6(socketserver.ThreadingUDPServer):
    address_family = socket.AF_INET6

def server(addr, handle_txt):
    class Handler(QnameminTest): pass
    Handler.handle_txt = handle_txt
    Handler.addr = addr
    return socketserver.ThreadingUDPServer((addr, 53), Handler)

if __name__ == "__main__":
    for s in ( server(fst_addr, First), server(snd_addr, Second) ):
        t = threading.Thread(target=s.serve_forever)
        t.daemon = True
        t.start()
    while 1:
        time.sleep(100)

