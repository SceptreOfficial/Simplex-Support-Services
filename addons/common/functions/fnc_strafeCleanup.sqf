#include "script_component.hpp"

params ["_completed"];

DEBUG_1("Shot counts: %1",_vehicle getVariable QGVAR(firedCounts));
_vehicle setVariable [QGVAR(firedCounts),nil,true];

removeMissionEventHandler ["EachFrame",_vehicle getVariable [QGVAR(strafeSimEHID),-1]];
_vehicle setVariable [QGVAR(strafeSimEHID),nil];

_vehicle removeEventHandler ["Fired",_vehicle getVariable [QGVAR(firedEHID),-1]];
_vehicle setVariable [QGVAR(firedEHID),nil];

_vehicle setVariable [QGVAR(strafe),nil,true];
_vehicle setVariable [QGVAR(strafeCancel),nil,true];
_vehicle setVariable [QGVAR(strafeApproach),nil,true];
_vehicle setVariable [QGVAR(bombMagazines),nil,true];
_vehicle setVariable [QGVAR(relativeVelocity),nil,true];

// Remove targeting dummy (for missile locks)
[{deleteVehicle _this},_vehicle getVariable [QGVAR(targetDummy),objNull],10] call CBA_fnc_waitAndExecute;

// Reset pylon bays
{
	private _pylonIndex = _forEachIndex + 1;
	_vehicle animateBay [_pylonIndex,-1,false];
} forEach getPylonMagazines _vehicle;

// Reset AI abilities
{
	private _unit = _x;

	{
		[QGVAR(enableAIFeature),[_unit,_x],_unit] call CBA_fnc_targetEvent;
	} forEach (_unit getVariable [QGVAR(strafeAIFeatures),[["AUTOTARGET",true],["TARGET",true]]]);

	_unit setVariable [QGVAR(strafeAIFeatures),nil];
} forEach (_vehicle getVariable [QGVAR(strafeAI),[]]);

_vehicle setVariable [QGVAR(strafeAI),nil];

// Reset camera locks
{_vehicle lockCameraTo [objNull,_x,true]} forEach ([[-1]] + allTurrets _vehicle);

// Reset speed
private _entity = _vehicle getVariable [QPVAR(entity),objNull];

[QGVAR(limitSpeed),[_vehicle,_entity getVariable [QPVAR(speed),-1]],_vehicle] call CBA_fnc_targetEvent;

// Reset flying height
if (_completed) then {
	[QGVAR(flyInHeight),[_vehicle,50 max (getPos _vehicle # 2 - 30)],_vehicle] call CBA_fnc_targetEvent;
	[QGVAR(flyInHeightASL),[_vehicle,50],_vehicle] call CBA_fnc_targetEvent;

	[{
		private _vehicle = _this;
		private _entity = _vehicle getVariable [QPVAR(entity),objNull];
		
		if (_entity getVariable [QPVAR(service),""] == "CAS") then {
			[{
				private _vehicle = _this;
				[QGVAR(flyInHeight),[_vehicle,_vehicle getVariable [QGVAR(strafeHeightATL),100]],_vehicle] call CBA_fnc_targetEvent;
				[QGVAR(flyInHeightASL),[_vehicle,_vehicle getVariable [QGVAR(strafeHeightASL),100]],_vehicle] call CBA_fnc_targetEvent;
			},_vehicle,10] call CBA_fnc_waitAndExecute;
		} else {
			[QGVAR(flyInHeight),[_vehicle,_entity getVariable [QPVAR(altitudeATL),100]],_vehicle] call CBA_fnc_targetEvent;
			[QGVAR(flyInHeightASL),[_vehicle,_entity getVariable [QPVAR(altitudeASL),100]],_vehicle] call CBA_fnc_targetEvent;
		};
			
	},_vehicle,5] call CBA_fnc_waitAndExecute;
} else {
	[QGVAR(flyInHeight),[_vehicle,_entity getVariable [QPVAR(altitudeATL),_vehicle getVariable [QGVAR(strafeHeightATL),100]]],_vehicle] call CBA_fnc_targetEvent;
	[QGVAR(flyInHeightASL),[_vehicle,_entity getVariable [QPVAR(altitudeASL),_vehicle getVariable [QGVAR(strafeHeightASL),100]]],_vehicle] call CBA_fnc_targetEvent;
};

// CBA Event
[QGVAR(strafeCleanup),[_vehicle,_completed]] call CBA_fnc_globalEvent;
