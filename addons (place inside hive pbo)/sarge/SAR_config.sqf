// =========================================================================================================
//  SAR_AI - DayZ AI library
//  Version: 1.5.2 
//  Author: Sarge (sarge@krumeich.ch) 
//
//		Wiki: to come
//		Forum: http://opendayz.net/#sarge-ai.131
//		
// ---------------------------------------------------------------------------------------------------------
//  Required:
//  UPSMon  (special version, the standard one will NOT work
//  SHK_pos 
//  
// ---------------------------------------------------------------------------------------------------------
// SAR_config.sqf - User adjustable config values
// last modified: 28.5.2013  
// ---------------------------------------------------------------------------------------------------------

SAR_HC = false;
SAR_respawn_waittime = round(random 300);
SAR_dynamic_spawning = true;
SAR_dynamic_group_respawn = true;
SAR_DESPAWN_TIMEOUT = 120; // 2 minutes
SAR_DELETE_TIMEOUT = 900; // 2 minutes
SAR_AI_STEAL_VEHICLE = false;
SAR_AI_disable_UPSMON_AI = false;

SAR_DEBUG = false;
SAR_KILL_MSG = true;
SAR_log_AI_kills = true;
SAR_HITKILL_DEBUG = false;
SAR_EXTREME_DEBUG = false;

SAR_surv_kill_value = 250;
SAR_band_kill_value = 50;
SAR_HUMANITY_HOSTILE_LIMIT = -2500;
SAR_REAMMO_INTERVAL = 30;
SAR_DETECT_INTERVAL = 15;
SAR_DETECT_HOSTILE = 200;
SAR_DETECT_FROM_VEHICLE_INTERVAL = 5;
SAR_DETECT_HOSTILE_FROM_VEHICLE = 500;
SAR_heli_shield = false;

SAR_max_grps_bandits = 2;
SAR_max_grps_soldiers = 1;
SAR_max_grps_survivors = 1;

SAR_chance_bandits = 75;
SAR_chance_soldiers = 30;
SAR_chance_survivors = 50;

SAR_max_grpsize_bandits = round(random 3);
SAR_max_grpsize_soldiers = round(random 3);
SAR_max_grpsize_survivors = round(random 3);

SAR_leader_health_factor = 1; // values: 0.1 - 1, 1 = no change, 0.5 = damage taken reduced by 50%, 0.1 = damage taken reduced by 90% -  EXPERIMENTAL

SAR_AI_XP_SYSTEM = true;
SAR_SHOW_XP_LVL = false;

// xp needed to reach this level
SAR_AI_XP_LVL_1 = 0;
SAR_AI_XP_NAME_1 = "Rookie";
SAR_AI_XP_ARMOR_1 = 1; // values: 0.1 - 1, 1 = no change, 0.5 = damage taken reduced by 50%, 0.1 = damage taken reduced by 90%

// xp needed to reach this level
SAR_AI_XP_LVL_2 = 5;
SAR_AI_XP_NAME_2 = "Veteran";
SAR_AI_XP_ARMOR_2 = 0.5; // values: 0.1 - 1, 1 = no change, 0.5 = damage taken reduced by 50%, 0.1 = damage taken reduced by 90% 

// xp needed to reach this level
SAR_AI_XP_LVL_3 = 20;
SAR_AI_XP_NAME_3 = "Legendary";
SAR_AI_XP_ARMOR_3 = 0.3; // values: 0 - 1, 1 = no change, 0.5 = damage taken reduced by 50%, 0.1 = damage taken reduced by 90% 

SAR_leader_sold_list = ["Rocket_DZ"]; // the potential classes of the leader of a soldier group
SAR_sniper_sold_list = ["Sniper1_DZ"]; // the potential classes of the snipers of a soldier group
SAR_soldier_sold_list = ["Soldier1_DZ","Camo1_DZ"]; // the potential classes of the riflemen of a soldier group

SAR_leader_band_list = ["Bandit1_DZ","BanditW1_DZ"]; // the potential classes of the leader of a bandit group
SAR_sniper_band_list = ["Bandit1_DZ","BanditW1_DZ"]; // the potential classes of the snipers of a bandit group
SAR_soldier_band_list = ["Bandit1_DZ","BanditW1_DZ"]; // the potential classes of the riflemen of a bandit group

SAR_leader_surv_list = ["Survivor3_DZ"]; // the potential classes of the leaders of a survivor group
SAR_sniper_surv_list = ["Sniper1_DZ"]; // the potential classes of the snipers of a survivor group
SAR_soldier_surv_list = ["Survivor2_DZ","SurvivorW2_DZ","Soldier_Crew_PMC"]; // the potential classes of the riflemen of a survivor group

