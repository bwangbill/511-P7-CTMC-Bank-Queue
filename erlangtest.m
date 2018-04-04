function e = erlangtest(k,mu)
multiSum=rand();
for iExpCount=1:k-1
    multiSum=multiSum*rand();
end
e=(-1/mu)*(-log(multiSum));
end