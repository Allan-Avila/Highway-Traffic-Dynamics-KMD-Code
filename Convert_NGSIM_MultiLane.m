%% Convert NGSIM into Multilane Spatiotemporal Data
%Highway Traffic Dynamics: Data-Driven Analysis and Forecast 
%Allan M. Avila & Dr. Igor Mezic 2019
%University of California Santa Barbara
function [Bins]=Convert_NGSIM_MultiLane(Name,DelX,DelT)
tic
if strcmp(Name,'101')
disp('Loading NGSIM US 101 Trajectories')
Data1=dlmread('trajectories-0750am-0805am.txt');
Data2=dlmread('trajectories-0805am-0820am.txt');
Data3=dlmread('trajectories-0820am-0835am.txt');
pass=1;
else
disp('Invalid Syntax for Data Type')
pass=0;
Bins=[];
end
toc

if pass
disp('Processing Trajectories')
tic
Data1(:,4)=Data1(:,4)./1000;        % Convert Golbal Time Into Seconds
Data2(:,4)=Data2(:,4)./1000;        % Convert Golbal Time Into Seconds
Data3(:,4)=Data3(:,4)./1000;        % Convert Golbal Time Into Seconds

Data2(:,4)=Data2(:,4)-min(Data1(:,4));     % Shift Data2 Global Time
Data3(:,4)=Data3(:,4)-min(Data1(:,4));     % Shift Data3 Global Time
Data1(:,4)=Data1(:,4)-min(Data1(:,4));     % Shift Data1 Global Time
Data=[Data1;Data2;Data3];                  % Concatenate Data
Data=Data(Data(:,4)<=2700,:);              % Exclude Data Past 45 Mins

% Find Max Position
Max_X=max(Data(:,6));                    % Find Max Spatial Location
Max_T=max(Data(:,4));                    % Find Max Time
NumBinsT=round(Max_T/DelT);              % Bins Must be Integer
NumBinsX=round(Max_X/DelX);              % Bins Must be Integer
DelT=Max_T/NumBinsT;                     % Compute Actual Time Step
DelX=Max_X/NumBinsX;                     % Compute Actual Spatial Step
SamplingRate=.1;                         % Specify NGSIM Sampling Rate

DensityBins1=zeros(NumBinsX,NumBinsT);   % Initialize
DensityBins2=zeros(NumBinsX,NumBinsT);   % Initialize
DensityBins3=zeros(NumBinsX,NumBinsT);   % Initialize
DensityBins4=zeros(NumBinsX,NumBinsT);   % Initialize
DensityBins5=zeros(NumBinsX,NumBinsT);   % Initialize
DensityBins678=zeros(NumBinsX,NumBinsT); % Initialize

t0=min(Data1(:,4)); t1=t0+DelT;       % Initialize Time Step 
x0=0; x1=x0+DelX;                     % Initialize Spatial Step

toc
disp('Computing SpatioTemporal Data')
tic
for i=1:NumBinsX
for j=1:NumBinsT

% Compute Sum of All Speeds Within Bin_ij
% Compute Number of Vehicle Footprints Within Bin_ij

Density1=length(Data(t0<=Data(:,4) & Data(:,4)<t1 &...
    x0<=Data(:,6) & Data(:,6)<x1 & Data(:,14)==1,12));


Density2=length(Data(t0<=Data(:,4) & Data(:,4)<t1 &...
    x0<=Data(:,6) & Data(:,6)<x1 & Data(:,14)==2,12));


Density3=length(Data(t0<=Data(:,4) & Data(:,4)<t1 &... 
    x0<=Data(:,6) & Data(:,6)<x1 & Data(:,14)==3,12));


Density4=length(Data(t0<=Data(:,4) & Data(:,4)<t1 &...
    x0<=Data(:,6) & Data(:,6)<x1 & Data(:,14)==4,12));


Density5=length(Data(t0<=Data(:,4) & Data(:,4)<t1 &...
    x0<=Data(:,6) & Data(:,6)<x1 & Data(:,14)==5,12));


Density678=length(Data(t0<=Data(:,4) & Data(:,4)<t1 &... 
    x0<=Data(:,6) & Data(:,6)<x1 & (Data(:,14)==6 | Data(:,14)==7 |...
    Data(:,14)==8),12));

