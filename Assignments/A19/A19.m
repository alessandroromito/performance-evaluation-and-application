clear all;

% Row -> Classes      Col -> Stations
   %CRM FS
S = [1, 2; 1, 2];

D = [0.05 0.1; 0.06 0.04]; % in seconds

%D = v.* S so...
v = D./S;

lam = [5; 10];

Uck = D .* [lam lam];

%utilization of servers
Uk = sum(Uck);

Xc = lam;

Xck = v .* [lam lam];

%system thrughput
X = sum(Xc);

Rck = D ./ (1 - [Uk; Uk]);

%residence time of servers
Rk = sum(Xc ./ [X; X] .* Rck);

%response time
R = sum(Rk);

fprintf(1, "first server: CRM - second server: FS\n");
fprintf(1, "The utilization of the first server is: %g\n", Uk(1));
fprintf(1, "The utilization of the second server is: %g\n", Uk(2));

fprintf(1, "The residence time of the first server is: %g\n", Rk(1));
fprintf(1, "The residence time of the second server is: %g\n", Rk(2));

fprintf(1, "The system response time is: %g\n", R);
