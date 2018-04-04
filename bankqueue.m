%{
Bill (Belal) Wang, 9058118990
EE511 Project 7: CTMC Bank Queue
%}

%{
Scenario 1: Simulating Bank Queue with following parameters -
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

%------------Single Queue Scenario-------------
%initialization
buffer=0; %number of customers in queue (including currently being served)
simTime=0; %simulation time in minutes (can be fractional)
%track busy status of each teller
tellerStatus=zeros(1,3);
%number of events (arrival, departure) to simulate for
totalCustArrivals=input('Max customers to be serviced: ');
lambda=input('Customer Arrival Rate (Poisson): ');

%result containers
arrTime=zeros(1, totalCustArrivals);
depTime=zeros(1, totalCustArrivals);
delay=zeros(1, totalCustArrivals);

%Initialize event counters
arrNum=0;
depNum=0;

%Bernoulli p=0.75
p=0.75;

%Initialize arrival times and departure times 1-3
%calc initial next arrival time
nextArrTime=poisTime(lambda);
%NextArrTime2 = 0;
%NextArrTime3 = 0;
nextDepTime1 = 1;
nextDepTime2 = 1;
nextDepTime3 = 1;

%main loop, runs until max number of arriving customers is reached
while arrNum < totalCustArrivals
    %get next event
    if (nextArrTime<nextDepTime1 && nextArrTime<nextDepTime2 && nextArrTime < nextDepTime3)
        %arrival
        arrNum=arrNum+1;
        simTime=nextArrTime;
        arrTime(arrNum)=simTime;
        %----Start-----
        if buffer==0
            %calc departure time dependent on complexity
            if bernTime(p)==1 %simple transaction
                nextDepTime1=simTime+erlangTime(2,2);
                nextDepTime2=simTime+erlangTime(2,2);
                nextDepTime3=simTime+erlangTime(2,2);
            else %complex transaction
                nextDepTime1=simTime+erlangTime(5,6);
                nextDepTime2=simTime+erlangTime(5,6);
                nextDepTime3=simTime+erlangTime(5,6);
            end
        end
        buffer=buffer+1;
        nextArrTime=simTime-poisTime(lambda);
    else
        %departure
        depNum=depNum+1;
        simTime=min([nextDepTime1, nextDepTime2, nextDepTime3]);
        depTime(depNum)=simTime;
        buffer=buffer-1;
        if buffer>0 && nextDepTime1==min([nextDepTime1, nextDepTime2, nextDepTime3])
            if bernTime(p)==1 %simple transaction
                nextDepTime1=simTime+erlangTime(2,2);
            else %complex transaction
                nextDepTime1=simTime+erlangTime(5,6);
            end
        elseif buffer>0 && nextDepTime2==min([nextDepTime1, nextDepTime2, nextDepTime3])
             if bernTime(p)==1 %simple transaction
                nextDepTime2=simTime+erlangTime(2,2);
            else %complex transaction
                nextDepTime2=simTime+erlangTime(5,6);
             end
        elseif buffer>0 && nextDepTime2==min([nextDepTime1, nextDepTime2, nextDepTime3])
            if bernTime(p)==1 %simple transaction
                nextDepTime3=simTime+erlangTime(2,2);
            else %complex transaction
                nextDepTime3=simTime+erlangTime(5,6);
            end
        else
            nextDepTime1=nextArrTime+1;
            nextDepTime2=nextArrTime+1;
            nextDepTime3=nextArrTime+1;
        end
    end
end

%cleanup buffer of remaining customers in line
while buffer>0
    depNum=depNum+1;
    simTime=min([nextDepTime1, nextDepTime2, nextDepTime3]);
    depTime(depNum)=simTime;
    buffer=buffer-1;
    if buffer>0 && nextDepTime1==min([nextDepTime1, nextDepTime2, nextDepTime3])
        if bernTime(p)==1 %simple transaction
            nextDepTime1=simTime+erlangTime(2,2);
        else %complex transaction
            nextDepTime1=simTime+erlangTime(5,6);
        end
    elseif buffer>0 && nextDepTime2==min([nextDepTime1, nextDepTime2, nextDepTime3])
         if bernTime(p)==1 %simple transaction
            nextDepTime2=simTime+erlangTime(2,2);
        else %complex transaction
            nextDepTime2=simTime+erlangTime(5,6);
         end
    elseif buffer>0 && nextDepTime2==min([nextDepTime1, nextDepTime2, nextDepTime3])
        if bernTime(p)==1 %simple transaction
            nextDepTime3=simTime+erlangTime(2,2);
        else %complex transaction
            nextDepTime3=simTime+erlangTime(5,6);
        end
    end
end

%delay stats
delay=depTime-arrTime;
sum_delay=0;
for c_no=1:depNum
    sum_delay=sum_delay+delay(c_no);
end
mean_delay=sum_delay/depNum


%--------Functions for inverse distributions------------
%determine transaction type (1=simple, 0=complex)
function b = bernTime(p)
rngU=rand();
if rngU<p
    b=1;
else
    b=0;
end
end

%determine next customer arrival time
function p =poisTime(lambda)
p=poissrnd(lambda);
end

%determine erlang transaction time
function e = erlangTime(k,mu)
multiSum=0;
for iExpCount=1:k
    rngU=rand();
    multiSum=multiSum*rngU;
end
e=(-1/mu)*(-log(multiSum));
end