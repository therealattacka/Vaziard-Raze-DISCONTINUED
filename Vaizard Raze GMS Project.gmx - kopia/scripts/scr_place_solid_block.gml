///scr_place_solid_block(X,Y)

if !collision_rectangle(argument0,argument1,argument0+90,argument1+90,obj_solid_block,false,false)
{
instance_create(argument0,argument1,obj_solid_block);
return true;
}

return false;