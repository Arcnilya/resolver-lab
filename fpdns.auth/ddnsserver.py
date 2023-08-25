#!/usr/bin/python3
"""
https://gist.github.com/pklaus/b5a7876d4d2cf7271873
LICENSE http://www.apache.org/licenses/LICENSE-2.0
"""

import argparse
import datetime
import sys
import time
import threading
import traceback
import socketserver
import struct
import json
try:
    from dnslib import *
except ImportError:
    print("Missing dependency dnslib: <https://pypi.python.org/pypi/dnslib>. Please install it with `pip`.")
    sys.exit(2)


class DomainName(str):
    def __getattr__(self, item):
        return DomainName(item + '.' + self)

this_zone = 'fpdns.auth'
D = DomainName(this_zone + '.')
IP = '10.0.53.6'
TTL = 60 * 5

soa_record = SOA(
    mname=D.ns1,  # primary name server
    rname=D.jonamagn,  # email of the domain administrator
    times=(
        201307231,  # serial number
        60 * 60 * 1,  # refresh
        60 * 60 * 3,  # retry
        60 * 60 * 24,  # expire
        60 * 60 * 1,  # minimum
    )
)
ns_records = [NS(D.ns1), NS(D.ns2)]
records = {
    D: [A(IP), AAAA((0,) * 16), soa_record] + ns_records,
    D.ns1: [A(IP)],  
    D.ns2: [A(IP)],
    D.foo: [A(IP)],
    D.jonamagn: [CNAME(D)],
}

def csv_print(data):
    #if "-" in data['nonce']:
    print(",".join([
        data['nonce'],
        data['src'],
        data['signature'],
        data['flags'],
        data['subnet'],
        data['edns']]))


def parse_and_print(req, client_address, time):
    #print(req)
    d = dict.fromkeys(['qname', 'qtype', 'flags', 'edns', 'subnet', 'nonce'])
    d['time'] = time
    d['src'] = client_address[0]
    d['qname'] = str(req.q.qname).lower()
    d['qtype'] = QTYPE[req.q.qtype]
    qnlst = d['qname'].split('.')
    d['signature'] = str(len(qnlst)-1) + d['qtype']
    d['nonce'] = qnlst[-4] if len(qnlst) > 3 else ""

    d['flags'] = ""
    d['edns'] = ""
    d['subnet'] = ""
    for line in str(req).splitlines():
        if line.startswith(";; flags:"):
            d['flags'] = line.replace(";; flags:","").split(";")[0].lstrip()
        if line.startswith("; EDNS: "):
            d['edns'] = d['edns'].lstrip() + ", " + line.replace("; EDNS: ", "").replace(";", ",")
        if line.startswith("; SUBNET:"):
            d['subnet'] = line.split()[2]
    csv_print(d)
    #print(json.dumps(d, indent=2))


def dns_response(data, client_address, time):
    request = DNSRecord.parse(data)
    parse_and_print(request, client_address, time)
    reply = DNSRecord(DNSHeader(id=request.header.id, qr=1, aa=1, ra=1), q=request.q)
    qname = request.q.qname
    qn = str(qname)
    qtype = request.q.qtype
    qt = QTYPE[qtype]
    if qn.lower() == D or qn.lower().endswith('.' + D):
        if qt not in ['NS','AAAA','DNSKEY','TXT','SRV','SOA','MX','HTTPS','CNAME','CAA','ANY']:
            reply.add_answer(RR(rname=qname, rtype=getattr(QTYPE, qt), rclass=1, ttl=TTL, rdata=A(IP)))
        #reply.add_answer(*RR.fromZone(f"{qn} {TTL} {qt} {A(IP)}"))

        for rdata in ns_records:
            reply.add_ar(RR(rname=D, rtype=QTYPE.NS, rclass=1, ttl=TTL, rdata=rdata))

        reply.add_auth(RR(rname=D, rtype=QTYPE.SOA, rclass=1, ttl=TTL, rdata=soa_record))

    #print("REPLY\n", reply)
    return reply.pack()


class BaseRequestHandler(socketserver.BaseRequestHandler):

    def get_data(self):
        raise NotImplementedError

    def send_data(self, data):
        raise NotImplementedError

    def handle(self):
        now = datetime.datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S.%f')
        try:
            data = self.get_data()
            self.send_data(dns_response(data, self.client_address, now))
        except Exception:
            traceback.print_exc(file=sys.stderr)


class UDPRequestHandler(BaseRequestHandler):

    def get_data(self):
        # https://github.com/apache/trafficserver/issues/5793#issuecomment-524807080
        return self.request[0] #.strip()

    def send_data(self, data):
        return self.request[1].sendto(data, self.client_address)


def main():
    parser = argparse.ArgumentParser(description='Start a DNS implemented in Python.')
    parser = argparse.ArgumentParser(description='Start a DNS implemented in Python. Usually DNSs use UDP on port 53.')
    parser.add_argument('--port', default=53, type=int, help='The port to listen on.')
    
    args = parser.parse_args()
    servers = []
    servers.append(socketserver.ThreadingUDPServer(('', args.port), UDPRequestHandler))

    for s in servers:
        thread = threading.Thread(target=s.serve_forever)  # that thread will start one more thread for each request
        thread.daemon = True  # exit the server thread when the main thread terminates
        thread.start()

    try:
        while 1:
            time.sleep(1)
            sys.stderr.flush()
            sys.stdout.flush()

    except KeyboardInterrupt:
        pass
    finally:
        for s in servers:
            s.shutdown()

if __name__ == '__main__':
    main()


