# Network percolation studies

## Process for using the code
1. put the data file in a local repository
2. in the file code/main_liu.m: locate the filename for each dataset. Example: filename = '../Belgium_Trains/networkAdjMatrBelgiumTrains.txt';
3. set appropriate settings: number of simulations, number of threads, etc.
4. launch main_liu.m, results are then dropped into the evolution/results/ folder
5. copy the results file in the /data_network_figures/results folder
5. open main.m in the /data_network_figures folder and specify the #filename in FIGURE_2(#filename); for locating your results. Example:FIGURE_2('results--23-Mar-2020-99-Belgium trains.mat');
6. figures are produced in the figures/ folder

## Belgium Trains