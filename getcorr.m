k=1;
for i = 1:20:(floor(numel(a)/20)*20)
    a_corr(:,k) = xcov(a(i:(i+20)),a(i:(i+20)),10,'coeff');
    k=k+1;   
end