SAR_leader_sold_skills = [
    ["aimingAccuracy",0.35, 0], // skilltype, <min value>, <random value added to min>;
    ["aimingShake",   0.35, 0],
    ["aimingSpeed",   0.80, 0],
    ["spotDistance",  0.70, 0],
    ["spotTime",      0.65, 0],
    ["endurance",     0.80, 0],
    ["courage",       0.80, 0],
    ["reloadSpeed",   0.80, 0],
    ["commanding",    0.80, 0],
    ["general",       0.80, 0]
];
SAR_soldier_sold_skills  = [
    ["aimingAccuracy",0.25, 0], // skilltype, <min value>, <random value added to min>;
    ["aimingShake",   0.25, 0],
    ["aimingSpeed",   0.70, 0],
    ["spotDistance",  0.55, 0],
    ["spotTime",      0.30, 0],
    ["endurance",     0.60, 0],
    ["courage",       0.60, 0],
    ["reloadSpeed",   0.60, 0],
    ["commanding",    0.60, 0],
    ["general",       0.60, 0]
];
SAR_sniper_sold_skills = [
    ["aimingAccuracy",0.80, 0], // skilltype, <min value>, <random value added to min>;
    ["aimingShake",   0.90, 0],
    ["aimingSpeed",   0.70, 0],
    ["spotDistance",  0.70, 0],
    ["spotTime",      0.75, 0],
    ["endurance",     0.70, 0],
    ["courage",       0.70, 0],
    ["reloadSpeed",   0.70, 0],
    ["commanding",    0.70, 0],
    ["general",       0.70, 0]
];

SAR_leader_band_skills = [
    ["aimingAccuracy",0.35, 0], // skilltype, <min value>, <random value added to min>;
    ["aimingShake",   0.35, 0],
    ["aimingSpeed",   0.60, 0],
    ["spotDistance",  0.40, 0],
    ["spotTime",      0.45, 0],
    ["endurance",     0.40, 0],
    ["courage",       0.50, 0],
    ["reloadSpeed",   0.60, 0],
    ["commanding",    0.50, 0],
    ["general",       0.50, 0]
];
SAR_soldier_band_skills = [
    ["aimingAccuracy",0.15, 0], // skilltype, <min value>, <random value added to min>;
    ["aimingShake",   0.15, 0],
    ["aimingSpeed",   0.60, 0],
    ["spotDistance",  0.40, 0],
    ["spotTime",      0.40, 0],
    ["endurance",     0.40, 0],
    ["courage",       0.40, 0],
    ["reloadSpeed",   0.40, 0],
    ["commanding",    0.40, 0],
    ["general",       0.40, 0]
];
SAR_sniper_band_skills = [
    ["aimingAccuracy",0.70, 0], // skilltype, <min value>, <random value added to min>;
    ["aimingShake",   0.80, 0],
    ["aimingSpeed",   0.70, 0],
    ["spotDistance",  0.90, 0],
    ["spotTime",      0.55, 0],
    ["endurance",     0.70, 0],
    ["courage",       0.70, 0],
    ["reloadSpeed",   0.70, 0],
    ["commanding",    0.50, 0],
    ["general",       0.60, 0]
];

SAR_leader_surv_skills = [
    ["aimingAccuracy",0.35, 0], // skilltype, <min value>, <random value added to min>;
    ["aimingShake",   0.35, 0],
    ["aimingSpeed",   0.60, 0],
    ["spotDistance",  0.40, 0],
    ["spotTime",      0.45, 0],
    ["endurance",     0.40, 0],
    ["courage",       0.50, 0],
    ["reloadSpeed",   0.60, 0],
    ["commanding",    0.50, 0],
    ["general",       0.50, 0]
];
SAR_soldier_surv_skills = [
    ["aimingAccuracy",0.15, 0], // skilltype, <min value>, <random value added to min>;
    ["aimingShake",   0.15, 0],
    ["aimingSpeed",   0.60, 0],
    ["spotDistance",  0.45, 0],
    ["spotTime",      0.20, 0],
    ["endurance",     0.40, 0],
    ["courage",       0.40, 0],
    ["reloadSpeed",   0.40, 0],
    ["commanding",    0.40, 0],
    ["general",       0.40, 0]
];
SAR_sniper_surv_skills = [
    ["aimingAccuracy",0.70, 0], // skilltype, <min value>, <random value added to min>;
    ["aimingShake",   0.80, 0],
    ["aimingSpeed",   0.70, 0],
    ["spotDistance",  0.70, 0],
    ["spotTime",      0.65, 0],
    ["endurance",     0.70, 0],
    ["courage",       0.70, 0],
    ["reloadSpeed",   0.70, 0],
    ["commanding",    0.50, 0],
    ["general",       0.60, 0]
];


