%% Interpolate and Fill Missing Spatiotemporal Data
%Highway Traffic Dynamics: Data-Driven Analysis and Forecast 
%Allan M. Avila & Dr. Igor Mezic 2019
%University of California Santa Barbara
function [Bins]=InterpolateandFill(Bins,Name,Size,Save)
if strcmp(Name,'101')
% Remove Rows Missing More Than 20% of Data
Bins{1,5}=rmmissing(...
    Bins{1,4},1,'MinNumMissing',round(size(Bins{1,4},2)./5));
Bins{2,5}=rmmissing(...
    Bins{2,4},1,'MinNumMissing',round(size(Bins{2,4},2)./5));
Bins{3,5}=rmmissing(...
    Bins{3,4},1,'MinNumMissing',round(size(Bins{3,4},2)./5));
elseif strcmp(Name,'80')
% Remove Rows Missing More Than 20% of Data
Bins{1,5}=rmmissing(...
    Bins{1,1},1,'MinNumMissing',round(size(Bins{1,1},2)./5));
Bins{2,5}=rmmissing(...
    Bins{2,1},1,'MinNumMissing',round(size(Bins{2,1},2)./5));
Bins{3,5}=rmmissing(...
    Bins{3,1},1,'MinNumMissing',round(size(Bins{3,1},2)./5));

Bins{1,6}=rmmissing(...
    Bins{1,4},1,'MinNumMissing',round(size(Bins{1,4},2)./5));
Bins{2,6}=rmmissing(...
    Bins{2,4},1,'MinNumMissing',round(size(Bins{2,4},2)./5));
Bins{3,6}=rmmissing(...
    Bins{3,4},1,'MinNumMissing',round(size(Bins{3,4},2)./5));
end


if strcmp(Name,'101')
while (1)
% Plot Interpolated Data
subplot(1,3,1)
contourf(fillmissing(Bins{1,5},'movmean',[Size,Size],2),'linestyle','none')
subplot(1,3,2)
contourf(fillmissing(Bins{2,5},'movmean',[Size,Size],2),'linestyle','none')
subplot(1,3,3)
contourf(fillmissing(Bins{3,5},'movmean',[Size,Size],2),'linestyle','none')
% Ask User if They are Satisfied with Interpolated Results.
% 1 and 0  Correspond to User Answering Yes or CLosing Figure
% 2 Corresponds to User Answering No.
choice = menu('Are you content with results','Yes','No');
if choice==1 || choice==0
   break;
elseif choice==2                                        
% Prompt User for Another Window Size for Interpolation.
prompt={'Enter New Moving Average Window Size'};
dlgtitle='Window Size';
definput={'10'};
Answer=inputdlg(prompt,dlgtitle,[1 100],definput);
Size=str2double(Answer{1});
end

end
% Perform Interpolation With New Window Size
Bins{1,5}=fillmissing(Bins{1,5},'movmean',[Size,Size],2);
Bins{2,5}=fillmissing(Bins{2,5},'movmean',[Size,Size],2);
Bins{3,5}=fillmissing(Bins{3,5},'movmean',[Size,Size],2);

if Save
% Store Outputs if User Specified
A=Bins{1,5}; B=Bins{2,5}; C=Bins{3,5};
save('NGSIM_US101_Velocity_Data.txt','A','-ASCII','-append');
save('NGSIM_US101_Density_Data.txt','B','-ASCII','-append');
save('NGSIM_US101_Flow_Data.txt','C','-ASCII','-append');
end

elseif strcmp(Name,'80')
while (1)
% Plot Interpolated Data
subplot(2,3,1)
contourf(fillmissing(Bins{1,5},'movmean',[Size,Size],2),'linestyle','none')
subplot(2,3,2)
contourf(fillmissing(Bins{2,5},'movmean',[Size,Size],2),'linestyle','none')
subplot(2,3,3)
contourf(fillmissing(Bins{3,5},'movmean',[Size,Size],2),'linestyle','none')
subplot(2,3,4)
contourf(fillmissing(Bins{1,6},'movmean',[Size,Size],2),'linestyle','none')
subplot(2,3,5)
contourf(fillmissing(Bins{2,6},'movmean',[Size,Size],2),'linestyle','none')
subplot(2,3,6)
contourf(fillmissing(Bins{3,6},'movmean',[Size,Size],2),'linestyle','none')
% Ask User if They are Satisfied with Interpolated Results.
% 1 and 0  Correspond to User Answering Yes or CLosing Figure
% 2 Corresponds to User Answering No.
choice = menu('Are you content with results','Yes','No');
if choice==1 || choice==0
   break;
elseif choice==2
% Prompt User for Another Window Size for Interpolation.
prompt={'Enter New Moving Average Window Size'};
dlgtitle='Window Size';
definput={'10'};
Answer=inputdlg(prompt,dlgtitle,[1 100],definput);
Size=str2double(Answer{1});
end

end
% Perform Interpolation With New Window Size
Bins{1,5}=fillmissing(Bins{1,5},'movmean',[Size,Size],2);
Bins{2,5}=fillmissing(Bins{2,5},'movmean',[Size,Size],2);
Bins{3,5}=fillmissing(Bins{3,5},'movmean',[Size,Size],2);

Bins{1,6}=fillmissing(Bins{1,6},'movmean',[Size,Size],2);
Bins{2,6}=fillmissing(Bins{2,6},'movmean',[Size,Size],2);
Bins{3,6}=fillmissing(Bins{3,6},'movmean',[Size,Size],2);

if Save
% Store Outputs if User Specified.
A=Bins{1,5}; B=Bins{2,5}; C=Bins{3,5};
D=Bins{1,6}; E=Bins{2,6}; F=Bins{3,6};

save('NGSIM_US80_4pm_Velocity_Data.txt','A','-ASCII','-append');
save('NGSIM_US80_4pm_Density_Data.txt','B','-ASCII','-append');
save('NGSIM_US80_4pm_Flow_Data.txt','C','-ASCII','-append');
save('NGSIM_US80_5pm_Velocity_Data.txt','D','-ASCII','-append');
save('NGSIM_US80_5pm_Density_Data.txt','E','-ASCII','-append');
save('NGSIM_US80_5pm_Flow_Data.txt','F','-ASCII','-append');
end



end

end

