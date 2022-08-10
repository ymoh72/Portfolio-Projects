#!/usr/bin/env python
# coding: utf-8

# In[2]:


import pandas as pd
import numpy as np
import seaborn as sns

import matplotlib
import matplotlib.pyplot as plt
plt.style.use('ggplot')
from matplotlib.pyplot import figure

get_ipython().run_line_magic('matplotlib', 'inline')
matplotlib.rcParams['figure.figsize'] = (12,8)

# Read in the data

df = pd.read_csv(r'C:\Users\mohma\OneDrive\Documents\Data Science Learning\Portfolio_Projects\DAPythonProject\movies.csv')


# In[5]:


# Display the raw data

df.head()


# In[6]:


# Locate any missing data 

for col in df.columns:
    pct_missing = np.mean(df[col].isnull())
    print('{} - {}%'.format(col, pct_missing))


# In[7]:


# Examining the data types for our columns

df.dtypes


# In[8]:


#Display the correct release date for the movie in the 'Released' column

df['yearcorrect'] = df['released'].astype(str).str[:4]

df


# In[9]:


#Display any outliers in terms of gross revenue

df.boxplot(column=['gross'])


# In[10]:


#Drop any duplicate rows in the dataset

df.drop_duplicates()


# In[11]:


#Ordering the data by gross revenue

df.sort_values(by=['gross'], inplace=False, ascending=False)


# In[15]:


#Using a scatterplot to display the data and establish correlation between 'budget' and 'gross' revenue

sns.regplot(x="gross", y="budget", data=df)


# In[17]:


#Display scatterplot to establish correlation between 'score' and 'gross' revenue

sns.regplot(x="score", y="gross", data=df)


# In[18]:


#Creating a correlation matrix between all numeric columns using the three basic CM methods: Pearson, Kendall and Spearman

df.corr(method ='pearson')


# In[20]:


df.corr(method ='kendall')


# In[21]:


df.corr(method ='spearman')


# In[25]:


#Creating a heat map for the numeric columns in the dataset

correlation_matrix = df.corr()

sns.heatmap(correlation_matrix, annot = True)

plt.title("Correlation matrix for Numeric Features")

plt.xlabel("Movie features")

plt.ylabel("Movie features")

plt.show()


# In[26]:


#Establishing correlation between all variables using Factorization

df.apply(lambda x: x.factorize()[0]).corr(method='pearson')


# In[27]:


correlation_matrix = df.apply(lambda x: x.factorize()[0]).corr(method='pearson')

sns.heatmap(correlation_matrix, annot = True)

plt.title("Correlation matrix for Movies")

plt.xlabel("Movie features")

plt.ylabel("Movie features")

plt.show()


# In[31]:


correlation_mat = df.apply(lambda x: x.factorize()[0]).corr()

corr_pairs = correlation_mat.unstack()

print(corr_pairs)


# In[34]:


sorted_pairs = corr_pairs.sort_values(kind="quicksort")

print(sorted_pairs)


# In[35]:


#Sorting pairs that have a high correlation (> 0.5)

strong_pairs = sorted_pairs[abs(sorted_pairs) > 0.5]

print(strong_pairs)


# In[38]:


#Looking at the top 15 compaies by gross revenue

CompanyGrossSum = df.groupby('company')[["gross"]].sum()

CompanyGrossSumSorted = CompanyGrossSum.sort_values('gross', ascending = False)[:15]

CompanyGrossSumSorted = CompanyGrossSumSorted['gross'].astype('int64') 

CompanyGrossSumSorted


# In[3]:


df['Year'] = df['released'].astype(str).str[:4]
df


# In[7]:


#Displaying scatter plot for 'gross' revenue and 'budget' of films

plt.scatter(x=df['budget'], y=df['gross'], alpha=0.5)
plt.title('Budget vs Gross Earnings')
plt.xlabel('Gross Earnings')
plt.ylabel('Budget for Film')
plt.show()

