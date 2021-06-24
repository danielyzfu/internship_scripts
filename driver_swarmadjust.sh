#!/bin/bash
#----------------------------------------
#6/23/2021, Daniel Fu, Initial Version
#Inserts TER keyword after each chain in .pdb for SwarmDock job requests in [name]_sd.pdb (driver)
#----------------------------------------

inpath="/Users/daniel/Downloads/unbound_clean/*"

echo "Creating files..."

n=0 #Counter
for f in $inpath
do 
    #echo "$f"
    ./swarmadjust.sh $f
    let n++
done
echo "${n} files created"