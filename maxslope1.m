clear, clc, clf

% This program requires 2 separate excel sheets
% First one is the cut data of your simulation starting at the point of
% your step change. In the example it was at t=150. 
% Second one is the full data of your simulation
% They must be formatted so that the first column is T and the second
% column is your process variable. 

data = readtable('1-5.xlsx'); %cut data
fulldata = table2array(readtable('1-5full.xlsx')); %full data
time = table2array(data(:,1));
values = table2array(data(:,2));

%calculating the slope of each point and using abs so the max slope can be
%found even if max slope is negative. 
prime = gradient(values, time);
slope = abs(prime); 
maximum = max(slope); 
index = find(slope==maximum);
combined = [time; slope];
maxtime = time(index);

%changing the sign of the slope if necessary

if prime(index) < 0
    m=-maximum;
else
    m=maximum;
end
x = linspace(0,300);
tangent = values(index)+m.*(x-maxtime);


c=values(index)-m.*maxtime;
%y value of the point before time = 150 a.k.a first steady state
y= 40.0398474470268;
%finding Td when 150 is the step change time (change if different)
Td = (y-c)/m-150
%value of final steady state
z=values(length(values));
%finding tau when 150 is the step change time (change if different)
tau = (z-c)/m -Td -150

%plotting with additional xlines and ylines to visualize Td and tau
figure(1)
plot(time, values)
hold on 
plot(x, tangent)
plot(fulldata(:,1), fulldata(:,2))
yline(values(length(values)),'--')
xline(Td+150,'--')
yline(y, '--') 
xline(tau+Td+150, '--')
xline(150,'--')
xlim([130,220])
ylim([values(1)-0.07, values(length(values))+0.07])
xlabel('Time (hours)')
ylabel('Bioethanol concentration (g/L)')
title('Change in ethanol concentration with time after step change at time=150h')
hold off
%figure(2)
%plot(time,slope)
