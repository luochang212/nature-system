function initialise_results(nr,nf,np,nsteps)
%% some changes in this file
%The number of all agents in the beginning: nr+(nf+1)*np
%The number of all kinds of wolves in the beginning: (nf+1)*np
%a new array "wolfRange" means the size of wolf pack range at each iteration

%%
global  IT_STATS ENV_DATA

%set up data structure to record statistics for each model iteration
%IT_STATS  -  is data structure containing statistics on model at each
%ENV_DATA - data structure representing the environment

IT_STATS=struct('div_r',[zeros(1,nsteps+1);],...            %no. births per iteration
    'div_f',[zeros(1,nsteps+1)],...
    'died_r',[zeros(1,nsteps+1)],...			%no. agents dying per iteration
    'died_f',[zeros(1,nsteps+1)],...
    'eaten',[zeros(1,nsteps+1)],...              %no. mooses eaten per iteration
    'mig',[zeros(1,nsteps+1)],...                %no. agents migrating per iteration
    'tot',[zeros(1,nsteps+1)],...				 %total no. agents in model per iteration
    'tot_r',[zeros(1,nsteps+1)],...              %total no. mooses
    'tot_f',[zeros(1,nsteps+1)],...              %total no. wolves
    'tfood',[zeros(1,nsteps+1)],...              %remaining vegetation level
    'ran_mode',[zeros(1,nsteps+1)],...           %no. choose random mode in each iteration
    'pos_mode',[zeros(1,nsteps+1)],...           %no. choose positive feedback mode in each iteration
    'wolfRange',[zeros(1,nsteps+1)]);            %Average size of wolf pack range in each iteration


%% some changes here
tf=sum(sum(ENV_DATA.food));            %remaining food is summed over all squares in the environment
IT_STATS.tot(1)=nr+(nf+1)*np;
IT_STATS.tot_r(1)=nr;
IT_STATS.tot_f(1)=(nf+1)*np;
IT_STATS.tfood(1)=tf;
