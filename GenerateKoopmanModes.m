%% Generate Koopman Traffic Modes
%Highway Traffic Dynamics: Data-Driven Analysis and Forecast 
%Allan M. Avila & Dr. Igor Mezic 2019
%University of California Santa Barbara
function [Psi]=GenerateKoopmanModes(data,mode1,mode2,save)
%% Load Data
clc; close all;
disp('Loading Data Set...')
tic
if strcmp(data,'NGSIM_101_Velocity')
Data=dlmread('NGSIM_US101_Velocity_Data.txt'); 
delay=7; dtype='Velocity'; hwy='101'; 
delt=5; delx=20; hwylength=round(delx*size(Data,1));
elseif strcmp(data,'NGSIM_101_Density')
Data=dlmread('NGSIM_US101_Density_Data.txt'); 
delay=6; dtype='Density'; hwy='101'; 
delt=5; delx=20; hwylength=round(delx*size(Data,1));
elseif strcmp(data,'NGSIM_101_Flow')
Data=dlmread('NGSIM_US101_Flow_Data.txt'); 
delay=7; dtype='Flow'; hwy='101'; 
delt=5; delx=20; hwylength=round(delx*size(Data,1));
elseif strcmp(data,'NGSIM_101_MultiLane')
Lane1=load('NGSIM_US101_Lane1_Density_Data.txt');
Lane2=load('NGSIM_US101_Lane2_Density_Data.txt');
Lane3=load('NGSIM_US101_Lane3_Density_Data.txt');
Lane4=load('NGSIM_US101_Lane4_Density_Data.txt');
Lane5=load('NGSIM_US101_Lane5_Density_Data.txt');
Lane678=load('NGSIM_US101_Lane678_Density_Data.txt');
Data=[Lane1;Lane2;Lane3;Lane4;Lane5;Lane678];
delay=2; dtype='Density'; hwy='101 MultiLane'; delt=10; 
[NxLn,NtLn]=size(Lane1);

elseif strcmp(data,'NGSIM_80_4pm_Velocity')
Data=dlmread('NGSIM_US80_4pm_Velocity_Data.txt'); 
delay=3; dtype='Velocity'; hwylength=1600; hwy='80'; delt=5;
elseif strcmp(data,'NGSIM_80_4pm_Density')
Data=dlmread('NGSIM_US80_4pm_Density_Data.txt'); 
delay=3; dtype='Density'; hwylength=1600; hwy='80'; delt=5;
elseif strcmp(data,'NGSIM_80_4pm_Flow')
Data=dlmread('NGSIM_US80_4pm_Flow_Data.txt'); 
delay=3; dtype='Flow'; hwylength=1600; hwy='80'; delt=5;

elseif strcmp(data,'NGSIM_80_5pm_Velocity')
Data=dlmread('NGSIM_US80_5pm_Velocity_Data.txt'); 
delay=8; dtype='Velocity'; hwylength=1600; hwy='80'; delt=5;
elseif strcmp(data,'NGSIM_80_5pm_Density')
Data=dlmread('NGSIM_US80_5pm_Density_Data.txt'); 
delay=8; dtype='Density'; hwylength=1600; hwy='80'; delt=5;
elseif strcmp(data,'NGSIM_80_5pm_Flow')
Data=dlmread('NGSIM_US80_5pm_Flow_Data.txt'); 
delay=6; dtype='Flow'; hwylength=1600; hwy='80'; delt=5;

elseif strcmp(data,'PeMs_I10_Week_Velocity')
Data=dlmread('I10_East_Week_Velocity_Data.txt'); 
delay=13; dtype='Velocity'; hwylength=100; hwy='10'; delt=5;
elseif strcmp(data,'PeMs_I5_Month_Velocity')
Data=dlmread('I5_North_Month_Velocity_Data.txt');
delay=34; dtype='Velocity'; hwylength=330; hwy='5'; delt=5;
disp('This Data Set Takes Very long Time')
elseif strcmp(data,'PeMs_LA_Multilane_Network_Density')
Data=dlmread('LA_Multilane_Netwk_Dec2018_Density_Data.txt');
delay=2; dtype='Density'; hwy='LAntwk'; delt=5;
end
toc

