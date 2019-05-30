function c=set(c,prop_name,val)

%standard function to allow insertion of memory parameters from alphaWolf object

switch prop_name
   
case 'food'
	c.food=val;
case 'pos'
    c.pos=val; 
case 'age'
	c.age=val;
case 'speed'
	c.speed=val; 
case 'last_breed'
	c.last_breed=val;
case 'population'
    c.population=val;
case 'range'
    c.range=val;
case 'eaten'
    c.eaten=val;
otherwise 
	error('invalid field name')
end

