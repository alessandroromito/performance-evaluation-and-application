%% Fitting for projD 2022-2023 PEA course prof. Marco Gribaudo

clear all;
% clear all graph data
clf; 

% Arrivals of different packets: A, B, C, D

% opening documents
fileA = fopen("TraceD-A.txt", 'r');
fileB = fopen("TraceD-B.txt", 'r');
fileC = fopen("TraceD-C.txt", 'r');
fileD = fopen("TraceD-D.txt", 'r');
% scanning documents
TraceD_A = fscanf(fileA, '%f');
TraceD_B = fscanf(fileB, '%f');
TraceD_C = fscanf(fileC, '%f');
TraceD_D = fscanf(fileD, '%f');
% closing documents
fclose(fileA);
fclose(fileB);
fclose(fileC);
fclose(fileD);

%converting traces from milliseconds to seconds
TraceD_A = TraceD_A/1000;
TraceD_B = TraceD_B/1000;
TraceD_C = TraceD_C/1000;
TraceD_D = TraceD_D/1000;

% USELESS -----------------------------------------
%nArrivals = size(TraceD_A,1);
% -------------------------------------------------


% Inter-Arrivals

% calculating inter-arrivals
iA_A = TraceD_A(2:50000)-TraceD_A(1:50000-1);
iA_B = TraceD_B(2:50000)-TraceD_B(1:50000-1);
iA_C = TraceD_C(2:50000)-TraceD_C(1:50000-1);
iA_D = TraceD_D(2:end)-TraceD_D(1:50000-1);
% sorting inter-arrivals
iA_A = sort(iA_A);
iA_B = sort(iA_B);
iA_C = sort(iA_C);
iA_D = sort(iA_D);
% calculating average of inter-arrivals
M1_A = mean(iA_A);
M1_B = mean(iA_B);
M1_C = mean(iA_C);
M1_D = mean(iA_D);

% exponential rate (lambda) with method of moments
lambda_MMA = 1/M1_A;
lambda_MMB = 1/M1_B;
lambda_MMC = 1/M1_C;
lambda_MMD = 1/M1_D;

% plot fitting
xA = [0:0.001:iA_A(49999,1)];
xB = [0:0.001:iA_B(49999,1)];
xC = [0:0.001:iA_C(49999,1)];
xD = [0:0.001:iA_D(49999,1)];


%plotting graphs

nexttile
plot(iA_A(:), [1:49999]/49999, "+", xA, 1 - exp(-lambda_MMA*xA), 'LineWidth', 1);
legend('Dataset_A','Exp_A');
title("Fitting_A" + lambda_MMA);

nexttile
plot(iA_B(:), [1:49999]/49999, "+", xB, 1 - exp(-lambda_MMB*xB), 'LineWidth', 1);
legend('Dataset_B','Exp_B');
title("Fitting_B" + lambda_MMB);

nexttile
plot(iA_C(:), [1:49999]/49999, "+", xC, 1 - exp(-lambda_MMC*xC), 'LineWidth', 1);
legend('Dataset_C','Exp_C');
title("Fitting_C" + lambda_MMC);

nexttile
plot(iA_D(:), [1:49999]/49999, "+", xD, 1 - exp(-lambda_MMD*xD), 'LineWidth', 1);
legend('Dataset_D','Exp_D');
title("Fitting_D" + lambda_MMD);

% printing results
fprintf(1, "The inter-arrivals rate of the Trace A: %g\n", lambda_MMA);
fprintf(1, "The inter-arrivals rate of the Trace B: %g\n", lambda_MMB);
fprintf(1, "The inter-arrivals rate of the Trace C: %g\n", lambda_MMC);
fprintf(1, "The inter-arrivals rate of the Trace D: %g\n", lambda_MMD);