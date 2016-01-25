
## Appendix C: Performance Comparison

The scripts listed in appendices A and B were run on an 8 Core Intel 64 bit 3.2Ghz processor with 48gb ram, for messages over the date range  

Step                                | Python Runtime | Unicage Runtime
:---------------------------------- | :------------: | :-------------:
1. Counting Hashtag Pairs           |  38h:34m:33s   | 08h:27m:43s
2. Weighted Edgelists               |  00h:00m:10s   | 00h:03m:32s
3. Unweighted Edgelists             |  00h:13m:36s   | 00h:08m:11s
4. Maximal Clique Identification    |  00h:10m:13s   | 00h:02m:18s
5. k-Clique Percolation             |  00h:05m:45s   | 00h:08m:53s
6. Mapping back to Text             |  00h:19m:56s   | 00h:09m:56s
7. Computing transition likelihoods |  00h:03m:15s   | 05h:47m:51s
**Total time**                      | **39h:27m:28s** | **14h:48m:24s**
