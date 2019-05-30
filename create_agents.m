function [agent]=create_agents(nr,nf,np)
%% There are many changes in this file because of the change of meaning of 'nf' and the new variable 'np'
%PS: I use some codes come from migrate.m in @wolf
%agent{x}
%   x=1:nr - moose
%   x=nr+1:nr+np - alphaWolf
%   x=nr+np+1:nr+np+np*nf - regular wolf
%rloc - the initial position of moose
%aloc - the initial position of alphaWolf
%floc - the initial position of regular Wolf

%%

%creates the objects representing each agent

%agent - cell array containing list of objects representing agents
%nr - number of mooses
%nf - number of wolfes

%global parameters
%ENV_DATA - data structure representing the environment (initialised in
%create_environment.m)
%MESSAGES is a data structure containing information that agents need to
%broadcast to each other
%PARAM - structure containing values of all parameters governing agent
%behaviour for the current simulation

global ENV_DATA MESSAGES PARAM

bm_size=ENV_DATA.bm_size;
rloc=(bm_size-1)*rand(nr,2)+1;      %generate random initial positions for mooses
%% some changes here
%generate random initial positions for alphaWolf
aloc=(bm_size-1)*rand(np,2)+1;

%initial range
if nf<=5
    range = ceil(PARAM.F_SPD/2 * (1 + nf/5));
else
    range = PARAM.F_SPD;
end

%generate random initial positions for regular Wolves
for i=1:np
    for j=1:nf
        f=(i-1)*nf+j;
        mig=0;
        cnt=1;
        dir=rand*2*pi;              %fox has been unable to find food, so chooses a random direction to move in
        dist=rand*range;
        while mig==0&cnt<=8        %fox has up to 8 attempts to migrate (without leaving the edge of the model)
            npos(1)=aloc(i,1)+dist*cos(dir);        %new x co-ordinate
            npos(2)=aloc(i,2)+dist*sin(dir);        %new y co-ordinate
            if npos(1)<ENV_DATA.bm_size&npos(2)<ENV_DATA.bm_size&npos(1)>=1&npos(2)>=1   %check that fox has not left edge of model - correct if so.
                mig=1;
            end
            cnt=cnt+1;
            dir=dir+(pi/4);         %if migration not successful, then increment direction by 45 degrees and try again
        end
        floc(f,:)=npos;
    end
end

MESSAGES.pos=[rloc;aloc;floc];

%%
%generate all moose agents and record their positions in ENV_MAT_R
for r=1:nr
    pos=rloc(r,:);
    %create moose agents with random ages between 0 and 10 days and random
    %food levels 20-40
    age=ceil(rand*10);
    food=ceil(rand*20)+20;
    lbreed=round(rand*PARAM.R_BRDFQ);
    agent{r}=moose(age,food,pos,PARAM.R_SPD,lbreed);
end

%% some changes here
%generate all alpha wolf agents and record their positions in ENV_MAT_F
for a=nr+1:nr+np
    pos=aloc(a-nr,:);
    %create wolf agents with random ages between 0 and 10 days and random
    %food levels 20-40
    age=ceil(rand*10);
    food=ceil(rand*20)+20;
    lbreed=round(rand*PARAM.F_BRDFQ);
    population=nf;
    %initial the property "range" of alphaWolf here
    if population<=10
        range = PARAM.F_SPD + ceil((PARAM.F_SPD/10)*population);
    else
        range = PARAM.F_SPD * 2;
    end
    eaten=0;
    agent{a}=alphaWolf(age,food,pos,PARAM.F_SPD,lbreed,population,range,eaten);
end
%% some changes here
%generate all wolf agents and record their positions in ENV_MAT_F
for i=1:np
    for j=1:nf
        f=nr+np+(i-1)*nf+j;
        pos=floc(f-nr-np,:);
        %create wolf agents with random ages between 0 and 10 days and random
        %food levels 20-40
        age=ceil(rand*10);
        food=ceil(rand*20)+20;
        lbreed=round(rand*PARAM.F_BRDFQ);
        packNo=nr+i;
        migration = 0;
        agent{f}=wolf(age,food,pos,PARAM.F_SPD,lbreed,packNo,migration);
    end
end

%% some changes here
% initial the total food of each wolf pack
for m = 1:length(agent)
    currAgent = agent{m};
    if isa(currAgent,'alphaWolf')
        nfood = 0;
        for n = 1:length(agent)
            if isa(agent{n},'wolf') & agent{n}.packNo == m
                nfood = nfood + agent{n}.food;
            end
        end
        currAgent.food = currAgent.food + nfood;
        agent{m} = currAgent;
    end
end