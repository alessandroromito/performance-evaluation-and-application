clear all;

filename = 'apache1.log';
data = readtable(filename);

nA = size(data,1);
nC = size(data,1);

dateArray = data(:,4);
dateArray = table2array(dateArray);
allDateAndTime = datetime(dateArray, 'inputFormat', '[dd/MMM/yyyy:HH:mm:ss.SSS');

%service time array
serviceTimeArray = data(:,11);
serviceTimeArray=table2array(serviceTimeArray);
for i = 1:nA
    serviceTimeArray(i) = serviceTimeArray(i)/1000;
end


%arrivals
Ai = zeros(nA,1);
for i = 2:nA
    Ai(i) = seconds(diff(datetime([allDateAndTime(1);allDateAndTime(i)])));
end


%begin Service Time
beginServiceTime = zeros(nC,1);
%beginServiceTime(1) = Ai(1);
for i = 2:nA
    if beginServiceTime(i-1)  + serviceTimeArray(i-1) > Ai(i)
        beginServiceTime(i) = beginServiceTime(i-1)  + serviceTimeArray(i-1);
    else
        beginServiceTime(i) = Ai(i);
    end
end

%completions
Ci = zeros(nC,1);
for i=1:nA
    Ci(i) = beginServiceTime(i) + serviceTimeArray(i);
end

%time finishing processing last service
T = Ci(nA,1);

%average service time
S=sum(serviceTimeArray)/nC;

%arrival rate
Lambda = nA / T;

%throughput
X = nC / T;

Ia = 1/Lambda; %Average inter-arrival time
B = sum(serviceTimeArray); 
U = B/T;

Rt = Ci(:,1) - Ai(:,1);
W = sum(Rt);

%Average response time
R = W/nC;
%Average number of jobs
N = W/T;

PR1 = sum(Rt < 1) / nC;
PR5 = sum(Rt < 5) / nC;
PR10 = sum(Rt < 10) / nC;

%number of jobs in time
evs = [Ai(:,1), ones(nA, 1), zeros(nA, 4); Ci(:,1), -ones(nC,1), zeros(nC, 4)];
evs = sortrows(evs,1);
evs(:,3) = cumsum(evs(:,2)); %height (queue)
evs(1:end-1, 4) = evs(2:end, 1) - evs(1:end-1, 1); %width
evs(:,5) = evs(:,3) .* evs(:,4); %Ym

pn = [zeros(nA,4);zeros(nA,4)];
pn(:,1) = evs(:,5).*(evs(:,3)==0);

PN0 = sum((evs(:,3)==0).*evs(:,4))/T;
PN1 = sum((evs(:,3)==1).*evs(:,4))/T;
PN2 = sum((evs(:,3)==2).*evs(:,4))/T;
PN3 = sum((evs(:,3)==3).*evs(:,4))/T;

% PN0 = 0;
% for i = 1:2*nA
%     if evs(i,3) == 0
%         PN0 = PN0 + evs(i,4);
%     end
% end
% PN0 = PN0/T;
% 
% PN1 = 0;
% for i = 1:2*nA
%     if evs(i,3) == 1
%         PN1 = PN1 + evs(i,4);
%     end
% end
% PN1 = PN1/T;
% 
% PN2 = 0;
% for i = 1:2*nA
%     if evs(i,3) == 2
%         PN2 = PN2 + evs(i,4);
%     end
% end
% PN2 = PN2/T;
% 
% PN3 = 0;
% for i = 1:2*nA
%     if evs(i,3) == 3
%         PN3 = PN3 + evs(i,4);
%     end
% end
% PN3 = PN3/T;

fprintf(1, "Arrival Rate: %g, Throughput %g\n", Lambda, X);
fprintf(1, "Average inter-arrival time: %g\n", Ia);
fprintf(1, "Busy-time: %g\n", B);
fprintf(1, "Utilization: %g\n", U);
fprintf(1, "W: %g\n", W);
fprintf(1, "Average Service Time: %g\n", S);
fprintf(1, "Average Number of Jobs: %g\n", N);
fprintf(1, "Average Response Time: %g\n", R);

fprintf(1, "Probability of having response time less than 1s: %g\n", PR1);
fprintf(1, "Probability of having response time less than 5s: %g\n", PR5);
fprintf(1, "Probability of having response time less than 10s: %g\n", PR10);

fprintf(1, "Probability of having 0 jobs in queue: %g\n", PN0);
fprintf(1, "Probability of having 1 jobs in queue: %g\n", PN1);
fprintf(1, "Probability of having 2 jobs in queue: %g\n", PN2);
fprintf(1, "Probability of having 3 jobs in queue: %g\n", PN3);