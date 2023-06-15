clear all;

filename = input('Insert file name:',"s");
file = fopen(filename, 'r');
iA = fscanf(file, '%f');
fclose(file);

N = size(iA,1);
sortedIA = sort(iA);

Mean = sum(iA)/N;
Moment2 = sum(iA.^2)/N;
Moment3 = sum(iA.^3)/N;
Moment4 = sum(iA.^4)/N;
Moment5 = sum(iA.^5)/N;

centredMean = iA(:,1) - Mean;

Moment2Centred = sum(centredMean(:,1).^2)/N;
Moment3Centred = sum(centredMean(:,1).^3)/N;
Moment4Centred = sum(centredMean(:,1).^4)/N;
Moment5Centred = sum(centredMean(:,1).^5)/N;

stdDeviation = std(iA);
StdMoment3 = sum((centredMean(:,1)/stdDeviation).^3)/N;
StdMoment4 = sum((centredMean(:,1)/stdDeviation).^4)/N;
StdMoment5 = sum((centredMean(:,1)/stdDeviation).^5)/N;

VariationCoefficient = stdDeviation/Mean;

ExcessKurtosis = (Moment4Centred/(stdDeviation^4)) - 3;

h = (N - 1) * 10 / 100 + 1;
percentile10 = sortedIA(floor(h),1) + (h - floor(h)) * (sortedIA(floor(h)+1,1) - sortedIA(floor(h),1));
h = (N - 1) * 25 / 100 + 1;
percentile25 = sortedIA(floor(h),1) + (h - floor(h)) * (sortedIA(floor(h)+1,1) - sortedIA(floor(h),1));
h = (N - 1) * 50 / 100 + 1;
percentile50 = sortedIA(floor(h),1) + (h - floor(h)) * (sortedIA(floor(h)+1,1) - sortedIA(floor(h),1));
h = (N - 1) * 75 / 100 + 1;
percentile75 = sortedIA(floor(h),1) + (h - floor(h)) * (sortedIA(floor(h)+1,1) - sortedIA(floor(h),1));
h = (N - 1) * 90 / 100 + 1;
percentile90 = sortedIA(floor(h),1) + (h - floor(h)) * (sortedIA(floor(h)+1,1) - sortedIA(floor(h),1));

partialCrossCovariance = 0.0;
for i = 1:N-1
    partialCrossCovariance = partialCrossCovariance + (iA(i,1) - Mean) * (iA(i+1,1) - Mean);
end    
crossCovariance1 = (1/(N-1)) * partialCrossCovariance;

partialCrossCovariance = 0.0;
for i = 1:N-2
    partialCrossCovariance = partialCrossCovariance + (iA(i,1) - Mean) * (iA(i+2,1) - Mean);
end    
crossCovariance2 = (1/(N-2)) * partialCrossCovariance;

partialCrossCovariance = 0.0;
for i = 1:N-3
    partialCrossCovariance = partialCrossCovariance + (iA(i,1) - Mean) * (iA(i+3,1) - Mean);
end    
crossCovariance3 = (1/(N-3)) * partialCrossCovariance;

pearsonCorrelation1 = crossCovariance1 / Moment2Centred;
pearsonCorrelation2 = crossCovariance2 / Moment2Centred;
pearsonCorrelation3 = crossCovariance3 / Moment2Centred;

for i = 1:N
    counterN(i,1) = i;
end
Fx = counterN ./ N;
plot(sortedIA(:,1), Fx(:,1),'LineWidth',3);

fprintf(1, "First Moment: %g\n", Mean);
fprintf(1, "Second Moment: %g\n", Moment2);
fprintf(1, "Third Moment: %g\n", Moment3);
fprintf(1, "Fourth Moment: %g\n", Moment4);
fprintf(1, "Fifth Moment: %g\n", Moment5);

fprintf(1, "Second Centered Moment: %g\n", Moment2Centred);
fprintf(1, "Third Centered Moment: %g\n", Moment3Centred);
fprintf(1, "Fourth Centered Moment: %g\n", Moment4Centred);
fprintf(1, "Fifth Centered Moment: %g\n", Moment5Centred);

fprintf(1, "Third Standardized Moment: %g\n", StdMoment3);
fprintf(1, "Fourth Standardized Moment: %g\n", StdMoment4);
fprintf(1, "Fifth Standardized Moment: %g\n", StdMoment5);

fprintf(1, "Standard Deviation: %g\n", stdDeviation);
fprintf(1, "Coefficient of Variation: %g\n", VariationCoefficient);
fprintf(1, "Excess Kurtosis: %g\n", ExcessKurtosis);

fprintf(1, "10%% percentile: %g\n", percentile10);
fprintf(1, "25%% percentile: %g\n", percentile25);
fprintf(1, "50%% percentile: %g\n", percentile50);
fprintf(1, "75%% percentile: %g\n", percentile75);
fprintf(1, "90%% percentile: %g\n", percentile90);

fprintf(1, "CrossCovariance for lag m=1: %g\n", crossCovariance1);
fprintf(1, "CrossCovariance for lag m=2: %g\n", crossCovariance2);
fprintf(1, "CrossCovariance for lag m=3: %g\n", crossCovariance3);

fprintf(1, "Pearson Correlation Coefficient for lag m=1: %g\n", pearsonCorrelation1);
fprintf(1, "Pearson Correlation Coefficient for lag m=2: %g\n", pearsonCorrelation2);
fprintf(1, "Pearson Correlation Coefficient for lag m=3: %g\n", pearsonCorrelation3);