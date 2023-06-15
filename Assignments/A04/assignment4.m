clear all;

ST = csvread("Traces.csv");
STsorted = sort(ST);
N = size(ST);

tableColumn = input("Choose the column number: ");
clf;

% Moments
M1 = mean(ST);
M2 = mean(ST .^2);
M3 = mean(ST .^3);

cv = std(ST(:,tableColumn)) / M1(tableColumn);

% Uniform left and right bounds
Unif_a_MM = M1 - sqrt(12*(M2 - M1.^2))/2;
Unif_b_MM = M1 + sqrt(12*(M2 - M1.^2))/2;

%Exponential Rate with moments method
lambda_MM = 1/M1(tableColumn);

%xUnif = linspace(Unif_a_MM(tableColumn), Unif_b_MM(tableColumn), 1000);
xUnif = 0:0.1:50;
yUnif = cdf(makedist('Uniform','lower',Unif_a_MM(tableColumn),'upper',Unif_b_MM(tableColumn)),xUnif);

x = [0:500]/10;


if cv > 1
    % HyperExponential parameters with moments method
    % p(1) -> lambda1
    % p(2) -> lambda2
    % p(3) -> p1
    
    F1 = @(p) [ (p(3) / p(1) + (1 - p(3)) / p(2)) / M1(tableColumn) - 1
        2 * (p(3) / p(1)^2 + (1 - p(3)) / p(2)^2) / M2(tableColumn) - 1
        6 * (p(3) / p(1)^3 + (1 - p(3)) / p(2)^3) / M3(tableColumn) - 1
        ];
    
    HypExpParameters_MM = fsolve(F1, [0.8/M1(tableColumn),1.2/M1(tableColumn),0.4]);
elseif cv < 1
    %HypoExponential parameters with moments method
    % p(1) -> lambda1
    % p(2) -> lambda2

    F2 = @(p) [ ((1 / (p(1)-p(2))) * (p(1)/p(2) - p(2)/p(1))) / M1(tableColumn) - 1
        ( 2 * (1/(p(1)^2) + 1/(p(1)*p(2)) + 1/(p(2)^2)) / M2(tableColumn)) - 1
        ];

    HypoExpParameters_MM = fsolve(F2, [1/(0.3*M1(tableColumn)),1/(0.7*M1(tableColumn))]);
end

fprintf(1, "METHOD OF MOMENTS\n");
fprintf(1, "First Moment: %g\n", M1(tableColumn));
fprintf(1, "Second Moment: %g\n", M2(tableColumn));
fprintf(1, "Third Moment: %g\n", M3(tableColumn));
fprintf(1, "Coefficient of Variation: %g\n\n", cv);
fprintf(1, "Uniform Left Bound: %g\n", Unif_a_MM(tableColumn));
fprintf(1, "Uniform Right Bound: %g\n\n", Unif_b_MM(tableColumn));
fprintf(1, "Exponential Rate: %g\n", lambda_MM);
if cv > 1
    fprintf(1, "No solution for Hypo Exponential (cv > 1)\n");
    fprintf(1, "Hyper Exponential lambda1: %g\n", HypExpParameters_MM(1));
    fprintf(1, "Hyper Exponential lambda2: %g\n", HypExpParameters_MM(2));
    fprintf(1, "Hyper Exponential p1: %g\n\n", HypExpParameters_MM(3));

    nexttile
    plot(STsorted(:,tableColumn), [1:1000]/1000, "+", xUnif, yUnif , x, 1 - HypExpParameters_MM(3)*exp(-HypExpParameters_MM(1)*x) - (1 - HypExpParameters_MM(3))*exp(-HypExpParameters_MM(2)*x),  x, 1 - exp(-lambda_MM*x), 'LineWidth', 2);
    legend('Dataset','Uniform', 'HyperExp', 'Exp');
    title("Methods of moments");
