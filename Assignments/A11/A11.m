clear all;

N = 16;
N0 = 8;
%n_packets = 0;

m = 100;
b0 = 200;
lambda = @(i) ((N0<=i)&&(i<N)) * b0 * ((N-i)/(N-N0)) + (i<N0) * b0;
%p = @(n) min(1, (n - N0) / (N - N0));

pn = zeros(1, N+1);
pd = zeros(1, N+1);

pn(1,1) = 0;
pd(1,1) = 0;

for i=1:N
	if i == 1
		lim1 = b0;
	else
		lim1 = lambda(i);
	end
	pn(1, i+1) = pn(1,i) + log(lim1);
	pd(1, i+1) = pd(1,i) + log(m);
end

p = exp(pn(1:N) - pd(2:N+1));
p = p / sum(p);

plot(1:N, p, "-");

for i = N-6:N
    fprintf(1, "p%g = %g\n", i, p(i));
end
