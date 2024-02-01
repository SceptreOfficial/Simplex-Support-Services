#include "script_component.hpp"

params [
	["_service","",[""]],
	["_supportType","",[""]],
	["_guiClass","",[""]],
	["_callsign","",[""]],
	["_class","",[""]],
	["_side",sideUnknown,[sideUnknown]],
	["_icon","",[""]],
	["_vehicleInit",{},[{},""]],
	["_remoteAccess",true,[false]],
	["_accessItems",[],[[]]],
	["_accessItemsLogic",false,[false]],
	["_accessCondition",{true},[{},""]],
	["_requestCondition",{true},[{},""]],
	["_authorizations",[],[[]]],
	["_physicalProperties",[],[[]]]
];

_service = toUpper _service;
_supportType = toUpper _supportType;

private _entities = GVAR(services) get _service;

if (isNil "_entities") exitWith {
	LOG_ERROR_1("Service not found: %1",_service);
	objNull
};

if (_vehicleInit isEqualType "") then {_vehicleInit = compile _vehicleInit};
if (_accessCondition isEqualType "") then {_accessCondition = compile _accessCondition};
if (_requestCondition isEqualType "") then {_requestCondition = compile _requestCondition};

private _entity = true call CBA_fnc_createNamespace;
private _exit = false;

if (_physicalProperties isNotEqualTo []) then {
	_physicalProperties params [["_vehicle",objNull,[objNull,[]]],["_respawnDelay",120,[0]],["_relocation",[false,60],[[]]]];

	private _group = grpNull;

	if (_vehicle isEqualType objNull) then {
		if ([_vehicle,_callsign] call FUNC(validateVehicle)) exitWith {
			LOG_ERROR_3("%1: Invalid vehicle: %2 (%3)",_service,_vehicle,_callsign);
			_exit = true;
		};
		
		_group = group _vehicle;

		_entity setVariable [QPVAR(vehicle),_vehicle,true];
		_entity setVariable [QPVAR(vehicleCount),1,true];
		_entity setVariable [QPVAR(base),getPosASL _vehicle,true];
		_entity setVariable [QPVAR(baseNormal),[vectorDir _vehicle,vectorUp _vehicle],true];
	} else {
		private _vehicles = [];

		{
			if ([_x,_callsign] call FUNC(validateVehicle)) then {continue};

			_vehicles pushBack _x;
			_x setVariable [QPVAR(base),getPosASL _x,true];
			_x setVariable [QPVAR(baseNormal),[vectorDir _x,vectorUp _x],true];
		} forEach _vehicle;

		if (_vehicles isEqualTo []) exitWith {
			LOG_ERROR_3("%1: No valid vehicle found: %2 (%3)",_service,_vehicle,_callsign);
			_exit = true;
		};

		_group = group (_vehicles # 0);
		_entity setVariable [QPVAR(vehicles),_vehicles,true];
		_entity setVariable [QPVAR(vehicleCount),count _vehicles,true];
	};

	if (_exit || isNull _group) exitWith {_exit = true};

	if (side _group != _side) then {
		_group = createGroup [_side,false];
	} else {
		[QGVAR(deleteGroupWhenEmpty),[_group,false],_group] call CBA_fnc_targetEvent;
	};

	_entity setVariable [QPVAR(respawnDelay),_respawnDelay,true];
	_entity setVariable [QPVAR(relocation),_relocation,true];
	_entity setVariable [QPVAR(group),_group,true];
	_group setVariable [QPVAR(entity),_entity,true];
};

if (_exit) exitWith {
	[{deleteVehicle _this},_entity] call CBA_fnc_execNextFrame;
	objNull
};

_entity setVariable [QPVAR(service),_service,true];
_entity setVariable [QPVAR(supportType),_supportType,true];
_entity setVariable [QPVAR(gui),_guiClass,true];
_entity setVariable [QPVAR(callsign),_callsign,true];
_entity setVariable [QPVAR(class),_class,true];
_entity setVariable [QPVAR(side),_side,true];
_entity setVariable [QPVAR(icon),_icon,true];
_entity setVariable [QPVAR(vehicleInit),_vehicleInit,true];
_entity setVariable [QPVAR(remoteAccess),_remoteAccess,true];
_entity setVariable [QPVAR(accessItems),_accessItems apply {toLower _x},true];
_entity setVariable [QPVAR(accessItemsLogic),_accessItemsLogic,true];
_entity setVariable [QPVAR(accessCondition),_accessCondition,true];
_entity setVariable [QPVAR(requestCondition),_requestCondition,true];
_entity setVariable [QPVAR(auth),_authorizations,true];
_entity setVariable [QPVAR(uid),format ["%1#%2",_entities pushBack _entity,systemTimeUTC],true];
_entity setVariable [QPVAR(requester),objNull,true];
_entity setVariable [QPVAR(busy),false,true];
_entity setVariable [QPVAR(task),"",true];
_entity setVariable [QPVAR(status),[LSTRING(statusIdle),[1,1,1,1]],true];

GVAR(services) set [_service,_entities];
publicVariable QGVAR(services);

// Support registered event executed next frame to ensure extra variables are added from specific services fnc
[{[QPVAR(supportRegistered),_this] call CBA_fnc_globalEvent},[_entity,_service,_supportType,_callsign]] call CBA_fnc_execNextFrame;
DEBUG_4("%1:%2 '%3' (%4)",_service,_supportType,_callsign,_class);

_entity
