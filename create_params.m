function create_params

%set up breeding, migration and starvation threshold parameters. These
%are all completely made up!

%PARAM - structure containing values of all parameters governing agent
%behaviour for the current simulation

global PARAM

    PARAM.R_SPD=2;         %speed of movement - units per itn (moose)
    PARAM.F_SPD=5;         %speed of movement - units per itn (wolf)
    PARAM.R_BRDFQ=10;      %breeding frequency - iterations
    PARAM.F_BRDFQ=5;
    PARAM.R_MINFOOD=0;      %minimum food threshold before agent dies 
    PARAM.F_MINFOOD=0;
    PARAM.R_FOODBRD=10;     %minimum food threshold for breeding
    PARAM.F_FOODBRD=10;
    PARAM.R_MAXAGE=50;      %maximum age allowed 
    PARAM.F_MAXAGE=25;
    %% some changes here
    PARAM.F_SIZE=5;         %the define of a big wolf pack
    
    %if the number of wolves in a wolf pack is biger than  PARAM.F_SIZE, it
    %a big wolf pack; if the number is less than PARAM.F_SIZE, it is a
    %small wolf pack. big wolf pack and smail wolf pack have different
    %behavior pattern in terms of migrate and breed.
    
    