%% Compute KMD and Sort Modes
disp('Computing KMD via Hankel-DMD...')
tic
Avg=mean(Data,2);% Compute and Store Time Average
[eigval,Modes1,bo] = H_DMD(Data-Avg,delay); % Compute HDMD
toc
disp('Sorting Modes...')
tic
  % Sampling Frequency of PeMs/NGSIM Data is 5 Minutes/Seconds.
omega=log(diag(eigval))./delt;% Compute Cont. Time Eigenvalues
Freal=imag(omega)./(2*pi);% Compute Frequency
[T,Im]=sort((1./Freal)./60,'descend');% Sort Frequencies
omega=omega(Im); Modes1=Modes1(:,Im); bo=bo(Im); % Sort Modes
toc

%% Compute and Plot Modes
disp('Computing and Plotting Modes...')
tic
[nbx,nbt]=size(Data); % Get Data Size
time=(0:nbt-1)*delt;% Specify Time Interval
Psi=zeros(nbx,nbt,mode2-mode1+1);
for i=mode1:mode2 % Loop Through all Modes to Plot.
psi=zeros(1,nbt);% Preallocate Time Evolution of Mode.
omeganow=omega(i);% Get Current Eigenvalue.
bnow=bo(i);% Get Current Amplitude Coefficient.
parfor t=1:length(time) 
psi(:,t)=exp(omeganow*time(t))*bnow; % Evolve for Time Length.
end
psi=Modes1(1:nbx,i)*psi;% Compute Mode.
Psi(:,:,i)=psi;% Store & Output Modes
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
FONTSIZE = 24;
TICKSIZE = 18;
if strcmp(hwy,'101') || strcmp(hwy,'80') % Plot NGSIM Modes
[X,Y]=meshgrid(time./60,linspace(0,hwylength,nbx));% Compute Mesh.
figure
s1=surfc(X,Y,real(psi));% Generate Surface Plot
set(s1,'LineStyle','none')% No Lines
title({['Koopman Mode #' num2str(i)  ],[ 'Period=' num2str(T(i),'%.2f')...
    ' Minutes    Growth/Decay Rate=' num2str(abs(exp(omega(i))),'%.4f')]})

title({['Koopman Mode #' num2str(i)  '      Period=' num2str(T(i),'%.2f')...
    ' Minutes']},'Interpreter','latex')

set(gca,'TickLabelInterpreter','latex','fontsize',TICKSIZE)
title(strcat('Koopman Mode #',num2str(i),'$,   Period=',num2str(T(i),'%.2f'),'Minutes $'),...
                     'fontsize',FONTSIZE,...
                     'Interpreter','Latex')

xlabel('Time [Minutes]','Interpreter','latex'); 
ylabel('Position Along Highway [Feet]','Interpreter','latex');
h=colorbar;

if strcmp(dtype,'Velocity')
set(get(h,'title'),'string', {'Feet/Second'});
elseif strcmp(dtype,'Density')
set(get(h,'title'),'string', {'Vehicles/Feet'});
elseif strcmp(dtype,'Flow')
set(get(h,'title'),'string', {'Vehicles/Second'});
end

if strcmp(hwy,'101')
hold on
plot3(X(29,:),Y(29,:),real(psi(29,:)),...
    'o','MarkerEdge',[.85, .325, .098],...
    'MarkerFace',[.85, .325, .098]);% Mark On-Ramp 29th index
plot3(X(61,:),Y(61,:),real(psi(61,:)),...
    'o','MarkerEdge',[.85, .325, .098],...
    'MarkerFace',[.85, .325, .098]);% Mark Off-Ramp 61st index
hold off
elseif strcmp(hwy,'80')
hold on
plot3(X(21,:),Y(21,:),real(psi(21,:)),'ro');% Mark On-Ramp
hold off
end

% Auto Save Figs!
if save
if strcmp(data,'NGSIM_101_Velocity')
fnam=sprintf('KMD_101_Velocity_Mode%d.jpg',i); 
elseif strcmp(data,'NGSIM_101_Density')
fnam=sprintf('KMD_101_Density_Mode%d.jpg',i); 
elseif strcmp(data,'NGSIM_101_Flow')
fnam=sprintf('KMD_101_Flow_Mode%d.jpg',i); 

