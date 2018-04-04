% Simulation of a simple CTMC, John Silvester, November 2016
% Initialization
state=0;
sim_time=0;
% Read in parameters

no_departures=input('No departures: ');
arrival_time=zeros(no_departures);
departure_time=zeros(no_departures);
delay=zeros(no_departures);
% above is not efficient in use of storage- ok for short runs.
% For longer runs may want to compact how much data is retained
% generate initial arrival and departure
arr_no=0;
dep_no=0;
lambda=input('Arrival rate (exponential): ');
mu=input('Departure rate (exponential): ');
next_arr_time=-log(rand(1,1))/lambda;
% following is an artificial departure time
% it will be modified when the first arrival occurs
next_dep_time=next_arr_time+1;
%
% Main simulation loop
while arr_no<no_departures
    % get next event
    if (next_arr_time<next_dep_time)
        % arrival
        arr_no=arr_no+1;
        sim_time=next_arr_time;
        arrival_time(arr_no)=sim_time;
        if (state==0)
            next_dep_time=sim_time-log(rand(1,1))/mu;
        end
        state=state+1;
        
        next_arr_time=sim_time-log(rand(1,1))/lambda;
    else
        %departure
        dep_no=dep_no+1;
        sim_time=next_dep_time;
        departure_time(dep_no)=sim_time;
        state=state-1;
        
        if state>0
            next_dep_time=sim_time-log(rand(1,1))/mu;
        else
            next_dep_time=next_arr_time+1; % artificial
        end
    end
end
%processing remaining customers 
while state>0
dep_no=dep_no+1;
sim_time=next_dep_time;
departure_time(dep_no)=sim_time;
state=state-1;
    if state>0
        next_dep_time=sim_time-log(rand(1,1))/mu;
    end
end
% output
% delay is time in system = waiting time + service time
delay=departure_time-arrival_time;
sum_delay=0;

for c_no=1:dep_no
    sum_delay=sum_delay+delay(c_no);
end
mean_delay=sum_delay/dep_no
% should compute and print other statistics of interest
