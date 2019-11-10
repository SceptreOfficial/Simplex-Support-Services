#include "script_component.hpp"

disableSerialization;
params [["_index",0,[0]]];

private _ctrl = (uiNamespace getVariable QGVAR(controls)) # _index;
private _data = _ctrl getVariable QGVAR(data);

switch (_data # 0) do {
	case "CHECKBOX";
	case "EDITBOX" : {_data # 2};
	case "SLIDER";
	case "COMBOBOX";
	case "LISTNBOX" : {_data # 2 # 1};
}
