
# coding: utf-8

# # Track Conversations on twitter via their structure
# 
# This code takes messages that are on twitter, and extracts their hashtags. It then constructs a set of network diagrams that look at which hashtags show up in the same tweet. The network diagrams are interpreted to have a set of clusters within them, the clusters representing places where hashtags are all related to one another, and thus represent 'conversations' that are happening in the pool of twitter messages. We track similarity between clusters from day to day to investigate how conversations develop.

# In[ ]:

import json
import gzip
from collections import Counter
from itertools import combinations
import glob
import dateutil.parser
import pandas as pd
import os.path
import numpy as np
import datetime


# We have twitter messages saved as compressed files, where each line in the file is the JSON object that the twitter sample stream returns to us. The files are created by splitting the streaming dataset according to a fixed number of lines - not necessarily by a fixed time or date range. 
# 
# All the files have the format `posts_sample_YYYYMMDD_HHMMSS_aa.txt` where the date listed is the date at which the stream was initialized. Multiple days worth of stream may be grouped under the same second, as long as the stream remains unbroken. If we have to restart the stream, then a new datetime will be added to the files.

# In[ ]:

# Collect a list of all the filenames that will be working with

files = glob.glob('/mnt/nfs-marketdepth/houghton/data/twitter/raw/posts_sample*.gz')
len(files)


# Its helpful to have a list of the dates in the range that we'll be looking at, because we can't always just add one to get to the next date. Here we create a list of strings with dates in the format 'YYYYMMDD'. The resulting list looks like:
# 
#     ['20141101', '20141102', '20141103', ... '20150629', '20150630']

# In[ ]:

dt = datetime.datetime(2014, 11, 1)
end = datetime.datetime(2015, 7, 1)
step = datetime.timedelta(days=1)

dates = []
while dt < end:
    dates.append(dt.strftime('%Y%m%d'))
    dt += step


# The most data-intensive part of the analysis is this first piece, which parses all of the input files, and counts the various combinations of hashtags on each day. This code is written out in a procedural way to mimic the way it will be done by unicage - although there are alternatives to this method that we should explore.

# In[ ]:

#construct a counter object for each date
tallydict = dict([(date, Counter()) for date in dates])


# In[ ]:

files = files[750:2000]


# In[ ]:

#look one at a time at each of the 
for zfile in files:
    print '.',
    try:
        with gzip.open(zfile) as gzf:
            #look at each line in the file
            for line in gzf:
                try:
                    #parse the json object (in Unicage this will probably be implemented with jq)
                    parsed_json = json.loads(line)
                    #we only want to look at tweets that are in english, so check that this is the case.
                    if parsed_json.has_key('lang'):
                        if parsed_json['lang'] =='en':
                            #look only at messages with more than two hashtags, 
                            #as these are the only ones that make connections
                            if len(parsed_json['entities']['hashtags']) >=2:
                                #extract the hashtags to a list 
                                taglist = [entry['text'] for entry in parsed_json['entities']['hashtags']]
                                #identify the date in the message - this is important because sometimes 
                                #messages come out of order.
                                date = dateutil.parser.parse(parsed_json['created_at']).strftime("%Y%m%d") 
                                #look at all the combinations of hashtags in the set
                                for pair in combinations(taglist, 2):
                                    #count up the number of alpha sorted tag pairs
                                    tallydict[date][' '.join(sorted(pair))] += 1
                except:
                    print 'd',
    except:
        print 'error in', zfile


# In[ ]:

files.index('/mnt/nfs-marketdepth/houghton/data/twitter/raw/posts_sample_20141120_123234_bt.gz')


