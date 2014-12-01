import json
# import ijson
import pprint 
import fileinput 
from cosineSimilarity import cosineSimilarity

user_array = {}
prod_array = {}
avg_rat_array = {}
rev_text = {}
cosine_sim = {}
data_write = {}
_count = {}

def percentCheck(count1, count2):
	x = 0
	if count1 > count2:
		x = ((count1 - count2) / count2)
	elif count2 > count1:
		x = ((count2 - count1) / count1)
	else:
		return True
	if x < 0.1:
		return True
	else:
		return False

print "users.."
users=open("C:\\Users\\raghuar\\Documents\\GitHub\\Mining\\Dataset-Norm\\users.txt","w")
# avg_rat=open("C:\\Users\\raghuar\\Documents\\GitHub\\Mining\\Dataset-Norm\\avg_ratings.txt","w")
users.truncate()
# avg_rat.truncate()
users.write("USER_ID,USER_NAME\n")
# avg_rat.write("PROD_NAME,AVG_RAT\n")
count=0
with open('C:\\Users\\raghuar\\Desktop\\SkillTest\\JSON-Python\\yelp_academic_dataset_user.json', 'r') as file:
	for line in file:
		data = json.loads(line)
		users.write(''+data['user_id'].encode('utf-8')+',\''+data['name'].encode('utf-8')+'\'\n')
		user_array[''+data['user_id'].encode('utf-8')] = data['name'].encode('utf-8')

file.close()
users.close()
print "users complete.."
print "products start.."
products=open("C:\\Users\\raghuar\\Documents\\GitHub\\Mining\\Dataset-Norm\\products.txt","w")
products.truncate()
products.write("PROD_ID,PROD_NAME\n")
count=0
with open('C:\\Users\\raghuar\\Desktop\\SkillTest\\JSON-Python\\yelp_academic_dataset_business.json', 'r') as file:
	for line in file:
		data = json.loads(line)
		products.write(''+data['business_id'].encode('utf-8')+',\''+data['name'].encode('utf-8')+'\'\n')
		prod_array[''+data['business_id'].encode('utf-8')] = data['name'].encode('utf-8')
		avg_rat_array[''+data['business_id'].encode('utf-8')] = `data['stars']`
		# avg_rat.write('\''+data['name'].encode('utf-8')+'\','+`data['stars']`+'\n')

file.close()
# avg_rat.close()
products.close()
print "products complete..\n"

print "relation start..\n"
relation=open("C:\\Users\\raghuar\\Documents\\GitHub\\Mining\\Dataset-Norm\\relation.txt","w")
relation.truncate()
relation.write("USER_ID,PROD_ID,RATING,AVG_RAT,USEFUL,DUP_CNT\n")
count=0
with open('C:\\Users\\raghuar\\Desktop\\SkillTest\\JSON-Python\\yelp_academic_dataset_review.json', 'r') as file:
# with open('C:\\Users\\raghuar\\Desktop\\SkillTest\\JSON-Python\\tests.json', 'r') as file:
	for line in file:
		data = json.loads(line)
		# avg_rat_array[''+data['business_id'].encode('utf-8')] = 0
		data_write[data['review_id'].encode('utf-8')] = ''+data['user_id'].encode('utf-8')+','+data['business_id'].encode('utf-8')+','+`data['stars']`+','+avg_rat_array[''+data['business_id'].encode('utf-8')]+','+`data['votes']['useful']`
		rev_text[data['review_id'].encode('utf-8')] = data['text'].encode('utf-8')
		cosine_sim[data['review_id'].encode('utf-8')]=0
		_count[data['review_id'].encode('utf-8')] = len(data['text'].encode('utf-8'));
		count+=1
		if count == 1000:
			break

print "relation complete.."
count = 0
for k in rev_text.keys():
	for j in rev_text.keys():
		if k != j:
			if percentCheck(_count[k],_count[j]) == True:
				cosine = cosineSimilarity(rev_text[k].split(),rev_text[j].split())
				if cosine > 0.7:
					cosine_sim[str(k).encode('utf-8')] = cosine_sim[str(k).encode('utf-8')] + 1
for k in cosine_sim.keys():
	relation.write (""+data_write[k]+","+`cosine_sim[k]`+"\n")

file.close()
relation.close()