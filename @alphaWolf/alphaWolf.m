classdef alphaWolf          %declares alphaWolf object
    %% new variables
    %population - number of regular wolf agents in current wolf pack
    %range - maximum distance for regular wolves to move away from alphaWolf
    
    %%
    properties         %define alphaWolf properties (parameters)
        age;
        food;
        pos;
        speed;
        last_breed;
        population;        %number of regular wolf agents in current wolf pack
        range;             %maximum distance form regular wolve to alphaWolf
        eaten;             %number of food be eaten in this iteration
    end
    methods                         %note that this class definition mfile contains only the constructor method!
        %all additional member functions associated with this class are included as separate mfiles in the @alphaWolf folder.
        
        function a=alphaWolf(varargin) %constructor method for alphaWolf  - assigns values to alphaWolf properties
            %a=alphaWolf(age,food,pos....)
            %
            %age of agent (usually 0)
            %food - amount of food that rabbit has eaten
            %pos - vector containg x,y, co-ords
            
            switch nargin                     %Use switch statement with nargin,varargin contructs to overload constructor methods
                case 0                        %create default object
                    a.age=[];
                    a.food=[];
                    a.pos=[];
                    a.speed=[];
                    a.last_breed=[];
                    a.population=[];
                    a.range=[];
                    a.eaten=[];
                case 1                         %input is already an alphaWolf, so just return!
                    if (isa(varargin{1},'alphaWolf'))
                        a=varargin{1};
                    else
                        error('Input argument is not a alphaWolf')
                    end
                case 8                          %create a new alphaWolf (currently the only constructor method used)
                    a.age=varargin{1};               %age of alphaWolf object in number of iterations
                    a.food=varargin{2};              %current food content (arbitrary units)
                    a.pos=varargin{3};               %current position in Cartesian co-ords [x y]
                    a.speed=varargin{4};             %number of kilometres alphaWolf can migrate in 1 day
                    a.last_breed=varargin{5};        %number of iterations since alphaWolf last reproduced.
                    a.population=varargin{6};
                    a.range=varargin{7};
                    a.eaten=varargin{8};
                otherwise
                    error('Invalid no. of input arguments for alphaWolf')
            end
        end
    end
end