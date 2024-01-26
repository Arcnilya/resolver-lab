#!/bin/bash
ip address add 10.0.53.7/24 dev eth0
ip address add 10.0.53.8/24 dev eth0
python3 old/qmin.py
