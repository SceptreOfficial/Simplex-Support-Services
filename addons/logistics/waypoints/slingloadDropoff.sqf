#include "script_component.hpp"

params ["_group","_wpPos","_attachedObject",["_fastrope",true]];

private _vehicle = vehicle leader _group;

if !(driver _vehicle in units _group) exitWith {true};

_group allowFleeing 0;

private _moveTick = 0;

waitUntil {
	if (CBA_missionTime > _moveTick) then {
		_moveTick = CBA_missionTime + 3;

		if (isTouchingGround _vehicle && _vehicle distance2D _wpPos < 200) then {
			_vehicle doMove (_vehicle getPos [200,getDir _vehicle]);
		} else {
			_vehicle doMove _wpPos
		};
	};

	sleep WAYPOINT_SLEEP;

	!isTouchingGround _vehicle && _vehicle distance2D _wpPos < 800
};

if (isNil {_vehicle getVariable QGVAR(flybyData)}) exitWith {true};

private _posASL = +_wpPos;
_posASL set [2,waypointPosition [_group,currentWaypoint _group] # 2];
_posASL = ATLToASL _posASL;

[_vehicle,_posASL] call EFUNC(common,slingloadDropoff);

private _object = _vehicle getVariable [QEGVAR(common,slingloadCargo),objNull];
private _entity = _vehicle getVariable [QPVAR(entity),objNull];
_vehicle setVariable [QGVAR(dropping),true,true];

[{
	params ["_entity"];

	if (_entity getVariable [QGVAR(dropping),false]) exitWith {};

	if (GVAR(cooldownTrigger) == "END") then {
		[_entity,true,"UNLOAD",[LSTRING(statusAirdropDropping),RGBA_YELLOW]] call EFUNC(common,setStatus);
	};
	
	NOTIFY(_entity,LSTRING(notifyAirdropDropping));

	_entity setVariable [QGVAR(dropping),true,true];
},_entity] call CBA_fnc_directCall;

waitUntil {
	sleep WAYPOINT_SLEEP;
	isNull (_vehicle getVariable [QEGVAR(common,slingloadCargo),objNull]) ||
	!(_vehicle getVariable [QEGVAR(common,pilotHelicopter),false]) ||
	_vehicle getVariable [QEGVAR(common,pilotHelicopterCompleted),false]
};

if (isNil {_vehicle getVariable QGVAR(flybyData)}) exitWith {
	_vehicle setVariable [QGVAR(dropping),nil,true];
	true
};

if (alive _object) then {
	_object getVariable [QGVAR(signals),[]] params [
		["_signal1Class","",[""]],
		["_signal2Class","",[""]]
	];

	private _offset = _object modelToWorldVisualWorld ((boundingBoxReal _object) # 0);
	private _signal1 = _signal1Class createVehicle [0,0,0];
	_signal1 setPosASL _offset;
	private _signal2 = _signal2Class createVehicle [0,0,0];
	_signal2 setPosASL _offset;
};

private _ejections = SECONDARY_CREW(_vehicle);

if (_ejections isNotEqualTo []) then {
	if (_entity getVariable QPVAR(unloadAltitude) > 0) then {
		[
			_vehicle,
			[_vehicle,ATLtoASL (_posASL getPos [sizeOf typeOf _object,random 360]),"FASTROPE",_entity getVariable QPVAR(unloadAltitude)] call EFUNC(common,surfacePosASL),
			[-1],
			(getPos _vehicle # 2) max 50,
			400,
			nil,
			[EFUNC(common,pilotHelicopterHover),[true,_ejections]]
		] call EFUNC(common,pilotHelicopter);

		_vehicle setVariable [QPVAR(fastropeDone),false,true];

		waitUntil {
			sleep WAYPOINT_SLEEP;
			_vehicle getVariable [QPVAR(fastropeDone),false] ||
			!(_vehicle getVariable [QEGVAR(common,pilotHelicopter),false]) ||
			_vehicle getVariable [QEGVAR(common,pilotHelicopterCompleted),false]
		};
	} else {
		[
			_vehicle,
			[_vehicle,ATLtoASL (_posASL getPos [sizeOf typeOf _object + sizeOf typeOf _vehicle,random 360]),"LAND"] call EFUNC(common,surfacePosASL),
			[-1],
			(getPos _vehicle # 2) max 50,
			100,
			nil,
			[EFUNC(common,pilotHelicopterLand),[-1,true]]
		] call EFUNC(common,pilotHelicopter);

		waitUntil {
			sleep WAYPOINT_SLEEP;
			isTouchingGround _vehicle ||
			!(_vehicle getVariable [QEGVAR(common,pilotHelicopter),false]) ||
			_vehicle getVariable [QEGVAR(common,pilotHelicopterCompleted),false]
		};

		[_vehicle,_ejections] call EFUNC(common,unloadTransport);

		waitUntil {
			sleep WAYPOINT_SLEEP;
			_vehicle getVariable [QEGVAR(common,unloadEnd),false]
		};
	};

	[_vehicle,[0,0,0]] call EFUNC(common,pilotHelicopter);
};

_vehicle setVariable [QGVAR(dropping),nil,true];

if (isNil {_vehicle getVariable QGVAR(flybyData)}) exitWith {true};

[{
	params ["_entity"];

	private _vehicles = _entity getVariable [QPVAR(vehicles),[]];

	if (GVAR(cooldownTrigger) != "END" || {{alive _x && _x getVariable [QGVAR(dropping),false]} count _vehicles > 0}) exitWith {};

	[_entity,true,"RTB",[LSTRING(statusAirdropComplete),RGBA_YELLOW]] call EFUNC(common,setStatus);
},_entity] call CBA_fnc_directCall;

true
