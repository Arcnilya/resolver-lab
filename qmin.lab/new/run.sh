#!/bin/bash
ip address add 10.0.53.9/24 dev eth0
ip address add 10.0.53.10/24 dev eth0
python3 new/qmin.py
