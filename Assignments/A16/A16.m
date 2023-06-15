clear all;

pij = [0 1 0; 0 0 1 ; 0 0 0];
%       WS;   DBS;   SS
Sk = [0.085; 0.075; 0.060]; %in sec because of the lambda

l_in = [10 ; 0; 5]; 
l= inv(eye(3)-pij') * l_in;
l0= sum(l_in);
vk = l / l0; 

dk = vk(:,1) .* Sk(:, 1);
Uk = l(:,1) .* Sk(:, 1);

for i=1:3
    Rk(i) = dk(i)/(1-Uk(i));
end
Nk = l0 * Rk(1, :);
R=sum(Rk);


fprintf(1, "Visits %g\n", vk);
fprintf(1, "Demands %g\n", dk);
fprintf(1, "Utilizations %g\n", Uk); %stable because <1 for each k
fprintf(1, "Throughput of the system %g\n", l0); %Xk=lk, X=l0
fprintf(1, "Average number of jobs in the three stations %g\n", Nk);
fprintf(1, "Average system response time %g\n", R);