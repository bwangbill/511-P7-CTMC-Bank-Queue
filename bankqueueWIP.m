%{
Bill (Belal) Wang, 9058118990
EE511 Project 7: CTMC Bank Queue
%}
%-------------Scenario 1: Single Queue--------------
%-------------Initialization------------------------
%Simulation time (minutes), System State
%(buffer size, server1 customer #, server2 customer #, server3 customer #), Counters (# arrivals, total
%customers served by servers 1, 2, 3), Output vars: Arrival and Departure
%matrices, next events (arrival, departures 1, 2, 3)

timestamp=0; %tracks timestamps


ss=0; %systemstate(n customers in system, i customer in s1, j customer in s2, k customer in s3)
%ss=number Cs in system
ssijk=zeros(1,3);
%ssijk(1)=cNum at server 1
%ssijk(2)=cNum at server 2
%ssijk(3)=cNum at server 3
cNum=0; %customer number, similar to arrival#

%input number of arrivals/departure to simulate:
runtime=input('Max customer arrivals (simulation time): ');
lambda=input('Customer Arrival Rate (Poisson): ');
arrTimes=zeros(1,runtime);
depTimes1=zeros(1,runtime);
depTimes2=zeros(1,runtime);
depTimes3=zeros(1,runtime);
depTimes=zeros(1,runtime);

%initialize first arrival
nextArr=expRV(lambda);
timestamp=nextArr;%next departures need to be greater for first run
nextDep1=inf;
nextDep2=inf;
nextDep3=inf;

%main loop
while cNum < runtime
    nextEvt=min([nextArr,nextDep1,nextDep2,nextDep3]);
    
    %case 1, arrTime min -- arrival
    if nextEvt==nextArr
        
        
        %cNum=cNum+1; %count arrivals
        %determine last position in system to add arrival
        if (ss<4)
            cNum=max(ssijk)+1;
        else
            cNum=max(ssijk)+ss-3;
        end
        %cNum=max(ss(1,:)) + ss(1,0) - 3 + 1;
        %%%timestamp = timestamp+nextArr; %record arrival time
        timestamp=nextArr;
        %%%arrTimes(cNum)=timestamp; %set timestamp of event
        arrTimes(cNum)=nextArr;
        %actions based on system state ss
        if ss<3 %open slots, fewer than 3 custs
            %push arrival to next open slot
            %if min(ssijk)==ssijk(1) %slot 1 has min cNum
            if nextDep1==inf    
                ssijk(1)=cNum;
                if bernTime(0.75)==1
                    %%%nextDep1=timestamp-erlangTime(2,5);
                    nextDep1=nextArr-erlangTime(2,5);
                else
                    %%%nextDep1=timestamp-erlangTime(5,6);
                    nextDep1=nextArr-erlangTime(5,6);
                end
                %nextDep1=nextArr+nextDep1;
            %elseif min(ssijk)==ssijk(2) %slot 2 has min cNum
            elseif nextDep2==inf
                ssijk(2)=cNum;
                if bernTime(0.75)==1
                    %%%nextDep1=timestamp-erlangTime(2,5);
                    nextDep2=nextArr-erlangTime(2,5);
                else
                    %%%nextDep1=timestamp-erlangTime(5,6);
                    nextDep2=nextArr-erlangTime(5,6);
                end
                %nextDep2=nextArr+nextDep2;
            %elseif min(ssijk)==ssijk(3) %slot 3 has min cNum
            elseif nextDep3==inf
                ssijk(3)=cNum;
                if bernTime(0.75)==1
                    %%%nextDep1=timestamp-erlangTime(2,5);
                    nextDep3=nextArr-erlangTime(2,5);
                else
                    %%%nextDep1=timestamp-erlangTime(5,6);
                    nextDep3=nextArr-erlangTime(5,6);
                end
                %nextDep3=nextArr+nextDep3;
            end
            
        else %no slots open -- buffer arrival
            %ss(1,0) = ss(1,0)+1; %increase n
        end
        
        %calculate time of next arrival
        nextArr=nextArr+expRV(lambda); 
        ss = ss + 1; %increase n system count
        %cNum=cNum+1; %increase arrival count
        timestamp
        ss
        ssijk
        cNum
    %case 2, depTime1 min -- departure at teller1
    elseif nextEvt==nextDep1
        cNum=ssijk(1); %%set customer # to customer in teller position
        depTimes1(cNum)=nextDep1; %update output table
        depTimes(cNum)=nextDep1;
        ss=ss - 1; %remove Cs from the system
        if ss < 3 %if no customers in queue (less than 3 in system would all be serviced)
            nextDep1=inf; %set dep to high for min calculation in loop
        else %customers waiting
            ssijk(1)=max(ssijk) + 1; %pick next buffer - max customer in process + 1, set to first server
            if bernTime(0.75)==1
                nextDep1=nextDep1-erlangTime(2,5);
            else
                nextDep1=nextDep1-erlangTime(5,6);
            end
        end
        timestamp
        ss
        ssijk
        cNum
    %case 3, depTime2 min -- departure at teller2
    elseif nextEvt==nextDep2
        timestamp=timestamp+nextDep2; %update timestamp
        cNum=ssijk(2); %%set customer # to customer in teller position
        depTimes2(cNum)=nextDep2; %update output table
        depTimes(cNum)=nextDep2;
        ss=ss - 1; %remove Cs from the system
        if ss < 3 %if no customers in queue (less than 3 in system would all be serviced)
            nextDep2=inf; %set dep to high for min calculation in loop
        else %customers waiting
            ssijk(2)=max(ssijk) + 1; %pick next buffer - max customer in process + 1, set to first server
            if bernTime(0.75)==1
                nextDep2=nextDep2-erlangTime(2,5);
            else
                nextDep2=nextDep2-erlangTime(5,6);
            end
        end
        timestamp
        ss
        ssijk
        cNum
        %{
        cNum=ss(1,2); %%set customer # to customer in teller position
        ss(1,0)=ss(1,0)-1; %remove Cs from the system
        if ss(1,0)==0 %if no customers in system
            nextDep2=inf;
        end
        %}
    %case 4, depTime3 min -- departure at teller3
    elseif nextEvt==nextDep3
        timestamp=timestamp+nextDep3; %update timestamp
        cNum=ssijk(3); %%set customer # to customer in teller position
        depTimes3(cNum)=nextDep3; %update output table
        depTimes(cNum)=nextDep3;
        ss = ss - 1; %remove Cs from the system
        if ss < 3 %if no customers in queue (less than 3 in system would all be serviced)
            nextDep3=inf; %set dep to high for min calculation in loop
        else %customers waiting
            ssijk(2)=max(ssijk) + 1; %pick next buffer - max customer in process + 1, set to first server
            if bernTime(0.75)==1
                nextDep3=nextDep3-erlangTime(2,5);
            else
                %nextDep3=timestamp-erlangTime(5,6);
                nextDep3=nextDep3-erlangTime(5,6);
            end
        end
        timestamp
        ss
        ssijk
        cNum

    end
