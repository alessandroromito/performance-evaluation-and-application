clear all;

%% FSM
s = 1;
t = 0;
i = 1;
maxT = 1000000;

Ts1 = 0;
Ts2 = 0;
Ts3 = 0;
Ts4 = 0;

Ns1 = 0;

while t < maxT
    if s == 1
        ns = 2;
        dt = - (log(rand()) + log(rand()) + log(rand()))/0.1;
        Ts1 = Ts1 + dt;
        Ns1 = Ns1 + 1;
    end
    if s == 2
        rnd = rand();
        if rnd < 0.5
            ns = 1;
        elseif rnd >= 0.5 && rnd < 0.8
            ns = 3;
        else
            ns = 4;
        end
        dt = 10 + (20 - 10) * rand();
        Ts2 = Ts2 + dt;
    end
    if s == 3
        ns = 1;
        dt = -log(rand())/0.05;
        Ts3 = Ts3 + dt;
    end
    if s == 4
        ns = 1;
        dt = -log(rand())/0.03;
        Ts4 = Ts4 + dt;
    end
    
    s = ns;
    t = t + dt;
end

Ps1 = Ts1 / t;
Ps2 = Ts2 / t;
Ps3 = Ts3 / t;
Ps4 = Ts4 / t;

Xsensing = Ns1 / t;

fprintf(1, "Probability of the system being sensing: %g\n", Ps1);
fprintf(1, "Probability of the system using CPU: %g\n", Ps2);
fprintf(1, "Probability of the system actuating air conditioning: %g\n", Ps3);
fprintf(1, "Probability of the system actuating heat pump: %g\n", Ps4);
fprintf(1, "Sensing frequency of the system: %g\n", Xsensing);