def print_hex(n):
	n = int(n, 16)
	print("Decimal")
	print(n)

n = (input("hex = "))
while not isinstance(n, basestring):
	n = (input("hex = "))
print_hex(n)