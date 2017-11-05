private ["_baseOwner","_attackAll","_friendlyPlayers","_ai","_entity_array","_humanitylimit","_sleeptime","_detectrange"];

//if (elec_stop_exec == 1) exitWith {}; // only run this on the client

_ai = _this select 0;
_friendlyPlayers = [];
_friendlyPlayers = _ai getVariable ["SAR_FLAG_FRIENDLY", []];
_attackAll = _ai getVariable ["ATTACK_ALL", false];
_detectrange = SAR_DETECT_HOSTILE;
_humanitylimit = SAR_HUMANITY_HOSTILE_LIMIT;
_sleeptime = SAR_DETECT_INTERVAL;

while {alive _ai} do {
	_friendlyPlayers = _ai getVariable ["SAR_FLAG_FRIENDLY", []]; // Check dynamically if friendlies added
	_attackAll 	= _ai getVariable ["ATTACK_ALL", true];  // Check dynamically attack all changes
	_entity_array = (getPosATL _ai) nearEntities [["CAManBase","AllVehicles"],(_detectrange + 200)];
	if (_attackAll) then {
		{
					if (isPlayer _x) then {
						_baseOwner = _x getVariable ["BaseOwner", 0];
						if (_baseOwner == 0) then {
							if (((getPlayerUID _x) in _friendlyPlayers)) then {
								_x addrating 50000;
								_x setVariable ["BaseOwner", 1, true];
							} else {
								_x addrating -50000;
							};
						} else {
							if (_baseOwner == 1 && rating _x < 50000) then {
								_x addrating 50000;
							};
						};
					} else {
						_tFriendlyPlayers = _x getVariable ["SAR_FLAG_FRIENDLY", []];
						_result = [_tFriendlyPlayers, _friendlyPlayers] call BIS_fnc_arrayCompare;
						if (_result) then {
							_x addrating 50000;
						} else { _x addrating -50000};
					};
		} forEach _entity_array;
	};
    sleep _sleeptime;
};
