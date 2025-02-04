# Network percolation studies

## How to use the code
1. put the data file in a local repository
2. in the file *code/main_liu.m*: locate the filename for each dataset. Example: filename = '../Belgium_Trains/networkAdjMatrBelgiumTrains.txt';
3. set appropriate settings: number of simulations, number of threads, etc.
4. launch *main_liu.m*, results are then dropped into the *evolution/results/* folder
5. copy the results file in the */data_network_figures/results* folder
5. open *main.m* in the */data_network_figures* folder and specify the #filename in *FIGURE_2(#filename)*; for locating your results. Example:FIGURE_2('results--23-Mar-2020-99-Belgium trains.mat');
6. figures are produced in the *figures/* folder

## Adjacency matrices 

We take various sources of data from http://networkrepository.com/ and generate networks ourselves.

### Pre-processing:
Total number of nodes before processing: 644  
Total number of links before processing: 645  
removed 0 links (self-loops)  
removed 105 (isolated) nodes  
removed 60 unconnected nodes  
Total number of nodes after processing: 479  
Total number of links after processing: 540  

![Belgium_trains_processing](/figures/1_Belgium_trains_analytics.png)

### Results
Evolution results for the Random and Pseudo-Darwinian evolutions (1000 simulations). Bold lines represent the average value at each time step.

![Belgium_trains_evolution](/figures/1_Belgium_trains_evolutions.png)