elseif strcmp(data,'NGSIM_80_4pm_Velocity')
fnam=sprintf('KMD_80_4pm_Velocity_Mode%d.jpg',i); 
elseif strcmp(data,'NGSIM_80_4pm_Density')
fnam=sprintf('KMD_80_4pm_Density_Mode%d.jpg',i); 
elseif strcmp(data,'NGSIM_80_4pm_Flow')
fnam=sprintf('KMD_80_4pm_Flow_Mode%d.jpg',i); 

elseif strcmp(data,'NGSIM_80_5pm_Velocity')
fnam=sprintf('KMD_80_5pm_Velocity_Mode%d.jpg',i); 
elseif strcmp(data,'NGSIM_80_5pm_Density')
fnam=sprintf('KMD_80_5pm_Density_Mode%d.jpg',i); 
elseif strcmp(data,'NGSIM_80_5pm_Flow')
fnam=sprintf('KMD_80_5pm_Flow_Mode%d.jpg',i); 
end

Xportname='defaut'; 
s=hgexport('readstyle',Xportname);
s.Format = 'jpeg';
hgexport(gcf,fnam,s);
close
end
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
elseif strcmp(hwy,'101 MultiLane') % Plot NGSIM MultiLane Modes
psi=reshape(psi,NxLn,6,NtLn);
psi(1:27,6,:)=nan; psi(68:end,6,:)=nan; psi(:,6,:)=psi(:,6,:)*5;
mov(1:NtLn)=struct('cdata',[],'colormap',[]);
fnam=sprintf('NGSIM_US101_MultiLane_Mode%d.avi',i); 
vidObj = VideoWriter(fnam); 
vidObj.FrameRate=16; open(vidObj); h=figure(1); movegui(h, 'onscreen');
rect = get(h,'Position'); rect(1:2) = [0 0];
for j=1:length(time)
imagesc(real(psi(end-4:-1:5,:,j)))
title([{'US 101 Highway MultiLane Analysis'} ,{['Time= '...
    num2str(delt*j./60,'%.2f') ' Mode #= ' num2str(i,'%.2f') ' Period= '...
    num2str(T(i),'%.2f')]}])
xticks(1:6); 
xlabel('Lane [#]');
xticklabels({'Lane 1','Lane 2','Lane 3','Lane 4','Lane 5','Ramp'})
yticks(linspace(1,NxLn,6)); 
ylabel('Position Along Highway [Feet]'); 
yticklabels({'2100','1680','1260','840','420','0'})
h=colorbar; 
set(get(h,'title'),'string', {'$\frac{Veh.}{Feet}$'},'interpret','latex');
if i==1
caxis([-.0018,.0018]); 
else 
caxis([-.0013,.0013]); 
end


set(gca,'nextplot','replacechildren');
movegui(h, 'onscreen'); hold all;  drawnow; currFrame = getframe(gcf,rect); 
writeVideo(vidObj,currFrame)
end
close(vidObj)

%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
elseif strcmp(hwy,'10') || strcmp(hwy,'5') % Plot PeMs Modes
[X,Y]=meshgrid(time./60,linspace(0,hwylength,nbx));% Compute Mesh.
figure
s1=surfc(X,Y,real(psi));% Generate Surface Plot
set(s1,'LineStyle','none')% No lines
title({['Koopman Mode #' num2str(i)  ],[ 'Period=' num2str(T(i),'%.2f')...
    ' Hours    Growth/Decay Rate=' num2str(abs(exp(omega(i))),'%.4f')]})
xlabel('Time [Hours]'); ylabel('Position Along Highway [Miles]');
h=colorbar; set(get(h,'title'),'string', {'MPH'});
% Auto Save Figs!
if save
if strcmp(hwy,'10')
fnam=sprintf('KMD_I10_Mode%d.jpg',i); 
elseif strcmp(hwy,'5')
fnam=sprintf('KMD_I5_Mode%d.jpg',i); 
end
Xportname='defaut'; 
s=hgexport('readstyle',Xportname);
s.Format = 'jpeg';
hgexport(gcf,fnam,s);
close
end

