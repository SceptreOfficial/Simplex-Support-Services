#include "script_component.hpp"

params ["_service"];

private _title = switch (_service) do {
	case "CASDrones" : {"Remove CAS Drone(s)"};
	case "CASPlanes" : {"Remove CAS Plane(s)"};
	case "CASGunships" : {"Remove CAS Gunship(s)"};
};

[_title,[
	["COMBOBOX","Side",[["BLUFOR","OPFOR","Independent"],0],true,{
		params ["_currentValue","_service"];

		private _side = [west,east,independent] # _currentValue;
		private _displayNames = (missionNamespace getVariable [format ["SSS_%1_%2",_service,_side],[]]) apply {_x getVariable "SSS_displayName"};
		[1,[_displayNames,0]] call SSS_CDS_fnc_setValues;
	}],
	["COMBOBOX","Callsign",[[],0]]
],{
	params ["_values","_service"];
	_values params ["_sideSelection","_selection"];

	if (_selection isEqualTo -1) exitWith {};

	private _side = [west,east,independent] # _sideSelection;
	((missionNamespace getVariable [format ["SSS_%1_%2",_service,_side],[]]) # _selection) remoteExecCall ["SSS_fnc_remove",2];
},{},_service] call SSS_CDS_fnc_dialog;
