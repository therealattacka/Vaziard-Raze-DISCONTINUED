///scr_place_ground_block(X,Y)

if !collision_rectangle(argument0,argument1,argument0+90,argument1+90,obj_solid_ground,false,false)
{
instance_create(argument0,argument1,obj_solid_ground);
return true;
}

return false;