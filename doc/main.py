#!/usr/bin/python3
 
import pymysql
 
db = pymysql.connect(host='localhost',
                     user='testuser',
                     password='test123',
                     database='TESTDB')
 
cursor = db.cursor()
 
cursor.execute("SELECT VERSION()")
 
data = cursor.fetchone()
 
print ("Database version : %s " % data)

db.close()