%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
else % Plot LA Multi-Lane Netwk
figure
subplot(3,1,1)
contourf(real(psi),'Linestyle','none')
yticks([45,135,210,270,336,400,511,647,755,830])
yticklabels({'405N','405S','110N','110S','710N','710S','10E',...
             '10W','105E','105W'})
xticks([1,72,72*2,72*3,72*4])
xticklabels({'0','6','12','18','24'});
xlabel('Time [Hour]')
h=colorbar;
set(get(h,'title'),'string', {'% Occupancy'});
title({['Koopman Mode #' num2str(i)],['Period=' num2str(T(i),'%.2f')...
        ' Hours  Growth/Decay Rate=' num2str(abs(exp(omega(i))),'%.4f')]})
hold on
plot(90*ones(nbt),'r')
plot(180*ones(nbt),'r')
plot(240*ones(nbt),'r')
plot(300*ones(nbt),'r')
plot(372*ones(nbt),'r')
plot(444*ones(nbt),'r')
plot(582*ones(nbt),'r')
plot(720*ones(nbt),'r')
plot(795*ones(nbt),'r')
hold off
subplot(3,1,2)
contourf(angle(psi),'Linestyle','none')
yticks([45,135,210,270,336,400,511,647,755,830])
yticklabels({'405N','405S','110N','110S','710N','710S','10E',...
             '10W','105E','105W'})
xticks([1,72,72*2,72*3,72*4])
xticklabels({'0','6','12','18','24'});
xlabel('Time [Hour]')
h=colorbar;
set(get(h,'title'),'string', {'Radians'});
title(['Koopman Mode # ' num2str(i)  ' Phase'])
hold on
plot(90*ones(nbt),'r')
plot(180*ones(nbt),'r')
plot(240*ones(nbt),'r')
plot(300*ones(nbt),'r')
plot(372*ones(nbt),'r')
plot(444*ones(nbt),'r')
plot(582*ones(nbt),'r')
plot(720*ones(nbt),'r')
plot(795*ones(nbt),'r')
hold off
subplot(3,1,3)
contourf(abs(psi),'Linestyle','none')
yticks([45,135,210,270,336,400,511,647,755,830])
yticklabels({'405N','405S','110N','110S','710N','710S','10E','10W',...
             '105E','105W'})
xticks([1,72,72*2,72*3,72*4])
xticklabels({'0','6','12','18','24'});
xlabel('Time [Hour]')
h=colorbar;
set(get(h,'title'),'string', {'% Occupancy'});
title(['Koopman Mode # ' num2str(i)  ' Magnitude'])
hold on
plot(90*ones(nbt),'r')
plot(180*ones(nbt),'r')
plot(240*ones(nbt),'r')
plot(300*ones(nbt),'r')
plot(372*ones(nbt),'r')
plot(444*ones(nbt),'r')
plot(582*ones(nbt),'r')
plot(720*ones(nbt),'r')
plot(795*ones(nbt),'r')
hold off
m=20;
AvgPhase405N=mean(angle(psi(1:90,m)));
AvgPhase405S=mean(angle(psi(90:180,m)));
AvgPhase110N=mean(angle(psi(180:240,m)));
AvgPhase110S=mean(angle(psi(240:300,m)));
AvgPhase710N=mean(angle(psi(300:372,m)));
AvgPhase710S=mean(angle(psi(372:444,m)));
AvgPhase10E=mean(angle(psi(444:582,m)));
AvgPhase10W=mean(angle(psi(582:720,m)));
AvgPhase105E=mean(angle(psi(720:795,m)));
AvgPhase105W=mean(angle(psi(795:end,m)));
AvgPhase=[AvgPhase405N AvgPhase405S AvgPhase110N AvgPhase110S...
    AvgPhase710N AvgPhase710S AvgPhase10E AvgPhase10W AvgPhase105E...
    AvgPhase105W];




bar(AvgPhase);

h=title('Average Phase ','Interpreter','Latex');h.FontSize=18;
ylabel('Phase [Radians]','Interpreter','Latex'); 
xticklabels({'405N','405S','110N','110S','710N','710S','10E','10W',...
             '105E','105W'}); 


end %End If Statement for Highways

end %End Modes to Plot Loop
toc
disp('All Done')

end %End function
