#include "script_component.hpp"

params ["_target","_player","_args"];
_args params ["_entity","_request"];

if (missionNamespace getVariable format ["SSS_setting_milsimMode%1",_entity getVariable "SSS_service"]) then {
	["Map grid position",[
		["EDITBOX",["Grid","Supports up to a 10 digit grid reference"],""]
	],{
		params ["_values","_args"];
		_values params ["_grid"];
		_args params ["_target","_entity","_request"];

		if (_grid isEqualTo "") exitWith {
			titleText ["Request Cancelled - No grid input","PLAIN",0.5];
			[{titleFadeOut 0.5;},[],1] call CBA_fnc_waitAndExecute;
		};
		
		private _position = _grid call CBA_fnc_mapGridToPos;
		
		[_target,_entity,_request,_position] call FUNC(onMapClick);
	},{REQUEST_CANCELLED;},[_target,_entity,_request]] call EFUNC(CDS,dialog);
} else {
	SSS_mapWasOpened = visibleMap;
	SSS_mapClicked = false;

	openMap [true,false];
	titleText ["Select Position","PLAIN",0.5];

	["SSS_selectPosition","onMapSingleClick",{
		params ["_units","_position","_alt","_shift","_target","_entity","_request"];

		["SSS_selectPosition","onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;

		SSS_mapClicked = true;
		titleFadeOut 0.5;
		if (!SSS_mapWasOpened) then {
			openMap [false,false];
		};

		[_target,_entity,_request,_position] call FUNC(onMapClick);
	},[_target,_entity,_request]] call BIS_fnc_addStackedEventHandler;

	[{!visibleMap || SSS_mapClicked},{
		if (!SSS_mapClicked) then {
			["SSS_selectPosition","onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;

			titleFadeOut 0.5;
			REQUEST_CANCELLED;
		};
	}] call CBA_fnc_waitUntilAndExecute;
};