elseif cv < 1
    fprintf(1, "No solution for Hyper Exponential (cv < 1)\n");
    fprintf(1, "Hypo Exponential lambda1: %g\n", HypoExpParameters_MM(1));
    fprintf(1, "Hypo Exponential lambda2: %g\n", HypoExpParameters_MM(2));

    nexttile
    plot(STsorted(:,tableColumn), [1:1000]/1000, "+", xUnif, yUnif , x, 1 - ((HypoExpParameters_MM(2)*exp(-HypoExpParameters_MM(1)*x))/((HypoExpParameters_MM(2)-HypoExpParameters_MM(1)))) + (((HypoExpParameters_MM(1)*exp(-HypoExpParameters_MM(2)*x))/((HypoExpParameters_MM(2)-HypoExpParameters_MM(1))))),  x, 1 - exp(-lambda_MM*x), 'LineWidth', 2);
    legend('Dataset','Uniform', 'HypoExp', 'Exp');
    title("Methods of moments");
end



%Exponential Rate with maximum likelihood method
lambda_MLE = N(1,1) / sum(ST(:,tableColumn),1);

if cv > 1
    % HyperExponential parameters with maximum likelihood method
    F3 = @(x,l1,l2,p1) p1 * l1 * exp(-l1 * x) + (1-p1) * l2 * exp(-l2 * x);
    HypExpParameters_MLE = mle(ST(:,tableColumn), 'pdf', F3, 'start', [0.8/M1(tableColumn),1.2/M1(tableColumn),0.4], 'LowerBound', [0,0,0], 'Upperbound', [Inf,Inf,1]);
elseif cv < 1
    % HypoExponential parameters with maximum likelihood method
    F4 = @(x,l1,l2) ((l1*l2) / (l1-l2)) * (exp(-l2*x) - exp(-l1*x));
    HypoExpParameters_MLE = mle(ST(:,tableColumn), 'pdf', F4, 'start', [1/(0.3*M1(tableColumn)),1/(0.7*M1(tableColumn))], 'LowerBound', [0,0], 'Upperbound', [Inf,Inf]);
end


fprintf(1, "\n\nMAXIMUM LIKELIHOOD METHOD\n");
fprintf(1, "Exponential Rate: %g\n", lambda_MLE);
if cv > 1
    fprintf(1, "No solution for Hypo Exponential (cv > 1)\n");
    fprintf(1, "Hyper Exponential lambda1: %g\n", HypExpParameters_MLE(1));
    fprintf(1, "Hyper Exponential lambda2: %g\n", HypExpParameters_MLE(2));
    fprintf(1, "Hyper Exponential p1: %g\n\n", HypExpParameters_MLE(3));
    
    nexttile
    plot(STsorted(:,tableColumn), [1:1000]/1000, "+", xUnif, yUnif , x, 1 - HypExpParameters_MLE(3)*exp(-HypExpParameters_MLE(1)*x) - (1 - HypExpParameters_MLE(3))*exp(-HypExpParameters_MLE(2)*x),  x, 1 - exp(-lambda_MLE*x), 'LineWidth', 2);
    legend('Dataset','Uniform', 'HyperExp', 'Exp');
    title("Maximum likelihood method");
elseif cv < 1
    fprintf(1, "No solution for Hyper Exponential (cv < 1)\n");
    fprintf(1, "Hypo Exponential lambda1: %g\n", HypoExpParameters_MLE(1));
    fprintf(1, "Hypo Exponential lambda2: %g\n", HypoExpParameters_MLE(2));

    nexttile
    plot(STsorted(:,tableColumn), [1:1000]/1000, "+", xUnif, yUnif , x, 1 - ((HypoExpParameters_MLE(2)*exp(-HypoExpParameters_MLE(1)*x))/((HypoExpParameters_MLE(2)-HypoExpParameters_MLE(1)))) + (((HypoExpParameters_MLE(1)*exp(-HypoExpParameters_MLE(2)*x))/((HypoExpParameters_MLE(2)-HypoExpParameters_MLE(1))))), x, 1 - exp(-lambda_MLE*x), 'LineWidth', 2);
    legend('Dataset','Uniform', 'HypoExp', 'Exp');
    title("Maximum likelihood method");
end