#!/bin/sh
# n132
for i in `ls -l | grep -v '^d' | awk '{print $9}'`
do
echo "\n\n"
echo "FileName:    "+$i
echo "\n\n"
strings $i | grep $1;
done