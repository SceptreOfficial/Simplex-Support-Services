#include "script_component.hpp"

params [
	["_classname","",[""]],
	["_callsign","",[""]],
	["_spawnPosition",[],[[]]],
	["_spawnDelay",DEFAULT_LOGISTICS_AIRDROP_SPAWN_DELAY,[0]],
	["_flyingHeight",DEFAULT_LOGISTICS_AIRDROP_FLYING_HEIGHT,[0]],
	["_listFnc","",["",{}]],
	["_universalInitFnc",{},["",{}]],
	["_maxAmount",1,[0]],
	["_landingSignal",1,[0]],
	["_cooldownDefault",DEFAULT_COOLDOWN_LOGISTICS_AIRDROP,[0]],
	["_customInit",{},[{},""]],
	["_side",sideEmpty,[sideEmpty]],
	["_accessItems",[],[[]]],
	["_accessCondition",{true},[{},""]],
	["_requestCondition",{true},[{},""]]
];

// Validation
if (_classname isEqualTo "" || !(_classname isKindOf "Air")) exitWith {
	SSS_ERROR_1(localize LSTRING(InvalidLogisticsAirdropClassname),_classname);
	objNull
};

if (_callsign isEqualTo "") then {
	_callsign = localize LSTRING(DefaultCallsignLogisticsAirdrop);
};

if !(_spawnPosition isEqualTo []) then {
	_spawnPosition params [["_posX",0,[0]],["_posY",0,[0]]];
	_spawnPosition = [_posX,_posY,_flyingHeight];
};

if (_listFnc isEqualType "") then {
	_listFnc = compile _listFnc;
};

if (_universalInitFnc isEqualType "") then {
	_universalInitFnc = compile _universalInitFnc;
};

if (_customInit isEqualType "") then {
	_customInit = compile _customInit;
};

if (_accessCondition isEqualType "") then {
	_accessCondition = compile _accessCondition;
};

if (_requestCondition isEqualType "") then {
	_requestCondition = compile _requestCondition;
};

if (!isServer) exitWith {
	_this remoteExecCall [QFUNC(addLogisticsAirdrop),2];
	objNull
};

// Basic setup
private _entity = true call CBA_fnc_createNamespace;

BASE_TRAITS(_entity,_classname,_callsign,_side,ICON_PARACHUTE,_customInit,"logistics","logisticsAirdrop",_accessItems,_accessCondition,_requestCondition);
CREATE_TASK_MARKER(_entity,_callsign,"mil_end","Airdrop");

// Specifics
_entity setVariable ["SSS_spawnPosition",_spawnPosition,true];
_entity setVariable ["SSS_spawnDelay",_spawnDelay,true];
_entity setVariable ["SSS_flyingHeight",_flyingHeight,true];
_entity setVariable ["SSS_listFnc",_listFnc,true];
_entity setVariable ["SSS_universalInitFnc",_universalInitFnc,true];
_entity setVariable ["SSS_maxAmount",_maxAmount max 1,true];
_entity setVariable ["SSS_landingSignal",_landingSignal,true];
_entity setVariable ["SSS_cooldown",0,true];
_entity setVariable ["SSS_cooldownDefault",_cooldownDefault,true];

// Assignment
SSS_entities pushBack _entity;
publicVariable "SSS_entities";

// Event handlers
[_entity,"Deleted",{_this call EFUNC(common,deletedEntity)}] call CBA_fnc_addBISEventHandler;

_entity
