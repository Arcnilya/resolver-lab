#!/usr/bin/env python2

import datetime
import SocketServer
import socket
import time
import threading
from dnslib import QTYPE, CNAME, RR, DNSRecord, NS, AAAA, TXT, A

zone1 = 'qnamemintest.net.'
zone2 = 'opendane.net.'
ttl = 10
fst_addr = ('2a04:b900:0:100::11', '185.49.141.11')
snd_addr = ('2a04:b900:0:100::12', '185.49.141.12')

class QnameminTest(SocketServer.BaseRequestHandler):
	def handle(self):
		query = DNSRecord.parse(self.request[0])
		qname = str(query.q.qname).lower()
		qnlst = qname.split('.')
		qtype = query.q.qtype
		reply = query.reply()
		reply.header.bitmap = 0
		reply.header.set_qr(True)
		reply.header.set_aa(True)

		if  not qname.endswith(zone1) \
		and not qname.endswith(zone2):
			pass

		elif qtype == QTYPE.TXT:
			self.handle_txt(reply, qname)

		elif qnlst[0] == 'ns':
			if qname == 'ns.' + zone1 \
			or qname == 'ns.' + zone2:
				addr = fst_addr
			else:
				addr = snd_addr

			if self.addr != addr[0] and self.addr != addr[1]:
				reply.header.set_aa(False)

				reply.add_auth(RR( '.'.join(qnlst[1:]), QTYPE.NS, ttl = ttl
						 , rdata = NS(qname)))
				reply.add_ar(RR( qname, QTYPE.AAAA, ttl = ttl
					       , rdata = AAAA(snd_addr[0])))
				reply.add_ar(RR( qname, QTYPE.A, ttl = ttl
					       , rdata = A(snd_addr[1])))
			elif qtype == QTYPE.A:
				reply.add_answer(RR(qname, QTYPE.A, ttl = ttl, rdata = A(addr[1])))
			elif qtype == QTYPE.AAAA:
				reply.add_answer(RR(qname, QTYPE.AAAA, ttl = ttl, rdata = AAAA(addr[0])))

		elif qtype != QTYPE.NS and qtype != QTYPE.A:
			pass

		elif qtype == QTYPE.A \
		and (  qname == zone1 or qname == 'www.' + zone1
		    or qname == zone2 or qname == 'www.' + zone2):
			reply.add_answer(RR( qname, QTYPE.A, ttl = 3600
			                 , rdata = A('193.10.227.202')))

		elif qtype == QTYPE.NS \
		and (qname == zone1 or qname == zone2):
			reply.add_answer(RR( qname, QTYPE.NS, ttl = ttl
					   , rdata = NS('ns.' + qname)))
			reply.add_ar(RR( 'ns.' + qname, QTYPE.AAAA, ttl = ttl
				       , rdata = AAAA(fst_addr[0])))
			reply.add_ar(RR( 'ns.' + qname, QTYPE.A, ttl = ttl
				       , rdata = A(fst_addr[1])))

		elif qtype == QTYPE.NS \
		and (self.addr == snd_addr[0] or self.addr == snd_addr[1]):
			reply.add_answer(RR( qname, QTYPE.NS, ttl = ttl
					   , rdata = NS('ns.' + qname)))
			reply.add_ar(RR( 'ns.' + qname, QTYPE.AAAA, ttl = ttl
				       , rdata = AAAA(snd_addr[0])))
			reply.add_ar(RR( 'ns.' + qname, QTYPE.A, ttl = ttl
				       , rdata = A(snd_addr[1])))

		elif qnlst[0] == '_' \
		and (self.addr == snd_addr[0] or self.addr == snd_addr[1]):
			pass

		elif qnlst[0] == '_' and qname[2:] != zone1 and qname[2:] != zone2:
			reply.header.set_aa(False)
			qname = qname[2:]
			reply.add_auth(RR( qname, QTYPE.NS, ttl = ttl
					 , rdata = NS('ns.' + qname)))
			reply.add_ar(RR( 'ns.' + qname, QTYPE.AAAA, ttl = ttl
				       , rdata = AAAA(snd_addr[0])))
			reply.add_ar(RR( 'ns.' + qname, QTYPE.A, ttl = ttl
				       , rdata = A(snd_addr[1])))

		elif qnlst[0] != 'ns' and qnlst[0] != 'a' and qnlst[0] != '_':
			reply.header.set_aa(False)
			reply.add_auth(RR( qname, QTYPE.NS, ttl = ttl
					 , rdata = NS('ns.' + qname)))
			reply.add_ar(RR( 'ns.' + qname, QTYPE.AAAA, ttl = ttl
				       , rdata = AAAA(snd_addr[0])))
			reply.add_ar(RR( 'ns.' + qname, QTYPE.A, ttl = ttl
				       , rdata = A(snd_addr[1])))

		print(str(datetime.datetime.now()) + ' ' + str(self.client_address) + ' -> ' + self.addr + ' ' + qname + ' ' + str(qtype))
		return self.request[1].sendto(reply.pack(), self.client_address)

def First(self, reply, qname):
	reply.add_answer(RR( qname, QTYPE.TXT, ttl = ttl, rdata = TXT(
	    [ 'NO - QNAME minimisation is NOT enabled on your resolver :('
	    , repr(self.client_address)])))

def Second(self, reply, qname):
	reply.add_answer(RR( qname, QTYPE.TXT, ttl = ttl, rdata = TXT(
	    [ 'HOORAY - QNAME minimisation is enabled on your resolver :)!'
	    , repr(self.client_address)])))

class ThreadingUDPServer6(SocketServer.ThreadingUDPServer):
	address_family = socket.AF_INET6

def server(addr, handle_txt):
	class Handler(QnameminTest): pass
	Handler.handle_txt = handle_txt
	Handler.addr = addr
	return (ThreadingUDPServer6 if ':' in addr
	   else SocketServer.ThreadingUDPServer)((addr, 53), Handler)

if __name__ == "__main__":

	for s in ( server(fst_addr[0], First) , server(fst_addr[1], First)
	         , server(snd_addr[0], Second), server(snd_addr[1], Second)):
		t = threading.Thread(target=s.serve_forever)
		t.daemon = True
		t.start()
	while 1:
		time.sleep(100)