end

%cleanup remaining customers
while (ss>0) %while customers are remaining in system
    
    nextEvt=min([nextDep1,nextDep2,nextDep3]);
    %{
    if (ss<4) %3 customers remaining, buffer is empty
        cNum=max(ssijk)+1; %select customer at 
    else %buffer not empty
        cNum=max(ssijk)+ss-3; %select customer at 
    end
    %}
    
    %case 1, depTime1 min -- departure at teller1
    if nextEvt==nextDep1
        timestamp=timestamp+nextDep1; %update timestamp
        cNum=ssijk(1); %%set customer # to customer in teller position
        depTimes1(1,cNum)=nextDep1; %update output table
        depTimes(1,cNum)=nextDep1;
        ss = ss - 1; %remove Cs from the system
        if ss < 3 %if no customers in queue (less than 3 in system would all be serviced)
            nextDep1=inf; %set dep to high for min calculation in loop
        else %customers waiting
            ssijk(1)=max(ssijk) + 1; %pick next buffer - max customer in process + 1, set to first server
            if bernTime(0.75)==1
                nextDep1=nextDep1-erlangTime(2,5);
            else
                nextDep1=nextDep1-erlangTime(5,6);
            end
        end
    %case 2, depTime2 min -- departure at teller2
    elseif nextEvt==nextDep2
        timestamp=timestamp+nextDep2; %update timestamp
        cNum=ssijk(2); %%set customer # to customer in teller position
        depTimes2(1,cNum)=timestamp; %update output table
        depTimes(1,cNum)=timestamp;
        ss = ss - 1; %remove Cs from the system
        if ss < 3 %if no customers in queue (less than 3 in system would all be serviced)
            nextDep2=inf; %set dep to high for min calculation in loop
        else %customers waiting
            ssijk(2)=max(ssijk) + 1; %pick next buffer - max customer in process + 1, set to first server
            if bernTime(0.75)==1
                nextDep2=nextDep2-erlangTime(2,5);
            else
                nextDep2=nextDep2-erlangTime(5,6);
            end
        end
    %case 3, depTime3 min -- departure at teller3
    elseif nextEvt==nextDep3
        timestamp=timestamp+nextDep3; %update timestamp
        cNum=ssijk(3); %%set customer # to customer in teller position
        depTimes3(1,cNum)=timestamp; %update output table
        depTimes(1,cNum)=timestamp;
        ss = ss - 1; %remove Cs from the system
        if ss < 3 %if no customers in queue (less than 3 in system would all be serviced)
            nextDep3=inf; %set dep to high for min calculation in loop
        else %customers waiting
            ssijk(2)=max(ssijk) + 1; %pick next buffer - max customer in process + 1, set to first server
            if bernTime(0.75)==1
                nextDep3=nextDep3-erlangTime(2,5);
            else
                nextDep3=nextDep3-erlangTime(5,6);
            end
        end
    end
end

%calculate statistics
delay=depTimes-arrTimes;


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