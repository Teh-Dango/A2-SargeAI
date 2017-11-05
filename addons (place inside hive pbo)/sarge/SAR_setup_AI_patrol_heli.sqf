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
//  UPSMon  
//  SHK_pos 
//  
// ---------------------------------------------------------------------------------------------------------
//   SAR_setup_AI_patrol_heli.sqf
//   last modified: 28.5.2013
// ---------------------------------------------------------------------------------------------------------
private ["_ai_type","_riflemenlist","_side","_leader_group","_initstring","_patrol_area_name","_rndpos","_groupheli","_heli","_leader","_man2heli","_man3heli","_argc","_grouptype","_respawn","_leader_weapon_names","_leader_items","_leader_tools","_soldier_weapon_names","_soldier_items","_soldier_tools","_leaderskills","_sniperskills","_ups_para_list","_type","_error","_respawn_time","_leadername"];

//if (elec_stop_exec == 1) exitWith {};

_argc = count _this;
_error = false;
_patrol_area_name = _this select 0;

if (_argc > 1) then {

    _grouptype = _this select 1;
    switch (_grouptype) do
    {
        case 1: // military
        {
            _side = SAR_AI_friendly_side;
            _type="sold";
            _ai_type = "AI Military";
            _initstring = "[this] spawn SAR_AI_trace_veh;[this] spawn SAR_AI_reammo;";
        };
        case 2: // survivors
        {
            _side = SAR_AI_friendly_side;
            _type="surv";
            _ai_type = "AI Survivor";            
            _initstring = "[this] spawn SAR_AI_trace_veh;[this] spawn SAR_AI_reammo;";
        };
        case 3: // bandits
        {
            _side = SAR_AI_unfriendly_side;
            _type="band";
            _ai_type = "AI Bandit";            
            _initstring = "[this] spawn SAR_AI_trace_veh;[this] spawn SAR_AI_reammo;";
        };
    };
} else {
    _error = true;
};

// respawn parameter
if (_argc >2) then {
    _respawn = _this select 2;
} else {
    _respawn = false;
};
// respawn time
if(_argc>3) then {
    _respawn_time = _this select 3;
}else {
    _respawn_time = SAR_respawn_waittime;
};

if(_error) exitWith {diag_log "SAR_AI: Heli patrol setup failed, wrong parameters passed!";};

_leader_group = call compile format ["SAR_leader_%1_list",_type] call BIS_fnc_selectRandom;
_riflemenlist = call compile format ["SAR_soldier_%1_list",_type];

_leaderskills = call compile format ["SAR_leader_%1_skills",_type];

_sniperskills = call compile format ["SAR_sniper_%1_skills",_type];

_leader_weapon_names = ["leader",_type] call SAR_unit_loadout_weapons;
_leader_items = ["leader",_type] call SAR_unit_loadout_items;
_leader_tools = ["leader",_type] call SAR_unit_loadout_tools;
	
_rndpos = [(getMarkerPos _patrol_area_name),1,500,1,0,1.0,0] call BIS_fnc_findSafePos;

_groupheli = createGroup _side;

_groupheli setVariable ["SAR_protect",true,true];

_heli = createVehicle [(SAR_heli_type call BIS_fnc_selectRandom), [(_rndpos select 0) + 10, _rndpos select 1, 80], [], 0, "FLY"];
_heli addEventHandler ["GetIn",{_nil = [nil,(_this select 2),"loc",rTITLETEXT,"Warning: This vehicle will disappear on server restart!","PLAIN DOWN",5] call RE;}];
_heli setFuel 1;
_heli setVariable ["Sarge",1,true];
_heli engineon true; 
//_heli allowDamage false;
_heli setVehicleAmmo 1;

if (SAR_heli_shield) then {
    _heli addEventHandler ["HandleDamage", {returnvalue = _this spawn SAR_AI_VEH_HIT;}];  
} else {
    _heli addEventHandler ["HandleDamage", {_this spawn SAR_AI_VEH_HIT;_this select 2;}];  
};

[_heli] joinSilent _groupheli;

_leader = _groupheli createunit [_leader_group, [(_rndpos select 0) + 10, _rndpos select 1, 0], [], 0.5, "CAN_COLLIDE"];

[_leader,_leader_weapon_names,_leader_items,_leader_tools] call SAR_unit_loadout;

_leader setVehicleInit _initstring;
_leader addMPEventHandler ["MPkilled", {Null = _this spawn SAR_AI_killed;}];
_leader addMPEventHandler ["MPHit", {Null = _this spawn SAR_AI_hit;}];  
_leader addEventHandler ["HandleDamage",{if (_this select 1!="") then {_unit=_this select 0;damage _unit+((_this select 2)-damage _unit)*SAR_leader_health_factor}}];

