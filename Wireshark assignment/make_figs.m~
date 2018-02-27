T1 = readtable('connects.csv')
T2 = readtable('disconnects.csv')
Array1 = table2array(T1)
Array2 = table2array(T2)

Array1=csvread('connects.csv',2);
Array2=csvread('disconnects.csv',2);
t1 = readtable('vendor.csv')
time1 = Array1(:, 1);
connects = Array1(:, 2);
time2 = Array2(:,1);
disconnects = Array2(:,2);

stem([time1,time2],[connects,disconnects], 'filled')

xlabel('time (s)')
ylabel('(dis)connects')
title('The number of (dis)connects of the network per second')
xlim([min(min(time1),min(time2)) max(max(time1),max(time2))])
legend('Connects per second', 'Disconnects per second')

print('connects_disconnects_time','-dpng')

%%%%% Now do the vendor part:
clear all;
close all;

formatSpec = '%C%f';
T = readtable('vendor.csv', 'Delimiter',',','Format',formatSpec);
labels = table2array(T(:,1));
vals = table2array(T(:,2));
pie(vals)