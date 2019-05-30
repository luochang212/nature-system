classdef wolf           %declares fox object
    %%
    %pachNo - the number of the alphaWolf in cell array 'agent' which is current wolf belong to
    %migration - the value of it is "0" or "1", to find out does this wolf move
    %in this iteration
    
    %%
    properties         %define fox properties (parameters)
        age;
        food;
        pos;
        speed;
        last_breed;
        packNo;       %a new property to find the alpha wolf of this regular wolf
        migration;    %a new property to find out does this wolf move in this iteration
    end
    methods                         %note that this class definition mfile contains only the constructor method!
        %all additional member functions associated with this class are included as separate mfiles in the @fox folder.
        function f=wolf(varargin) %constructor method for fox  - assigns values to fox properties
            %f=fox(age,food,pos....)
            %
            %age of agent (usually 0)
            %food - amount of food that rabbit has eaten
            %pos - vector containg x,y, co-ords
            
            %Modified by Martin Bayley on 29/01/13
            
            switch nargin                     %Use switch statement with nargin,varargin contructs to overload constructor methods
                case 0                        %create default object
                    f.age=[];
                    f.food=[];
                    f.pos=[];
                    f.speed=[];
                    f.last_breed=[];
                    f.packNo=[];
                    f.migration=[];
                case 1                         %input is already a fox, so just return!
                    if (isa(varargin{1},'fox'))
                        f=varargin{1};
                    else
                        error('Input argument is not a fox')
                    end
                case 7                               %create a new fox (currently the only constructor method used)
                    f.age=varargin{1};               %age of fox object in number of iterations
                    f.food=varargin{2};              %current food content (arbitrary units)
                    f.pos=varargin{3};               %current position in Cartesian co-ords [x y]
                    f.speed=varargin{4};             %number of kilometres fox can migrate in 1 day
                    f.last_breed=varargin{5};        %number of iterations since fox last reproduced.
                    f.packNo=varargin{6};
                    f.migration=varargin{7};
                otherwise
                    error('Invalid no. of input arguments for fox')
            end
        end
    end
end