SAR_sold_leader_weapon_list = ["M4A1","M16A2","AK_74","LeeEnfield","M1014"];
SAR_sold_leader_pistol_list = [];   
SAR_sold_leader_items = [["ItemSodaCoke",75],["FoodCanBakedBeans",60]];
SAR_sold_leader_tools =  [["ItemMap",50],["ItemCompass",30],["Binocular_Vector",5],["NVGoggles",5],["ItemRadio",100]];

SAR_sold_rifleman_weapon_list = ["M4A1","M16A2","AK_74","LeeEnfield","M1014"];
SAR_sold_rifleman_pistol_list = [];    
SAR_sold_rifleman_items = [["ItemSodaCoke",75],["FoodCanBakedBeans",60]];
SAR_sold_rifleman_tools = [["ItemMap",50],["ItemCompass",30]];

SAR_sold_sniper_weapon_list = ["M4A1","M16A2","AK_74","LeeEnfield","M1014"];
SAR_sold_sniper_pistol_list = [];   
SAR_sold_sniper_items = [["ItemSodaCoke",75],["FoodCanBakedBeans",60],["Skin_Sniper1_DZ",10]];
SAR_sold_sniper_tools = [["ItemMap",50],["ItemCompass",30]];

SAR_surv_leader_weapon_list = ["M4A1","M16A2","AK_74","LeeEnfield","M1014"];
SAR_surv_leader_pistol_list = [];   
SAR_surv_leader_items = [["ItemSodaCoke",75],["FoodCanBakedBeans",60]];
SAR_surv_leader_tools =  [["ItemMap",50],["ItemCompass",30],["Binocular_Vector",5],["NVGoggles",5],["ItemRadio",100]];

SAR_surv_rifleman_weapon_list = ["M4A1","M16A2","AK_74","LeeEnfield","M1014"];
SAR_surv_rifleman_pistol_list = [];    
SAR_surv_rifleman_items = [["ItemSodaCoke",75],["FoodCanBakedBeans",60]];
SAR_surv_rifleman_tools = [["ItemMap",50],["ItemCompass",30]];

SAR_surv_sniper_weapon_list = ["M4A1","M16A2","AK_74","LeeEnfield","M1014"];
SAR_surv_sniper_pistol_list = [];   
SAR_surv_sniper_items = [["ItemSodaCoke",75],["FoodCanBakedBeans",60],["Skin_Sniper1_DZ",10]];
SAR_surv_sniper_tools = [["ItemMap",50],["ItemCompass",30]];

SAR_band_leader_weapon_list = ["M4A1","M16A2","AK_74","LeeEnfield","M1014"];
SAR_band_leader_pistol_list = [];   
SAR_band_leader_items = [["ItemSodaCoke",75],["FoodCanBakedBeans",60]];
SAR_band_leader_tools =  [["ItemMap",50],["ItemCompass",30],["Binocular_Vector",5],["NVGoggles",5],["ItemRadio",100]];

SAR_band_rifleman_weapon_list = ["M4A1","M16A2","AK_74","LeeEnfield","M1014"];
SAR_band_rifleman_pistol_list = [];    
SAR_band_rifleman_items = [["ItemSodaCoke",75],["FoodCanBakedBeans",60]];
SAR_band_rifleman_tools = [["ItemMap",50],["ItemCompass",30],["Binocular_Vector",2]];

SAR_band_sniper_weapon_list = ["M4A1","M16A2","AK_74","LeeEnfield","M1014"];
SAR_band_sniper_pistol_list = [];   
SAR_band_sniper_items = [["ItemSodaCoke",75],["FoodCanBakedBeans",60],["Skin_Sniper1_DZ",100]];
SAR_band_sniper_tools = [["ItemMap",50],["ItemCompass",30],["Binocular_Vector",10],["ItemFlashlight",100]];

// define the type of heli(s) you want to use here for the heli patrols - make sure you include helis that have minimum 2 gunner positions, anything else might fail
SAR_heli_type = ["UH1H_DZ","Mi17_DZ"];