# Having created this sorted set of tag pairs, we should write these counts to files. We'll create one file for each day. The files themselves will have one pair of words followed by the number of times those hashtags were spotted in combination on each day.
# 
# ```
# PCMS champs 3
# TeamFairyRose TeamFollowBack 3
# instadaily latepost 2
# LifeGoals happy 2
# DanielaPadillaHoopsForHope TeamBiogesic 2
# shoes shopping 5
# kordon saatc 3
# DID Leg 3
# entrepreneur grow 11
# Authors Spangaloo 2
# ```
# 
# We'll save these in a very specific directory structure that will simplify keeping track of our data down the road, when we want to do more complex things with it. An example:
# 
# ```
# twitter/
#    20141116/
#        weighted_edges_20141116.txt
#    20141117/
#        weighted_edges_20141117.txt
#    20141118/
#        weighted_edges_20141118.txt
#    etc...
# ```
# 
# We create a row for every combination that has a count of at least two.

# In[ ]:

for key in tallydict.keys(): #keys are datestamps
    #create a directory for the date in question
    try:
        get_ipython().system(u'mkdir $key')
    except:
        print key, 'probably already exists'
    with open(key+'/weighted_edges_'+key+'.txt', 'w') as fout: #replace old file, instead of append
        for item in tallydict[key].iteritems():
            if item[1] >= 2: #throw out the ones that only have one edge in order to simplify things. The threshold will almost certainly be at least 2.
                fout.write(item[0].encode('utf8')+' '+str(item[1])+'\n')



# Now lets get a list of the wieghed edgelist files, which will be helpful later on.

# In[ ]:

weighted_files = glob.glob('*/weight*.txt')
weighted_files


# #Construct unweigheted edgelist
# 
# We make an unweighted list of edges by throwing out everything below a certain threshold. We'll do this for a range of different thresholds, so that we can compare the results later. Looks like:
# 
# ```
# FoxNflSunday tvtag
# android free
# AZCardinals Lions
# usa xxx
# كبلز متحرره
# CAORU TEAMANGELS
# RT win
# FarCry4 Games
# ```
# 
# We do this for thresholds between 2 and 15 (for now, although we may want to change later) so the directory structure looks like:
# ```
# twitter/
#    20141116/
#        th_02/
#            unweighted_20141116_th_02.txt
#        th_03/
#            unweighted_20141116_th_03.txt
#        th_04/
#            unweighted_20141116_th_04.txt
#        etc...
#    20151117/
#        th_02/
#            unweighted_20141117_th_02.txt
#        etc...
#    etc...
# ```
# 
# Filenames include the date and the threshold, and the fact that these files are unweighted edge lists.

# In[ ]:

for threshold in range (2, 15):
    for infile_name in weighted_files:
        date_dir, weighted_edgefile = infile_name.split('/')
        #create a subdirectory for each threshold we choose
        th_dir = date_dir+'/th_%02i'%threshold
        get_ipython().system(u'mkdir $th_dir')
        
        #load the weighted edgelists file and filter it to only include values above the threshold
        df = pd.read_csv(infile_name, sep=' ', header=None, names=['Tag1', 'Tag2', 'count'])
        filtered = df[df['count']>threshold][['Tag1','Tag2']]
        
        #write out an unweighted edgelist file for each threshold
        outfile_name = th_dir+'/unweighted_'+date_dir+'_th_%02i'%threshold+'.txt'
        with open(outfile_name, 'w') as fout: #replace old file, instead of append
            for index, row in filtered.iterrows():
                fout.write(row['Tag1']+' '+row['Tag2']+'\n')


# Now lets get a list of all the unweighted edgelist files we created

# In[ ]:

unweighted_files = glob.glob('*/*/unweight*.txt')
unweighted_files[:5]


# #Find the communities
# 
# We're using [COS Parallel](http://sourceforge.net/p/cosparallel/wiki/Home/) to identify k-cliques, so we feed each unweighted edge file into the `./maximal_cliques` preprocessor, and then the `./cos` algorithm. 
# 
# The unweighed edgelist files should be in the correct format for `./maximal_cliques` to process at this point. 
# 
# `./maximal_cliques` translates each node name into an integer to make it faster and easier to deal with, and so the output from this file is both a listing of all of the maximal cliques in the network, with an extension `.mcliques`, and a mapping of all of the integer nodenames back to the original text names, having extension `.map`.
# 
# It is a relatively simple task to feed each unweighed edgelist we generated above into the `./maximal_cliques` algorithm.

