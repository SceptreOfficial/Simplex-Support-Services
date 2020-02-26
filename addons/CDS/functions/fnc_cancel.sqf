#include "script_component.hpp"

disableSerialization;
GVAR(PFHID) call CBA_fnc_removePerFrameHandler;

private _values = (uiNamespace getVariable QGVAR(controls)) apply {	
	private _data = _x getVariable QGVAR(data);
	switch (_data # 0) do {
		case "CHECKBOX";
		case "EDITBOX";
		case "BUTTON" : {_data # 2};
		case "SLIDER";
		case "COMBOBOX";
		case "LISTNBOX" : {_data # 2 # 1};
	}
};

closeDialog 0;

[{isNull (uiNamespace getVariable QGVAR(display))},{
	params ["_values","_arguments","_code"];
	[_values,_arguments] call _code;
},[_values,uiNamespace getVariable QGVAR(arguments),uiNamespace getVariable QGVAR(onCancel)]] call CBA_fnc_waitUntilAndExecute;
