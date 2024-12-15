#include "..\script_component.hpp"
#define IDD_RSCDISPLAYCURATOR 312

disableSerialization;
params [["_enterCode",{},[{}]],["_customArguments",[]],["_message",LLSTRING(zeusSelectionItems),[""]]];

[_message,"FD_Finish_F"] call FUNC(zeusMessage);

[findDisplay IDD_RSCDISPLAYCURATOR,"KeyDown",{
	params ["_display","_key"];
	_thisArgs params ["_enterCode","_customArguments"];

	//Escape
	if (_key == 0x01) exitWith {
		_display displayRemoveEventHandler [_thisType,_thisID];
		[LLSTRING(zeusSelectionCancelled)] call FUNC(zeusMessage);
		true
	};

	//Enter
	if (_key == 0x1C) exitWith {
		_display displayRemoveEventHandler [_thisType,_thisID];
		[LLSTRING(zeusSelectionSubmitted)] call FUNC(zeusMessage);

		// _curatorSelected params ["_objects","_groups","_waypoints","_markers"];
		[_enterCode,[curatorSelected,_customArguments]] call CBA_fnc_execNextFrame;
		
		true
	};

	false
},[_enterCode,_customArguments]] call CBA_fnc_addBISEventHandler;
