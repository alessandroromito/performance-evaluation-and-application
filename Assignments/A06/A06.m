

clear all;

N = 50000;

% INTER-ARRIVALS
p = [0.1, 0.9];
lambda = [0.02, 0.2];
C = cumsum(p);

for k = 1:N
	r1 = rand();
	for i = 1:2
		if r1 < C(1,i)
			resHyper(k,1) = -(log(rand())/lambda(i)); %not the same r1
			break
		end
	end
end


% SERIVICE TIME
a = 5;
b = 10;

resUnif = a + (b-a)*rand(N,1);

% completions

% arrivals | begin service time | service | completions | response time
times = zeros(N,4);
times(2:end,1) = cumsum(resHyper(1:end-1,1));
times(:,3) = resUnif(:,1);

times(1,2) = times(1,1);
for i=2:N
    if times(i-1,2) + times(i-1,3) >= times(i,1)
        times(i,2) = times(i-1,2) + times(i-1,3);
    else
        times(i,2) = times(i,1);
    end
end

times(:,4) = times(:,2) + times(:,3);


% RESPONSE TIMES
times(:,5) = times(:,4) - times(:,1);

R = mean(times(:,5));
stdDevRt = std(times(:,5));
confidenceR(1) = R - 1.96*stdDevRt*sqrt(1/N);
confidenceR(2) = R + 1.96*stdDevRt*sqrt(1/N);

K = 200;
M = 250;
Batch1 = zeros(M,K);
Batch2 = zeros(M,K);

% Batch Response
count = 0;
for i=1:K
    for j=1:M
        count = count + 1;
        Batch1(j,i) = times(count,5);
    end
end

% Batch Service
count = 0;
for i=1:K
    for j=1:M
        count = count + 1;
        Batch2(j,i) = times(count,3);
    end
end

% N
for i=1:K
    Njobs(1,i) = sum(Batch1(:,i)) / (times(i*250, 4) - times((i-1)*250+1,1));
end
avgN = mean(Njobs);
stdDevNjobs = std(Njobs(1,:));
confidenceN(1) = avgN - 1.96*stdDevNjobs*sqrt(1/K);
confidenceN(2) = avgN + 1.96*stdDevNjobs*sqrt(1/K);

% U
for i=1:K
    Util(1,i) = sum(Batch2(:,i)) / (times(i*250, 4) - times((i-1)*250+1,1));
end
U = mean(Util);
stdDevU = std(Util(1,:));
confidenceU(1) = U - 1.96*stdDevU*sqrt(1/K);
confidenceU(2) = U + 1.96*stdDevU*sqrt(1/K);

% X
for i=1:K
    Troughput(1,i) = M / (times(i*250, 4) - times((i-1)*250+1,1));
end
X = mean(Troughput);
stdDevXt = std(Troughput(1,:));
confidenceX(1) = X - 1.96*stdDevXt*sqrt(1/K);
confidenceX(2) = X + 1.96*stdDevXt*sqrt(1/K);


fprintf(1, "R low: %g\n", confidenceR(1));
fprintf(1, "R high: %g\n", confidenceR(2));
%and other results...