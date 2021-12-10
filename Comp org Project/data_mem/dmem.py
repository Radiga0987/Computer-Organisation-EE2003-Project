import numpy as np

A = [[1,2,3,4,5,6,7,8],[1,2,3,4,5,6,7,8],[1,2,3,4,5,6,7,8],[1,2,3,4,5,6,7,8],[1,2,3,4,5,6,7,8],[1,2,3,4,5,6,7,8],[1,2,3,4,5,6,7,8],[1,2,3,4,5,6,7,8]]
B = [[1,2,3,4,5,6,7,8],[1,2,3,4,5,6,7,8],[1,2,3,4,5,6,7,8],[1,2,3,4,5,6,7,8],[1,2,3,4,5,6,7,8],[1,2,3,4,5,6,7,8],[1,2,3,4,5,6,7,8],[1,2,3,4,5,6,7,8]]

m = len(A)
n = len(A[0])
o = len(B[0])

if m%8==0:
    m1=m
else:
    m1 = m+8-(m % 8)

if n%8==0:
    n1=n
else:
    n1 = n+8-(n % 8)

if o%8==0:
    o1=o
else:
    o1 = o+8-(o % 8)

data0 = []
data1 = []
data2 = []
data3 = []


for i in range(m1):
    for j in range(n1):
        if i<m and j<n:
            val = hex(A[i][j])[2:][::-1]
            if len(val)<8:
                val=val+("0"*(8-len(val)))
            val = val[::-1]
            data3.append(val[0:2])
            data2.append(val[2:4])
            data1.append(val[4:6])
            data0.append(val[6:])
        else:
            data3.append("00")
            data2.append("00")
            data1.append("00")
            data0.append("00")


for i in range(m1*n1*4,5120,4):
    data3.append("00")
    data2.append("00")
    data1.append("00")
    data0.append("00")

for i in range(n1):
    for j in range(o1):
        if i<n and j<o:
            val = hex(B[i][j])[2:][::-1]
            if len(val)<8:
                val=val+("0"*(8-len(val)))
            val = val[::-1]
            data3.append(val[0:2])
            data2.append(val[2:4])
            data1.append(val[4:6])
            data0.append(val[6:])
        else:
            data3.append("00")
            data2.append("00")
            data1.append("00")
            data0.append("00")

for i in range(5120+n1*o1*4,15360,4):
    data3.append("00")
    data2.append("00")
    data1.append("00")
    data0.append("00")


dim_m=bin(m1)[2:][::-1]
if len(dim_m)<11:
    dim_m=dim_m+("0"*(11-len(dim_m)))
dim_m=dim_m[::-1]

dim_n=bin(n1)[2:][::-1]
if len(dim_n)<11:
    dim_n=dim_n+("0"*(11-len(dim_n)))
dim_n=dim_n[::-1]

dim_o=bin(o1)[2:][::-1]
if len(dim_o)<11:
    dim_o=dim_o+("0"*(11-len(dim_o)))
dim_o=dim_o[::-1]

val = dim_o + dim_n + dim_m
h = hex(int(val,2))[2:][::-1]
if len(h)<8:
    h=h+("0" * (8-len(h)))
h=h[::-1]

data3.append(h[0:2])
data2.append(h[2:4])
data1.append(h[4:6])
data0.append(h[6:])

for i in range(15364,16385,4):
    data3.append("00")
    data2.append("00")
    data1.append("00")
    data0.append("00")

with open("data0.mem", "w") as file1:
    for i in range(len(data0)):
        file1.write(data0[i]+"\n")
    
with open("data1.mem", "w") as file1:
    for i in range(len(data1)):
        file1.write(data1[i]+"\n")

with open("data2.mem", "w") as file1:
    for i in range(len(data2)):
        file1.write(data2[i]+"\n")

with open("data3.mem", "w") as file1:
    for i in range(len(data3)):
        file1.write(data3[i]+"\n")