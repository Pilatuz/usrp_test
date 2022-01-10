#!/bin/bash

for center_freq in 50e6 1e9 2e9 3e9; do
    for tx_gain in 10 20 30 40 50; do
        for rx_gain in 10 20 30 40 50; do
            echo "XXX running F0=$center_freq TX=$tx_gain RX=$rx_gain ..."
            CENTER_FREQ=$center_freq RX_GAIN=$rx_gain TX_GAIN=$tx_gain python sine_rx.py &
            grc_pid=$!
            sleep 20s
            echo "XXX killing #$grc_pid ..."
            kill $grc_pid
            sleep 10s
        done
    done
done
