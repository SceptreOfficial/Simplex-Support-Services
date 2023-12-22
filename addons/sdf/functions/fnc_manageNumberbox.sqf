#include "script_component.hpp"

params ["_ctrlEdit",["_value",0,[0,""]],"_onValueChanged",["_suffix",""]];

_ctrlEdit setVariable [QGVAR(onValueChanged),_onValueChanged];
_ctrlEdit setVariable [QGVAR(suffix),_suffix];

if (_value isEqualType "") then {_value = parseNumber _value};

_ctrlEdit ctrlSetText (str _value + _suffix);

private _IDs = _ctrlEdit getVariable QGVAR(manageIDs);

if (!isNil "_IDs") then {
	_ctrlEdit ctrlRemoveEventHandler ["KeyUp",_IDs # 0];
	_ctrlEdit ctrlRemoveEventHandler ["KillFocus",_IDs # 1];
	_ctrlEdit ctrlRemoveEventHandler ["SetFocus",_IDs # 2];
};

_ctrlEdit setVariable [QGVAR(manageIDs),[
	[_ctrlEdit,"KeyUp",{
		params ["_ctrlEdit","_key"];

		private _value = parseNumber ctrlText _ctrlEdit;
		
		if (_key in [28,156]) then {
			_ctrlEdit ctrlSetText (str _value + (_ctrlEdit getVariable QGVAR(suffix)));
			_ctrlEdit ctrlSetTextSelection [0,0];
		};

		[_ctrlEdit,_value] call (_ctrlEdit getVariable QGVAR(onValueChanged));
	}] call CBA_fnc_addBISEventHandler,

	[_ctrlEdit,"KillFocus",{
		params ["_ctrlEdit"];

		private _value = parseNumber ctrlText _ctrlEdit;

		_ctrlEdit ctrlSetText (str _value + (_ctrlEdit getVariable QGVAR(suffix)));
		_ctrlEdit ctrlSetTextSelection [0,0];
	}] call CBA_fnc_addBISEventHandler,

	[_ctrlEdit,"SetFocus",{
		params ["_ctrlEdit"];
		uiNamespace setVariable [QGVAR(editFocus),_ctrlEdit];

		private _value = parseNumber ctrlText _ctrlEdit;
		
		_ctrlEdit ctrlSetText str _value;
	}] call CBA_fnc_addBISEventHandler
]];
