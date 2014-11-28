#!/bin/sh -e

numRecords=$1

test -e relation_$numRecords.txt && rm -f relation_$numRecords.txt
touch relation_$numRecords.txt

`head -$numRecords relation.txt >> relation_$numRecords.txt`

fileName=relation_$numRecords.txt

test -e users_$numRecords.txt && rm -f users_$numRecords.txt
touch users_$numRecords.txt
test -e products_$numRecords.txt && rm -f products_$numRecords.txt
touch products_$numRecords.txt


for line in `cat $fileName`; do
     userId=`echo $line | cut -d, -f1`
    `grep -e $userId users.txt >> users_$numRecords.txt`    
    
    productId=`echo $line | cut -d, -f2`
    `grep -e $productId products.txt >> products_$numRecords.txt`
done


`cat users_$numRecords.txt | sort | uniq > users_$numRecords_temp.txt`
`cat products_$numRecords.txt | sort | uniq > products_$numRecords_temp.txt`

rm -f users_$numRecords.txt
rm -f products_$numRecords.txt

mv users_$numRecords_temp.txt users_$numRecords.txt
mv products_$numRecords_temp.txt products_$numRecords.txt
