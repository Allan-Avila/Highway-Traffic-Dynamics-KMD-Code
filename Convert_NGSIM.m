%% Convert NGSIM into Spatiotemporal Data
%Highway Traffic Dynamics: Data-Driven Analysis and Forecast 
%Allan M. Avila & Dr. Igor Mezic 2019
%University of California Santa Barbara
function [Bins,Trajectory]=Convert_NGSIM(Name,DelX,DelT)
tic
if strcmp(Name,'101')
disp('Loading NGSIM US 101 Trajectories')
Data1=dlmread('trajectories-0750am-0805am.txt'); % Read data
Data2=dlmread('trajectories-0805am-0820am.txt'); % Read data
Data3=dlmread('trajectories-0820am-0835am.txt'); % Read data
pass=1;
elseif strcmp(Name,'80')
Data1=dlmread('trajectories-0400-0415.txt'); % Read data
Data2=dlmread('trajectories-0500-0515.txt'); % Read data
Data3=dlmread('trajectories-0515-0530.txt'); % Read data
pass=1;
else
disp('Invalid Syntax for Data Type')
pass=0;
Bins=[];Trajectory=[];
end
toc

if pass
disp('Processing Trajectories')
tic
Data1(:,4)=Data1(:,4)./1000;        % Convert Golbal Time Into Seconds
Data2(:,4)=Data2(:,4)./1000;        % Convert Golbal Time Into Seconds
Data3(:,4)=Data3(:,4)./1000;        % Convert Golbal Time Into Seconds

if strcmp(Name,'101')
Data2(:,4)=Data2(:,4)-min(Data1(:,4));     % Shift Data2 Global Time
Data3(:,4)=Data3(:,4)-min(Data1(:,4));     % Shift Data3 Global Time
Data1(:,4)=Data1(:,4)-min(Data1(:,4));     % Shift Data1 Global Time

Data1=Data1(Data1(:,4)<=900,:);          % Exclude Data1 Past 15 Mins
Data2=Data2(Data2(:,4)>=900,:);          % Exclude Data1/Data2 Overlap
Data2=Data2(Data2(:,4)<=1800,:);         % Exclude Data2 Past 30 Mins
Data3=Data3(Data3(:,4)>=1800,:);         % Exclude Data2/Data3 Overlap
Data3=Data3(Data3(:,4)<=2700,:);         % Exclude Data2 Past 45 Mins


elseif strcmp(Name,'80')
Data1(:,4)=Data1(:,4)-min(Data1(:,4));     % Shift Data1 Global Time
Data3(:,4)=Data3(:,4)-min(Data2(:,4));     % Shift Data3 Global Time
Data2(:,4)=Data2(:,4)-min(Data2(:,4));     % Shift Data2 Global Time

Data1=Data1(Data1(:,4)<=900,:);          % Exclude Data1 Past 15 Mins
Data2=Data2(Data2(:,4)<=900,:);         % Exclude Data2 Past 15 Mins
Data3=Data3(Data3(:,4)>=900,:);         % Exclude Data2/Data3 Overlap
Data3=Data3(Data3(:,4)<=1800,:);         % Exclude Data2 Past 30 Mins

end


% Find Max Position
Max_X=max([max(Data1(:,6)),max(Data2(:,6)),max(Data3(:,6))]);
Max_T=max(Data1(:,4));                   % Find Max Time
NumBinsT=round(Max_T/DelT);              % Bins Must be Integer
NumBinsX=round(Max_X/DelX);              % Bins Must be Integer
DelT=Max_T/NumBinsT;                     % Compute Actual Time Step
DelX=Max_X/NumBinsX;                     % Compute Actual Spatial Step
SamplingRate=.1;                         % Specify NGSIM Sampling Rate

SpeedBins1=zeros(NumBinsX,NumBinsT);     % Initialize
SpeedBins2=zeros(NumBinsX,NumBinsT);     % Initialize
SpeedBins3=zeros(NumBinsX,NumBinsT);     % Initialize

DensityBins1=zeros(NumBinsX,NumBinsT);   % Initialize
DensityBins2=zeros(NumBinsX,NumBinsT);   % Initialize
DensityBins3=zeros(NumBinsX,NumBinsT);   % Initialize


