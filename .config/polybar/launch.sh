#!/usr/bin/env bash

polybar-msg cmd quit
polybar top 2>&1 | tee -a /tmp/polybar.log & disown
