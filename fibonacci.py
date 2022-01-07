# -*- coding: utf-8 -*-
"""
Created on Thu Jan  6 08:41:06 2022

@author: nishi
"""
import numpy as np
import matplotlib.pyplot as plt
r = 1
x_cord = []
y_cord = []
for i in range (0,180):
    x = r * np.cos(i*3.14/180)
    y = r * np.sin(i*3.14/180)
    x_cord.append(x)
    y_cord.append(y)
    

r = 2
for i in range (180,270):
    x = r * np.cos(i*3.14/180)+1
    y = r * np.sin(i*3.14/180)
    x_cord.append(x)
    y_cord.append(y)

a = 0
b = 1
fib_num = [0,1]
x_align = [0,0,0,1]
y_align = [0,0,0,0]

n = 4
  
for i in range (3,n+8):
    c = a + b
    a = b
    b = c
    fib_num.append(c)
 
for i in range (4,n+3,4):
    x_temp = x_align[i-1]
    y_temp = y_align[i-1] + fib_num[i-2]
    x_align.append(x_temp)
    y_align.append(y_temp)
    
    x_temp = x_align[i] - fib_num[i-1]
    y_temp = y_align[i]
    x_align.append(x_temp)
    y_align.append(y_temp)
    
    x_temp = x_align[i+1]
    y_temp = y_align[i+1] - fib_num[i]
    x_align.append(x_temp)
    y_align.append(y_temp)
    
    x_temp = x_align[i+2] + fib_num[i+1]
    y_temp = y_align[i+2]
    x_align.append(x_temp)
    y_align.append(y_temp)  
    
for i in range (4,n+3,4):
    r = fib_num[i]  
    for j in range (270,360):
         x = r * np.cos(j*3.14/180) + x_align[i]
         y = r * np.sin(j*3.14/180) + y_align[i]
         x_cord.append(x)
         y_cord.append(y)
         
    if fib_num[n]==r:
        break
         
    r = fib_num[i+1]  
    for j in range (0,90):
          x = r * np.cos(j*3.14/180) + x_align[i+1]
          y = r * np.sin(j*3.14/180) + y_align[i+1]
          x_cord.append(x)
          y_cord.append(y)
          
    if fib_num[n]==r:
        break
          
    r = fib_num[i+2]  
    for j in range (90,180):
          x = r * np.cos(j*3.14/180) + x_align[i+2]
          y = r * np.sin(j*3.14/180) + y_align[i+2]
          x_cord.append(x)
          y_cord.append(y)
         
    if fib_num[n]==r:
        break
         
    r = fib_num[i+3]  
    for j in range (180,270):
          x = r * np.cos(j*3.14/180) + x_align[i+3]
          y = r * np.sin(j*3.14/180) + y_align[i+3]
          x_cord.append(x)
          y_cord.append(y)
          
    if fib_num[n]==r:
        break
    
plt.figure(figsize=(9,6))
plt.plot(x_cord,y_cord)
plt.plot(x_cord,y_cord)
plt.axhline(y=0,color ='k')
plt.axvline(x=0,color ='k')
plt.xlabel("X-axis")
plt.ylabel("Y-axis")
plt.title("Fibbonacci Curve")
plt.grid()
