#include "script_component.hpp"

params ["_player","_entity","_request","_position"];

if (isNull _entity) exitWith {};

if (count _position isEqualTo 2) then {
	_position set [2,0];
};

private _approvalReturn = [_position] call (_entity getVariable ["SSS_requestCondition",{true}]);
private _denialText = "Request denied. ";
private _approval = if (_approvalReturn isEqualType true) then {
	_approvalReturn
} else {
	_approvalReturn params [["_bool",false,[false]],["_reason","",[""]]];
	_denialText = _denialText + _reason;
	_bool
};

if (!_approval) exitWith {
	NOTIFY_LOCAL(_entity,_denialText);
};

switch (_entity getVariable "SSS_supportType") do {
	case "artillery" : {
		private _vehicle = _entity getVariable ["SSS_vehicle",objNull];

		if (!alive _vehicle) exitWith {};

		if (!(_vehicle isKindOf "B_Ship_MRLS_01_base_F") && {!(_position inRangeOfArtillery [[_vehicle],_request])}) exitWith {
			private _string = ["<t color='#f4ca00'>Position out of range.</t> Unable to fulfill request.","Position out of range. Unable to fulfill request."] select SSS_setting_useChatNotifications;
			NOTIFY_LOCAL(_entity,_string);
		};

		private _coordinationType = _entity getVariable ["SSS_coordinationType",0];
		private _nearbyArtillery = [];

		if (_coordinationType in [1,2]) then {
			_nearbyArtillery append ((_vehicle nearEntities (_entity getVariable "SSS_coordinationDistance")) select {
				if (!alive _x || {_x isKindOf "CAManBase"} || {!isNil {_x getVariable "SSS_parentEntity"}}) then {false} else {
					private _magazines = if (_x isKindOf "B_Ship_MRLS_01_base_F") then {
						["magazine_Missiles_Cruise_01_x18","magazine_Missiles_Cruise_01_Cluster_x18"]
					} else {
						getArtilleryAmmo [_x]
					};

					_request in _magazines && unitReady _x && _vehicle != _x
				};
			});
		};

		if (_coordinationType in [0,2]) then {
			_nearbyArtillery append (([_player,"artillery"] call FUNC(availableEntities)) select {
				private _otherVehicle = _x getVariable ["SSS_vehicle",objNull];

				if (alive _otherVehicle) then {
					private _magazines = if (_otherVehicle isKindOf "B_Ship_MRLS_01_base_F") then {
						["magazine_Missiles_Cruise_01_x18","magazine_Missiles_Cruise_01_Cluster_x18"]
					} else {
						getArtilleryAmmo [_otherVehicle]
					};

					_request in _magazines && _vehicle != _otherVehicle &&
					{_vehicle distance2D _otherVehicle < (_entity getVariable "SSS_coordinationDistance")} &&
					{(_x getVariable "SSS_cooldown") isEqualTo 0}
				} else {
					false
				};
			});
		};
		
		["Fire Mission Parameters - " + mapGridPosition _position,[
			["SLIDER","Rounds",[[1,_entity getVariable "SSS_maxRounds",0],1]],
			["SLIDER","Random dispersion radius",[[0,250,0],0]],
			["SLIDER",["Coordination amount","Request fire mission from similar nearby artillery"],[[0,count _nearbyArtillery,0],0],true,{},!(_nearbyArtillery isEqualTo [])]
		],{
			params ["_values","_args"];
			_values params ["_rounds","_dispersion","_coordinateCount"];
			_args params ["_entity","_request","_position","_nearbyArtillery"];

			private _vehicle = _entity getVariable ["SSS_vehicle",objNull];

			if (alive _vehicle) then {
				[_entity,_request,_position,_rounds,_dispersion] remoteExecCall [QEFUNC(support,requestArtillery),_vehicle];
			};

			if (_coordinateCount > 0) then {
				_nearbyArtillery = _nearbyArtillery select {
					if (!alive _x) then {false} else {
						if (isNil {_x getVariable "SSS_vehicle"}) then {true} else {
							(_x getVariable "SSS_cooldown") isEqualTo 0 && {alive (_x getVariable ["SSS_vehicle",objNull])}
						};
					};
				};

				{
					private _extraVehicle = _x getVariable ["SSS_vehicle",objNull];

					if (isNull _extraVehicle) then {
						// Non-support
						[_x,_request,_position,_rounds,_dispersion] remoteExecCall [QEFUNC(support,requestArtilleryNonSupport),_x];
					} else {
						// Support
						[_x,_request,_position,_rounds,_dispersion] remoteExecCall [QEFUNC(support,requestArtillery),_extraVehicle];
					};

					_coordinateCount = _coordinateCount - 1;
					if (_coordinateCount <= 0) exitWith {};
				} forEach _nearbyArtillery;
			};
		},{REQUEST_CANCELLED;},[_entity,_request,_position,_nearbyArtillery]] call EFUNC(CDS,dialog);
	};

	case "CASDrone" : {
		if (SSS_setting_GiveUAVTerminal) then {
			private _UAVTerminal = switch (_entity getVariable "SSS_side") do {
				case west : {"B_UavTerminal"};
				case east : {"O_UavTerminal"};
				case independent : {"I_UavTerminal"};
				case civilian : {"C_UavTerminal"};
			};

			if !(_UAVTerminal in (assignedItems player)) then {
				player linkItem _UAVTerminal;
			};
		};

		["Drone Request Parameters",[
			["COMBOBOX","Loiter direction",[[["Clockwise","",ICON_CLOCKWISE],["Counter-Clockwise","",ICON_COUNTER_CLOCKWISE]],0]],
			["SLIDER","Loiter radius",[[800,2500,0],1000]],
			["SLIDER","Altitude above position",[[600,2500,0],1000]]
		],{
			params ["_values","_args"];
			_values params ["_loiterDirection","_loiterRadius","_loiterAltitude"];
			_args params ["_entity","_position"];

			[_entity,_position,_loiterDirection,_loiterRadius,_loiterAltitude] remoteExecCall [QEFUNC(support,requestCASDrone),2];
		},{REQUEST_CANCELLED;},[_entity,_position]] call EFUNC(CDS,dialog);
	};

	case "CASGunship" : {
		["Gunship Request Parameters",[
			["SLIDER","Loiter radius",[[800,2500,0],1000]],
			["SLIDER","Altitude above position",[[600,2500,0],1000]]
		],{
			params ["_values","_args"];
			_values params ["_loiterRadius","_loiterAltitude"];
			_args params ["_entity","_position"];

			[_entity,_position,_loiterRadius,_loiterAltitude] remoteExecCall [QEFUNC(support,requestCASGunship),2];
		},{REQUEST_CANCELLED;},[_entity,_position]] call EFUNC(CDS,dialog);
	};

	case "CASHelicopter" : {
		private _vehicle = _entity getVariable ["SSS_vehicle",objNull];

		if (!alive _vehicle) exitWith {};

		switch (_request) do {
			case "LOITER";
			case 3 : {
				["Loiter parameters",[
					["SLIDER","Loiter radius",[[150,1500,0],200]],
					["COMBOBOX","Loiter direction",[[["Clockwise","",ICON_CLOCKWISE],["Counter-Clockwise","",ICON_COUNTER_CLOCKWISE]],0]]
				],{
					params ["_values","_args"];
					_args params ["_entity","_request","_position"];

					private _vehicle = _entity getVariable ["SSS_vehicle",objNull];

					if (!alive _vehicle) exitWith {};

					[_entity,_request,_position,_values] remoteExecCall [QEFUNC(support,requestCASHelicopter),_vehicle];
				},{REQUEST_CANCELLED;},[_entity,_request,_position]] call EFUNC(CDS,dialog);
			};

			default {
				[_entity,_request,_position] remoteExecCall [QEFUNC(support,requestCASHelicopter),_vehicle];
			};
		};
	};

	case "CASPlane" : {
		// Get directions not blocked by terrain
		_position set [2,1];
		private _positionASL = AGLtoASL _position;
		private _bearingList = [[0,LELSTRING(Main,DirectionN)],[45,LELSTRING(Main,DirectionNE)],[90,LELSTRING(Main,DirectionE)],[135,LELSTRING(Main,DirectionSE)],[180,LELSTRING(Main,DirectionS)],[225,LELSTRING(Main,DirectionSW)],[270,LELSTRING(Main,DirectionW)],[315,LELSTRING(Main,DirectionNW)]] apply {
			private _testPos = AGLtoASL (_position getPos [600,_x # 0]);
			_testPos set [2,_positionASL # 2 + 350];
			if (terrainIntersectASL [_positionASL,_testPos]) then {
				[_x # 1,"Terrain obstructing approach","",RGBA_ORANGE]
			} else {
				[_x # 1]
			};
		};

		["CAS Parameters - " + mapGridPosition _position,[
			["COMBOBOX",["Approach from","Orange means the approach is blocked"],[_bearingList,0],false],
			["COMBOBOX","Map position or other signal",[[
				["Map Position","",ICON_MAP],
				["Laser Target","",ICON_TARGET],
				["Smoke Signal","",ICON_SMOKE],
				["IR Signal","",ICON_STROBE]
			],0],false,{
				params ["_currentValue","_args","_ctrl"];
				if (_currentValue isEqualTo 2) then {
					[2,{true}] call EFUNC(CDS,setEnableCondition);
				} else {
					[2,{false}] call EFUNC(CDS,setEnableCondition);
				};
			}],
			["COMBOBOX","Smoke Color",[[
				LELSTRING(Main,SmokeColorWhite),
				LELSTRING(Main,SmokeColorBlack),
				[LELSTRING(Main,SmokeColorRed),"","",[0.9,0,0,1]],
				[LELSTRING(Main,SmokeColorOrange),"","",[0.85,0.4,0,1]],
				[LELSTRING(Main,SmokeColorYellow),"","",[0.85,0.85,0,1]],
				[LELSTRING(Main,SmokeColorGreen),"","",[0,0.8,0,1]],
				[LELSTRING(Main,SmokeColorBlue),"","",[0,0,1,1]],
				[LELSTRING(Main,SmokeColorPurple),"","",[0.75,0.15,0.75,1]]
			],0],false,{},{false}]
		],{
			params ["_values","_args"];

			(_args + _values) remoteExecCall [QEFUNC(support,requestCASPlane),2];
		},{REQUEST_CANCELLED;},[_entity,_request,_position]] call EFUNC(CDS,dialog);
	};

	case "transportHelicopter" : {
		private _vehicle = _entity getVariable ["SSS_vehicle",objNull];

		if (!alive _vehicle) exitWith {};

		switch (_request) do {
			case "HOVER";
			case 5 : {
				["Hover parameters",[
					["SLIDER",["Hover height","Terrain collision is possible if set too low for angle/enviroment"],[[1,2000,0],15],false],
					["CHECKBOX","Fastrope at position",true,false]
				],{
					params ["_values","_args"];
					_args params ["_entity","_request","_position"];

					private _vehicle = _entity getVariable ["SSS_vehicle",objNull];

					if (!alive _vehicle) exitWith {};

					[_entity,_request,_position,_values] remoteExecCall [QEFUNC(support,requestTransportHelicopter),_vehicle];
				},{REQUEST_CANCELLED;},[_entity,_request,_position]] call EFUNC(CDS,dialog);
			};

			case "LOITER";
			case 6 : {
				["Loiter parameters",[
					["SLIDER","Loiter radius",[[150,1500,0],200]],
					["COMBOBOX","Loiter direction",[[["Clockwise","",ICON_CLOCKWISE],["Counter-Clockwise","",ICON_COUNTER_CLOCKWISE]],0]]
				],{
					params ["_values","_args"];
					_args params ["_entity","_request","_position"];

					private _vehicle = _entity getVariable ["SSS_vehicle",objNull];

					if (!alive _vehicle) exitWith {};

					[_entity,_request,_position,_values] remoteExecCall [QEFUNC(support,requestTransportHelicopter),_vehicle];
				},{REQUEST_CANCELLED;},[_entity,_request,_position]] call EFUNC(CDS,dialog);
			};

			case "PARADROP" : {
				["Paradrop parameters",[
					["SLIDER",["Jump delay","Seconds between each unit jumping out"],[[0,5,1],1]],
					["SLIDER","AI opening height",[[100,2000,0],200]]
				],{
					params ["_values","_args"];
					_args params ["_entity","_request","_position"];

					private _vehicle = _entity getVariable ["SSS_vehicle",objNull];

					if (!alive _vehicle) exitWith {};

					[_entity,_request,_position,_values] remoteExecCall [QEFUNC(support,requestTransportHelicopter),_vehicle];
				},{REQUEST_CANCELLED;},[_entity,_request,_position]] call EFUNC(CDS,dialog);
			};

			default {
				[_entity,_request,_position] remoteExecCall [QEFUNC(support,requestTransportHelicopter),_vehicle];
			};
		};
	};

	case "transportLandVehicle" : {
		private _vehicle = _entity getVariable ["SSS_vehicle",objNull];

		if (!alive _vehicle) exitWith {};

		[_entity,_request,_position] remoteExecCall [QEFUNC(support,requestTransportLandVehicle),_vehicle];
	};

	case "transportMaritime" : {
		private _vehicle = _entity getVariable ["SSS_vehicle",objNull];

		if (!alive _vehicle) exitWith {};

		[_entity,_request,_position] remoteExecCall [QEFUNC(support,requestTransportMaritime),_vehicle];
	};

	case "transportPlane" : {
		private _vehicle = _entity getVariable ["SSS_vehicle",objNull];

		if (!alive _vehicle) exitWith {};

		switch (_request) do {
			case "PARADROP";
			case 2 : {
				["Paradrop parameters",[
					["SLIDER",["Jump delay","Seconds between each unit jumping out"],[[0,5,1],1]],
					["SLIDER","AI opening height",[[100,2000,0],200]]
				],{
					params ["_values","_args"];
					_args params ["_entity","_request","_position"];

					private _vehicle = _entity getVariable ["SSS_vehicle",objNull];

					if (!alive _vehicle) exitWith {};

					[_entity,_request,_position,_values] remoteExecCall [QEFUNC(support,requestTransportPlane),_vehicle];
				},{REQUEST_CANCELLED;},[_entity,_request,_position]] call EFUNC(CDS,dialog);
			};

			case "LOITER";
			case 3 : {
				["Loiter parameters",[
					["SLIDER","Loiter radius",[[500,1500,0],500]],
					["COMBOBOX","Loiter direction",[[["Clockwise","",ICON_CLOCKWISE],["Counter-Clockwise","",ICON_COUNTER_CLOCKWISE]],0]]
				],{
					params ["_values","_args"];
					_args params ["_entity","_request","_position"];

					private _vehicle = _entity getVariable ["SSS_vehicle",objNull];

					if (!alive _vehicle) exitWith {};

					[_entity,_request,_position,_values] remoteExecCall [QEFUNC(support,requestTransportPlane),_vehicle];
				},{REQUEST_CANCELLED;},[_entity,_request,_position]] call EFUNC(CDS,dialog);
			};

			default {
				[_entity,_request,_position] remoteExecCall [QEFUNC(support,requestTransportPlane),_vehicle];
			};
		};
	};

	case "transportVTOL" : {
		private _vehicle = _entity getVariable ["SSS_vehicle",objNull];

		if (!alive _vehicle) exitWith {};

		switch (_request) do {
			case "PARADROP";
			case 5 : {
				["Paradrop parameters",[
					["SLIDER",["Jump delay","Seconds between each unit jumping out"],[[0,5,1],1]],
					["SLIDER","AI opening height",[[100,2000,0],200]]
				],{
					params ["_values","_args"];
					_args params ["_entity","_request","_position"];

					private _vehicle = _entity getVariable ["SSS_vehicle",objNull];

					if (!alive _vehicle) exitWith {};

					[_entity,_request,_position,_values] remoteExecCall [QEFUNC(support,requestTransportPlane),_vehicle];
				},{REQUEST_CANCELLED;},[_entity,_request,_position]] call EFUNC(CDS,dialog);
			};

			case "LOITER";
			case 6 : {
				["Loiter parameters",[
					["SLIDER","Loiter radius",[[500,1500,0],500]],
					["COMBOBOX","Loiter direction",[[["Clockwise","",ICON_CLOCKWISE],["Counter-Clockwise","",ICON_COUNTER_CLOCKWISE]],0]]
				],{
					params ["_values","_args"];
					_args params ["_entity","_request","_position"];

					private _vehicle = _entity getVariable ["SSS_vehicle",objNull];

					if (!alive _vehicle) exitWith {};

					[_entity,_request,_position,_values] remoteExecCall [QEFUNC(support,requestTransportVTOL),_vehicle];
				},{REQUEST_CANCELLED;},[_entity,_request,_position]] call EFUNC(CDS,dialog);
			};

			default {
				[_entity,_request,_position] remoteExecCall [QEFUNC(support,requestTransportVTOL),_vehicle];
			};
		};
	};

	case "logisticsAirdrop" : {
		[_entity,_position,_player] call EFUNC(support,requestLogisticsAirdrop);
	};
};
