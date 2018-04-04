%{
Bill (Belal) Wang, 9058118990
EE511 Project 7: CTMC Bank Queue
%}

%{
Part 3: Simulating Bank Queue with following parameters -
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

 


