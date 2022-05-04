#!/bin/sh

uptime -p | sed -e 's:up : :g' -e 's:day*.:d:g' -e 's:hour*.:h:g' -e 's:minute*.:m:g'
