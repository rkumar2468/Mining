import json
import pprint 
import os
import fileinput 
import glob
import hashlib


# This file is to parse the non-recommended reviews from Yelp-Dataset and calculate the average ratings for each product.

print "starting parsing the reviews for average ratings calculation..!"
prods = open("C:\\Users\\raghuar\\Documents\\GitHub\\Mining\\Dataset-Norm\\Rec-NonRec\\averageRatings.txt","w")
prods.truncate()

prods.write('PROD_ID,AVG_RATING\n')

avgrat = {}
key = ''
files = glob.glob('C:\\Users\\raghuar\\Documents\\GitHub\\Json\\*.txt')

for filenames in files[:]:	
	file_name = filenames.split('\\')
	length = len(file_name)
	name=file_name[length-1].split('.')
	rcount = 0
	key = hashlib.sha1(str(name[0])).hexdigest()
	avgrat[key] = 0
	with open(filenames,"r") as file:
		for line in file:
			if len(line) == 0:
				continue
			data = json.loads(line)
			newdata = data["nonReccomended"]
			for w in newdata[:]:
				rcount = rcount + 1
				avgrat[key] = avgrat[key] + float(w['Rating'].encode('utf-8'))
			
			newdata = data["Reccomended"]
			for w in newdata[:]:
				rcount = rcount + 1
				avgrat[key] = avgrat[key] + float(w['Rating'].encode('utf-8'))
		if rcount != 0:
			avgrat[key] = avgrat[key] / rcount	
		# else:
			# print name[0]+"\n"
		avgrat[key] = "{0:.2f}".format(round(avgrat[key],2));
		
for k in avgrat.keys():
	prods.write(""+k+","+avgrat[k]+"\n")

print "completed the parsing..!"
file.close()
prods.close()

