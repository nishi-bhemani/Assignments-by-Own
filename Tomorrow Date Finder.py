# -*- coding: utf-8 -*-
"""
Created on Sun Dec 26 14:34:08 2021

@author: nishi
"""

today_date = input ("Enter today's date in format DD/MM/YYYY   ")

for i in range (len(today_date)):
    if today_date[i] == '/' or today_date[i] == '-' or today_date[i] == ' ':
        a = i
        break

day = int(today_date[0:(a)])

today_date_rev = today_date[::-1]
for i in range (len(today_date_rev)):
    if today_date_rev[i] == '/' or today_date_rev[i] == '-' or today_date_rev[i] == ' ':
        b = i
        break

year_rev = today_date_rev[0:b]
year_str = year_rev[::-1]
year = int(year_str)

c = len(today_date) - b

d = 0
for i in range (a,c):
    if today_date[i] == '1' or today_date[i] == '2' or today_date[i] == '3' or today_date[i] == '4' or today_date[i] == '5' or today_date[i] == '6' or today_date[i] == '7' or today_date[i] == '8' or today_date[i] == '9' or today_date[i] == '0':      
        d = i
        break
for i in range (d,c):
    if (today_date[i] == '/' or today_date[i] == '-' or today_date[i] == ' ') and d!=0:
        e =i
        break
print("d=",d)
print("e=",e)    

month_str = today_date[d:e]

month = int(month_str)
print(month)
print(year)

if year % 4 == 0:  
    if month == 2: 
        if day == 28:
            day2 = 29
            month2 = 2
            year2 = year
            day2_str = str(day2)
            month2_str = str(month2)
            year2_str = str(year2)

            print (day2_str,"/"+month2_str,"/"+year2_str)
            
elif year % 4 == 0:  
    if month == 2: 
        if day == 29:
            day2 = 1
            month2 = 3
            year2 = year
            day2_str = str(day2)
            month2_str = str(month2)
            year2_str = str(year2)
        
            print (day2_str,"/"+month2_str,"/"+year2_str)
            
elif year % 4 != 0 and month ==2 and day == 28:
    day2 = 1
    month2 = 3
    year2 = year 
    day2_str = str(day2)
    month2_str = str(month2)
    year2_str = str(year2)

    print (day2_str,"/"+month2_str,"/"+year2_str)       

elif month == 12 and day ==31:
    day2 = 1
    month2 = 1
    year2 = year + 1
    day2_str = str(day2)
    month2_str = str(month2)
    year2_str = str(year2)

    print (day2_str,"/"+month2_str,"/"+year2_str)
        
elif (month == 1 or  month == 3 or  month == 5 or  month == 7 or  month == 8 or  month == 10) and day == 31:
    day2 = 1
    month2 = month + 1
    year2 = year
    day2_str = str(day2)
    month2_str = str(month2)
    year2_str = str(year2)

    print (day2_str,"/"+month2_str,"/"+year2_str)

elif (month == 4 or month == 6 or month == 9 or month == 11) and day == 30:
    day2 = 1
    month2 = month + 1
    year2 = year
    day2_str = str(day2)
    month2_str = str(month2)
    year2_str = str(year2)

    print (day2_str,"/"+month2_str,"/"+year2_str)
    
elif day> 31 and (month == 1 or  month == 3 or  month == 5 or  month == 7 or  month == 8 or  month == 10):
    print ("ïnvalid date")
    
elif day> 30 and (month == 4 or month == 6 or month == 9 or month == 11):
    print ("ïnvalid date") 
       
elif month>12:
    print ("ïnvalid date") 
    
elif year % 4 == 0  and month == 2 and day > 29:
    print ("ïnvalid date") 

elif year % 4 != 0 and month ==2 and day > 28:
    print ("ïnvalid date") 

else:
    day2 = day + 1
    month2 = month
    year2 = year

    day2_str = str(day2)
    month2_str = str(month2)
    year2_str = str(year2)

    print (day2_str,"/"+month2_str,"/"+year2_str)
    
# print(today_date[-1])

        
    

