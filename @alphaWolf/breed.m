function [agt,new]=breed(agt,cn)

%breeding function for class alphaWolf
%agt=alphaWolf object
%cn - current agent number
%new - contains new  agent object if created, otherwise empty

global PARAM IT_STATS N_IT
%N_IT is current iteration number
%IT_STATS is data structure containing statistics on model at each
%iteration (no. agents etc)
%PARAM is data structure containing migration speed and breeding
%frequency parameters for both alphaWolf, wolf and moose

   
flim=PARAM.F_FOODBRD * agt.population;       %minimum food level required for breeding
tlim=PARAM.F_BRDFQ;         %minimum interval required for breeding
cfood=agt.food;             %get current agent food level
age=agt.age;                %get current agent age
last_breed=agt.last_breed;  %length of time since agent last reproduced
pos=agt.pos;                %current position

%% some changes here
% when the number of wolf pack is small
if cfood>=flim & last_breed>=tlim & agt.population <= PARAM.F_SIZE & ceil(agt.population * 1/2)>0  %if food > threshold and age > interval, then create offspring
    for f = 1:ceil(agt.population * 1/2)
        new{f}=wolf(0,0,pos,PARAM.F_SPD,0,cn,0);   %new wolf agent
    end
    agt.food=ceil(cfood * 1/2); %reduce food level for new born
    agt.last_breed=0;
    agt.age=age+1;
    IT_STATS.div_f(N_IT+1)=IT_STATS.div_f(N_IT+1)+ceil(agt.population * 1/2);             %update statistics
% when the number of wolf pack is big
elseif  cfood>=flim & last_breed>=tlim & agt.population > PARAM.F_SIZE & ceil(agt.population * 1/4)>0  %if food > threshold and age > interval, then create offspring
        for f = 1:ceil(agt.population * 1/4)
        new{f}=wolf(0,0,pos,PARAM.F_SPD,0,cn,0);   %new wolf agent
    end
    agt.food=ceil(cfood * 3/4); %reduce food level for new born
    agt.last_breed=0;
    agt.age=age+1;
    IT_STATS.div_f(N_IT+1)=IT_STATS.div_f(N_IT+1)+ceil(agt.population * 1/4);             %update statistics
else
    agt.age=age+1;          %not able to breed, so increment age by 1
    agt.last_breed=last_breed+1;
    new=[];
end