# In[ ]:

for infile in unweighted_files:
    th_dir = os.path.dirname(infile)
    th_file = os.path.basename(infile)
    print infile
    get_ipython().system(u'cd $th_dir && /home/houghton/tools/cosparallel-0.99/extras/./maximal_cliques $th_file ')


# Once this step is complete, we then feed the `.mcliques` output files into the `cosparallel` algorith.

# In[ ]:

maxclique_files = glob.glob('*/*/*.mcliques')
maxclique_files[:5]


# In[ ]:

current_directory = os.getcwd()
for infile in maxclique_files:
    mc_dir = os.path.dirname(infile)
    mc_file = os.path.basename(infile)
    print mc_dir, mc_file
    get_ipython().system(u'cd $mc_dir && /home/houghton/tools/cosparallel-0.99/./cos $mc_file ; cd $current_directory ')


# # Translate back from numbers to actual words
# The algorithms we just ran abstract away from the actual text words and give us a result with integer collections and a map back to the original text. So we apply the map to recover the clusters in terms of their original words, and give each cluster a unique identifier:
# 
# ```
# 0 Ferguson Anonymous HoodsOff OpKKK
# 1 Beauty Deals Skin Hair 
# 2 Family gym sauna selfie
# etc...
# ```
# 
# 

# In[ ]:

community_files = glob.glob('*/*/[0-9]*communities.txt')
community_files[:5]


# In[ ]:

#we'll be reading a lot of files like this, so it makes sense to create a function to help with it.
def read_cluster_file(infile_name):
    """ take a file output from COS and return a dictionary
    with keys being the integer cluster name, and 
    elements being a set of the keywords in that cluster"""
    clusters = dict()
    with open(infile_name, 'r') as fin:
        for i, line in enumerate(fin):
            name = line.split(':')[0] #the name of the cluster is the bit before the colon
            if not clusters.has_key(name):
                clusters[name] = set()
            #the elements of the cluster are after the colon, space delimited
            nodes = line.split(':')[1].split(' ')[:-1] 
            for node in nodes:
                clusters[name].add(int(node))
    return clusters        


current_directory = os.getcwd()
for infile in community_files:
    c_dir = os.path.dirname(infile)
    c_file = os.path.basename(infile)
    
    #load the map into a pandas series to make it easy to translate
    map_filename = glob.glob('%s/*.map'%c_dir)
    mapping = pd.read_csv(map_filename[0], sep=' ', header=None, names=['word', 'number'], index_col='number')

    clusters = read_cluster_file(infile)
    #create a named cluster file in the same directory
    with open(c_dir+'/named'+c_file, 'w') as fout:
        for name, nodes in clusters.iteritems():
            fout.write(' '.join([str(name)]+[mapping.loc[int(node)]['word'] for node in list(nodes)]+['\n']))


# While we're at it, we'll write a function to read the files we're creating

# In[ ]:


def read_named_cluster_file(infile_name):
    """ take a file output from COS and return a """
    clusters = dict()
    with open(infile_name, 'r') as fin:
        for i, line in enumerate(fin):
            name = line.split(' ')[0]
            if not clusters.has_key(name):
                clusters[int(name)] = set()
            nodes = line.split(' ')[1:-1]
            for node in nodes:
                clusters[int(name)].add(node)
    return clusters  


# ##Compute transition likelihoods
# 
# We want to know how a cluster on one day is related to a cluster on the next day. For now, we'll use a brute-force algorithm of counting the number of nodes in a cluster that are present in each of the subsequent day's cluster. From this we can get a likelihood of sorts for subsequent clusters.
# 
# We'll define a function that, given the clusers on day 1 and day 2, creates a matrix from the two, with day1 clusters as row elements and day2 clusters as column elements. The entries to the matrix are the number of nodes shared by each cluster.

