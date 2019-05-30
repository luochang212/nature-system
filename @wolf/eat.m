function [agt,agent]=eat(agt,cn,agent)
%% Changes in this file
%function [agt,eaten]=eat(agt,cn) -> function [agt,eaten]=eat(agt,cn,agent)
%cfood
%can't go out the circle

%%
%eating function for class wolf
%agt=wolf object
%cn - current agent number
%eaten = 1 if wolf successfully finds a moose, =0 otherwise

%SUMMARY OF wolf EAT RULE
%Wolf calculates distance to all mooses
%Wolf identifies nearest mooses(s)
%If more than one equidistant within search radius, one is randomly picked
%Probability of wolf killing moose =1 - distance of moose/speed of wolf
%If probability > rand, wolf moves to moose location and moose is
%killed
%If wolf does not kill moose, it's food is decremented by one unit

%GLOBAL VARIABLES
%N_IT is current iteration number
%IT_STATS is data structure containing statistics on model at each
%iteration (no. agents etc)
%MESSAGES is a data structure containing information that agents need to
%broadcast to each other
%    MESSAGES.atype - n x 1 array listing the type of each agent in the model
%    (1=moose, 2=wolf, 3=alphaWolf, 0=dead agent)
%    MESSAGES.pos - list of every agent position in [x y]
%    MESSAGE.dead - n x1 array containing ones for agents that have died
%    in the current iteration


%Modified by D Walker 3/4/08

global  IT_STATS N_IT MESSAGES ENV_DATA

pos=agt.pos;                        %extract current position
%% some changes here
%cfood=agt.food;                     %get current agent food level
%cfood = get(agent{get(agt,'packNo')},'food');
cfood = agent{agt.packNo}.food;
spd=agt.speed;                      %wolf migration speed in units per iteration - this is equal to the food search radius
hungry=1;
eaten=0;

typ=MESSAGES.atype;                                         %extract types of all agents
rb=find(typ==1);                                            %indices of all mooses
rpos=MESSAGES.pos(rb,:);                                     %extract positions of all mooses
csep=sqrt((rpos(:,1)-pos(:,1)).^2+(rpos(:,2)-pos(:,2)).^2);  %calculate distance to all mooses
[d,ind]=min(csep);                                            %d is distance to closest moose, ind is index of that moose
nrst=rb(ind);                                                %index of nearest moose(s)
nrst_old = nrst;

%% some changes here
if length(nrst)>1       %if more than one moose located at same distance then randomly pick one to head towards
    s=round(rand*(length(nrst)-1))+1;
    nrst=nrst(s);
end

posit = get(agent{get(agt,'packNo')},'pos');     % The location of alphaWolf
dist = sqrt((MESSAGES.pos(nrst,1)-posit(1)).^2+(MESSAGES.pos(nrst,2)-posit(2)).^2);  %the distance form moose to alphaWolf

if d<=spd & length(nrst_old)>0 & dist<=get(agent{get(agt,'packNo')},'range')      %if there is at least one  moose within the search radius
    pk=1-(d/spd);                       %probability that wolf will kill moose is ratio of speed to distance
    if pk>rand
        nx=MESSAGES.pos(nrst,1);    %extract exact location of this moose
        ny=MESSAGES.pos(nrst,2);
        npos=[nx ny];
        %% some changes here
        % Check the new position is legal or not
        if npos(1)<ENV_DATA.bm_size&npos(2)<ENV_DATA.bm_size&npos(1)>=1&npos(2)>=1
            %agt.food=cfood+1;           %increase agent food by one unit
            agent{agt.packNo}.food=cfood+1;
            agt.pos=npos;               %move agent to position of this moose
            IT_STATS.eaten(N_IT+1)=IT_STATS.eaten(N_IT+1)+1;                %update model statistics
            eaten=1;
            hungry=0;
            MESSAGES.dead(nrst)=1;       %send message to moose so it knows it's dead!
        end
    end
end

%% some changes here
% calculate the number of moose be eaten by this wolfpack in this iteration
prevEaten=agent{agt.packNo}.eaten;
if eaten==1
    agent{agt.packNo}.eaten = prevEaten+1;
end

% if wolf eat moose, then it migrate in this iteration, it can't move again
if eaten==1
    agt.migration = 1;
end

% the alphawolf represent the wolf pack, so if a wolf eat some thing, the
% alphawolf.food will plus 1
if hungry==1
    agent{agt.packNo}.food = cfood-1;     %if no food, then reduce agent food by one unit
end

