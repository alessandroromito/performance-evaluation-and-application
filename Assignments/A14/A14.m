clear all;

lambda = 500;
mu1 = 1500;
mu2 = 1000;

D = (1 / (mu1 - mu2)) * ((mu1/mu2) - (mu2/mu1)); % formula hypo

rho = lambda * D;

U = lambda * D;

m2 = (2 / (mu1 - mu2)) * ((mu1 / mu2^2) - (mu2 / mu1^2));

R = D + ((lambda * m2) / (2 * (1-rho)));

N =  rho + ((lambda^2 * m2) / (2 * (1-rho))); % pollaczek formula

fprintf(1, "PART 1 - M/G/1\n");
fprintf(1, "Utilization of the system: %g\n", U);
fprintf(1, "Exact average response time: %g\n", R);
fprintf(1, "Exact average number of jobs: %g\n", N);


lambdaErlang = 4000;

T = 4/lambdaErlang;

mean = 4 / lambdaErlang;

rho = D / (2*T);

ca = 1 / 2; 

cv = ((sqrt(mu1^2 + mu2^2)) / (mu1 + mu2));

R = D + ((ca^2 + cv^2) / 2) * ((rho^2 * D) / (1 - rho^2)); % kingsman formula

U = D / (2 * mean);

N = R * (1/T);

fprintf(1, "\nPART 2 - G/G/2\n");
fprintf(1, "Avarage Utilization of the system: %g\n", U);
fprintf(1, "Approximate average response time: %g\n", R);
fprintf(1, "Approximate average number of jobs in the system: %g\n", N);
 

