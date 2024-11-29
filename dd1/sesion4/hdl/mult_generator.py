import csv

# File path to write the CSV to
file_path = "sim/estimulos.txt"

n = 8

data = []

# Generate the data
OP1_list = []
OP2_list = []
result_list = []

for i in range(0, 2**n):
    for j in range(0, 2**n):
        OP1_list.append(i)
        OP2_list.append(j)
        result_list.append(i*j)


data = list(zip(OP1_list, OP2_list, result_list))

with open(file_path, mode='w', newline='') as file:
    writer = csv.writer(file, delimiter=',')  
    writer.writerows(data)
