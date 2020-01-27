%% Plot MuliLane Network Forecasts
%Highway Traffic Dynamics: Data-Driven Analysis and Forecast 
%Allan M. Avila & Dr. Igor Mezic 2019
%University of California Santa Barbara
function [] = PlotMultiLaneNetwork(Data,Forecasts,Time,s,f,hwy)
%% Sort Raw Data Into Seperate Highways
Data405=Data(1:180,:);% I405 Raw Data
Data110=Data(181:300,:);% I110 Raw Data
Data710=Data(301:444,:);% I710 Raw Data
Data10=Data(445:720,:);% I10 Raw Data
Data105=Data(721:end,:);% I105 Raw Data

% Reshape RawnData Into Multi-Lane Data 6 Lanes per Highway
Data405=reshape(Data405,30,6,285);% I405 Multi-Lane Data
Data110=reshape(Data110,20,6,285);% I110 Multi-Lane Data
Data710=reshape(Data710,24,6,285);% I710 Multi-Lane Data
Data10=reshape(Data10,46,6,285);% I10 Multi-Lane Data
Data105=reshape(Data105,25,6,285);% I105 Multi-Lane Data

%% Sort Forecasted Data Into Seperate Highways
Forecasts405=Forecasts(1:180,:);% I405 Forecasted Data
Forecasts110=Forecasts(181:300,:);% I110 Forecasted Data
Forecasts710=Forecasts(301:444,:);% I710 Forecasted Data
Forecasts10=Forecasts(445:720,:);% I10 Forecasted Data
Forecasts105=Forecasts(721:end,:);% I105 Forecasted Data

% Reshape Forecasted Data Into Multi-Lane Data 6 Lanes per Highway
Forecasts405=reshape(Forecasts405,30,6,285);% I405 Multi-Lane Data
Forecasts110=reshape(Forecasts110,20,6,285);% I110 Multi-Lane Data
Forecasts710=reshape(Forecasts710,24,6,285);% I710 Multi-Lane Data
Forecasts10=reshape(Forecasts10,46,6,285);% I10 Multi-Lane Data
Forecasts105=reshape(Forecasts105,25,6,285);% I105 Multi-Lane Data

%% Get Number of Spatial Points in Multi-lane Data and Time Vector
nx405=size(Data405,1);
nx110=size(Data110,1);
nx710=size(Data710,1);
nx10=size(Data10,1);
nx105=size(Data105,1);
nt=length(Time);

%% Create Video Object
mov(1:nt)=struct('cdata',[],'colormap',[]);
vidObj = VideoWriter('LA_Multilane_Network_Forecast.avi'); 
vidObj.FrameRate=2; open(vidObj); h=figure(1); movegui(h, 'onscreen');
rect = get(h,'Position'); rect(1:2) = [0 0];

%% Generate Video
for t=s+1:nt % Loop Over Time Window

Net=nan(38,46);% Create Forecasted Network to Plot
Net(end:-1:end-nx405+1,1:3)=Forecasts405(:,6:-1:4,t-s);%I405 SouthBound
Net(end:-1:end-nx405+1,5:7)=Forecasts405(:,1:3,t-s);%I405 NorthBound
Net(end-8:-1:end-8-nx110+1,20:22)=Forecasts110(:,6:-1:4,t-s);%I110 SouthBound
Net(end-8:-1:end-8-nx110+1,24:26)=Forecasts110(:,1:3,t-s);%I110 NorthBound
Net(end-4:-1:end-4-nx710+1,36:38)=Forecasts710(:,6:-1:4,t-s);%I710 SouthBound
Net(end-4:-1:end-4-nx710+1,40:42)=Forecasts710(:,1:3,t-s);%I710 NorthBound
Net(end:-1:end-2,10:34)=Forecasts105(:,1:3,t-s)';%I105 EastBound
Net(end-4:-1:end-6,10:34)=Forecasts105(:,6:-1:4,t-s)';%I105 WestBound
Net(5:7,1:46)=Forecasts10(:,1:3,t-s)';%I10 EastBound
Net(1:3,1:46)=Forecasts10(:,6:-1:4,t-s)';%I10 WestBound

set(gca,'nextplot','replacechildren'); figure(1); subplot(1,2,1)
imagesc(Net,[0 .7]) % Plot Forecasted Network   
axis off; colorbar;
title([{hwy},{['Forecasted Conditions for ' datestr(Time(t),'HH:MM')]}]); 

% if t>s+f % If One Forecasting Window has Passed then Plot True Data
NetData=nan(38,46);
NetData(end:-1:end-nx405+1,1:3)=Data405(:,6:-1:4,t-f);%I405 SouthBound
NetData(end:-1:end-nx405+1,5:7)=Data405(:,1:3,t-f);%I405 SouthBound
NetData(end-8:-1:end-8-nx110+1,20:22)=Data110(:,6:-1:4,t-f);%I110 SouthBound
NetData(end-8:-1:end-8-nx110+1,24:26)=Data110(:,1:3,t-f);%I110 NorthBound
NetData(end-4:-1:end-4-nx710+1,36:38)=Data710(:,6:-1:4,t-f);%I710 SouthBound
NetData(end-4:-1:end-4-nx710+1,40:42)=Data710(:,1:3,t-f);%I710 NorthBound
NetData(end:-1:end-2,10:34)=Data105(:,1:3,t-f)';%I105 EastBound
NetData(end-4:-1:end-6,10:34)=Data105(:,6:-1:4,t-f)';%I105WestBound
NetData(5:7,1:46)=Data10(:,1:3,t-f)';%I10 EastBound
NetData(1:3,1:46)=Data10(:,6:-1:4,t-f)';%I10 WestBound

subplot(1,2,2);
imagesc(NetData,[0 .7])% Plot True Network Conditions
axis off; colorbar;
title([{hwy},{['True Condtions for ' datestr(Time(t),'HH:MM')]}]); 
% end % End IF statement
movegui(h, 'onscreen'); hold all;  drawnow; currFrame = getframe(gcf,rect); 
writeVideo(vidObj,currFrame)
pause(.25)
end % End FOR Loop
close(vidObj)
end % End Function

