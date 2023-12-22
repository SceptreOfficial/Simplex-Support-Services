#include "script_component.hpp"

disableSerialization;
params [["_ctrl",0,[0,controlNull]],["_show",true,[true]]];

if (_ctrl isEqualType 0) then {
	_ctrl = (uiNamespace getVariable QGVAR(controls)) # _ctrl;
};

if (isNil {_ctrl getVariable QGVAR(position)}) then {
	_ctrl setVariable [QGVAR(position),ctrlPosition _ctrl];
};

if (_show) then {
	_ctrl ctrlShow true;
	_ctrl ctrlSetPosition (_ctrl getVariable QGVAR(position));
	_ctrl ctrlCommit 0;
	{[_x,true] call FUNC(show)} forEach (_ctrl getVariable [QGVAR(controls),[]]);

	switch ((_ctrl getVariable QGVAR(parameters)) param [0,""]) do {
		case "SLIDER" : {
			private _ctrlEdit = _ctrl getVariable QGVAR(ctrlEdit);
			_ctrlEdit ctrlShow true;
			_ctrlEdit ctrlSetPosition (_ctrlEdit getVariable QGVAR(position));
			_ctrlEdit ctrlCommit 0;
		};
		case "LISTNBOX";
		case "LISTNBOXCB";
		case "LISTNBOXMULTI" : {
			private _ctrlBG = _ctrl getVariable QGVAR(ctrlBG);
			_ctrlBG ctrlShow true;
			_ctrlBG ctrlSetPosition (_ctrl getVariable QGVAR(position));
			_ctrlBG ctrlCommit 0;
		};
	};
} else {
	_ctrl ctrlShow false;
	_ctrl ctrlSetPosition [0,0,0,0];
	_ctrl ctrlCommit 0;
	{[_x,false] call FUNC(show)} forEach (_ctrl getVariable [QGVAR(controls),[]]);

	switch ((_ctrl getVariable QGVAR(parameters)) param [0,""]) do {
		case "SLIDER" : {
			private _ctrlEdit = _ctrl getVariable QGVAR(ctrlEdit);
			_ctrlEdit ctrlShow false;
			_ctrlEdit ctrlSetPosition [0,0,0,0];
			_ctrlEdit ctrlCommit 0;
		};
		case "LISTNBOX";
		case "LISTNBOXCB";
		case "LISTNBOXMULTI" : {
			private _ctrlBG = _ctrl getVariable QGVAR(ctrlBG);
			_ctrlBG ctrlShow false;
			_ctrlBG ctrlSetPosition [0,0,0,0];
			_ctrlBG ctrlCommit 0;
		};
	};
};
