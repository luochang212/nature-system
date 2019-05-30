function [agt,eaten]=eat(agt,cn)

%% !! eating function for class alphaWolf was ignored !!
%agt=alphaWolf object
%cn - current agent number
%eaten = 1 if alphaWolf successfully finds a moose, =0 otherwise

%SUMMARY OF alphaWolf EAT RULE
%alphaWolf calculates distance to all moose
%alphaWolf identifies nearest moose
%If more than one equidistant within search radius, one is randomly picked
%Probability of alphaWolf killing moose =1 - distance of moose/speed of alphaWolf
%If probability > rand, alphaWolf moves to moose location and moose is
%killed
%If alphaWolf does not kill moose, it's food is decremented by one unit

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

global  IT_STATS N_IT MESSAGES

pos=agt.pos;                        %extract current position
cfood=agt.food;                     %get current agent food level
spd=agt.speed;                      %alphaWolf migration speed in units per iteration - this is equal to the food search radius
hungry=1;
eaten=0;

typ=MESSAGES.atype;                                         %extract types of all agents
rb=find(typ==1);                                            %indices of all moose
rpos=MESSAGES.pos(rb,:);                                     %extract positions of all moose
csep=sqrt((rpos(:,1)-pos(:,1)).^2+(rpos(:,2)-pos(:,2)).^2);  %calculate distance to all moose
[d,ind]=min(csep);                                            %d is distance to closest moose, ind is index of that moose
nrst=rb(ind);                                                %index of nearest moose

if d<=spd&length(nrst)>0    %if there is at least one  moose within the search radius
    if length(nrst)>1       %if more than one moose located at same distance then randomly pick one to head towards
        s=round(rand*(length(nrst)-1))+1;
        nrst=nrst(s);
    end
    pk=1-(d/spd);                       %probability that alphaWolf will kill moose is ratio of speed to distance
    if pk>rand
        nx=MESSAGES.pos(nrst,1);    %extract exact location of this moose
        ny=MESSAGES.pos(nrst,2);
        npos=[nx ny];
        %% some changes here
        if npos(1)<ENV_DATA.bm_size&npos(2)<ENV_DATA.bm_size&npos(1)>=1&npos(2)>=1
            agt.food=cfood+1;           %increase agent food by one unit
            agt.pos=npos;               %move agent to position of this moose
            IT_STATS.eaten(N_IT+1)=IT_STATS.eaten(N_IT+1)+1;                %update model statistics
            eaten=1;
            hungry=0;
            MESSAGES.dead(nrst)=1;       %send message to moose so it knows it's dead!
        end
    end
end

%this function can only use once in per iteration
agt.food = cfood - 0.5*agt.population;

%{
if hungry==1
    agt.food=cfood-1;     %if no food, then reduce agent food by one unit
end
%}