#include "script_component.hpp"

params ["_units","_position","_alt","_shift","_vehicle","_request","_service"];

switch (_service) do {
	case "artillery" : {
		if !(_position inRangeOfArtillery [[_vehicle],_request]) exitWith {NOTIFY_LOCAL(_vehicle,"Artillery range INVALID. Unable to fulfill request.")};

		private _serviceArray = missionNamespace getVariable format ["SSS_artillery_%1",_vehicle getVariable "SSS_side"];
		private _nearbyArtillery = (_serviceArray select {
			_vehicle distance2D _x < 100 && {
			_request in getArtilleryAmmo [_x] && {
			(_x getVariable "SSS_cooldown") isEqualTo 0
		}}}) - [_vehicle];

		["Fire Mission Parameters",[
			["SLIDER","Rounds",[[1,10,0],1]],
			["SLIDER","Random Dispersion Radius",[[0,200,0],0]],
			["CHECKBOX","Coordinate with nearby artillery units",false,true,{},[{true},{false}] select (_nearbyArtillery isEqualTo [])],
			["SLIDER","Additional units to include with request",[[1,count _nearbyArtillery,0],1],true,{},{2 call SSS_CDS_fnc_getCurrentValue}]
		],{
			params ["_values","_args"];
			_values params ["_rounds","_dispersion","_coordinate","_coordinateCount"];
			_args params ["_nearbyArtillery","_vehicle","_request","_position"];

			[_vehicle,_request,_position,_rounds,_dispersion] remoteExecCall ["SSS_fnc_requestArtillery",_vehicle];

			if (_coordinate) then {
				for "_i" from 0 to (_coordinateCount - 1) do {
					private _nearbyVehicle = _nearbyArtillery # _i;
					[_nearbyVehicle,_request,_position,_rounds,_dispersion] remoteExecCall ["SSS_fnc_requestArtillery",_nearbyVehicle];
				};
			};
		},{REQUEST_CANCELLED},[_nearbyArtillery,_vehicle,_request,_position]] call SSS_CDS_fnc_dialog;
	};
	case "CASDrones" : {
		if (SSS_setting_GiveUAVTerminal) then {
			private _UAVTerminal = switch (side player) do {
				case west : {"B_UavTerminal"};
				case east : {"O_UavTerminal"};
				case independent : {"I_UavTerminal"};
			};

			if !(_UAVTerminal in (assignedItems player)) then {player linkItem _UAVTerminal;};
		};

		[_vehicle,_position] remoteExecCall ["SSS_fnc_requestCASDrone",2];
	};
	case "CASGunships" : {
		[_vehicle,_position] remoteExecCall ["SSS_fnc_requestCASGunship",2];
	};
	case "CASHelis" : {
		[_vehicle,_request,_position] remoteExecCall ["SSS_fnc_requestCASHeli",_vehicle];
	};
	case "CASPlanes" : {
		// Get directions not blocked by terrain
		_position set [2,1];
		private _positionASL = AGLtoASL _position;
		private _bearingList = [[0,"N"],[45,"NE"],[90,"E"],[135,"SE"],[180,"S"],[225,"SW"],[270,"W"],[315,"NW"]] apply {
			private _testPos = AGLtoASL (_position getPos [600,_x # 0]);
			_testPos set [2,_positionASL # 2 + 350];
			if (terrainIntersectASL [_positionASL,_testPos]) then {
				[_x # 1,"Terrain obstructing approach","",RGBA_ORANGE]
			} else {
				[_x # 1]
			};
		};

		["CAS Parameters",[
			["COMBOBOX",["Approach direction","Orange means the approach is blocked"],[_bearingList,0],false],
			["COMBOBOX","Map position or other signal",[[
				["Map Position","",ICON_MAP],
				["Laser Target","",ICON_TARGET],
				["Smoke Signal","",ICON_SMOKE],
				["IR Signal","",ICON_STROBE]
			],0],false,{
				params ["_currentValue","_args","_ctrl"];
				if (_currentValue isEqualTo 2) then {
					[2,{true}] call SSS_CDS_fnc_setEnableCondition;
				} else {
					[2,{false}] call SSS_CDS_fnc_setEnableCondition;
				};
			}],
			["COMBOBOX","Smoke Color",[[
				"White","Black",
				["Red","","",[0.9,0,0,1]],
				["Orange","","",[0.85,0.4,0,1]],
				["Yellow","","",[0.85,0.85,0,1]],
				["Green","","",[0,0.8,0,1]],
				["Blue","","",[0,0,1,1]],
				["Purple","","",[0.75,0.15,0.75,1]]
			],0],false,{},{false}]
		],{
			params ["_values","_args"];

			(_args + _values) remoteExecCall ["SSS_fnc_requestCASPlane",2];
		},{REQUEST_CANCELLED},[_vehicle,_request,_position]] call SSS_CDS_fnc_dialog;
	};
	case "transport" : {
		if (_request isEqualTo 5) then {
			["Hover parameters",[
				["SLIDER","Hover height",[[3,40,0],15],false],
				["CHECKBOX","Fastrope at position",true,false]
			],{
				params ["_values","_args"];
				_args params ["_vehicle","_request","_position"];

				[_vehicle,_request,_position,_values] remoteExecCall ["SSS_fnc_requestTransporti",_vehicle];
			},{REQUEST_CANCELLED},[_vehicle,_request,_position]] call SSS_CDS_fnc_dialog
		} else {
			[_vehicle,_request,_position] remoteExecCall ["SSS_fnc_requestTransport",_vehicle];
		};
	};
};
