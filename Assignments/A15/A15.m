clear all;

pij = [0 0.3 0.2; 1 0 0 ; 0.2 0.8 0];
%       CPU;Disk;Net
l_in = [10 ; 0; 0]; 
l= inv(eye(3)-pij') * l_in;
l0= sum(l_in);
vk = l / l0; 

Sk = [0.04; 0.100; 0.120]; %in sec because of the lambda
dk = vk(:,1) .* Sk(:, 1);

fprintf(1, "CPU %g\n");
fprintf(1, "Visits %g\n", vk(1));
fprintf(1, "Demands %g\n", dk(1));
fprintf(1, "Throughputs %g\n\n", l(1)); %Xk=lk

fprintf(1, "Disk %g\n");
fprintf(1, "Visits %g\n", vk(2));
fprintf(1, "Demands %g\n", dk(2));
fprintf(1, "Throughputs %g\n\n", l(2)); %Xk=lk

fprintf(1, "Network %g\n");
fprintf(1, "Visits %g\n", vk(3));
fprintf(1, "Demands %g\n", dk(3));
fprintf(1, "Throughputs %g\n", l(3)); %Xk=lk
 

