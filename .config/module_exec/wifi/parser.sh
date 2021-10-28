#!/bin/bash
# Simple Wifi Parser
# Dependency: nmcli

wifi_name=$(nmcli con show --active | tail -n1)

if [[ $wifi_name = "" ]]; then
	if [[ $1 = "--simple" ]]; then
		echo "睊"
	else
		echo "睊  Not connected"
	fi
else
	if [[ $1 = "--simple" ]]; then
		echo "直"
	else
		echo "直  $(nmcli -g name con | head -n1)"
	fi
fi
