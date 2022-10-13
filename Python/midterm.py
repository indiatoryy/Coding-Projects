# Test duration: 1 hour and 50 minutes (9:10am-11:00am)
#
# Aids allowed: any material on the course website http://www.cs.toronto.edu/~guerzhoy/180/
# You may use Pyzo (or another Python IDE) during the exam.
#
# You are responsible for submitting the file midterm.py on Gradescope.
#
# You can resubmit the file multiple times. Your last submission will be
# graded.
#
# You are responsible for making sure that the functions are named as specified
# and that there are no syntax errors. Gradescope will let you know if the
# file is incorrectly named or there are syntax errors, but you will not see
# whether the functions return the right values.
#
# Make sure that your functions RETURN, rather than PRINT, the required
# outputs.
#
# You may use
#  import math
# but you may not import other modules.
#
# Questions will be answered on Zoom: https://utoronto.zoom.us/j/92599671787

################################################################################
#
# 1 (15 pts). Write a function that returns the sum of the numbers
# 1^3 + 2^3 + ... + k^3. Assume that k >= 1
#
# For example sum_cubes(2) should return 9

def sum_cubes(k):
    sum = 0
    for i in range(1,k+1):
        sum += i*i*i
    return sum
# print(sum_cubes(5))
#
#
#
# ################################################################################
# 2 (15 pts). Write a function that takes in a number n, and returns the smallest
#    number k such that 1^3 + 2^3 + ... + k^3 >= n
#
#    For example, sum_cubes_num_terms(10) should return 3, since
#    1^3 + 2^3 < 10, and 1^3 + 2^3 + 3^3 >= 10


def sum_cubes_num_terms(n):
    sum = 0
    num_terms = 0
    while True:
        for i in range(1,num_terms+1):
            sum += i*i*i

        if sum == n:
            return num_terms

        elif sum > n:
            return num_terms - 1

        else:
            num_terms += 1
            sum = 0

# print(sum_cubes_num_terms(225))




################################################################################
# 3 (15 pts). A list contains 30 elements, representing the rainfall during a month. For
#    example, the following represents the rainfall data for Toronto in
#    September.
measurements = [10.4, 1.6, 2, 0.2, 0, 0, 5.2, 0, 0, 0, 0, 0, 3.8, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 2.0, 0, 0, 0, 8.4, 2.2, 5.0]

#    Write a function that returns a list that contains the three-day moving
#    average percipitation for days 2..(N-1), given a list of measurements of
#    length N. The three-day moving average for day d is the average
#    precepitation on days (d-1), d, (d+1). Assume the input list contains
#    at least three numbers.
#    If measurements is a list of length N, moving_average(measurements) should
#    return a list of length N-2.

def moving_average(measurements):
    averages = []
    length = len(measurements)
    for i in range(1,length-1):
        a = measurements[i-1]
        b = measurements[i]
        c = measurements[i+1]
        average = (a+b+c)/3
        averages.append(average)

    print(averages)
    print(len(averages))

    return averages


# # moving_average([2.0,3.0])



################################################################################
# 4. (15 pts) A pattern matches a string "with wraparound" if it is possible to match
#    the pattern to the string while possibly wrapping the pattern around.
#    For example, the pattern "abc" matches the string "zabcz"
#    with wraparound (though wrapping around was not used). The string "czz"
#    matches "zabcz" with wraparound, since it's possible to read czz by
#    starting at "zabcz"[3:5] and then continuing to the other z wrapping around.
#    On the other hand, "czy"  doesn't match "zabcz".
#    Write a function match(pattern, text) that returns True if pattern matches
#    text (possibly using wraparound), and False otherwise.
#
#    You can access the contents of a string similarly to lists:
#    >> my_str = "abc"
#    >> my_str[1:3]
#    "bc"
#    >> my_str[1]
#
#
def match(pattern, text):
    # pass
    lenP = len(pattern)
    lenT = len(text)

    if lenT >= lenP:
        if pattern in text:
            return True
        else:
            # return False
            checked = 0
            for p in range(1,lenP-1):
                string = ""
                lookingIndex = lenT-lenP+p
                looking = text[lookingIndex]
                string += text[lookingIndex-1:]
            string += text[0]
        print("string", string)
        if string == pattern:
            return True
        else:
            return False



            #     for p in range(looking, looking+lenP-p):
            #         string += p
            #     for p in range(0,i):
            #         string += p
            # print(string)
            #

print(match("fgab","abcdefgab"))






################################################################################
# 5 (15 pts). Matrices can be represented as lists of lists. Write a function
#    that takes in two matrices of size m x n (m rows and n columns), and
#    returns True iff the matrices have at least n-1 of the same columns.
#    For example, consider the following:

M1 = [[1, 2, 3],
      [1, 5, 1],
      [1, 2, 2]]

M2 = [[3, 1, 0],
      [1, 1, 2],
      [2, 1, 0]]
#
# M1 = [[1, 2],
#       [1, 5]]
#
# M2 = [[1, 2],
#       [1, 5]]


#    M2 contains the first and the third column of M1, so M1 and M2 share
#    (3-1) columns, and so share_n1(M1, M2) should return True
#
#    The function should return True for matrices that are equal.
#
#    share_n1(M1, M2) should return False if M1 and M2 share fewer than
#    (n-1) columns, where n is the number of columns in M1

def share_n1(M1, M2):
    col = len(M1)
    row = len(M1[0])

    columns1 = []
    for i in range(0,col):
        columns1.append([])

    # columns in M1
    for n in range(0,row):
        for m in range(0,col):
            # print(M1[m][n],"\n")
            columns1[n].append(M1[m][n])
    # print(columns1)


    columns2 = []
    for i in range(0,col):
        columns2.append([])

    # columns in M1
    for n in range(0,row):
        for m in range(0,col):
            # print(M2[m][n],"\n")
            columns2[n].append(M2[m][n])
    # print(columns2)

    num_shared = 0
    for i in range(0,len(columns1)):
        if columns1[i] in columns2:
            num_shared += 1

    if num_shared >= col-1:
        return True
    else:
        return False

print(share_n1(M1, M2))