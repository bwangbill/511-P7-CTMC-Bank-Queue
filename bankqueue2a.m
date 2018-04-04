%{
Bill (Belal) Wang, 9058118990
EE511 Project 7: CTMC Bank Queue
%}

%{
Scenario 2: Simulating Bank Queue with following parameters -
Given: All times in minutes
Given: 3 Tellers
-Customer arrival distributed as random Poisson(lambda) process
-Each customer has a random {simple, complex} transaction time
~Bernoulli(p), p=0.75 for simple
-{simple} - Erlang(x, 2, 2)
-{complex} - Erlang(x, 5, 6)

Scenarios:
1. Single queue, customer goes to first free teller
2. Separate queue for each teller (arriving customer joins shortest queue)
3. Queues for simple/complext transactions.  1 Teller for simple, 2 for
complex

%}

%------------3 Teller Separate Queue Scenario-------------
%initialization
buffer1=0;
buffer2=0; 
buffer3=0; %number of customers in queue (including currently being served) -- SS
simTime1=0;
simTime2=0; 
simTime3=0; %simulation time in minutes (can be fractional)
%number of events (arrival, departure) to simulate for
totalCustArrivals=input('Max customers to be serviced: ');
lambda=input('Customer Arrival Rate (Poisson): ');

%result containers
arrTime1=zeros(1, int8(totalCustArrivals/3)+1);
arrTime2=zeros(1, int8(totalCustArrivals/3)+1);
arrTime3=zeros(1, int8(totalCustArrivals/3)+1);
depTime1=zeros(1, int8(totalCustArrivals/3)+1);
depTime2=zeros(1, int8(totalCustArrivals/3)+1); 
depTime3=zeros(1, int8(totalCustArrivals/3)+1);
%delay1=zeros(1, totalCustArrivals/3+1);
%delay2=zeros(1, totalCustArrivals/3+1);
%delay3=zeros(1, totalCustArrivals/3+1);

%Initialize event counters
totalArr=0;
arrNum1=0;
arrNum2=0; 
arrNum3=0;
depNum1=0;
depNum2=0;
depNum3=0;

%Bernoulli p=0.75
p=0.75;

%Initialize arrival times 1-3
nextArrTime1 = expRV(lambda);
nextArrTime2 = expRV(lambda);
nextArrTime3 = expRV(lambda);
%artificial departure times
nextDepTime1 = nextArrTime1+1;
nextDepTime2 = nextArrTime2+1;
nextDepTime3 = nextArrTime3+1;

