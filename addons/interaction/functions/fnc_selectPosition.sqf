#include "script_component.hpp"

params ["_target","_player","_args"];
_args params ["_entity","_request"];

if (missionNamespace getVariable format ["SSS_setting_milsimMode%1",_entity getVariable "SSS_service"]) then {
	[localize LSTRING(MapGridPosition),[
		["EDITBOX",[localize LSTRING(Grid),localize LSTRING(Support10DigitsRef)],""]
	],{
		params ["_values","_args"];
		_values params ["_grid"];
		_args params ["_player","_entity","_request"];

		if (_grid isEqualTo "") exitWith {
			titleText [localize LSTRING(RequestCancelledNoGridInput),"PLAIN",0.5];
			[{titleFadeOut 0.5},[],1] call CBA_fnc_waitAndExecute;
		};
		
		private _position = [_grid, true] call CBA_fnc_mapGridToPos;
		
		[_player,_entity,_request,_position] call FUNC(onMapClick);
	},{REQUEST_CANCELLED;},[_player,_entity,_request]] call EFUNC(CDS,dialog);
} else {
	SSS_mapWasOpened = visibleMap;
	SSS_mapClicked = false;

	openMap [true,false];
	titleText [localize LSTRING(SelectPosition),"PLAIN",0.5];

	["SSS_selectPosition","onMapSingleClick",{
		params ["_units","_position","_alt","_shift","_player","_entity","_request"];

		["SSS_selectPosition","onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;

		SSS_mapClicked = true;
		titleFadeOut 0.5;
		if (!SSS_mapWasOpened) then {
			openMap [false,false];
		};

		[_player,_entity,_request,_position] call FUNC(onMapClick);
	},[_player,_entity,_request]] call BIS_fnc_addStackedEventHandler;

	[{!visibleMap || SSS_mapClicked},{
		if (!SSS_mapClicked) then {
			["SSS_selectPosition","onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;

			titleFadeOut 0.5;
			REQUEST_CANCELLED;
		};
	}] call CBA_fnc_waitUntilAndExecute;
};