DensityBins1(i,j)=(Density1*SamplingRate)/(DelX*DelT); % Compute Density 1
DensityBins2(i,j)=(Density2*SamplingRate)/(DelX*DelT); % Compute Density 2
DensityBins3(i,j)=(Density3*SamplingRate)/(DelX*DelT); % Compute Density 3
DensityBins4(i,j)=(Density4*SamplingRate)/(DelX*DelT); % Compute Density 4
DensityBins5(i,j)=(Density5*SamplingRate)/(DelX*DelT); % Compute Density 5
DensityBins678(i,j)=(Density678*SamplingRate)/(DelX*DelT); % Compute 678

t0=t1; t1=t1+DelT;                    % Update Time Step

end
t0=min(Data1(:,4)); t1=t0+DelT;       % Reset Time Step 
x0=x1; x1=x1+DelX;                    % Update Spatial Step
end

DensityBins1(DensityBins1==0)=nan;       % Set Zero Density to NaN
DensityBins2(DensityBins2==0)=nan;       % Set Zero Density to NaN
DensityBins3(DensityBins3==0)=nan;       % Set Zero Density to NaN
DensityBins4(DensityBins4==0)=nan;       % Set Zero Density to NaN
DensityBins5(DensityBins5==0)=nan;       % Set Zero Density to NaN
DensityBins678(DensityBins678==0)=nan;   % Set Zero Density to NaN

% Find Index of Rows With Missing Data
[Lane11,T1]=rmmissing(...
    DensityBins1,1,'MinNumMissing',round(size(DensityBins1,2)./5));
[Lane22,T2]=rmmissing....
    (DensityBins2,1,'MinNumMissing',round(size(DensityBins2,2)./5));
[Lane33,T3]=rmmissing(...
    DensityBins3,1,'MinNumMissing',round(size(DensityBins3,2)./5));
[Lane44,T4]=rmmissing(...
    DensityBins4,1,'MinNumMissing',round(size(DensityBins4,2)./5));
[Lane55,T5]=rmmissing(...
    DensityBins5,1,'MinNumMissing',round(size(DensityBins5,2)./5));


[Lane11,T11]=rmmissing(Lane11,2); % Find Index of Columns with Missing Data
[Lane22,T22]=rmmissing(Lane22,2); % Find Index of Columns with Missing Data
[Lane33,T33]=rmmissing(Lane33,2); % Find Index of Columns with Missing Data
[Lane44,T44]=rmmissing(Lane44,2); % Find Index of Columns with Missing Data
[Lane55,T55]=rmmissing(Lane55,2); % Find Index of Columns with Missing Data

% Use Indices to Evenly Remove Rows/Columns With Missing Data
DensityBins1=DensityBins1(~(T1&T2&T3&T4&T5),~(T11&T22&T33&T44&T55));
DensityBins2=DensityBins2(~(T1&T2&T3&T4&T5),~(T11&T22&T33&T44&T55));
DensityBins3=DensityBins3(~(T1&T2&T3&T4&T5),~(T11&T22&T33&T44&T55));
DensityBins4=DensityBins4(~(T1&T2&T3&T4&T5),~(T11&T22&T33&T44&T55));
DensityBins5=DensityBins5(~(T1&T2&T3&T4&T5),~(T11&T22&T33&T44&T55));
DensityBins678=DensityBins678(~(T1&T2&T3&T4&T5),~(T11&T22&T33&T44&T55));

DensityBins1(isnan(DensityBins1))=0; % Set Remaining Missing Data to Zero 
DensityBins2(isnan(DensityBins2))=0; % Set Remaining Missing Data to Zero 
DensityBins3(isnan(DensityBins3))=0; % Set Remaining Missing Data to Zero 
DensityBins4(isnan(DensityBins4))=0; % Set Remaining Missing Data to Zero 
DensityBins5(isnan(DensityBins5))=0; % Set Remaining Missing Data to Zero 
DensityBins678(isnan(DensityBins678))=0;%Set Remaining Missing Data to Zero 

% Initialize and Store Outputs
Bins=cell(3,6);                           
Bins{1,1}=DensityBins1; 
Bins{1,2}=DensityBins2; 
Bins{1,3}=DensityBins3; 
Bins{1,4}=DensityBins4; 
Bins{1,5}=DensityBins5; 
Bins{1,6}=DensityBins678; 
toc
disp('All Done')
end

