// =========================================================================================================
//  SAR_AI - DayZ AI library
//  Version: 1.5.0 
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
// SAR_AI_init.sqf - main init and control file of the framework 
// last modified: 28.5.2013 
// ---------------------------------------------------------------------------------------------------------
private ["_worldname","_startx","_starty","_gridsize_x","_gridsize_y","_gridwidth","_markername","_triggername","_trig_act_stmnt","_trig_deact_stmnt","_trig_cond","_check","_script_handler","_legendname"];

diag_log format ["Sarge AI System: Now starting Sarge AI System for %1",worldName];

if (!isServer) then { // only run this on the connected clients
    "adjustrating" addPublicVariableEventHandler {((_this select 1) select 0) addRating ((_this select 1) select 1);	};
}; 

call compile preprocessFileLineNumbers "\z\addons\dayz_server\addons\sarge\SAR_config.sqf";
call compile preprocessFileLineNumbers "\z\addons\dayz_server\addons\sarge\SAR_functions.sqf";

//if (elec_stop_exec == 1) exitWith {};

SAR_AI                      = compile preprocessFileLineNumbers "\z\addons\dayz_server\addons\sarge\SAR_setup_AI_patrol.sqf";
SAR_AI_heli                 = compile preprocessFileLineNumbers "\z\addons\dayz_server\addons\sarge\SAR_setup_AI_patrol_heli.sqf";
SAR_AI_land                 = compile preprocessFileLineNumbers "\z\addons\dayz_server\addons\sarge\SAR_setup_AI_patrol_land.sqf";
SAR_AI_trace                = compile preprocessFileLineNumbers "\z\addons\dayz_server\addons\sarge\SAR_trace_entities.sqf";
SAR_AI_trace_veh            = compile preprocessFileLineNumbers "\z\addons\dayz_server\addons\sarge\SAR_trace_from_vehicle.sqf";
SAR_AI_reammo               = compile preprocessFileLineNumbers "\z\addons\dayz_server\addons\sarge\SAR_reammo_refuel_AI.sqf";
SAR_AI_spawn                = compile preprocessFileLineNumbers "\z\addons\dayz_server\addons\sarge\SAR_AI_spawn.sqf";
SAR_AI_despawn              = compile preprocessFileLineNumbers "\z\addons\dayz_server\addons\sarge\SAR_AI_despawn.sqf";
SAR_AI_hit                  = compile preprocessFileLineNumbers "\z\addons\dayz_server\addons\sarge\SAR_aihit.sqf";
SAR_AI_killed               = compile preprocessFileLineNumbers "\z\addons\dayz_server\addons\sarge\SAR_aikilled.sqf";
SAR_AI_VEH_HIT              = compile preprocessFileLineNumbers "\z\addons\dayz_server\addons\sarge\SAR_ai_vehicle_hit.sqf";
//SAR_AI_VEH_FIX              = compile preprocessFileLineNumbers "\z\addons\dayz_server\addons\sarge\SAR_vehicle_fix.sqf";

"doMedicAnim" addPublicVariableEventHandler {((_this select 1) select 0) playActionNow ((_this select 1) select 1);	};

// side definitions
createCenter east;
createCenter resistance;

// unfriendly AI bandits
EAST setFriend [WEST, 0]; 
EAST setFriend [RESISTANCE, 0];

// Players 
WEST setFriend [EAST, 0];
WEST setFriend [RESISTANCE, 1];

// friendly AI 
RESISTANCE setFriend [EAST, 0];
RESISTANCE setFriend [WEST, 1];

SAR_AI_friendly_side = resistance;
SAR_AI_unfriendly_side = east;
SAR_leader_number = 0;

SAR_AI_monitor = [];

waitUntil {!isNil "sm_done"};
waitUntil {sm_done};

_worldname= toLower format["%1",worldName];
diag_log format["Setting up SAR_AI for : %1",_worldname];

