%% Read Data
chanID1=897;
chanID2=937;

params.fs=30000;
chanNum=1024;

Index=[0:200:600];

for i=1:(length(Index)-1)
params.tbeg=Index(i);
params.tend=Index(i+1);

fp=fopen('D:\220802_172556.bin','r');

fseek(fp,params.tbeg*params.fs*chanNum*2,'bof');

tempData=fread(fp,[chanNum params.fs*(params.tend-params.tbeg)],'int16');
data{i,1}=tempData(chanID1:chanID2,:);
clear tempData
end

data=[data{1,1} data{2,1} data{3,1}];


for i=1:size(data,1)
    Data_LFP{i,1}=data(i,:)';
end


%% Filtering

[b,a]=butter(2,[1 300]/15000);

for i=1:size(data,1)
    Data_LFP{i,1}=filtfilt(b,a,Data_LFP{i,1}); 
end


% Using chronux toolbox 
TW1=2;
params1.tapers=[TW1 2*TW1-1];
params1.Fs=30000;

for i=1:size(data,1)
Data_LFP{i,1}(:,:)=rmlinesc(Data_LFP{i,1}(:,:),params1,[],'n',50); % filter 50Hz
end

% Filter Design

deltaFilter = designfilt('lowpassiir','FilterOrder',4, ...
         'PassbandFrequency',4,'PassbandRipple',0.2, ...
         'SampleRate',30000);

% Filter data
for i=1:size(data,1)
    Data_LFP{i,2}=filtfilt(deltaFilter,Data_LFP{i,1}); 
end

%% Organize data
for i=1:length(Data_LFP)
    tempLFP(i,:)=Data_LFP{i,1}';
    tempDelta(i,:)=Data_LFP{i,2}';    
end

clear Data_LFP data

%% Compute phase angle

load('D:\PL2_spikes_ch897_ch937.mat');

for i=1:size(tempDelta,1)
    htempDelta(i,:)=hilbert(tempDelta(i,:));
    AngleTempDelta(i,:)=angle(htempDelta(i,:));
    Index2=find(spike_matrix(i,:)>0);
    for j=1:length(Index2)
        sAngleTempDelta_1(i,j)=AngleTempDelta(i,Index2(j));
    end
end

sAngleTempDelta1_1=reshape(sAngleTempDelta_1,[1 size(sAngleTempDelta_1,1)*size(sAngleTempDelta_1,2)]);

sAngleTempDelta2_1=sAngleTempDelta1_1(find(sAngleTempDelta1_1));


%% Plot and statistical analysis
A=sAngleTempDelta2_1;
polarhistogram(A,18,'Normalization','probability');
h=polarhistogram(A,18,'Normalization','probability','FaceColor','none');
h.Values;
tt=max(h.Values);


w = ones(size(A));
% compute weighted sum of cos and sin of angles
r= w*exp(1i*A');
% obtain mean by
mu = angle(r);

% obtain length
r1= abs(r)/sum(w);

% plot mean directions with an overlaid arrow if desired
r2 = r1* tt;
phi = mu;

n = length(A');
% compute Rayleigh's R (equ. 27.1)
R = n*r1;

% compute Rayleigh's z (equ. 27.2)
z = R^2 / n;
% compute p value using approxation in Zar, p. 617
pval = exp(sqrt(1+4*n+4*(n^2-R^2))-(1+2*n));
