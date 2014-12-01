import json
import pprint 
import os
import fileinput 
import glob
import hashlib


# This file is to parse the non-recommended reviews from Yelp-Dataset

non_rec = {}

print "starting parsing the reviews"
users_nrec = open("C:\\Users\\raghuar\\Documents\\GitHub\\Mining\\Dataset-Norm\\Rec-NonRec\\users_nrec.txt","w")
users_rec = open("C:\\Users\\raghuar\\Documents\\GitHub\\Mining\\Dataset-Norm\\Rec-NonRec\\users_rec.txt","w")
prods = open("C:\\Users\\raghuar\\Documents\\GitHub\\Mining\\Dataset-Norm\\Rec-NonRec\\products_new.txt","w")
relation = open("C:\\Users\\raghuar\\Documents\\GitHub\\Mining\\Dataset-Norm\\Rec-NonRec\\relation_rec.txt","w")
relationnrec = open("C:\\Users\\raghuar\\Documents\\GitHub\\Mining\\Dataset-Norm\\Rec-NonRec\\relation_nrec.txt","w")
users_nrec.truncate()
users_rec.truncate()
prods.truncate()
relation.truncate()
relationnrec.truncate()

users_nrec.write('USER_ID,USER_NAME\n')
users_rec.write('USER_ID,USER_NAME\n')
prods.write('PROD_ID,PROD_NAME\n')
relation.write("USER_ID,PROD_ID,RATING,AVG_RAT,USEFUL,DUP_CNT\n")
relationnrec.write("USER_ID,PROD_ID,RATING,AVG_RAT,USEFUL,DUP_CNT\n")

usersnrec = {}
usersrec = {}
avgrat = {}

urcount = 0
unrcount = 0
pcount = 0
avg_rat = 0
useful = 0
usefulH = 100
dup_cnt = 10
dup_cntH = 0
# files = glob.glob('C:\\Users\\raghuar\\Documents\\GitHub\\Mining\\Dataset-Norm\\Json\\*.txt')
files = glob.glob('C:\\Users\\raghuar\\Documents\\GitHub\\Json\\*.txt')
# for filename in os.listdir('C:\\Users\\raghuar\\Documents\\GitHub\\Mining\\Dataset-Norm\\'):
	# print filename.split('.')

with open("C:\\Users\\raghuar\\Documents\\GitHub\\Mining\\Dataset-Norm\\Rec-NonRec\\averageRatings.txt","r") as avr:
	for line in avr:
		prodA = line.split(',')
		avgrat[prodA[0]] = prodA[1].split()
avr.close()

for filenames in files[:]:	
	# with open("C:\\Users\\raghuar\\Documents\\GitHub\\Mining\\Dataset-Norm\\zpizza.txt","r") as file:
	pcount = pcount + 1
	# if pcount == 5:
		# break
	file_name = filenames.split('\\')
	length = len(file_name)
	name=file_name[length-1].split('.')
	prods.write(''+hashlib.sha1(str(name[0])).hexdigest()+',\''+name[0]+'\'\n')
	# print name[0]+"\n"
	with open(filenames,"r") as file:
		for line in file:
			if len(line) == 0:
				continue
			data = json.loads(line)
			pKey = hashlib.sha1(str(name[0])).hexdigest()
			# Non-Recommended Users List #
			newdata = data["nonReccomended"]
			for w in newdata[:]:
				hKey = hashlib.sha1(str(w['Name'].encode('utf-8'))).hexdigest()
				usersnrec[hKey] = w['Name'].encode('utf-8');
				users_nrec.write(''+hKey+',\''+w['Name'].encode('utf-8')+'\'\n')
				relationnrec.write(''+hKey+','+pKey+','+w['Rating'].encode('utf-8')+','+avgrat[pKey][0]+','+`useful`+','+`dup_cnt`+'\n')
			
			# Recommended Users List #
			newdata = data["Reccomended"]
			count = 0
			for w in newdata[:]:
				hKey = hashlib.sha1(str(w['Name'].encode('utf-8'))).hexdigest()
				usersrec[hKey] = w['Name'].encode('utf-8');
				users_rec.write(''+hKey+',\''+w['Name'].encode('utf-8')+'\'\n')
				relation.write(''+hKey+','+pKey+','+w['Rating'].encode('utf-8')+','+avgrat[pKey][0]+','+`usefulH`+','+`dup_cntH`+'\n')

				
for k in usersnrec.keys():
	users_nrec.write(""+k+",\'"+usersnrec[k]+"\'\n")

for k in usersrec.keys():
	users_rec.write(""+k+",\'"+usersrec[k]+"\'\n")

print "completed the parsing..!"
file.close()
users_nrec.close()
users_rec.close()
prods.close()
relation.close()
relationnrec.close()

