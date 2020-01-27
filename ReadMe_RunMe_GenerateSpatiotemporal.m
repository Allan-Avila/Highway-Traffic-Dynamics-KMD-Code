%Highway Traffic Dynamics: Data-Driven Analysis and Forecast 
%Allan M. Avila 2019
%University of California Santa Barbara

%% Instructions for Generating SpatioTemporal Data.
% To generate spatiotemporal data call on the function:
% [Bins,Trajectory]=Convert_NGSIM(Name,DelX,DelT)

%Inputs Required:
% Name is a string containing the name of the highway.

% DelX and DelT are the spatial and temporal size of an individual bin.
% The resulting number of Bins must be an integer value. Hence, an
% arbitrary choice of DelX and DelT may not guarantee this. Therefore, your 
% input will be rounded to the closest value that guarantees the integer
% number of bins condition.


% The Following are correctly named highways:
% 1. 101
% 2. 80


%Outputs Returned:
% Bins is a cell array containing the Speed, Density and Flow Bins.
% Recall that the NGSIM data is provided in 15 minute intervals and the
% total 45 minutes must be concatented. 

% Specifically, for the 101, Bins is a 3x4 cell array.
% Bins{1,1:4} contains the Speed for the 1st, 2nd, 3rd 15 minutes and the
% conacetanation of all three.
% Bins{3,1:4} contains the Density for the 1st, 2nd, 3rd 15 minutes and the
% conacetanation of all three.
% Bins{3,1:4} contains the Flow for the 1st, 2nd, 3rd 15 minutes and the
% conacetanation of all three.

% Specifically, for the 80, Bins is a 3x4 cell array.
% Bins{1,1:4} contains the Speed for the 1st, 2nd, 3rd 15 minutes and the
% conacetanation of the last 30 minutes.
% Bins{1,2:4} contains the Density for the 1st, 2nd, 3rd 15 minutes and the
% conacetanation of the last 30 minutes.
% Bins{1,3:4} contains the Flow for the 1st, 2nd, 3rd 15 minutes and the
% conacetanation of the last 30 minutes.

% Trajectory contains the concatenated trajectories. 

%% Instructions for Filling Missing Data
% It is possible to obtain missing data
% values in certain bins due
% therefore in order to interpolate and fill missing 
% data call on the funciton:
% [Bins]=InterpolateandFill(Bins,Name,Size)
% The multilane data does not need to be interpolated as it is completely
% logical that not every lane will contain will always contain a vehicle.


%Inputs Required:

% Bins is the output of the Convert_NGSIM function.

% Name is a string containing the name of the highway.

% Size is the window size of the moving window used to perform a moving
% average window inperolation. The InterpolateandFill function will
% interactively allow you to tune the window size until the resulting data
% is satisfactory.

% Save is a logical value 1 or 0 indicating whether to generate text files
% storing the results. Only the filled data will be saved.

%% Examples:
clc; clear variables; close all;
[Bins,Trajectory]=Convert_NGSIM('101',20,5);
Bins=InterpolateandFill(Bins,'101',10,1);

clc; clear variables; close all;
[Bins,Trajectory]=Convert_NGSIM('80',20,5);
Bins=InterpolateandFill(Bins,'80',15,1);


clc; clear variables; close all;
[Bins]=Convert_NGSIM_MultiLane('101',20,10);