function [agt,klld,agent]=die(agt,cn,agent)
%% some changes here
%function [agt,klld]=die(agt,cn) -> function [agt,klld,agent]=die(agt,cn,agent)
%%
%death function for class alphaWolf
%agt=alphaWolf object
%cn - current agent number
%klld=1 if agent dies, =0 otherwise

%alphaWolfes die if their food level reaches zero or they are older than max_age

global PARAM IT_STATS N_IT MESSAGES

%N_IT is current iteration number
%IT_STATS is data structure containing statistics on model at each
%iteration (no. agents etc)
%PARAM is data structure containing migration speed and breeding
%frequency parameters for alphaWolf, wolf and moose
%MESSAGES is a data structure containing information that agents need to
%broadcast to each other
   %    MESSAGES.atype - n x 1 array listing the type of each agent in the model
   %    (1=moose, 2=wolf, 3=alphaWolf, 0=dead agent)
   %    MESSAGES.pos - list of every agent position in [x y]
   %    MESSAGE.dead - n x1 array containing ones for agents that have died
   %    in the current iteration
   
klld=0;
%% some changes here
thold=PARAM.F_MINFOOD * (agt.population + 1);      %threshold minimum food value for death to occur
cfood=agt.food;             %get current agent food level
age=agt.age;                %get current agent age

% die for food
if cfood<=thold
    if agt.population == 0
        IT_STATS.died_f(N_IT+1)=IT_STATS.died_f(N_IT+1)+1;  %update statistics
        MESSAGES.dead(cn)=1;                %update message list
        klld=1;
    else 
        for i = 1:length(agent)
            if isa(agent{i},'wolf') & agent{i}.packNo == cn
                IT_STATS.died_f(N_IT+1)=IT_STATS.died_f(N_IT+1)+1;  %update statistics
                MESSAGES.dead(i)=1;                %update message list
                break;
            end
        end
    end     
end

% die for age
% if the alphaWolf.population is not zero, a wolf will become alphaWolf
if age>PARAM.F_MAXAGE      %if food level < threshold and age > max age then agent dies
    if agt.population == 0
        IT_STATS.died_f(N_IT+1)=IT_STATS.died_f(N_IT+1)+1;  %update statistics
        MESSAGES.dead(cn)=1;                %update message list
        klld=1;
    else 
        for i = length(agent):-1:1
            if isa(agent{i},'wolf') & agent{i}.packNo == cn
                IT_STATS.died_f(N_IT+1)=IT_STATS.died_f(N_IT+1)+1;  %update statistics
                MESSAGES.dead(i)=1;                %update message list
                nage = agent{i}.age;
                agt.age = nage;
                break;
            end
        end
    end     
    %agt.population <= 0
    %IT_STATS.died_f(N_IT+1)=IT_STATS.died_f(N_IT+1)+1;  %update statistics
    %MESSAGES.dead(cn)=1;                %update message list
    %klld=1;
end

