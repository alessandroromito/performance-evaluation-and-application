clear all;

lambda = 50;
D = 0.015;

rho = lambda * D;
mu = lambda / rho;

%Utilization
U = rho;

% Probability of having exactly 1 job
pi0 = 1 - (lambda / mu);
pi1 = pi0 * (lambda/mu);

% Probability of having less than 4 job
pi2 = pi0 * (lambda/mu)^2;
pi3 = pi0 * (lambda/mu)^3;
p_less4 = pi0 + pi1 + pi2 + pi3;

% Average Queue Lenght
N = rho / (1 - rho);
Nq = N - U;

% Average Response Time
R = D / (1 - rho);

% Probability of having R > 0.5
R_greater05 = exp(-0.5/R);

% 90 Percentile
Percentile_90 = -log(1 - 90/100) * R;

fprintf(1, "FIRST PART\n");
fprintf(1, "The utilization of the system: %g\n", U);
fprintf(1, "The probability of having exactly one job in the system: %g\n", pi1);
fprintf(1, "The probability of having less than 4 jobs in the system: %g\n", p_less4);
fprintf(1, "The average queue length (job not in service): %g\n", Nq);
fprintf(1, "The average response time: %g\n", R);
fprintf(1, "The probability that the response time is greater than 0.5 s.: %g\n", R_greater05);
fprintf(1, "The 90 percentile of the response time distribution: %g\n", Percentile_90)



lambda = 85;
mu = 1 / D;
rho = lambda / (2 * mu);

% Utilization
U_avg = rho;
U_total = U_avg*2;

% Prob having exactly 1 job
pi0 = ((2 * mu) - lambda) / ((2 * mu) + lambda);
pi1 = pi0 * (lambda / mu);

% Probability of having less than 4 job
pi2 = pi0 * (lambda/mu) * (lambda/(2 * mu));
pi3 = pi0 * (lambda/mu) * (lambda/(2 * mu))^2;
p_less4 = pi0 + pi1 + pi2 + pi3;

% Average Queue Lenght ?????
N = (2 * rho) / (1 - rho^2);
Nq = N - U_total;

% Average Response Time
R = D / (1 - rho^2);

fprintf(1, "\nSECOND PART\n");
fprintf(1, "The avarage utilization of the system: %g\n", U_avg);
fprintf(1, "The total utilization of the system: %g\n", U_total);
fprintf(1, "The probability of having exactly one job in the system: %g\n", pi1);
fprintf(1, "The probability of having less than 4 jobs in the system: %g\n", p_less4);
fprintf(1, "The average queue length (job not in service): %g\n", Nq);
fprintf(1, "The average response time: %g\n", R);
