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

timestamp=0;
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
nextArr=poisTime(lambda);
%next departures need to be greater for first run
nextDep1=inf;
nextDep2=inf;
nextDep3=inf;
    
%main loop
while cNum < runtime
    nextEvt=min([nextArr,nextDep1,nextDep2,nextDep3])
    
    %case 1, arrTime min -- arrival
    if nextEvt==nextArr
        
        %cNum=cNum+1; %count arrivals 
        if (ss<4)
            cNum=max(ssijk)+1;
        else
            cNum=max(ssijk)+ss-3;
        end
        %cNum=max(ss(1,:)) + ss(1,0) - 3 + 1;
        timestamp=nextArr; %set timestamp of event
        arrTimes(1,cNum) = timestamp; %record arrival time
        %actions based on system state ss
        if ss<3 %open slots, fewer than 3 custs
            %push arrival to next open slot
            %if min(ssijk)==ssijk(1) %slot 1 has min cNum
            if nextDep1==inf    
                ssijk(1)=cNum;
                if bernTime(0.75)==1
                    nextDep1=timestamp-erlangTime(2,5);
                else
                    nextDep1=timestamp-erlangTime(5,6);
                end
            %elseif min(ssijk)==ssijk(2) %slot 2 has min cNum
            elseif nextDep2==inf
                ssijk(2)=cNum;
                if bernTime(0.75)==1
                    nextDep2=timestamp-erlangTime(2,5);
                else
                    nextDep2=timestamp-erlangTime(5,6);
                end
            %elseif min(ssijk)==ssijk(3) %slot 3 has min cNum
            elseif nextDep3==inf
                ssijk(3)=cNum;
                if bernTime(0.75)==1
                    nextDep3=timestamp-erlangTime(2,5);
                else
                    nextDep3=timestamp-erlangTime(5,6);
                end
            end
        %{
        if ss(1,0)==0 %initial arrival (first customer)
            ss(1,0) = ss(1,0)+1; %increase n
            ss(1,1) = cNum; %add Cs arrival # to teller 1
            %check for simple or complex, calculate departure time for
            %this (first) event
            if bern(0.75)==1
                nextDep1=timestamp+erlang(2,5);
            else
                nextDep1=timestamp+erlang(5,6);
            end
            
        %if first slot open
        elseif ss(1,1)==0
            ss(1,0) = ss(1,0)+1; %increase n
            ss(1,1) = cNum; %add Cs to teller 1
            %calculate next departure 1
            if bern(0.75)==1
                nextDep1=timestamp+erlang(2,5);
            else
                nextDep1=timestamp+erlang(5,6);
            end
        elseif ss(1,2)==0 %2nd slot open
            ss(1,2) = cNum; %add Cs to teller 1
            ss(1,0) = ss(1,0)+1; %increase n
            %calculate departure
            if bern(0.75)==1
                nextDep2=timestamp+erlang(2,5);
            else
                nextDep2=timestamp+erlang(5,6);
            end
        elseif ss(1,3)==0 %3rd slot open
            ss(1,2) = cNum; %add Cs to teller 1
            ss(1,0) = ss(1,0)+1; %increase n
            %calculate departure
            if bern(0.75)==1
                nextDep3=timestamp+erlang(2,5);
            else
                nextDep3=timestamp+erlang(5,6);
            end
            %}
            
        else %no slots open -- buffer arrival
            %ss(1,0) = ss(1,0)+1; %increase n
        end
        
        %calculate time of next arrival
        nextArr=timestamp+poisTime(lambda); 
        ss = ss + 1; %increase n system count
        %cNum=cNum+1; %increase arrival count
        timestamp
        ss
        ssijk
        cNum
    %case 2, depTime1 min -- departure at teller1
    elseif nextEvt==nextDep1
        timestamp=timestamp+nextDep1; %update timestamp
        cNum=ssijk(1); %%set customer # to customer in teller position
        depTimes1(1,cNum)=timestamp; %update output table
        depTimes(1,cNum)=timestamp;
        ss=ss - 1; %remove Cs from the system
        if ss < 3 %if no customers in queue (less than 3 in system would all be serviced)
            nextDep1=inf; %set dep to high for min calculation in loop
        else %customers waiting
            ssijk(1)=max(ssijk) + 1; %pick next buffer - max customer in process + 1, set to first server
            if bernTime(0.75)==1
                nextDep1=timestamp-erlangTime(2,5);
            else
                nextDep1=timestamp-erlangTime(5,6);
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
        depTimes2(1,cNum)=timestamp; %update output table
        depTimes(1,cNum)=timestamp;
        ss=ss - 1; %remove Cs from the system
        if ss < 3 %if no customers in queue (less than 3 in system would all be serviced)
            nextDep2=inf; %set dep to high for min calculation in loop
        else %customers waiting
            ssijk(2)=max(ssijk) + 1; %pick next buffer - max customer in process + 1, set to first server
            if bernTime(0.75)==1
                nextDep2=timestamp-erlangTime(2,5);
            else
                nextDep2=timestamp-erlangTime(5,6);
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
        depTimes3(1,cNum)=timestamp; %update output table
        depTimes(1,cNum)=timestamp;
        ss = ss - 1; %remove Cs from the system
        if ss < 3 %if no customers in queue (less than 3 in system would all be serviced)
            nextDep3=inf; %set dep to high for min calculation in loop
        else %customers waiting
            ssijk(2)=max(ssijk) + 1; %pick next buffer - max customer in process + 1, set to first server
            if bernTime(0.75)==1
                nextDep3=timestamp-erlangTime(2,5);
            else
                nextDep3=timestamp-erlangTime(5,6);
            end
        end
        timestamp
        ss
        ssijk
        cNum
        %{
            ss(1,0)=ss(1,0)-1; %remove Cs from the system
        timestamp=timestamp+nextDep3; %update timestamp
        depTimes1(1,cNum)=timestamp; %update output table
        if ss(1,0)>2 %customers in queue ->pick next buffer, set departure time
        elseif ss(1,0)==0 %if no customers in system
            nextDep3=inf;
        end 
        %}
    end
end

%cleanup remaining customers
while (0==1) %while customers are remaining in buffer
    
end

%calculate statistics
delay=0;


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
multiSum=rand();
for iExpCount=1:k
    multiSum=multiSum*rand();
end
e=(-1/mu)*(-log(multiSum));
end