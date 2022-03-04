#!/bin/bash

awk -F'\t' '{print $1, $3}' $1_Dealer_schedule
