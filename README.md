# twitter-cluster
Clustering twitter conversations

This repository contains code that facilitates looking at clusters of conversation within the twitters, and how they evolve over time. 

Relevant files include:
- [Conversational Cluster Detection and Transition Likelihood Calculation Python Version](Appendix_A_Python_Example.ipynb)
- [Conversational Cluster Detection and Transition Likelihood Calculation Unicage Version](Appendix_B_Unicage_Example.ipynb)
- [Performance Comparison between python and unicage](Appendix_C_Performance_Comparison.ipynb)
- [Data collection scripts](Appendix_D_Data_Collection_Scripts.ipynb)
- [Visualization](Visualization_Overview.ipynb)


### config.json
To configure the locations of various data, working, and tools directories, modify the `config.json.template` file to include the relative paths to:

 - `data_dir` : The location of raw twitter message dumps 
 - `python_working_dir` : Where intermediate python files should be stored
 - `unicage_working_dir` : Where intermediate unicage working files should be stored
 - `cos-parallel` : the path to the cos-parallel tool
 - `maximal_cliques` : the path to cos-parallel's utility 'maximal cliques'
 
as an example:
```json
{"maximal_cliques": "tools/cosparallel-0.99/extras/./maximal_cliques", 
 "cos-parallel": "tools/cosparallel-0.99/extras/./maximal_cliques",
 "python_working_dir": "../PYTHON/working/",
 "unicage_working_dir": "../UNICAGE/working/",
 "data_dir": "../data/" }
```