t01=min(Data1(:,4)); t11=t01+DelT;       % Initialize Time Step 1
t02=min(Data2(:,4)); t12=t02+DelT;       % Initialize Time Step 2
t03=min(Data3(:,4)); t13=t03+DelT;       % Initialize Time Step 3
x0=0; x1=x0+DelX;                        % Initialize Spatial Step

toc
disp('Computing SpatioTemporal Data')
tic
for i=1:NumBinsX
for j=1:NumBinsT

% Compute Sum of All Speeds Within Bin_ij
% Compute Number of Vehicle Footprints Within Bin_ij
Speed1=sum(Data1(t01<=Data1(:,4) & Data1(:,4)<t11 &...
    x0<=Data1(:,6) & Data1(:,6)<x1,12));
Density1=length(Data1(t01<=Data1(:,4) & Data1(:,4)<t11 &...
    x0<=Data1(:,6) & Data1(:,6)<x1,12));

Speed2=sum(Data2(t02<=Data2(:,4) & Data2(:,4)<t12 &...
    x0<=Data2(:,6) & Data2(:,6)<x1,12));
Density2=length(Data2(t02<=Data2(:,4) & Data2(:,4)<t12 &...
    x0<=Data2(:,6) & Data2(:,6)<x1,12));

Speed3=sum(Data3(t03<=Data3(:,4) & Data3(:,4)<t13 &...
    x0<=Data3(:,6) & Data3(:,6)<x1,12));
Density3=length(Data3(t03<=Data3(:,4) & Data3(:,4)<t13 &... 
    x0<=Data3(:,6) & Data3(:,6)<x1,12));

SpeedBins1(i,j)=Speed1/Density1;         % Compute Average Speed 1
SpeedBins2(i,j)=Speed2/Density2;         % Compute Average Speed 2
SpeedBins3(i,j)=Speed3/Density3;         % Compute Average Speed 3

DensityBins1(i,j)=(Density1*SamplingRate)/(DelX*DelT); % Compute Density 1
DensityBins2(i,j)=(Density2*SamplingRate)/(DelX*DelT); % Compute Density 2
DensityBins3(i,j)=(Density3*SamplingRate)/(DelX*DelT); % Compute Density 3



t01=t11; t11=t11+DelT;                   % Update Time Step 1
t02=t12; t12=t12+DelT;                   % Update Time Step 1
t03=t13; t13=t13+DelT;                   % Update Time Step 1

end
t01=min(Data1(:,4)); t11=t01+DelT;       % Reset Time Step 1
t02=min(Data2(:,4)); t12=t02+DelT;       % Reset Time Step 2
t03=min(Data3(:,4)); t13=t03+DelT;       % Reset Time Step 3
x0=x1; x1=x1+DelX;                       % Update Spatial Step
end
 
DensityBins1(DensityBins1==0)=nan;       % Set Missing Density to NaN
DensityBins2(DensityBins2==0)=nan;       % Set Missing Density to NaN
DensityBins3(DensityBins3==0)=nan;       % Set Nissing Density to NaN


FlowBins1=SpeedBins1.*DensityBins1;       % Compute Flow 1
FlowBins2=SpeedBins2.*DensityBins2;       % Compute Flow 2
FlowBins3=SpeedBins3.*DensityBins3;       % Compute Flow 3

% Initialize and Store Outputs
Bins=cell(3,3);                           
Bins{1,1}=SpeedBins1; Bins{2,1}=DensityBins1; Bins{3,1}=FlowBins1;
Bins{1,2}=SpeedBins2; Bins{2,2}=DensityBins2; Bins{3,2}=FlowBins2;
Bins{1,3}=SpeedBins3; Bins{2,3}=DensityBins3; Bins{3,3}=FlowBins3;

if strcmp(Name,'101')
Bins{1,4}=[SpeedBins1 SpeedBins2 SpeedBins3];        % Concatenate
Bins{2,4}=[DensityBins1 DensityBins2 DensityBins3];  % Concatenate
Bins{3,4}=[FlowBins1 FlowBins2 FlowBins3];           % Concatenate
Trajectory=[Data1;Data2;Data3];                      % Concatenate


elseif strcmp(Name,'80')
Bins{1,4}=[SpeedBins2 SpeedBins3];                   % Concatenate
Bins{2,4}=[DensityBins2 DensityBins3];               % Concatenate
Bins{3,4}=[FlowBins2 FlowBins3];                     % Concatenate
Trajectory={Data1,[Data2;Data3]};                    % Concatenate


end

toc
end



disp('All Done')
end

