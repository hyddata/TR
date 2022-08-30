% claculate different return periods of maximum daily rainfall
clc
clear 
close all
%% input data
% stationname.xlsx in the time series of daily data
Prompt={'stationname','desired TR_1 ','desired TR_2 ','desired TR_3 ','desired TR_4 ','desired TR_5 ', 'firstDay', 'Lastday'};
Title='DailyRainfallData';
DefaultValues={'AAAA','10','25','50','100','1000','01/01/2010','31/12/2019'};
PARAMS=inputdlg(Prompt,Title,[1 75],DefaultValues);
PDaily=xlsread([PARAMS{1},'.xlsx']);
firstDayInYear = PARAMS{7};
lastDayInYear  = PARAMS{8};

firstDayInYearNum = datenum(firstDayInYear, 'dd/mm/yyyy');
lastDayInYearNum  = datenum(lastDayInYear,  'dd/mm/yyyy');
DaysInPeriod = firstDayInYearNum:1:lastDayInYearNum; 
period=DaysInPeriod';
period=datevec(period);
Data=[period PDaily];
[a,~,c]=unique(Data(:,1),'rows');
Pmax=[a, accumarray(c,Data(:,7),[],@max)];
P=Pmax(:,2);
% it is not limited to the 'Gamma' but 'Extreme Value', 'Weibull' , ...
pd=fitdist(P,'Gamma');


TR=[str2num(PARAMS{2}) str2num(PARAMS{3}) str2num(PARAMS{4}) str2num(PARAMS{5}) str2num(PARAMS{6})]; %#ok
p=1- (1./TR);
results=icdf(pd,p);
format shortG
disp ([TR;results])
format short

%% figures

aa=cdf(pd,P);
nn=(1:120)';
bb=cdf(pd,nn);
figure
s=scatter(P,(1-aa)*100);
s.LineWidth = 0.6;
s.MarkerEdgeColor = [0 0 0];
s.MarkerFaceColor = [0 0 0];
hold on
pl=plot(nn,(1-bb)*100,'r');
pl.LineWidth = 1.2;
grid on
box on
title(['Cumulative distribution function for ', PARAMS{1}],'FontSize',14, 'FontName', 'Times New Roman')
xlabel('Max daily precipitation in a year (mm)','FontSize',14, 'FontName', 'Times New Roman')
ylabel('Probability (%)', 'FontSize',14, 'FontName', 'Times New Roman')
legend('Maximum daily P(mm)', 'Gamma distribution', 'FontSize',14, 'FontName', 'Times New Roman')

figure
plot(DaysInPeriod',PDaily,'k')
axis tight
grid on
box on
datetick('x', 'yyyy')
xlabel('Date','FontSize',14, 'FontName', 'Times New Roman')
ylabel('Daily precipitation (mm)', 'FontSize',14, 'FontName', 'Times New Roman')
xTR1=repmat(results(1),length(DaysInPeriod),1);
xTR2=repmat(results(2),length(DaysInPeriod),1);
xTR3=repmat(results(3),length(DaysInPeriod),1);
xTR4=repmat(results(4),length(DaysInPeriod),1);
xTR5=repmat(results(5),length(DaysInPeriod),1);
hold on
plot(DaysInPeriod',xTR1,'g:', 'LineWidth',1.5)
plot(DaysInPeriod',xTR2,'c:', 'LineWidth',1.5)
plot(DaysInPeriod',xTR3,'y:', 'LineWidth',1.5)
plot(DaysInPeriod',xTR4,'b:', 'LineWidth',1.5)
plot(DaysInPeriod',xTR5,'r:', 'LineWidth',1.5)
ylim([0 139])
legend('Daily P', ['Daily P with TR-',PARAMS{2},' years'],...
    ['Daily P with TR-',PARAMS{3},' years'],...
    ['Daily P with TR-',PARAMS{4},' years'],...
    ['Daily P with TR-',PARAMS{5},' years'],...
    ['Daily P with TR-',PARAMS{6},' years'],...
    'FontSize',14, 'FontName', 'Times New Roman')



