#include "..\script_component.hpp"

[{
	params [["_target",objNull,[objNull]],["_event","",[""]],"_eventArgs"];

	if (isNull _target || _event isEqualTo "") exitWith {};

	private _hash = _target getVariable format ["%1:%2",QGVAR(event),_event];
	
	if (isNil "_hash") exitWith {};

	{[_target,_eventArgs,_x # 1] call _x # 0} forEach values _hash;
},_this] call CBA_fnc_directCall;
