clear all;

lambda = 1200;
D = 0.00125;
mu = 1 / D;

K = 16;

p = lambda / mu;

U = (p - p^(K+1)) / (1 - p^(K+1));

pi0 = (1 - p) / (1 - p^(K+1));
pi14 = pi0 * p^14;

N = (p / (1 - p)) - ((K+1) * p^(K+1)) / (1 - p^(K+1));

X = lambda * (1 - p^K) / (1 - p^(K+1));

Dr = lambda * (p^K - p^(K+1)) / (1 - p^(K+1));

R = N / X;

T = R - D;

fprintf(1, "M/M/1/16\n");
fprintf(1, "Utilization of the system: %g\n", U);
fprintf(1, "Probability of having 14 job in the system: %g\n", pi14);
fprintf(1, "Average number of packets: %g\n", N);
fprintf(1, "Throughput: %g\n", X);
fprintf(1, "Drop Rate: %g\n", Dr);
fprintf(1, "Response Time: %g\n", R);
fprintf(1, "Time Spent in Queue: %g\n", T);

p2 = lambda /(2* mu);

pi0 = (((2*p2)^2 / 2) * ((1 - p2^(K-1))/(1 - p2)) + (1 + (2*p2)))^-1;
pi = @(i) (i < 2) * ((pi0 / factorial(i)) * (lambda/mu)^i) + ((i >= 2) * (pi0 / (2 * 2^(i-2))) * (lambda/mu)^i);

temp = 0;
for i = 3:K
    temp = temp + pi(i);
end
U_tot = pi(1) + 2 * pi(2) + 2 * temp;
U_average = U_tot/2;

N = 0;
for n = 1:16
    N = N + n * pi(n);
end

X = lambda * (1 - pi(16));

Dr = lambda * pi(16);

R = N / (lambda * (1 - pi(16)));

T = R - D;

fprintf(1, "\nM/M/2/16\n");
fprintf(1, "Avarage Utilization of the system: %g\n", U_average);
fprintf(1, "Probability of having 14 job in the system: %g\n", pi(14));
fprintf(1, "Average number of packets: %g\n", N);
fprintf(1, "Throughput: %g\n", X);
fprintf(1, "Drop Rate: %g\n", Dr);
fprintf(1, "Avarage Response Time: %g\n", R);
fprintf(1, "Time Spent in Queue: %g\n", T);

