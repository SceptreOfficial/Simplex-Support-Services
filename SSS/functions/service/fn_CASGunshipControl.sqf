#include "script_component.hpp"
#define MIN_VIEW_DISTANCE 2500

params ["_entity"];

if !(_entity getVariable ["SSS_loitering",false]) exitWith {
	NOTIFY_LOCAL(_entity,"Not in the requested area yet. Gunship is on the way and will signal on arrival.")
};

private _vehicle = _entity getVariable ["SSS_physicalVehicle",objNull];
if (!alive _vehicle) exitWith {};
private _gunner = _vehicle turretUnit [1];
if (!isNull (_gunner getVariable ["SSS_remoteController",objNull])) exitWith {
	NOTIFY_LOCAL(_entity,"Currently occupied by another player")
};

_gunner setVariable ["SSS_remoteController",player,true];

player remoteControl _gunner;

if (cameraOn != _vehicle) then {
	_vehicle switchCamera "GUNNER";
};

// Set view distance where its needed
player setVariable ["SSS_viewDistance",viewDistance];
player setVariable ["SSS_objectViewDistance",getObjectViewDistance];
setViewDistance 2500 max viewDistance;
setObjectViewDistance [2000 max getObjectViewDistance # 0,getObjectViewDistance # 1];

// Don't count FF
player setVariable ["SSS_ratingEHID",player addEventHandler ["HandleRating",{0}]];

[{
	[{
		params ["_gunner","_vehicle","_entity"];

		if (alive _gunner && {vehicle _gunner != _vehicle}) then {
			player remoteControl _gunner;
			_this set [1,vehicle _gunner];
		};

		!(_entity getVariable "SSS_loitering") || {
		!alive _gunner || {
		!alive player || {
		cameraOn == vehicle player
	}}}},{
		params ["_gunner"];

		objNull remoteControl _gunner;
		player switchCamera cameraView;

		_gunner setVariable ["SSS_remoteController",nil,true];

		setViewDistance (player getVariable ["SSS_viewDistance",viewDistance]);
		setObjectViewDistance (player getVariable ["SSS_viewDistance",getObjectViewDistance]);
		player setVariable ["SSS_viewDistance",nil];
		player setVariable ["SSS_objectViewDistance",nil];
		player removeEventHandler ["HandleRating",player getVariable ["SSS_ratingEHID",-1]];
	},_this] call CBA_fnc_waitUntilAndExecute;
},[_gunner,_vehicle,_entity]] call CBA_fnc_execNextFrame;