if (SAR_dynamic_spawning) then {

    diag_log format["SAR_AI: dynamic Area & Trigger definition Started"];
	
    // default gridvalues
    _startx=2500;
    _starty=2800;
    _gridsize_x=6;
    _gridsize_y=6;
    _gridwidth = 1000;

    switch (_worldname) do {
        case "chernarus":
        {
            #include "map_config\SAR_cfg_grid_chernarus.sqf"
        };
    };

    SAR_area_ = text format ["SAR_area_%1","x"];
    for "_i" from 0 to (_gridsize_y - 1) do
    {
        for "_ii" from 0 to (_gridsize_x - 1) do
        {
            _markername = format["SAR_area_%1_%2",_ii,_i];
            _legendname = format["SAR_area_legend_%1_%2",_ii,_i];
            
            _this = createMarker[_markername,[_startx + (_ii * _gridwidth * 2),_starty + (_i * _gridwidth * 2)]];
            if (SAR_EXTREME_DEBUG) then {
                _this setMarkerAlpha 1;
            } else {
                _this setMarkerAlpha 0;
            };
            _this setMarkerShape "RECTANGLE";
            _this setMarkerType "Flag";
            _this setMarkerBrush "BORDER";
            _this setMarkerSize [_gridwidth, _gridwidth];

            Call Compile Format ["SAR_area_%1_%2 = _this",_ii,_i]; 

            _this = createMarker[_legendname,[_startx + (_ii * _gridwidth * 2) + (_gridwidth - (_gridwidth/2)),_starty + (_i * _gridwidth * 2) - (_gridwidth - (_gridwidth/10))]];
            if(SAR_EXTREME_DEBUG) then {
                _this setMarkerAlpha 1;
            } else {
                _this setMarkerAlpha 0;
            };
            
            _this setMarkerShape "ICON";
            _this setMarkerType "Flag";
            _this setMarkerColor "ColorBlack";
            
            _this setMarkerText format["%1/%2",_ii,_i];
            _this setMarkerSize [.1, .1];            

            _triggername = format["SAR_trig_%1_%2",_ii,_i];
            
            _this = createTrigger ["EmptyDetector", [_startx + (_ii * _gridwidth * 2),_starty + (_i * _gridwidth * 2)]];
            _this setTriggerArea [_gridwidth, _gridwidth, 0, true];
            _this setTriggerActivation ["ANY", "PRESENT", true];
            
            Call Compile Format ["SAR_trig_%1_%2 = _this",_ii,_i]; 

            _trig_act_stmnt = format["if (SAR_DEBUG) then {diag_log 'SAR DEBUG: trigger on in %1';};[thislist,'%1'] spawn SAR_AI_spawn;",_triggername];
            _trig_deact_stmnt = format["if (SAR_DEBUG) then {diag_log 'SAR DEBUG: trigger off in %1';};[thislist,thisTrigger,'%1'] spawn SAR_AI_despawn;",_triggername];
            
            _trig_cond = "{isPlayer _x} count thisList > 0;";
            
            Call Compile Format ["SAR_trig_%1_%2 ",_ii,_i] setTriggerStatements [_trig_cond,_trig_act_stmnt , _trig_deact_stmnt];

            // standard grid definition - maxgroups (ba,so,su) - probability (ba,so,su) - max group members (ba,so,su)
            SAR_AI_monitor set[count SAR_AI_monitor, [_markername,[SAR_max_grps_bandits,SAR_max_grps_soldiers,SAR_max_grps_survivors],[SAR_chance_bandits,SAR_chance_soldiers,SAR_chance_survivors],[SAR_max_grpsize_bandits,SAR_max_grpsize_soldiers,SAR_max_grpsize_survivors],[],[],[]]];
        };
    };
    diag_log format["SAR_AI: Area & Trigger definition finished"];
};

diag_log format["SAR_AI: Dynamic and static spawning Started"];

switch (_worldname) do {
    case "chernarus":
    {
        #include "map_config\SAR_cfg_grps_chernarus.sqf"
    };
};

diag_log format ["Sarge AI Debug: Dynamic and static spawning finished"];