_leader moveInDriver _heli;
_leader assignAsDriver _heli;

[_leader] joinSilent _groupheli;

{_leader setskill [_x select 0,(_x select 1 +(floor(random 2) * (_x select 2)))];} foreach _leaderskills;

SAR_leader_number = SAR_leader_number + 1;
_leadername = format["SAR_leader_%1",SAR_leader_number];

_leader setVehicleVarname _leadername;
_leader setVariable ["SAR_leader_name",_leadername,false];

// store AI type on the AI
_leader setVariable ["SAR_AI_type",_ai_type + " Leader",false];

// store experience value on AI
_leader setVariable ["SAR_AI_experience",0,false];

// create global variable for this group
call compile format ["KRON_UPS_%1=1",_leadername];

_leader Call Compile Format ["%1=_This ; PublicVariable ""%1""",_leadername];

_man2heli = _groupheli createunit [_riflemenlist call BIS_fnc_selectRandom, [(_rndpos select 0) - 30, _rndpos select 1, 0], [], 0.5, "CAN_COLLIDE"];

_soldier_weapon_names = ["rifleman",_type] call SAR_unit_loadout_weapons;
_soldier_items = ["rifleman",_type] call SAR_unit_loadout_items;
_soldier_tools = ["rifleman",_type] call SAR_unit_loadout_tools;
[_man2heli,_soldier_weapon_names,_soldier_items,_soldier_tools] call SAR_unit_loadout;

//_man2heli action ["getInTurret", _heli,[0]];
_man2heli moveInTurret [_heli,[0]];

_man2heli setVehicleInit _initstring;
_man2heli addMPEventHandler ["MPkilled", {Null = _this spawn SAR_AI_killed;}];
_man2heli addMPEventHandler ["MPHit", {Null = _this spawn SAR_AI_hit;}];  
[_man2heli] joinSilent _groupheli;

{_man2heli setskill [_x select 0,(_x select 1 +(floor(random 2) * (_x select 2)))];} forEach _sniperskills;

// store AI type on the AI
_man2heli setVariable ["SAR_AI_type",_ai_type,false];

// store experience value on AI
_man2heli setVariable ["SAR_AI_experience",0,false];

_man3heli = _groupheli createunit [_riflemenlist call BIS_fnc_selectRandom, [_rndpos select 0, (_rndpos select 1) + 30, 0], [], 0.5, "CAN_COLLIDE"];

_soldier_weapon_names = ["rifleman",_type] call SAR_unit_loadout_weapons;
_soldier_items = ["rifleman",_type] call SAR_unit_loadout_items;
_soldier_tools = ["rifleman",_type] call SAR_unit_loadout_tools;

[_man3heli,_soldier_weapon_names,_soldier_items,_soldier_tools] call SAR_unit_loadout;

_man3heli setVehicleInit _initstring;

//_man3heli action ["getInTurret", _heli,[1]];
_man3heli moveInTurret [_heli,[1]];

_man3heli addMPEventHandler ["MPkilled", {Null = _this spawn SAR_AI_killed;}];
_man3heli addMPEventHandler ["MPHit", {Null = _this spawn SAR_AI_hit;}];  
[_man3heli] joinSilent _groupheli;

{_man3heli setskill [_x select 0,(_x select 1 +(floor(random 2) * (_x select 2)))];} forEach _sniperskills;

// store AI type on the AI
_man3heli setVariable ["SAR_AI_type",_ai_type,false];

// store experience value on AI
_man3heli setVariable ["SAR_AI_experience",0,false];

//_groupheli setLeader _leader;

_ups_para_list = [_leader,_patrol_area_name,'NOWAIT','NOFOLLOW','AWARE','SPAWNED','DELETE:',SAR_DELETE_TIMEOUT];

if (_respawn) then {
    _ups_para_list = _ups_para_list + ['RESPAWN'];
    _ups_para_list set [count _ups_para_list,'RESPAWNTIME:'];
    _ups_para_list set [count _ups_para_list,_respawn_time];
};

_ups_para_list execVM "addons\scripts\UPSMON.sqf";

processInitCommands;

if(SAR_EXTREME_DEBUG) then {
    diag_log format["SAR_EXTREME_DEBUG: AI Heli patrol (%2) spawned in: %1.",_patrol_area_name,_groupheli];
};

_groupheli;