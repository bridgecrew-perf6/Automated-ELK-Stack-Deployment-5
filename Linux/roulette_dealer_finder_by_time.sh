#!/bin/bash


grep -E '05:00:00.*AM'\|'08:00:00.*AM'\|'02:00:00.*PM'\|08:00:00.*PM\|11:00:00.*PM *$1* >> Dealers_working_during_losses2
 
grep $2 *031* >> Dealers_working_during_losses2

