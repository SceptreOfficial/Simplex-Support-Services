#include "script_component.hpp"

params ["_ctrlItems","_entity"];

GVAR(list) = [];
tvClear _ctrlItems;

{
	_x call FUNC(reference) params ["_category","_list"];

	private _parent = [];

	if (_category isNotEqualTo "") then {
		_parent = _parent + [_ctrlItems tvAdd [_parent,_category]];
	};

	{
		_x params ["_class","_formatting","_init","_args","_load","_requestLimit","_quantity"];
		_formatting params ["_name","_icon","_tooltip","_info"];

		if (_quantity isEqualType 0) then {
			if (_quantity >= 0) then {
				_possess = true;
				private _var = GEN_STR(_class);
				_entity setVariable [_var,_quantity];
				_quantity = _var;
			} else {
				_quantity = "";
			};
		} else {
			if (_entity getVariable [_quantity,-1] == 0) then {continue};
		};

		_x set [6,_quantity];

		private _index = GVAR(list) pushBack _x;
		private _path = _parent + [_ctrlItems tvAdd [_parent,_name]];
		_ctrlItems tvSetPicture [_path,_icon];
		_ctrlItems tvSetTooltip [_path,""];
		_ctrlItems tvSetData [_path,str _index];
		_ctrlItems setVariable [str _index,nil];
	} forEach _list;
} forEach (_entity getVariable [QPVAR(referenceAreas),[]]);

private _cfgVehicles = configFile >> "CfgVehicles";
private _parent = [];
private _possess = false;
private _possessedList = [];
private _possessedRef = _possessedList;
private _fnc_recursive = {
	if (_x isEqualTypeArray ["",[]] && {_x # 0 select [0,1] isEqualTo "#"}) then {
		_x params ["_name",["_children",[],[[]]]];

		private _possessedRef = _possessedList # (_possessedList pushBack [_name,[]]) # 1;
		private _parent = _parent + [_ctrlItems tvAdd [_parent,_name select [1]]];
		_fnc_recursive forEach _children;

		continue;
	};

	_x params [["_class","",["",[]]],["_formatting","",["",[]]],["_init",{},[{}]],["_args",[]],["_load",1,[0]],["_requestLimit",-1,[0]],["_quantity",-1,[0,""]]];
	_formatting params [["_name","",[""]],["_icon","",[""]],["_tooltip","",[""]],["_info","",[""]]];
	
	if (_class isEqualType []) then {
		private _valid = [];

		{
			if (!isClass (_cfgVehicles >> _x)) then {
				LOG_WARNING_1("Undefined class in logistics list: %1",_x);
			} else {
				_valid pushBack _x;
			};
		} forEach _class;

		if (_valid isEqualTo []) then {continue};
		if (_name isEqualTo "") then {_name = LLSTRING(group)};
		if (_icon isEqualTo "") then {_icon = ICON_GROUP} else {_icon = _icon call EFUNC(common,icon)};
	} else {
		private _cfg = _cfgVehicles >> _class;
	
		if (!isClass _cfg) then {
			LOG_WARNING_1("Undefined class in logistics list: %1",_class);
			continue;
		};

		if (_name isEqualTo "") then {_name = getText (_cfg >> "displayName")};
		if (_icon isEqualTo "") then {_icon = [_cfg,true] call EFUNC(common,getIcon)} else {_icon = _icon call EFUNC(common,icon)};
	};

	if (_quantity isEqualType 0) then {
		if (_quantity >= 0) then {
			_possess = true;
			private _var = GEN_STR(_class);
			_entity setVariable [_var,_quantity];
			_quantity = _var;
		} else {
			_quantity = "";
		};
	} else {
		if (_entity getVariable [_quantity,-1] == 0) then {continue};
	};

	private _index = GVAR(list) pushBack [_class,[_name,_icon,_tooltip,_info],_init,_args,_load,_requestLimit,_quantity];
	_possessedRef pushBack (GVAR(list) # _index);
	
	private _path = _parent + [_ctrlItems tvAdd [_parent,_name]];
	_ctrlItems tvSetPicture [_path,_icon];
	_ctrlItems tvSetTooltip [_path,_tooltip];
	_ctrlItems tvSetData [_path,str _index];
	_ctrlItems setVariable [str _index,nil];
};

if (isNil {_entity getVariable QGVAR(possessedList)}) then {
	_fnc_recursive forEach ([] call (_entity getVariable [QPVAR(listFunction),{}]));
} else {
	_fnc_recursive forEach (_entity getVariable QGVAR(possessedList));
};

_ctrlItems tvSetCurSel [0];

if (GVAR(list) isEqualTo []) then {
	LOG_WARNING_1("No valid items in list for ""%1""",_entity getVariable QPVAR(callsign));
};

if (_possess) then {
	_entity setVariable [QGVAR(possessedList),_possessedList,true];
};