%main loop, runs until max number of arriving customers is reached
while totalArr < totalCustArrivals
    if(min([buffer1, buffer2, buffer3])==buffer1) %teller 1 shortest
        %teller 1 queue logic
        %calc next arrival time
        %nextArrTime1=poisPeriod(lambda);
        %calc next departure time dependent on complexity
        %{
        if transactionType(p)==1 %simple transaction
            nextDepTime1=erlangPeriod(2,2);
        else %complex transaction
            nextDepTime1=erlangPeriod(5,6);
        end
        %}
        if(nextArrTime1<nextDepTime1) %arrival
            arrNum1=arrNum1+1;
            simTime1=nextArrTime1;
            arrTime1(arrNum1)=simTime1;
            if(buffer1==0)
                if transactionType(p)==1 %simple transaction
                    nextDepTime1=simTime1-erlangTime(2,2);
                else %complex transaction
                    nextDepTime1=simTime1-erlangTime(5,6);
                end
                %nextDepTime1=simTime1+nextDepTime1;
            end
            totalArr=totalArr+1;
            buffer1=buffer1+1;
            nextArrTime1=simTime1+expRV(lambda);
        else  %departure
            depNum1=depNum1+1;
            simTime1=nextDepTime1;
            depTime1(depNum1)=simTime1;
            buffer1=buffer1-1;
            if buffer1>0
                if transactionType(p)==1 %simple transaction
                    nextDepTime1=simTime1-erlangTime(2,2);
                else %complex transaction
                    nextDepTime1=simTime1-erlangTime(5,6);
                end
            else
                nextDepTime1=nextArrTime1+1; % artificial
            end
            %totalArr=totalArr+1;
        end
            
    elseif (min([buffer1, buffer2, buffer3])==buffer2) %teller 2 shortest
        %teller 2 queue logic
        %calc next arrival time
        
        
        
        if(nextArrTime2<nextDepTime2) %arrival
            arrNum2=arrNum2+1;
            simTime2=nextArrTime2;
            arrTime2(arrNum2)=simTime2;
            if(buffer2==0)
                if transactionType(p)==1 %simple transaction
                    nextDepTime2=simTime2-erlangTime(2,2);
                else %complex transaction
                    nextDepTime2=simTime2-erlangTime(5,6);
                end
            end
            totalArr=totalArr+1;
            buffer2=buffer2+1;
            nextArrTime2=simTime2+expRV(lambda);
        else  %departure
            depNum2=depNum2+1;
            sim_time2=nextDepTime2;
            depTime2(depNum2)=simTime2;
            buffer2=buffer2-1;
            if buffer2>0
                if transactionType(p)==1 %simple transaction
                    nextDepTime2=simTime2-erlangTime(2,2);
                else %complex transaction
                    nextDepTime2=simTime2-erlangTime(5,6);
                end
            else
                nextDepTime2=nextArrTime2+2; % artificial
            end
            %totalArr=totalArr+1;
        end
    elseif (min([buffer1, buffer2, buffer3])==buffer3) %teller 3 shortest
        %teller 3 queue logic
        
        if(nextArrTime3<nextDepTime3) %arrival
            arrNum3=arrNum3+1;
            simTime3=nextArrTime3;
            arrTime3(arrNum3)=simTime3;
            if(buffer3==0)
                if transactionType(p)==1 %simple transaction
                    nextDepTime3=simTime3-erlangTime(2,2);
                else %complex transaction
                    nextDepTime3=simTime3-erlangTime(5,6);
                end
            end
            totalArr=totalArr+1;
            buffer3=buffer3+1;
            nextArrTime3=simTime3+expRV(lambda);
        else  %departure
            depNum3=depNum3+1;
            sim_time3=nextDepTime3;
            depTime3(depNum3)=simTime3;
            buffer3=buffer3-1;
            if buffer3>0
                if transactionType(p)==1 %simple transaction
                    nextDepTime3=simTime3-erlangTime(2,2);
                else %complex transaction
                    nextDepTime3=simTime3-erlangTime(5,6);
                end
            else
                nextDepTime3=nextArrTime3+2; % artificial
            end
            %totalArr=totalArr+1;
        end
    end
end

%cleanup buffer of remaining customers in line
%case1
while buffer1>0
    depNum1=depNum1+1;
    simTime1=nextDepTime1;
    depTime1(depNum1)=simTime1;
    buffer1=buffer1-1;
    if buffer1>0
        nextDepTime1=simTime1-nextDepTime1;
    end
end
%case2
while buffer2>0
    depNum2=depNum2+1;
    simTime2=nextDepTime2;
    depTime2(depNum2)=simTime2;
    buffer2=buffer2-1;
    if buffer2>0
        nextDepTime2=simTime2-nextDepTime2;
    end
end
%case3
while buffer3>0
depNum3=depNum3+1;
    simTime3=nextDepTime3;
    depTime3(depNum3)=simTime3;
    buffer3=buffer3-1;
    if buffer3>0
        nextDepTime3=simTime3-nextDepTime3;
    end
end

%output
delay1=depTime1-arrTime1;
delay2=depTime2-arrTime2;
delay3=depTime3-arrTime3;
sumDelay1=0;
sumDelay2=0;
sumDelay3=0;
for cNum1=1:depNum1%case1
    sumDelay1=sumDelay1+delay1(cNum1);
end
meanDelay1=sumDelay1/depNum1;
for cNum2=1:depNum2%cas2
    sumDelay2=sumDelay2+delay2(cNum2);
end
meanDelay2=sumDelay2/depNum2;
for cNum3=1:depNum3%case3
    sumDelay3=sumDelay3+delay3(cNum3);
end
meanDelay3=sumDelay3/depNum3;
totalDelay=sum([meanDelay1, meanDelay2, meanDelay3])/3;

%--------Functions for inverse distributions------------
%determine transaction type (1=simple, 0=complex)
function b = transactionType(p)
rngU=rand();
if rngU<p
    b=1;
else
    b=0;
end
end

%determine next customer arrival time
function p =poisTime(lmbda)
%rngU=rand();
%p=poissinv(rngU, lambda);
p=poissrnd(lmbda)
end

function ex = expRV(lambda)
ex=exprnd(1/lambda);
end

%determine erlang transaction time
function e = erlangTime(k,mu)
multiSum=rand();
for iExpCount=1:k-1
    multiSum=multiSum*rand();
end
e=(-1/mu)*(-log(multiSum));
end