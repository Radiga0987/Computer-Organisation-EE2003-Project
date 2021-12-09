import numpy as np

A = np.array([[1,],[],[]])
B = np.array([[1,],[],[]])

m = len(A)
n = len(A[0])
o = len(B[0])

m1 = m+8-(m % 8)
n1 = n+8-(n % 8)
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
                val.append("0"*(8-len(val)))
            val = val[::-1]
            data3.append(val[0:2])
            data2.append(val[2:4])
            data1.append(val[4:6])
            data0.append(val[6:])







