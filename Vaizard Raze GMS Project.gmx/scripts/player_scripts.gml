#define player_scripts
//Online stuff
playerid=-1;//No ID
client_ip="127.0.0.1"; //UDP IP adress
client_port=global.udpport_client;   //UDP Port number
client=-1; //No client
playername="Error?";
myroom=room_loading;

//Create Company objects
instance_create(x,y,obj_camera);

//Reset the player movement variables
scr_reset_player_input();
scr_reset_player_vars();

//Maximum speed of any vspeed/hspeed/speed things
max_speed=50;
max_fallspeed=20;
facedir=1;

//Gravitational things
max_gravity=1;
gravity_mod=0;     //Set to positive or negative to increase/decrease to fall faster/slower
jumpspeed=20;
jumpspeed_mod=0;   //Set to positive or negative to increase/decrease jump height/power
walljumpspeed=14;
walljumpupspeed=14;

//Movement speed things
movespeed=0;
movespeed_mod=0;   //Set to positive or negative to increase/decrease movement speed
max_movespeed=6;
movescanheight=20; //The height it scans up/down when checking for slope movement
movescanintervall=2; // Height checking per step (how precise the checking is)


stuck=false;         //If you are stuck




alarm[0]=30;




color_legs=c_blue;
color_torso=c_red;
color_eyes=c_green;

#define scr_player_move
//First of all, retrieve packets from all other players
if (object_index==obj_otherplayer && global.host==true)
   {
   scr_recive_message();
   }
//Reset that shit
scr_player_physics();  


//If this is the player it needs to accept the input
if (object_index==obj_player)
   {
   scr_reset_player_input();
   scr_player_inputcontroller();
   
   scr_player_moveupdateonline();
   
   stuck=false;//Stop being stuck
   }

//
scr_player_movespeed();
scr_entity_movement(movespeed,facedir,movescanheight,movescanintervall);
scr_entity_jump(press_jump,do_jump,do_walljump_right,do_walljump_left,jumpspeed,walljumpspeed,walljumpupspeed,jumpspeed_mod);


if stuck==true {scr_entity_freeze();}
 

scr_reset_player_vars(); //Reset vars that should be reset

#define scr_player_inputcontroller
//Basic movement
if keyboard_check(global.keybind[KEY_RIGHT])    press_right=true;
if keyboard_check(global.keybind[KEY_LEFT])     press_left=true;
if keyboard_check(global.keybind[KEY_UP])       press_up=true;
if keyboard_check(global.keybind[KEY_DOWN])     press_down=true;


if place_meeting(x,y+4,obj_solidparent)
{
do_walljump_right=false;
do_walljump_left=false;
}



if keyboard_check(global.keybind[KEY_JUMP])
   {
   press_jump=true;
   }

//Jumping
if keyboard_check_pressed(global.keybind[KEY_JUMP]) 
   {
   
   if place_meeting(x,y+4,obj_solidparent) && !place_meeting(x,y-(jumpspeed+jumpspeed_mod),obj_solidparent)
      {
      do_jump=true;
      }
   else if place_meeting(x-max_movespeed,y,obj_solidparent) && !place_meeting(x,y-(walljumpupspeed+(jumpspeed_mod/2)),obj_solidparent) //Walljump to the right
      {
      do_walljump_right=true;
      }
   else if place_meeting(x+max_movespeed,y,obj_solidparent) && !place_meeting(x,y-(walljumpupspeed+(jumpspeed_mod/2)),obj_solidparent)  // Walljump to the left
      {
      do_walljump_left=true;
      }
   }
   

   
   
   
   


#define scr_reset_player_input
press_right=false;
press_left=false;
press_up=false;
press_down=false;


press_jump=false;


do_sidedash_right=false;
do_sidedash_left=false;






#define scr_player_movespeed
//If you are pressing left/right at the same time
if (press_right==true && press_left==true) movespeed=0;

else if (hspeed!=0) movespeed=2;  //Cant move quick while moving this way

else if (do_sidedash_right==true || do_sidedash_left==true) movespeed=0; //Cant move at all while dashing



//You can move just fine otherwise
else if press_right==true 
     {
     movespeed = (max_movespeed+movespeed_mod);
     facedir=1;
     }
else if press_left==true 
     {
     movespeed = (max_movespeed+movespeed_mod);
     facedir=-1;
     }
else movespeed=0;
     

#define scr_player_physics
//Clamping speed before the gravity calculation
if vspeed>max_fallspeed vspeed=max_fallspeed;
if vspeed<-max_speed vspeed=-max_speed;
if hspeed>max_speed hspeed=max_speed;
if hspeed<-max_speed hspeed=-max_speed;


if place_meeting(x,y+4,obj_solidparent)
   {
   gravity=0;
   vspeed=0;
   hspeed=0;
   }
else if place_meeting(x,y+real(vspeed),obj_solidparent) {gravity=0}
else gravity = max_gravity+gravity_mod;



if place_meeting(x,y,obj_solidparent)
{
if !place_meeting(x+4,y,obj_solidparent) x+=1;
if !place_meeting(x-4,y,obj_solidparent) x-=1;

if !place_meeting(x,y+4,obj_solidparent) y+=1;
if !place_meeting(x,y-4,obj_solidparent) y-=1;
}

#define scr_player_collision
move_contact_solid(direction,16);
vspeed=0;
hspeed=0;
gravity=0;

x=round(x);
y=round(y);

#define scr_reset_player_vars
press_ability1=false;
press_ability2=false;
press_ability3=false;

press_special=false;
do_jump=false;
do_walljump_right=false;
do_walljump_left=false;
#define scr_player_moveupdateonline



   //If you press any of the keys you need to send this update to the other players
   if keyboard_check_pressed(global.keybind[KEY_RIGHT])
   or keyboard_check_pressed(global.keybind[KEY_LEFT])
   or keyboard_check_pressed(global.keybind[KEY_UP])
   or keyboard_check_pressed(global.keybind[KEY_DOWN])
   or keyboard_check_pressed(global.keybind[KEY_JUMP])
   or keyboard_check_pressed(global.keybind[KEY_SPECIAL])
   or keyboard_check_released(global.keybind[KEY_RIGHT])
   or keyboard_check_released(global.keybind[KEY_LEFT])
   or keyboard_check_released(global.keybind[KEY_UP])
   or keyboard_check_released(global.keybind[KEY_DOWN])
   or keyboard_check_released(global.keybind[KEY_JUMP])
   or keyboard_check_released(global.keybind[KEY_SPECIAL])
   {
   //Send the movement update NOW
   msg_send_move();
   alarm[0]=1; 
   }