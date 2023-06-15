clear all;
%time-sharing system (closed model) so the ref station is the infinite
%server that defines the think time of the users

N=530; %everything in base of this number
%       MS;    FS;   DBS
Sk = [0.080; 0.120; 0.011]; %in sec
vk = [1;0.75;10];
Z = 120; %in sec
dk = vk(:,1) .* Sk(:, 1);

Nk = zeros(1,3);

for i=1:N
    for j=1:3
        Rk(j) = (1 + Nk(1,j)) * dk(j); %residence time
    end
    X = i / (Z + sum(Rk)); %throughput
    for j=1:3
        Nk(j) = X * Rk(j);
    end
end

Uk = X * dk(:,1);

R = sum(Rk); %response time

N_notthinking = sum(Nk);    %avg #students not thinking

%% printing requests
fprintf(1, "Moodle Server\n");
fprintf(1, "Visits (given, not requested) %g\n", vk(1));
fprintf(1, "Demands %g\n", dk(1));
fprintf(1, "Utilization %g\n\n", Uk(1));

fprintf(1, "File Server\n");
fprintf(1, "Visits (given, not requested) %g\n", vk(2));
fprintf(1, "Demands %g\n", dk(2));
fprintf(1, "Utilization %g\n\n", Uk(2));

fprintf(1, "DB Server\n");
fprintf(1, "Visits (given, not requested) %g\n", vk(3));
fprintf(1, "Demands %g\n", dk(3));
fprintf(1, "Utilization %g\n\n", Uk(3));

fprintf(1, "Throughput of the system %g\n", X);
fprintf(1, "System response time %g\n", R);
fprintf(1, 'Number of students "not thinking" %g\n', N_notthinking);


 

