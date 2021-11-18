#!/bin/bash
# Prettifier for CPU and RAM Usage
# Dependency: mpstat(sysstat)

cpu=$(py ~/.config/shellexecutor/cpu/parser.py --decimal)
ram=$(free -m | tail -n2 | head -n1 | awk '{print int(($3/$2)*100)}')

echo "  CPU: ${cpu}% RAM: ${ram}%"
