#!/bin/bash
#----------------------------------------
#6/23/2021, Daniel Fu, Initial Version
#Inserts TER keyword after each chain in .pdb for SwarmDock job requests in [name]_sd.pdb (workhorse)

#6/25/2021, Daniel Fu
#Uses byte position instead of columns delimited by spaces
#----------------------------------------

inname=`echo $1 | sed 's/.pdb//'`
outname="${inname}_sd.pdb"
outpath="/Users/daniel/Downloads/unbound_clean_sd/"

#Parse thru each line, when fifth item is chain and changes add "TER"

awk 'BEGIN { getline; cmp=substr($0,22,1); print $0 } cmp!=substr($0,22,1) { print "TER\n" $0 } (substr($0,22,1) ~ /[[:space:]]/) && (cmp!=substr($0,22,1)) { print $0 } cmp==substr($0,22,1) { print $0 }  substr($0,22,1)==""{ print $0 } { cmp=substr($0,22,1); }' $1 > $outname

tailline=`tail -1 $outname`

#If has "END", add "TER" before it; otherwise add "TER" in last line

if [ "$tailline" = "END" ]; then
    totalline=`grep -c -v END $outname`
    head -$totalline $outname > temp.txt
    mv temp.txt $outname
    echo "TER" >> $outname
    echo "END" >> $outname
else
    echo "TER" >> $outname
fi

mv $outname $outpath
