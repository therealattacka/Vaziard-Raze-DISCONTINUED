player_health=10000;
player_mana=10000;
player_stamina=10000;


//Reset state of max health/mana/stamina aswell as regen.
scr_player_reset_tempstats();


//Team is part of the health system, along with hitboxes
if object_index=obj_player team=TEAM_PLAYER;
else team=TEAM_ALLY;
