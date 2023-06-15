clear all;

%click on the single section blue tab to run, but before run this

Values = readtable("random.csv");
Values1 = Values.Var1;
Values2 = Values.Var2;
Values3 = Values.Var3;

clear Values

N = size(Values2,1);

%% UNIFORM DISTRIBUTION
a = 5;
b = 15;
resUnif = zeros(N,1);

for k=1:500
    resUnif(k,1) = a + (b-a) * Values2(k);
end


xUnif = 5:0.1:15;
yUnif = cdf(makedist('Uniform','lower',5,'upper',15),xUnif);

plot(sort(resUnif), [1:N]/N, '-', xUnif, yUnif, "-");
legend('Dataset','Analytical Uniform');
title("Uniform Distribution");

fprintf(1, "First ten samples generated for the uniform distribution: \n");
for j=1:10
    fprintf(1, "%g\n", resUnif(j,1));
end

%% DISCRETE DISTRIBUTION
p = [0.3, 0.4, 0.3];
C = cumsum(p);

for k = 1:N
	r = Values1(k);
	for i = 1:3
		if r < C(1,i)
			resDescr(k,1) = i * 5;
			break
		end
	end
end

AnalyticalDescr(1,1) = 0;
AnalyticalDescr(2:150,1) = 5;
AnalyticalDescr(151:350,1) = 10;
AnalyticalDescr(351:499,1) = 15;
AnalyticalDescr(500,1) = 20;

plot(sort(resDescr), (1:N)/N, "-", AnalyticalDescr, (1:N)/N, "-");
legend('Dataset','Analytical Discrete');
title("Discrete Distribution");

fprintf(1, "\nFirst ten samples generated for the discrete distribution: \n");
for j=1:10
    fprintf(1, "%g\n", resDescr(j,1));
end

%% EXPONENTIAL
lambda = 1/10;

for k=1:500
    resExp(k,1) = -(log(Values2(k))/lambda);
end

x = [0:700]/10;
plot(sort(resExp), (1:N)/N, '-', x, 1 - exp(-lambda*x));
legend('Dataset','Analytical Exp');
title("Exponential Distribution");


fprintf(1, "\nFirst ten samples generated for the exponential distribution: \n");
for j=1:10
    fprintf(1, "%g\n", resExp(j,1));
end
%% HYPER-EXPONENTIAL
p = [0.3, 0.7];
lambda = [0.05, 0.175];
C = cumsum(p);

for k = 1:N
	r1 = Values1(k);
    r2 = Values2(k);
	for i = 1:2
		if r1 < C(1,i)
			resHyper(k,1) = -(log(r2)/lambda(i));
			break
		end
	end
end

x = [0:800]/10;
plot(sort(resHyper), (1:N)/N, '-', x, 1 - 0.3*exp(-0.05*x) - (0.7)*exp(-0.175*x), "-");
legend('Dataset','Analytical Hyper-Exp');
title("Hyper-Exponential Distribution");


fprintf(1, "\nFirst ten samples generated for the Hyper-Exponential distribution: \n");
for j=1:10
    fprintf(1, "%g\n", resHyper(j,1));
end
%% HYPO-EXPONENTIAL
lambda = [0.25, 0.16667];

for k=1:500
    resHypo(k,1) = -(log(Values2(k))/lambda(1)) - (log(Values3(k))/lambda(2));
end

x = [0:500]/10;
plot(sort(resHypo), (1:N)/N, '-', x, 1 - ((0.16667*exp(-0.25*x))/((0.16667-0.25))) + (((0.25*exp(-0.16667*x))/((0.16667-0.25)))));
legend('Dataset','Analytical Hypo-Exp');
title("Hypo-Exponential Distribution");

fprintf(1, "\nFirst ten samples generated for the Hypo-Exponential distribution: \n");
for j=1:10
    fprintf(1, "%g\n", resHypo(j,1));
end

%% HYPER-ERLANG
p = [0.3, 0.7];
lambda = [0.05, 0.35];
K_values = [1,2];
C = cumsum(p);

for k = 1:N
	r1 = Values1(k);
    r2 = Values2(k);
    r3 = Values3(k);
    if r1 < C(1,1)
       resErlang(k,1) = - (log(r2) /  lambda (1,1));
    else 
       resErlang(k,1) = - (log(r2) /  lambda (1,2)) - (log(r3) /  lambda (1,2));
    end
end

HE_CDF = @(x) 1 - p(1).*exp(-lambda(1)*x) - (1-p(1)) .* (exp(-lambda(2)*x) + lambda(2)*x.*exp(-lambda(2)*x));

plot(sort(resErlang), (1:N)/N, '-', 1:100, HE_CDF(1:100), "-")
xlim([0 100])
legend('Dataset','Analytical Hyper-Erlang');
title("Hyper-Erlang Distribution");

fprintf(1, "\nFirst ten samples generated for the Hyper-Erlang distribution: \n");
for j=1:10
    fprintf(1, "%g\n", resErlang(j,1));
end