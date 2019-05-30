function ecolab(size,nm,nw,np,nsteps,fmode,outImages)
%% new variables
%nw - initial number of regular wolf agents in each wolf pack - ecolab.m
%np - initial number of wolf packs - ecolab.m
%population - number of regular wolf agents in current wolf pa  ck - alphaWolf.m
%range - maximum distance form regular wolve to alphaWolf - alphaWolf.m

%% something new in functions
%function [agent]=create_agents(nm,nw) --> function [agent]=create_agents(nm,nw,np)
%function initialise_results(nm,nw,nsteps) --> initialise_results(nm,nw,np,nsteps)
%function [agent] = initial_iteration(agent) - this is a function added by us
%function [agent,n]=agnt_solve(agent); - we change a lots of things in here

%%
%ECO_LAB  agent-based predator-prey model, developed for
%demonstration purposes only for University of Sheffield module
%COM3001/6006/6009

%AUTHOR Dawn Walker d.c.walker@sheffield.ac.uk
%Created April 2008

%ecolab(size,nm,nw,nsteps)
%size = size of model environmnet in km (sugested value for plotting
%purposes =50)
%nm - initial number of moose agents
%nsteps - number of iterations required

%definition of global variables:
%N_IT - current iteration number
%IT_STATS  -  is data structure containing statistics on model at each
%iteration (number of agents etc). iniitialised in initialise_results.m
%ENV_DATA - data structure representing the environment (initialised in
%create_environment.m)

%clear any global variables/ close figures from previous simulations
clear global
close all
tic

global N_IT IT_STATS ENV_DATA CONTROL_DATA

if nargin == 4
    fmode=true;
    outImages=false;
elseif nargin == 5
    outImages=false;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MODEL INITIALISATION
create_control;                     %sets up the parameters to control fmode (speed up the code during experimental testing
create_params;                      %sets the parameters for this simulation
create_environment(size);           %creates environment data structure, given an environment size
random_selection(1);                %randomises random number sequence (NOT agent order). If input=0, then simulation should be identical to previous for same initial values
[agent]=create_agents(nm,nw,np);       %create nm moose and nw wolf agents and places them in a cell array called 'agents'
create_messages(agent);       %sets up the initial message lists
initialise_results(nm,nw,np,nsteps);   %initilaises structure for storing results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%MODEL EXECUTION
for n_it=1:nsteps                   %the main execution loop
    N_IT=n_it;
    [agent] = initial_iteration(agent,nw);   %a new function to initial the properties we add
    [agent,n]=agnt_solve(agent);     %the function which calls the rules
    plot_results(agent,nsteps,fmode,outImages); %updates results figures and structures
    %mov(n_it)=getframe(fig3);
    if n<=0                          %if no more agents, then stop simulation
        break
        disp('General convergence criteria satisfied - no agents left alive! > ')
    end
    if fmode == true                                       % if fastmode is used ...
        for test_l=1 : 5                                    % this checks the total number agents and adjusts the CONTROL_DATA.fmode_display_every variable accoringly to help prevent extreme slowdown
            if n > CONTROL_DATA.fmode_control(1,test_l)     % CONTROL_DATA.fmode_control contains an array of thresholds for agent numbers and associated fmode_display_every values
                CONTROL_DATA.fmode_display_every = CONTROL_DATA.fmode_control(2,test_l);
            end
        end
        if IT_STATS.tot_r(n_it) == 0             %fastmode convergence - all mooses eaten - all wolves will now die
            disp('Fast mode convergence criteria satisfied - no mooses left alive! > ')
            break
        end
        if IT_STATS.tot_f(n_it) == 0             %fastmode convergence - all wolves starved - mooses will now proliferate unchecked until all vegitation is eaten
            disp('Fast mode convergence criteria satisfied - no wolves left alive ! > ')
            break
        end
    end
end

%% some changes here
fprintf('\n')

% the initial range of wolf pack
initialRange = IT_STATS.wolfRange(1+1);
disp(strcat('The initial range of wolf pack = ',num2str(initialRange)))

%{
% count the average wolf pack range for all iteration
totalRange = 0;
for i = 1:nsteps
    totalRange = totalRange + IT_STATS.wolfRange(i+1);
end

averageRange = totalRange / nsteps;
disp(strcat('Average size of wolf pack range = ',num2str(averageRange)))
%}

% count the total number of eaten moose
totalMoose = 0;
for i = 1: nsteps
    totalMoose = totalMoose + IT_STATS.eaten(i+1);
end

averageMoose = totalMoose/nsteps;        % average of eaten moose per iteration
disp(strcat('Average number of mooses eaten per iteration = ',num2str(averageMoose)))


% There are two mode to move for alpha wolf
% one is random mode and another is positive feedback mode
% count the proportion of alpha wolf choose posotove feedback mode
totalPosMode = 0;
totalMode = 0;
for i = 1:nsteps
    totalPosMode = totalPosMode + IT_STATS.pos_mode(i+1);
    totalMode = totalMode + IT_STATS.ran_mode(i+1) + IT_STATS.pos_mode(i+1);
end

modePorportion = totalPosMode / totalMode;
disp(strcat('Proportion of choosing positive feedback mode = ',num2str(modePorportion)))


% calculate the time spent on running program
toc
disp(['Program running time = ',num2str(toc)])
%%
eval(['save results_nm_' num2str(nm) '_nw_' num2str(nw) '.mat IT_STATS ENV_DATA' ]);
clear global

%{
%Recommended input
ecolab(30 ,100, 5, 4, 60, false, false)
%}