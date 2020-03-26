#include "script_component.hpp"

disableSerialization;
GVAR(PFHID) call CBA_fnc_removePerFrameHandler;

private _values = (uiNamespace getVariable QGVAR(controls)) apply {
	private _data = _x getVariable QGVAR(data);
	switch (_data # 0) do {
		case "CHECKBOX";
		case "EDITBOX";
		case "BUTTON" : {
			private _value = _data # 2;
			GVAR(cache) setVariable [[uiNamespace getVariable QGVAR(title),_data # 1,_data # 0] joinString "~",_value];
			_value
		};
		case "SLIDER";
		case "COMBOBOX";
		case "LISTNBOX" : {
			private _value = _data # 2 # 1;
			GVAR(cache) setVariable [[uiNamespace getVariable QGVAR(title),_data # 1,_data # 0,_data # 2 # 0] joinString "~",_value];
			_value
		};
	}
};

closeDialog 0;

[{isNull (uiNamespace getVariable QGVAR(display))},{
	params ["_values","_arguments","_code"];
	[_values,_arguments] call _code;
},[_values,uiNamespace getVariable QGVAR(arguments),uiNamespace getVariable QGVAR(onConfirm)]] call CBA_fnc_waitUntilAndExecute;
