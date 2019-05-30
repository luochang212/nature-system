function [nagent,nn]=agnt_solve(agent)
%% many chnages in this file
% I rewrite the four rules in this file

%%
%sequence of functions called to apply agent rules to current agent population.
%%%%%%%%%%%%
%[nagent,nn]=agnt_solve(agent)
%%%%%%%%%%%
%agent - list of existing agent structures
%nagent - list of updated agent structures
%nn - total number of live agents at end of update

%Created by Dawn Walker 3/4/08


n=length(agent);    %current no. of agents
n_new=0;    %no. new agents
prev_n=n;   %remember current agent number at the start of this iteration

%execute existing agent update loop
%% some changes here
global MESSAGES PARAM IT_STATS N_IT

%cn=1:n -> cn=n:-1:1
for cn=n:-1:1
    curr=agent{cn};
    if isa(curr,'moose')|isa(curr,'wolf')|isa(curr,'alphaWolf')
        %% eat rules
        %moose
        if isa(curr,'moose')
            [curr,moose_eaten]=eat(curr,cn);
        end
        %wolf
        if isa(curr,'wolf')        %alphaWolf can't chase prey
            [curr,agent]=eat(curr,cn,agent);               %eating rules (mooses eat food, wolves eat mooses)
        end
        if isa(curr,'alphaWolf')
            eaten=curr.eaten;
        end
        
        %% migrate rule
        %if population is large, wolf pack will be active
        flag = 0;
        if isa(curr,'alphaWolf') & curr.population > PARAM.F_SIZE & eaten < ceil(curr.population * 1/2)
            [curr,agent_migrate]=migrate(curr,cn,agent,eaten);              %if no food was eaten, then migrate in search of some
            agent = agent_migrate;                      %up date cell array with modified agent data structure
            flag =1;
            %if population is small, wolf pack won't move so frequently
        elseif isa(curr,'alphaWolf') & curr.population <= PARAM.F_SIZE & eaten < ceil(curr.population * 1/4)
            [curr,agent_migrate]=migrate(curr,cn,agent,eaten);              %if no food was eaten, then migrate in search of some
            agent = agent_migrate;                      %up date cell array with modified agent data structure
            flag =1;
        elseif isa(curr,'moose') & moose_eaten==0
            curr=migrate(curr,cn);
        end
        %if the alphawolf didn't migrate,flag is 0
        %in this case,wolf should move randomly to find the food
        if isa(curr,'alphaWolf') & flag == 0
            for p = 1:length(agent)
                if isa(agent{p},'wolf') & agent{p}.packNo == cn & MESSAGES.atype(p) ~= 0 & agent{p}.migration == 0
                    [agent{p}] = migrate(agent{p},p,agent);
                end
            end
        end
        
        %% death rule
        %wolf (from old age)
        %moose (from starvation or old age)
        if isa(curr,'moose')|isa(curr,'wolf')
            [curr,klld]=die(curr,cn);
        end
        
        %alphaWolf (from old age) and wolf pack (from starvation)
        %PS: alphaWolf represent for the whole wolf pack here
        if isa(curr,'alphaWolf')
            [curr,klld,agent]=die(curr,cn,agent);
        end
        
        %% breed rule
        %moose
        if isa(curr,'moose')&klld==0
            new=[];
            [curr,new]=breed(curr,cn);			%breeding rule
            if ~isempty(new)					%if current agent has bred during this iteration
                n_new=n_new+1;                 %increase new agent number
                agent{n+n_new}=new;			%add new to end of agent list
            end
        end
        
        %alphaWolf
        %only alphaWolf can breed, wolf can't
        if isa(curr,'alphaWolf')&klld==0
            new=[];
            [curr,new]=breed(curr,cn);			%breeding rule
            if ~isempty(new)					%if current agent has bred during this iteration
                for ite = 1:length(new)
                    n_new=n_new+1;                 %increase new agent number
                    agent{n+n_new}=new{ite};			%add new to end of agent list
                end
            end
        end
        agent{cn}=curr;                          %up date cell array with modified agent data structure
    end
end

%% calculate the average wolf pack range at the end of this iteration
%tRange is the sum of range of all wolf packs
%count is the number of wolf packs
tRange = 0;
conut = 0;
for i = 1:length(agent)
    currAgent = agent{i};
    if isa(currAgent,'alphaWolf')
        tRange = tRange + currAgent.range;
        conut = conut + 1;
    end
end

%the average of wolf pack range in this iteration
IT_STATS.wolfRange(N_IT+1)= tRange / conut;  %update statistics

%%

temp_n=n+n_new; %new agent number (before accounting for agent deaths)
[nagent,nn]=update_messages(agent,prev_n,temp_n);   %function which update message list and 'kills off' dead agents.

