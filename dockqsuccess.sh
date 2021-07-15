#!/bin/bash
#----------------------------------------
#7/14/2021, Daniel Fu, Initial Version
#Calculates success rates from ranked models from ZDOCK for CAPRI criteria of Medium or High accuracy
#----------------------------------------

version="$1"
sampling="$2"
blocking="$3"

if [[ $1 = "-h" ]] || [[ $1 = "" ]]; then
    echo $'USAGE: dockqsuccess {VERSION} {SAMPLING} {BLOCKING}'
    exit 1
elif [[ "$#" -ne 3 ]]; then
    echo "Illegal number of parameters. Try 'dockqsuccess.sh -h' for more information."
    exit 1
fi

inpath="/piercehome/daniel/67_scoring/dockq_commands"

let complex_hits=0
nums_cg=(
1
2
2
4
6
9
13
20
31
48
74
115
176
271
417
642
988
1520
2340
3600
)
nums_fg=(
1
2
4
6
10
18
32
57
100
178
316
562
1000
2000
3556
6402
11525
20744
37340
54000
)

if [[ $sampling = "cg" ]]; then
    nums=("${nums_cg[@]}")
    cap=3600
elif [[ $sampling = "fg" ]]; then
    nums=("${nums_fg[@]}")
    cap=54000
else
    echo "Invalid sampling. Use cg or fg."
    exit 1
fi

let success_counter=0
first_success=()
for comp in $(cat "$inpath/list.txt")
do
    for ((i=1;i<=$cap;i++)); do
        file="$inpath/$comp/dockq_${version}_${sampling}_${blocking}/dockq.$i"
        if [[ ! -f $file ]]; then
            echo "$file not found!"
	else
            rating=`grep "CAPRI" $file | tail -2 | head -1 | sed 's/CAPRI //'`
            if [[ "$rating" = "Medium" ]] || [[ "$rating" = "High" ]]; then
                let complex_hits++
                first_success[${#first_success[@]}]=$i
                break
            fi
        fi
    done
done

for ceiling in "${nums[@]}"; do
    let n=0
    for j in "${first_success[@]}"; do
        if (( $j <= $ceiling )); then
            let n++
        fi
    done
    rate=$(bc -l <<< "($n/67)*100")
    echo -e "$ceiling\t$n\t$rate%" >> ~/successrate_${version}_${sampling}_${blocking}.txt
done