#!/usr/bin/env python
# coding: utf-8

# In[1]:


import requests
from bs4 import BeautifulSoup


# In[7]:


city = "lucknow"

url = "https://www.google.com/search?q="+"weather"+city
    
html = requests.get(url).content

soup = BeautifulSoup(html, 'html.parser')


# In[8]:


temp = soup.find('div', attrs={'class': 'BNeawe iBp4i AP7Wnd'}).text

str = soup.find('div', attrs = {'class': 'BNeawe tAd8D AP7Wnd'}).text

data = str.split('\n')

time = data[0]
sky = data[1]


# In[9]:


listdiv = soup.findAll('div', attrs={'class': 'BNeawe s3v9rd AP7Wnd'})

strd = listdiv[5].text
 
pos = strd.find('Wind')
other_data = strd[pos:]


# In[10]:


print("Temperature is", temp)
print("Time: ", time)
print("Sky Description: ", sky)
print(other_data)


# In[11]:


import requests
from bs4 import BeautifulSoup
 

city = "lucknow"

url = "https://www.google.com/search?q="+"weather"+city
html = requests.get(url).content
 
soup = BeautifulSoup(html, 'html.parser')
temp = soup.find('div', attrs={'class': 'BNeawe iBp4i AP7Wnd'}).text
str = soup.find('div', attrs={'class': 'BNeawe tAd8D AP7Wnd'}).text
 
data = str.split('\n')
time = data[0]
sky = data[1]
 
listdiv = soup.findAll('div', attrs={'class': 'BNeawe s3v9rd AP7Wnd'})
strd = listdiv[5].text
 
pos = strd.find('Wind')
other_data = strd[pos:]
 
print("Temperature is", temp)
print("Time: ", time)
print("Sky Description: ", sky)
print(other_data)


# In[20]:


import requests

res = requests.get('https://ipinfo.io/')

data = res.json()

citydata = data['city']

print(citydata)

url = 'https://wttr.in/{}'.format(citydata)

res = requests.get(url)

print(res.text)


# In[ ]:




