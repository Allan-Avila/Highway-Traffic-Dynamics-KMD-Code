%% Moving Horizon Hankel-DMD Forecasting
%Highway Traffic Dynamics: Data-Driven Analysis and Forecast 
%Allan M. Avila & Dr. Igor Mezic 2019
%University of California Santa Barbara
function [Prediction,Ptrue,MAE,MRE,RMSE,SAE,TMAE,SMAE,AvgTMAE,AvgSMAE]=...
          MovingHorizonHankelDMD(data,max_f)
%% Load Data
clc; close all;
tic
disp('Loading Data Set...')
if strcmp(data,'PeMs_I10_Week_Velocity')
Data=dlmread('I10_East_Week_Velocity_Data.txt'); 
dtype='Velocity'; hwy='I10E Highway'; delt=5;

elseif strcmp(data,'PeMs_I5_Month_Velocity')
Data=dlmread('I5_North_Month_Velocity_Data.txt');
dtype='Velocity'; hwy='I5N Highway'; delt=5;

elseif strcmp(data,'PeMs_US101_Rain_Feb17_Velocity_Data')
Data=dlmread('US101_Rain_Feb17_Velocity_Data.txt');
dtype='Velocity'; hwy='US 101N Highway Rain'; delt=5;

elseif strcmp(data,'PeMs_SoCal_Netwk_Dec2016_Velocity_Data')
Data=dlmread('SoCal_Netwk_Dec2016_Velocity_Data.txt');
dtype='Velocity'; hwy='SoCal Network Holiday'; delt=5;

elseif strcmp(data,'PeMs_LA_Multilane_Network_Density')
Data=dlmread('LA_Multilane_Netwk_Dec2018_Density_Data.txt');
dtype='Density'; hwy='LA Multi-lane Network'; delt=5;
end
toc

[nbx,nbt]=size(Data); % Get Data Size
Delt=5; % Sampling Frequency is 5 Mins
min_s=3;% Minimum Sampling of 15 Mins
min_f=min_s;% Minimum Forecasts of 15 Mins
max_s=max_f;% Maximum Sampling=Maximum Forecasting
Prediction{max(min_f,max_f),max(min_f,max_f)}=[]; % Preallocate
MAE=zeros(max(min_f,max_f),max(min_f,max_f)); % Preallocate
MRE=zeros(max(min_f,max_f),max(min_f,max_f)); % Preallocate
RMSE=zeros(max(min_f,max_f),max(min_f,max_f)); % Preallocate
SAE{max(min_f,max_f),max(min_f,max_f)}=[]; % Preallocate
TMAE{max(min_f,max_f),max(min_f,max_f)}=[]; % Preallocate
SMAE{max(min_f,max_f),max(min_f,max_f)}=[]; % Preallocate
AvgTMAE=zeros(max(min_f,max_f),max(min_f,max_f)); % Preallocate
AvgSMAE=zeros(max(min_f,max_f),max(min_f,max_f)); % Preallocate

%% Loop over Sampling and Forecasting Windows
disp('Generating Forecasts for Various Forecasting and Sampling Windows')
tic
for f=min_f:min_f:max_f % Loop over Forecast Size Steps of 15 Mins
for s=min_s:min_s:max_s % Loop over Sampling Size in Steps of 15 Mins

P=[]; PE=[]; E=[]; I=[]; R=[]; Ptrue=[];

for t=s:f:nbt-f % Slide Window
if mod(t,100)==0 % Display Progress
disp(['Delay=' num2str(delay) ' Forecasting Window=' num2str(f)...
    ' Sampling Window=' num2str(s) ' Current Time=' num2str(t)...
    ' Out of ' num2str(nbt-f)])
end
omega=[]; eigval=[]; Modes1=[]; bo=[]; % Clear 
Xdmd=[]; Xtrain=[]; det=[]; % Clear 
Xtrain=Data(:,t-s+1:t); % Training Data
Xfor=Data(:,t+1:t+f); % Ground Truth of Forecasted Data 
det=mean(Xtrain,2);% Compute and Store Time Average
delay=min(s-1);% Set Delays to Max Possible
[eigval,Modes1,bo] = H_DMD(Xtrain-det,delay); % Compute HDMD
omega=log(diag(eigval))./delt; Modes1=Modes1(1:nbx,:);
parfor time=1:s+f
Xdmd(:,time)=diag(exp(omega.*(time-1)))*bo;% Evolve
end
Xdmd=Modes1*Xdmd; % Compute Reconstructed & Forecasted Data
Xdmd=real(Xdmd+det);% Add the Average Back in
P=[P Xdmd(:,s+1:end)];% Only Store the Forecast
Ptrue=[Ptrue Xfor];
end % Window Sliding

Prediction{f,s}=P;% Store Entire Forecast for These f,w Values
E=P-Data(:,s+1:s+size(P,2));% Compute Error Matrix
I=size(E,1)*size(E,2);% Get Total # Elements in Error matrix
MAE(f,s)=sum(sum(abs(E)))./I;% Compute MAE
MRE(f,s)=sum(sum(abs(E)./Data(:,s+1:s+size(P,2))))./I;% Compute MRE
RMSE(f,s)=sqrt(sum(sum(E.^2))./I);% Compute RMSE


SAE{f,s}=abs(E)./mean(Data(:,s+1:s+size(P,2)),2);% Compute SAE
TMAE{f,s}=mean(abs(E),1);% Compute TMAE
SMAE{f,s}=mean(abs(E),2);% Compute SMAE
AvgTMAE(f,s)=mean(TMAE{f,s});% Compute Avg of TMAE
AvgSMAE(f,s)=mean(SMAE{f,s});% Compute Avg of SMAE

end % End Sampling Window Loop
end % End Forecasting WIndow Loop
disp('Forecasts Generated')
toc
tic
disp('Generating Plots')
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%% Plot Data, Forecasts and SAE
if ~strcmp(hwy,'LA Multi-lane Network')
figure('units','normalized','outerposition',[0 0 1 1])
subplot(1,3,1)
contourf(Data,'Linestyle','none')
xticks({}); yticks({});
h=colorbar; set(get(h,'title'),'string', {'MPH'});
title(['True Data ' hwy])

subplot(1,3,2)
contourf(Prediction{min_s,min_f},'Linestyle','none')
xticks({}); yticks({});
h=colorbar; set(get(h,'title'),'string', {'MPH'});
title(['Forecasted Data ' hwy])

subplot(1,3,3)
contourf(SAE{min_s,min_f},'Linestyle','none')
xticks({}); yticks({});
h=colorbar; set(get(h,'title'),'string', {'SAE'});
title(['Scaled Absolute Error ' hwy])
elseif strcmp(hwy,'LA Multi-lane Network')
d=0:minutes(5):hours(24); Time=datetime(1776,7,4)+d;
Time.Format='MMMM d,yyyy HH:mm'; Time=timeofday(Time(1:end-1));
PlotMultiLaneNetwork(Ptrue,Prediction{min_s,min_f},Time,min_s,min_f,hwy)

end
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%% Plot SMAE, TMAE and Histograms
figure('units','normalized','outerposition',[0 0 1 1])
subplot(3,1,1)
plot(SMAE{min_s,min_f})
hold on
plot(ones(1,length(SMAE{min_s,min_f})).*AvgSMAE(min_s,min_f),'m','Linewidth',2)
title([{hwy },{['SMAE for s=' num2str(min_s) ' f=' num2str(min_f)]}])
legend('SMAE','Avg of SMAE'); xticks({}); xlabel('Space'); axis('tight');

subplot(3,1,2)
plot(TMAE{min_s,min_f})
hold on
plot(ones(1,length(TMAE{min_s,min_f})).*AvgTMAE(min_s,min_f),'m','Linewidth',2)
title([{hwy },{['TMAE for s=' num2str(min_s) ' f=' num2str(min_f)]}])
legend('TMAE','Avg of TMAE'); xticks({}); xlabel('Time'); axis('tight');

subplot(3,1,3)
if ~strcmp(hwy,'LA Multi-lane Network')
histogram(Data(:,min_s+1:min_s+size(Prediction{min_s,min_f},2)),...
          'Normalization','pdf','Binwidth',.5); hold on
histogram(Prediction{min_s,min_f},'Normalization','pdf','Binwidth',.5)
title([{hwy },{['Histogram for s=' num2str(min_s) ' f=' num2str(min_f)]}])
legend('PEMS','KMD'); axis('tight'); xlabel('MPH');
elseif strcmp(hwy,'LA Multi-lane Network')
histogram(Data(:,min_s+1:min_s+size(Prediction{min_s,min_f},2)),...
          'Normalization','pdf'); hold on
histogram(Prediction{min_s,min_f},'Normalization','pdf')
title([{hwy },{['Histogram for s=' num2str(min_s) ' f=' num2str(min_f)]}])
legend('PEMS','KMD'); axis('tight'); xlabel('Vehicle Density')
end
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
%% Plot MAE,MRE,RMSE
MAE=MAE(min_f:min_f:max_f,min_s:min_s:max_s);% Select NonZero Entries
MRE=MRE(min_f:min_f:max_f,min_s:min_s:max_s);% Select NonZero Entries
RMSE=RMSE(min_f:min_f:max_f,min_s:min_s:max_s);% Select NonZero Entries

if ~isscalar(MAE)
figure('units','normalized','outerposition',[0 0 1 1])
subplot(1,3,1)
pcolor([[MAE MAE(:,end)];[MAE(end,:) MAE(end,end)]])
xticks([1.5 length(MAE)+.5]); xticklabels([delt*min_s,delt*max_s]);
yticks([1.5 length(MAE)+.5]); yticklabels([delt*min_s,delt*max_s]);
xlabel('Sampling Window [Min]')
ylabel('Forecasting Window [Min]')
h=colorbar;
set(get(h,'title'),'string', {'MAE'});
title(['MAE for ' hwy])

subplot(1,3,2)
pcolor([[MRE MRE(:,end)];[MRE(end,:) MRE(end,end)]])
xticks([1.5 length(MAE)+.5]); xticklabels([delt*min_s,delt*max_s]);
yticks([1.5 length(MAE)+.5]); yticklabels([delt*min_s,delt*max_s]);
xlabel('Sampling Window [Min]')
ylabel('Forecasting Window [Min]')
h=colorbar;
set(get(h,'title'),'string', {'MRE'});
title(['MRE for ' hwy])

subplot(1,3,3)
pcolor([[RMSE RMSE(:,end)];[RMSE(end,:) RMSE(end,end)]])
xticks([1.5 length(MAE)+.5]); xticklabels([delt*min_s,delt*max_s]);
yticks([1.5 length(MAE)+.5]); yticklabels([delt*min_s,delt*max_s]);
xlabel('Sampling Window [Min]')
ylabel('Forecasting Window [Min]')
h=colorbar;
set(get(h,'title'),'string', {'RMSE'});
axis('tight')
title(['RMSE for ' hwy])
else
disp('MAE, MRE & RMSE not Matrices')
disp(['MAE=' num2str(MAE) ' MRE=' num2str(MRE) ' RMSE=' num2str(RMSE)])
end
end % End Function