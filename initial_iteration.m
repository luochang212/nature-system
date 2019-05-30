function [agent] = initial_iteration(agent,nf)
% This a new function to initial the property at the beginning of each iteration
global MESSAGES PARAM

%% initial alphaWolf.eaten at the beginning of each iteration
%eaten is the number of moose be eaten at each iteration, this
%number will be useful to decision making process of migrate.
for p = 1:length(agent)
    if isa(agent{p},'alphaWolf')
        agent{p}.eaten = 0;
    end
end

%% initial wolf.migration at the beginning of each iteration
%wolf.migration
for q = 1:length(agent)
    if isa(agent{q},'wolf')
        agent{q}.migration = 0;
    end
end

%% update the alphaWolf.population of wolf pack for each iteration
for m = 1:length(agent)
    currAgent = agent{m};
    if isa(currAgent,'alphaWolf')
        count = 0;
        for n = 1:length(agent)
            if isa(agent{n},'wolf') & agent{n}.packNo == m & MESSAGES.atype(n) ~= 0
                count = count + 1;
            end
        end
        currAgent.population = count;
        agent{m} = currAgent;
    end
end


%% updatet alphaWolf.range at the beginning of each iteration
for m = 1:length(agent)
    currAgent = agent{m};
    if isa(currAgent,'alphaWolf')
        if currAgent.population <= PARAM.F_SIZE
            nrange = ceil(PARAM.F_SPD/2 * (1 + nf/5));
        else
            nrange = PARAM.F_SPD;
        end
        currAgent.range = nrange;
        agent{m} = currAgent;
    end
end