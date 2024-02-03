#include "..\script_component.hpp"

if (!isServer) exitWith {
	[QEGVAR(common,execute),[_this,QFUNC(addStation)]] call CBA_fnc_serverEvent;
	objNull
};

params [
	["_posASL",[0,0,0],[[],objNull],3],
	["_dir",0,[0]],
	["_callsign","",[""]],
	["_cooldown",0,[0]],
	["_clearingRadius",0,[0]],
	["_referenceAreas",[],[[]]],
	["_listFunction",{},["",{}]],
	["_itemInit",{},["",{}]],
	["_side",sideEmpty,[sideEmpty]],
	["_remoteAccess",true,[false]],
	["_accessItems",[],[[]]],
	["_accessItemsLogic",false,[false]],
	["_accessCondition",{true},[{},""]],
	["_requestCondition",{true},[{},""]],
	["_authorizations",[],[[]]]
];

// Defaults
if (_posASL isEqualType objNull) then {_posASL = getPosASL _posASL};
if (_side isEqualTo sideEmpty) then {_side = west};
if (_callsign isEqualTo "") then {_callsign = "Logistics Station"};
if (_listFunction isEqualType "") then {_listFunction = compile _listFunction};
if (_itemInit isEqualType "") then {_itemInit = compile _itemInit};

// Register
private _entity = [
	QSERVICE,
	"STATION",
	QGVAR(guiStation),
	_callsign,
	"",
	_side,
	ICON_BOX,
	{},
	_remoteAccess,
	_accessItems,
	_accessItemsLogic,
	_accessCondition,
	_requestCondition,
	_authorizations
] call EFUNC(common,registerSupport);

if (isNull _entity) exitWith {objNull};

// Extras
_entity setVariable [QPVAR(base),_posASL,true];
_entity setVariable [QPVAR(baseDir),_dir,true];
_entity setVariable [QPVAR(cooldown),_cooldown,true];
_entity setVariable [QPVAR(cooldownTimer),0,true];
_entity setVariable [QPVAR(clearingRadius),_clearingRadius,true];
_entity setVariable [QPVAR(referenceAreas),_referenceAreas,true];
_entity setVariable [QPVAR(listFunction),_listFunction,true];
_entity setVariable [QPVAR(itemInit),_itemInit,true];

_entity
