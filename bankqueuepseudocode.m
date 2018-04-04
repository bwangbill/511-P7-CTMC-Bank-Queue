%Pseudocode----

%initialize variables SS=0 (number customers in system)
timestamp=0;
SS=0;
%ijk placeholders for cNum at server #ijk
i=0;
j=0;
k=0;
cNum=0;

%set next arrival, set nextdeps inf
nextarrival=poisson;


%Step through sim -- main loop
while 1
    %-----------------check arrival VS departure
    nextevent=min([1,2,3,4]);
    %------------Arrivals------------
    %case1 - arrival
    if nextevent==1
        %update timestamp to next arrival time
        timestamp=timestamp+nextarrival;
        if SS<3 % less than 3 customers in system
            %push arrival to next open slot
            if min(ijk)==i
                %push to first slot
                i=cNum;
                %calculate next departure 1
            elseif min(ijk)==j
                %push to 2nd slot
                j=cNum;
                %calculate next departure 2
            elseif min (ijk)==k
                %push to 3rd slot
                k=cNum;
                %calculate next departure 3
            end
            
        elseif SS>2  %servers all busy
            %push to buffer
            
        end
        SS=SS+1; %increase system count
        cNum=cNum+1; %increase arrival count
        
        
    %------------Departures----------
    %case 2 - departure at s1
    elseif nextevent==2
        timestamp=timestamp+nextdep1; %set timestamp
        
        %select Cs at position 1
        
        %add to output variable (departure time)
        
        SS=SS-1; %decrease system count
        if SS>3%if buffer is not empty, 
            %pick next customer in queue
            cNum=k+1;
            %calc next departure time
            nextdep1=timestamp+erlangTime();
        else %buffer is empty
            nextdeparture1=inf; %set next departure to infinity (next iteration is arrival)
        end
            
    %case 3 - departure at s2
    elseif nextevent==3
        timestamp=timestamp+nextdep2; %set timestamp
        SS=SS-1; %decrease system count
        if SS>3%if buffer is not empty, 
            %pick next customer in queue
            cNum=k+1;
            %calc next departure time
            nextdep2=timestamp+erlangTime();
        else %buffer is empty
            nextdeparture2=inf; %set next departure to infinity (next iteration is arrival)
        end
        
    %case 4 - departure at s3
    elseif nextevent==4
        timestamp=timestamp+nextdep1; %set timestamp
        SS=SS-1; %decrease system count
        if SS>3%if buffer is not empty, 
            %pick next customer in queue
            cNum=k+1;
            %calc next departure time
            nextdep3=timestamp+erlangTime();
        else %buffer is empty
            nextdeparture3=inf; %set next departure to infinity (next iteration is arrival)
        end
    end
end

%clear remaining buffer items

%calculate statistics

