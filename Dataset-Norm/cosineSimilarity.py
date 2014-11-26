import math
from collections import Counter

def buildVector(iterable1, iterable2):
    counter1 = Counter(iterable1)
    counter2= Counter(iterable2)
    all_items = set(counter1.keys()).union( set(counter2.keys()) )
	
    vector1 = [counter1[k] for k in all_items]
    vector2 = [counter2[k] for k in all_items]
    return vector1, vector2

def cosim(v1, v2):
    dot_product = sum(n1 * n2 for n1,n2 in zip(v1, v2) )
    magnitude1 = math.sqrt (sum(n ** 2 for n in v1))
    magnitude2 = math.sqrt (sum(n ** 2 for n in v2))
    return dot_product / (magnitude1 * magnitude2)


# l1 = "Janeu Jane".split()
# l2 = "Jane likes me more than Julie loves me or".split()
# counter1 = Counter(l1)
# counter2= Counter(l2)
# all_items = set(counter1.keys()).union( set(counter2.keys()) )
# print counter1.keys()
# print counter2.keys()
# print set(counter1.keys()).union( set(counter2.keys()))
# print [counter1[k] for k in all_items]
# print [counter2[k] for k in all_items]
# print zip([counter1[k] for k in all_items],[counter2[k] for k in all_items])
def cosineSimilarity(str1, str2):
	v1,v2= buildVector(str1, str2)
	return (cosim(v1, v2))

