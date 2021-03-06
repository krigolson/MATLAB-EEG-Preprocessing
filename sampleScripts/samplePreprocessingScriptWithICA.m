clear all;
close all;
clc;

% Mat insert filename here
[EEG] = doLoadBVData();

%[EEG] = doResample(EEG,250);

% not needed but here for demonstration purposes
% [EEG] = doRemoveChannels(EEG,{},EEG.chanlocs);

[EEG] = doRereference(EEG,{'TP9','TP10'},{'ALL'},EEG.chanlocs);

EEG = doFilter(EEG,0.01,0,2,0,500);
EEG = doFilter(EEG,0,30,2,60,500);

[EEG] = doICA(EEG,0);

save('outICA','EEG');

% try running bit above and saving EEG file.

% this line plots topos
doICAPlotComponents(EEG,25);

% this line plots loadings (16) and shows the time range from 8000 to 10000
% - this you can change so a blink is in the window
doICAPlotComponentLoadings(EEG,16,[8000 10000]);

componentsToRemove = [1];
[EEG] = doICARemoveComponents(EEG,componentsToRemove);

% not needed but here for demonstration purposes
% [EEG] = doInterpolate(EEG,EEG.chanlocs,'spherical');

[EEG] = doSegmentData(EEG,{'S202','S203'},[-200 800]);

[EEG] = doBaseline(EEG,[-200,0]);

[EEG] = doArtifactRejection(EEG,'Gradient',30);
[EEG] = doArtifactRejection(EEG,'Difference',150);

[EEG] = doRemoveEpochs(EEG,EEG.artifactPresent);

[ERP] = doERP(EEG,{'S202','S203'});

% plot the results, a P300 on Channel 52 (Pz)
figure;
plot(ERP.times,ERP.data(52,:,1),'LineWidth',3);
hold on;
plot(ERP.times,ERP.data(52,:,2),'LineWidth',3);
hold off;
title('Channel Pz');
ylabel('Voltage (uV)');
xlabel('Time (ms)');
