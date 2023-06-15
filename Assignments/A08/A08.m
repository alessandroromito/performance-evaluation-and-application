clear all;

% FSM
% state 1 : Preparing new job
% state 2 : Execution of the job
% state 3 : Garbage collector switch ON
% state 4 : Garbage collector switch OFF

jobExec = 1;
jobFinished = 4;
switchON = 2;
switchOFF = 3;
s = jobFinished;
t = 0;
i = 1;
garbage = false;
garbageStart = -log(rand())/0.1;
garbageLast = -log(rand())/0.4;
fullSpeed = 0;
lowSpeed = 0;
Tprep = 0;
C = 0;

maxT = 1000000;

while t < maxT
    if s == jobFinished
        nextState = jobExec;
        dt = -log(rand())/0.05;
        garbageStart = t + dt + -log(rand())/0.1;
        garbageLast = -log(rand())/0.4;
        Tprep = Tprep + dt;
        C = C + 1;
    end
    
    if s == jobExec
        if garbage == true
            Tjob = -log(rand())/0.3;
            if t + Tjob < garbageStart + garbageLast
                lowSpeed = lowSpeed + Tjob;
                nextState = jobFinished;
                dt = Tjob;
            else
                lowSpeed = lowSpeed + (t + Tjob - garbageStart - garbageLast);
                nextState = switchOFF;
                remaining = t + Tjob - garbageStart - garbageLast;
                dt = remaining;
            end
        else
            Tjob = -log(rand());
            if t + Tjob < garbageStart
                fullSpeed = fullSpeed + Tjob;
                nextState = jobFinished;
                dt = Tjob;
            else
                fullSpeed = fullSpeed + (garbageStart - t);
                nextState = switchON;
                remaining = t + Tjob - garbageStart;
                dt = remaining;
            end
        end
    end

    if s == switchOFF
        garbage = false;
        garbageStart = t + -log(rand())/0.1;
        garbageLast = -log(rand())/0.4;
        if remaining < garbageStart
            fullSpeed = fullSpeed + remaining;
            nextState = jobFinished;
            dt = remaining;
        else
            fullSpeed = fullSpeed + garbageStart - t;
            nextState = switchON;
            dt = garbageStart - t;
        end
    end

    if s == switchON
        garbage = true;
        if remaining < garbageStart + garbageLast
            lowSpeed = lowSpeed + remaining;
            nextState = jobFinished;
            dt = remaining;
        else
            lowSpeed = lowSpeed + garbageStart + garbageLast - t;
            nextState = switchOFF;
            dt = garbageStart + garbageLast - t;
        end
    end
  
    s = nextState;
    t = t + dt;
end

pFull = fullSpeed / t;
pLow = lowSpeed / t;
pPrep = Tprep / t;
Throghput = C / t;

fprintf(1, "Probability of preparing a new job: %g\n", pPrep);
fprintf(1, "Probability of executing during garbage collector: %g\n", pLow);
fprintf(1, "Probability of executing at full speed: %g\n", pFull);
fprintf(1, "Throughput: %g\n", Throghput);