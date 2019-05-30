function val=get(c,prop_name)

%standard function to allow extraction of memory parameters from alphaWolf object

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
case 'population'
	val=c.population;
case 'range'
	val=c.range;
case 'eaten'
	val=c.eaten;
otherwise 
	error('invalid field name')
end