# In[ ]:

#brute force, without the intra-day clustering
def compute_transition_likelihood(current_clusters, next_clusters):
    transition_likelihood = np.empty([max(current_clusters.keys())+1, max(next_clusters.keys())+1])
    for current_cluster, current_elements in current_clusters.iteritems():
        for next_cluster, next_elements in next_clusters.iteritems():
            transition_likelihood[current_cluster, next_cluster] = (
                           len(current_elements & next_elements) ) #the size of the intersection of the sets
    return transition_likelihood




# We want to compute transition matricies for all clusters with every k and every threshold. We'll save the matrix for transitioning from Day1 to Day2 in Day1's folder. In many cases, there won't be an appropriate date/threshold/k combination, so we'll just skip that case.

# In[ ]:

#this should compute and store all of the transition likelihoods

for current_date in dates:
    next_date = dates[dates.index(current_date)+1]
    for threshold in range(2,15):
        for k in range(3, 20)
            try:
                current_file_name = glob.glob(+'%s/th_%02i/named%i_clusters.txt'%(current_date, threshold, k)
                next_file_name = glob.glob(+'%s/th_%02i/named%i_clusters.txt'%(next_date, threshold, k)
                current_clusters = read_named_cluster_file(current_file_name)
                next_clusters = read_named_cluster_file(next_file_name)                           
            except:
                pass
            
            transition = compute_transition_likelihood(current_clusters, next_clusters)
            transitiondf = pd.DataFrame(data=transition, 
                                    index=current_clusters.keys(),
                                    columns=next_clusters.keys())

            transitiondf.to_csv(current_file_name[:-4]+'_transition.csv')

        except:
            print 'nothing'


# ## View the results
# Now we've got the first stab at our results, we need to view them. Here are two functions that access the clusters we've created. It probably isn't important to build these up in unicage...

# In[ ]:

def get_clusters_with_keyword(date, threshold, keyword):

    files = pd.DataFrame(glob.glob(date+'/th_%02i'%threshold+'/named*_communities.txt'), columns=['filename'])
    files['clique_size']=files['filename'].apply(lambda x: int(x.split('named')[1].split('_')[0])) #brittle
    files.sort('clique_size', ascending=False, inplace=True)

    outlist = []
    
    
    for index, row in files.iterrows():
        clusters = read_named_cluster_file(row['filename'])
        for index, cluster_set in clusters.iteritems():
            outdict = {}
            if keyword in cluster_set:
                outdict['date'] = date
                outdict['threshold'] = threshold
                outdict['keyword'] = keyword
                outdict['elements'] = cluster_set
                outdict['k-clique'] = row['clique_size']
                outdict['name'] = index
                outlist.append(outdict)
    return outlist
#print seed_date+'/th_%02i'%threshold+'/named*_communities.txt'


keyword = 'follow'
threshold = 2
seed_date = '20141118'

clusters = get_clusters_with_keyword(seed_date, threshold, keyword)
clusters


# In[ ]:

def get_next_clusters(seed_cluster):
    current_date = seed_cluster['date']
    next_date = dates[dates.index(current_date)+1]
    print current_date, next_date
    
    transition_filename = '%s/th_%02i/named%i_communities_transition.csv'%(current_date, 
                                                                           seed_cluster['threshold'],
                                                                           seed_cluster['k-clique'])
    transitions = pd.read_csv(transition_filename)
    
    candidates = transitions.loc[seed_cluster['name']]
    candidates /= candidates.sum()
    print candidates[candidates>0.1]
    
    
    next_clusters_filename = '%s/th_%02i/named%i_communities.txt'%(next_date,
                                                                   seed_cluster['threshold'],
                                                                   seed_cluster['k-clique'])
    next_clusters = read_named_cluster_file(next_clusters_filename)
    return next_clusters

    
get_next_clusters(clusters[2])


# In[ ]:



