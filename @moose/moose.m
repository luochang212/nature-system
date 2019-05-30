classdef moose   %declares moose object
    properties    %define moose properties (parameters) 
        age; 
        food;
        pos;
        speed;
        last_breed;
    end
    methods                         %note that this class definition mfile contains only the constructor method!
                                    %all additional member functions associated with this class are included as separate mfiles in the @moose folder. 
        function m=moose(varargin) %constructor method for moose - assigns values to moose properties
                %m=moose(age,food,pos....)
                %
                %age of agent (usually 0)
                %food - amount of food that moose has eaten
                %pos - vector containg x,y, co-ords 

                switch nargin           %Use switch statement with nargin,varargin contructs to overload constructor methods
                    case 0				%create default object
                       m.age=[];			
                       m.food=[];
                       m.pos=[];
                       m.speed=[];
                       m.last_breed=[];
                    case 1              %input is already a moose, so just return!
                       if (isa(varargin{1},'moose'))		
                            m=varargin{1};
                       else
                            error('Input argument is not a moose')
                            
                       end
                    case 5               %create a new moose (currently the only constructor method used)
                       m.age=varargin{1};               %age of moose object in number of iterations
                       m.food=varargin{2};              %current food content (arbitrary units)
                       m.pos=varargin{3};               %current position in Cartesian co-ords [x y]
                       m.speed=varargin{4};             %number of kilometres moose can migrate in 1 day
                       m.last_breed=varargin{5};        %number of iterations since moose last reproduced.
                    otherwise
                       error('Invalid no. of input arguments')
                end
        end
    end
end
