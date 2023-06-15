clear all;
clf;

%Infinitesimal generator matrix
Q = [
    -1/10 1/10 0 0;
    1/50 -1/50-1/20-1/10 1/20 1/10;
    0 1/2 -1/2 0 ;
    0 1/5 0 -1/5
    ];

pi0 = [1, 0, 0, 0];

%State reward vectors, and transition reward matrices:
alpha = [0.1 2 10 0.5];

% system throughput epsilon matrix
epsilon1 = [
    0   0   0   0;
    1   0   0   0;
    0   0   0   0;
    0   0   0   0;
    ];

%cpu troughput epsilon matrix (not required)
epsilon2 = [
    0   0   0   0;
    0   0   0   0;
    0   1   0   0;
    0   1   0   0;
    ];

% GPU throughput epsilon matrix
epsilon3 = [
    0   0   0   0;
    0   0   0   0;
    0   1   0   0;
    0   0   0   0;
    ];

% I/O frequency epsilon matrix
epsilon4 = [
    0   0   0   0;
    0   0   0   0;
    0   0   0   0;
    0   1   0   0;
    ];

% evolution of state probabilities
t = linspace(0,500,101);
for i=1:size(t,2)
    pi(:,i) = pi0 * expm(Q * t(i));
end

nexttile
plot(t, pi, "-")
legend("IDLE", "CPU computation", "GPU computation", "I/O");

% Figure with the evolution of the rewards as function of time
t = linspace(0,500,101);
for i=1:size(t,2)
    alphaProb(:,i) = alpha * pi(:,i);
end
% require to use this formula instead of inner "for" cycle is
% to have the diagonal of each epsilon matrix = '0'
epsilonProb(1,:) = sum((Q.*epsilon1)' * pi);    %FOR System_throughput
epsilonProb(2,:) = sum((Q.*epsilon3)' * pi);    %FOR GPU_troughput
epsilonProb(3,:) = sum((Q.*epsilon4)' * pi);    %FOR I/O FREQUENCY


alpha1 = [0 1 1 1];
alphaProb1(:,i) = alpha1 * pi(:,i);
alphaProb1 = alpha1 * pi;
Utilization_State_Reward = alphaProb1(1,101);

% SSP = pi(:,101);
% Utilization_Steady_State = sum(SSP(:)) - SSP(1);

nexttile
plot(t, alphaProb, "-", t, alphaProb1, "-")
legend("power consumption", "utilization")
nexttile
plot(t, epsilonProb, "-")
legend("transition reward evolution IDLE","transition reward evolution GPU","transition reward evolution I/O");


Average_power_consumption = alphaProb(1,101);

System_throughput = epsilonProb(1,end);

GPU_troughput = epsilonProb(2,end);

IO_Frequency = epsilonProb(3,end);