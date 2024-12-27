#include "..\script_component.hpp"
#define IDD_RSCDISPLAYCURATOR 312

params [["_vehicle",objNull],["_unit",objNull],["_turret",[]],["_camera",""]];

_unit = effectiveCommander _unit;

if (!alive _vehicle || !alive _unit || !(_unit in _vehicle) || _unit call FUNC(isRemoteControlled)) exitWith {
	LOG_WARNING(LLSTRING(recipientUnavailable));
	false
};

_unit setVariable ["bis_fnc_moduleRemoteControl_owner",player,true];
missionNamespace setVariable ["bis_fnc_moduleRemoteControl_unit",_unit];

(findDisplay IDD_RSCDISPLAYCURATOR) closeDisplay 2;

if (!local _unit) then {
	//[QGVAR(remoteControlTransfer),[_unit,clientOwner]] call CBA_fnc_serverEvent;
	systemChat LLSTRING(remoteControlWarning);
};

if (OPTION(remoteControlAddMap) && {_unit getSlotItemName 608 isEqualTo ""}) then {
	_unit linkItem "itemMap";
};

[{
	params ["_vehicle","_unit","_turret","_camera"];	

	if (_turret isEqualTo []) then {
		_vehicle lock true;
	} else {
		_vehicle lockTurret [_turret,true];
	};
	
	if (cameraOn != _vehicle) then {
		if (_camera isEqualTo "") then {_camera = cameraView};
		_unit switchCamera _camera;
	};

	player remoteControl _unit;

	// Don't count friendly fire
	player setVariable [QGVAR(rcRatingEHID),player addEventHandler ["HandleRating",{0}]];

	[QGVAR(remoteControlStart),[player,_unit]] call CBA_fnc_globalEvent;

	[{
		params ["_vehicle","_unit","_turret","_camera"];
		isRemoteControlling player &&
		!isNull remoteControlled player &&
		_vehicle == cameraOn &&
		isNull findDisplay IDD_RSCDISPLAYCURATOR
	},{
		params ["_vehicle","_unit","_turret","_camera"];

		[QGVAR(remoteControlConnected),[player,_unit]] call CBA_fnc_globalEvent;

		[{
			params ["_vehicle","_unit","_turret","_camera"];
			!alive _unit ||
			!alive player ||
			{vehicle _unit != _vehicle} ||
			{_vehicle != cameraOn} ||
			{!isRemoteControlling player} ||
			{isNull remoteControlled player} ||
			{!isNull findDisplay IDD_RSCDISPLAYCURATOR}
		},{
			params ["_vehicle","_unit","_turret","_camera"];

			if (_turret isEqualTo []) then {
				_vehicle lock false;
			} else {
				_vehicle lockTurret [_turret,false];
			};
			
			player remoteControl objNull;
			switchCamera player;
			objNull remoteControl _unit;

			_unit setVariable ["bis_fnc_moduleRemoteControl_owner",nil,true];
			missionNamespace setVariable ["bis_fnc_moduleRemoteControl_unit",nil];

			player removeEventHandler ["HandleRating",player getVariable [QGVAR(rcRatingEHID),-1]];
			player setVariable [QGVAR(rcRatingEHID),nil];

			[QGVAR(remoteControlEnd),[player,_unit]] call CBA_fnc_globalEvent;
		},_this] call CBA_fnc_waitUntilAndExecute;
	},_this,10,{
		LOG_ERROR("Remote control failed!");

		params ["_vehicle","_unit","_turret","_camera"];

		if (_turret isEqualTo []) then {
			_vehicle lock false;
		} else {
			_vehicle lockTurret [_turret,false];
		};

		player remoteControl objNull;
		switchCamera player;
		objNull remoteControl _unit;

		_unit setVariable ["bis_fnc_moduleRemoteControl_owner",nil,true];
		missionNamespace setVariable ["bis_fnc_moduleRemoteControl_unit",nil];

		player removeEventHandler ["HandleRating",player getVariable [QGVAR(rcRatingEHID),-1]];
		player setVariable [QGVAR(rcRatingEHID),nil];

		[QGVAR(remoteControlFailed),[player,_unit]] call CBA_fnc_globalEvent;
	}] call CBA_fnc_waitUntilAndExecute;
},[_vehicle,_unit,_turret,_camera],2] call CBA_fnc_execAfterNFrames;

true
