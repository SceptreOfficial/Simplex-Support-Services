#include "script_component.hpp"

disableSerialization;
params [["_onClose",{},[{}]],["_cacheValues",false,[false]]];

private _values = if (_cacheValues) then {
	private _title = uiNamespace getVariable QGVAR(title);
	
	(uiNamespace getVariable QGVAR(controls)) apply {
		private _value = _x getVariable QGVAR(value);
		private _params = _x getVariable QGVAR(parameters);

		switch (_params # 0) do {
			case "CHECKBOX";
			case "EDITBOX" : {
				GVAR(cache) setVariable [
					[_title,_params # 1,_params # 0] joinString "~",
					_value
				];
			};
			case "SLIDER";
			case "ARRAY" : {
				GVAR(cache) setVariable [
					[_title,_params # 1,_params # 0,_params # 2 # 0] joinString "~",
					_value
				];
			};
			case "COMBOBOX";
			case "LISTNBOX";
			case "LISTNBOXCB";
			case "LISTNBOXMULTI";
			case "TOOLBOX" : {
				GVAR(cache) setVariable [
					[_title,_params # 1,_params # 0,_params # 2 # 0] joinString "~",
					_x getVariable QGVAR(selection)
				];
			};
		};

		_value
	};
} else {
	(uiNamespace getVariable QGVAR(controls)) apply {_x getVariable QGVAR(value)}
};

GVAR(PFHID) call CBA_fnc_removePerFrameHandler;
GVAR(exit) = true;

[{isNull (uiNamespace getVariable QGVAR(parent))},{
	params ["_values","_arguments","_code"];
	[_values,_arguments] call _code;
	[QGVAR(closed),[_values,_arguments]] call CBA_fnc_localEvent;
},[_values,uiNamespace getVariable QGVAR(arguments),_onClose]] call CBA_fnc_waitUntilAndExecute;

if (uiNamespace getVariable QGVAR(parent) isEqualType displayNull) then {
	closeDialog 0;
} else {
	(findDisplay IDD_RSCDISPLAYCURATOR) displayRemoveEventHandler ["KeyDown",GVAR(keyDownEHID)];
	[{ctrlDelete _this},uiNamespace getVariable QGVAR(parent)] call CBA_fnc_execNextFrame;
};
