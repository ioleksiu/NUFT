def print_octal(n):
	print("==================================")
	print("The octal number ")
	print(oct(n))

n = (input("Please , enter decimal number = "))
while not isinstance(n,int):
	n = (input("Please , enter decimal number = "))
print_octal(n)