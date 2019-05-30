function [agt,agent_migrate]=migrate(agt,cn,agent,eaten)
%% Changes in this file
%[agt]=migrate(agt,cn) -> [agt,agent_migrate]=migrate(agt,cn,agent)

%%
%migration functions for class alphaWolf
%agt=alphaWolf object
%cn - current agent number

%SUMMARY OF alphaWolf MIGRATE RULE
%If a alphaWolf has not eaten, it will pick a random migration direction
%If it will leave the edge of the model, the direction is incremented by 45
%degrees at it will try again (up to 8 times)

global IT_STATS N_IT ENV_DATA

%N_IT is current iteration number
%IT_STATS is data structure containing statistics on model at each
%iteration (no. agents etc)
%ENV_DATA is a data structure containing information about the model
%environment
%    ENV_DATA.shape - shape of environment - FIXED AS SQUARE
%    ENV_DATA.units - FIXED AS KM
%    ENV_DATA.bm_size - length of environment edge in km
%    ENV_DATA.food is  a bm_size x bm_size array containing distribution
%    of food


spd=agt.speed;   %alphaWolf migration speed in units per iteration - this is equal to the food search radius
pos=agt.pos;     %extract current position

if eaten == 0
    mig=0;
    cnt=1;
    dir=rand*2*pi;              %alphaWolf has been unable to find food, so chooses a random direction to move in
    while mig==0&cnt<=8        %alphaWolf has up to 8 attempts to migrate (without leaving the edge of the model)
        npos(1)=pos(1)+spd*cos(dir);        %new x co-ordinate
        npos(2)=pos(2)+spd*sin(dir);        %new y co-ordinate
        if npos(1)<ENV_DATA.bm_size&npos(2)<ENV_DATA.bm_size&npos(1)>=1&npos(2)>=1   %check that alphaWolf has not left edge of model - correct if so.
            mig=1;
        end
        cnt=cnt+1;
        dir=dir+(pi/4);         %if migration not successful, then increment direction by 45 degrees and try again
    end
    
    if mig==1
        agt.pos=npos;                    %update agent memory
        IT_STATS.mig(N_IT+1)=IT_STATS.mig(N_IT+1)+1;    %update model statistics
        IT_STATS.ran_mode(N_IT+1)=IT_STATS.mig(N_IT+1)+1;    %update model statistics
    end
else
    % positive feedback
    % if wolf pack eat some moose in this iteration
    % and it still want to migrate
    % alphaWolf will move to the position of one of its wolf
    % which eat a moose in this iteration
    for x = 1:length(agent)
        currAgent = agent{x};
        if isa(currAgent,'wolf') & currAgent.packNo == cn
            if currAgent.migration == 1
                npos = currAgent.pos;
            end
        end
    end
    
    % check
    if npos(1)<ENV_DATA.bm_size & npos(2)<ENV_DATA.bm_size & npos(1)>=1 & npos(2)>=1   %check that alphaWolf has not left edge of model - correct if so.
        mig=1;
    end
    
    if mig==1
        agt.pos=npos;                    %update agent memory
        IT_STATS.mig(N_IT+1)=IT_STATS.mig(N_IT+1)+1;    %update model statistics
    end
    IT_STATS.pos_mode(N_IT+1)=IT_STATS.mig(N_IT+1)+1;    %update model statistics
end
%% some changes here
%update the agent{}
agent{cn} = agt;

% The whole wolf pack will move with alphawolf
% find out all wolves belong to current wolf pack and change their position
for an = 1:length(agent)
    curr = agent{an};
    if isa(curr,'wolf') & agent{an}.packNo == cn
        [curr] = migrate(agent{an},an,agent);
        agent{an}=curr;    %up date cell array with modified agent data structure
    end
end

agent_migrate = agent;