function val=get(c,prop_name)

%standard function to allow extraction of memory parameters from fox object

switch prop_name
   
case 'age'
	val=c.age;
case 'food'
	val=c.food;
case 'pos'
	val=c.pos;
case 'speed'
	val=c.speed;
case 'last_breed'
	val=c.last_breed;
case 'packNo'
	val=c.packNo;  
otherwise 
    error('invalid field name')
end

