#include "script_component.hpp"

params ["_entity"];

if !(_entity getVariable ["SSS_loitering",false]) exitWith {
	NOTIFY_LOCAL(_entity,"Not in the requested area yet. Gunship is on the way and will notify on arrival.");
};

private _vehicle = _entity getVariable ["SSS_vehicle",objNull];

if (!alive _vehicle) exitWith {};

private _gunner = _vehicle turretUnit [1];

if (!isNull (_gunner getVariable ["SSS_remoteController",objNull])) exitWith {
	NOTIFY_LOCAL(_entity,"Currently occupied by another player");
};

_gunner setVariable ["SSS_remoteController",player,true];

_vehicle lock true;

player remoteControl _gunner;

if (cameraOn != _vehicle) then {
	_vehicle switchCamera "GUNNER";
};

// Don't count FF
SSS_ratingEHID = player addEventHandler ["HandleRating",{0}];

[{
	[{
		params ["_gunner","_vehicle","_entity"];

		isNull _entity || {
		!(_entity getVariable "SSS_loitering") || {
		vehicle _gunner != _vehicle || {
		!alive _gunner || {
		!alive player || {
		cameraOn == vehicle player
	}}}}}},{
		params ["_gunner"];

		objNull remoteControl _gunner;
		player switchCamera cameraView;

		_gunner setVariable ["SSS_remoteController",nil,true];

		player removeEventHandler ["HandleRating",SSS_ratingEHID];
		SSS_ratingEHID = nil;
	},_this] call CBA_fnc_waitUntilAndExecute;
},[_gunner,_vehicle,_entity]] call CBA_fnc_execNextFrame;
