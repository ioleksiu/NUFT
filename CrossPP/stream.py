#from __future__ import print_function

filename = "sourse"

myfile = open(filename, 'r')
min_len = 999999
for line in myfile:
	if len(line) < min_len:
		min_len = len(line)
myfile.close()

myfile = open(filename, 'r')
res = open("dest", 'w')

for line in myfile:
	if len(line) != min_len:
		res.write(line)
	else :
		temp = line		
res.write("\n" + temp)				