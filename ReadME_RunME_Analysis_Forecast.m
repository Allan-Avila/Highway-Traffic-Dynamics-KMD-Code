%Highway Traffic Dynamics: Data-Driven Analysis and Forecast 
%Allan M. Avila 2019
%University of California Santa Barbara

%% Instructions for Koopman Modes.
% To generate Koopman modes call on the function:
% Modes=GenerateKoopmanModes(Data,Mode1,Mode2,Save)

%Inputs Required:
% Data is a string containing the name of the data set.

% Mode1 and Mode2 are integers indicating which modes to produce.
% Ordered by their period of oscilaliton from slowest to fastest.
% Mode1 can be < or = Mode2.

% Save is a logical (0 or 1) indicating the modes to be saved as jpeg's. 
% Except for the multliLane modes which are videos.


% The Following are correctly named data sets for generating Koopman Modes:
% 1. NGSIM_101_Velocity
% 2. NGSIM_101_Density
% 3. NGSIM_101_Flow
% 4. NGSIM_101_MultiLane
% 
% 5. NGSIM_80_4pm_Velocity
% 6. NGSIM_80_4pm_Density
% 7. NGSIM_80_4pm_Flow
% 
% 8. NGSIM_80_5pm_Velocity
% 9. NGSIM_80_5pm_Density
% 10. NGSIM_80_5pm_Flow
% 
% 11. PeMs_I10_Week_Velocity
% 12. PeMs_I5_Month_Velocity
% 13. PeMs_LA_Multilane_Network_Density

%Outputs Returned:
% Modes is an n by m by #modes sized  array. 
% For example Modes(:,:,i) contains the i'th mode.

%Plots Generated:
% The funciton will generate plots of the desired Koopman Modes.

% Examples:
clc; clear variables; close all;
Modes101_Velocity=GenerateKoopmanModes('NGSIM_101_Velocity',1,1,0);

clc; clear variables; close all;
Modes101_Density=GenerateKoopmanModes('NGSIM_101_Density',1,1,0);

clc; clear variables; close all;
Modes101_Flow=GenerateKoopmanModes('NGSIM_101_Flow',1,1,0);

clc; clear variables; close all;
Modes80_4pm_Velocity=GenerateKoopmanModes('NGSIM_80_4pm_Velocity',1,1,0);

clc; clear variables; close all;
Modes80_4pm_Density=GenerateKoopmanModes('NGSIM_80_4pm_Density',1,1,0);

clc; clear variables; close all;
Modes80_4pm_Flow=GenerateKoopmanModes('NGSIM_80_5pm_Flow',1,1,0);

clc; clear variables; close all;
Modes80_5pm_Velocity=GenerateKoopmanModes('NGSIM_80_5pm_Velocity',1,1,0);

clc; clear variables; close all;
Modes80_5pm_Density=GenerateKoopmanModes('NGSIM_80_5pm_Density',1,1,0);

clc; clear variables; close all;
Modes80_5pm_Flow=GenerateKoopmanModes('NGSIM_80_5pm_Flow',1,1,0);

clc; clear variables; close all;
Modes101_Multi_Velocity=GenerateKoopmanModes('NGSIM_101_MultiLane',1,14,0);

clc; clear variables; close all;
Modes_I10_Velocity=GenerateKoopmanModes(...
    'PeMs_I10_Week_Velocity',1,10,0);

clc; clear variables; close all;
Modes_I5_Velocity=GenerateKoopmanModes(...
    'PeMs_I5_Month_Velocity',1,10,0);

clc; clear variables; close all;
Modes_MultiLaneNetwork_Velocity=GenerateKoopmanModes(...
    'PeMs_LA_Multilane_Network_Density',1,1,0);

%% Instructions for Forecasting.
% To forecsast PeMs data call on the function:
% [Prediction,MAE,MRE,RMSE,SAE,TMAE,SMAE,AvgTMAE,AvgSMAE]=...
% MovingHorizonHankelDMD(Data,Max_f)

% Inputs Required:
% Data is a string containing the name of the data set.

% Max_f is an integer multiple of 3 indicating the maximum forecasting 
% window size as a multiple of the PeMs data set sampling size (5 minutes).
% For example a Max_f=60 corresponds to a maximum sampling window size of 
% 60*5 minutes=300 minutes=5 hours.

% The Following are correctly named data sets for forecasting:
 
% 1. PeMs_I10_Week_Velocity
% 2. PeMs_I5_Month_Velocity
% 3. PeMs_US101_Rain_Feb17_Velocity_Data
% 4. PeMs_SoCal_Netwk_Dec2016_Velocity_Data
% 5. PeMs_LA_Multilane_Network_Density

%Outputs Returned:
% Prediction is a Max_f by Max_f sized array containing the forecasts for
% each sampling,forecasting window size combination. For example a single
% element of the array Prediction corresponds to a n by m matrix 
% whose values are the forecasts produced for the dataset. Note m<total
% number of timepoints of original data depending on the size of the
% sampling window.

% MAE is the mean absolute error. Equation 
 
% MRE is the mean relative error. Equation 
 
% RMSE is the root mean squared error. Equation 
 
% SAE is the scaled absolute error. Equation 
 
% TMAE is the temporal mean absolute error. Equation 
 
% SMAE is the spatial mean absolute error. Equation 
 
% AvgTMAE is the average of the TMAE. 
 
% AvgSMAE is the average of the SMAE.

%Plots Generated:
% The function will generate plots of:
% The raw data, forecasted data and scaled absolute error in one fig.
% The SMAE, TMAE and histograms of the raw and forecasted data in one fig.
% The MAE, MRE, and MSRE in one fig.

%Examples:
% Select a case and run
clc; clear variables; close all;
[Prediction,MAE,MRE,RMSE,SAE,TMAE,SMAE,AvgTMAE,AvgSMAE]=...
    MovingHorizonHankelDMD('PeMs_I10_Week_Velocity',30);

clc; clear variables; close all;
[Prediction,MAE,MRE,RMSE,SAE,TMAE,SMAE,AvgTMAE,AvgSMAE]=...
    MovingHorizonHankelDMD('PeMs_I5_Month_Velocity',30);

clc; clear variables; close all;
[Prediction,MAE,MRE,RMSE,SAE,TMAE,SMAE,AvgTMAE,AvgSMAE]=...
    MovingHorizonHankelDMD('PeMs_US101_Rain_Feb17_Velocity_Data',30);

clc; clear variables; close all;
[Prediction,MAE,MRE,RMSE,SAE,TMAE,SMAE,AvgTMAE,AvgSMAE]=...
    MovingHorizonHankelDMD('PeMs_SoCal_Netwk_Dec2016_Velocity_Data',30);

clc; clear variables; close all;
[Prediction,True,MAE,MRE,RMSE,SAE,TMAE,SMAE,AvgTMAE,AvgSMAE]=...
    MovingHorizonHankelDMD('PeMs_LA_Multilane_Network_Density',3);






