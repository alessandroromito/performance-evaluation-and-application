clear all;

filename = input('File Name: ', "s");
ia = csvread(filename); %inter-arrival time
nA = size(ia,1);
Ia = sum(ia)/nA; %average inter-arrival time
T = sum(ia);
Lambda = nA/T; %arrival rate
%X = Lambda; because the system is stable, we have all the inter-arrivals

SD = std(ia); %standard deviation of inter-arrival time


%service time = 1.2s as written in specifications
%arrivals
Ai = zeros(nA,1);
for i = 2:nA
    Ai(i) = sum(ia(1:i-1,1));
end

%begin Service Time
beginServiceTime = zeros(nA,1);
for i = 2:nA
    if beginServiceTime(i-1) + 1.2 > Ai(i)
        beginServiceTime(i) = beginServiceTime(i-1)  + 1.2;
    else
        beginServiceTime(i) = Ai(i);
    end
end

%completions
Ci = beginServiceTime(:) + 1.2;

Rt = Ci(:,1) - Ai(:,1);
R = sum(Rt)/nA;



fprintf(1, "Average Inter-arrival time: %g\n", Ia);
fprintf(1, "Average Arrival Rate: %g\n", Lambda);

fprintf(1, "Standard deviation of inter-arrival times: %g\n", SD);

fprintf(1, "Average Response Time: %g\n", R);

iaplot = [ia(1:nA-1,1), ia(2:nA,1)];
plot(iaplot(:,1), iaplot(:,2), ".");

