x = [-2 1 -4 3];
N = 4;             %period of x[n].
k = 0:3;        %Number of replicas is taken as 25 only.
k1 = 0:N-1;      %index of x[n] for one period
ak = zeros;
X = zeros(1,length(k));  %Initialization of X to store each replica.

%ak calculation withour scaling factor
for i = k
    ak(i+1) = ak(i)+x(1,i+1)*exp(-j*2*pi*l*i/N);  %Calculation of ak
end