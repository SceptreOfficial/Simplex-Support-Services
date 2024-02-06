#include "..\script_component.hpp"

params ["_logic"];

if (!isNil {_logic getVariable QGVAR(reference)}) exitWith {_logic getVariable QGVAR(reference)};

_logic getVariable ["ObjectArea",[]] params [
	["_width",10,[0]],
	["_length",10,[0]],
	["_direction",0,[0]],
	["_isRectangle",true,[false]],
	["_height",10,[0]]
];

private _area = [getPosATL _logic,_width,_length,_direction,_isRectangle,_height];
private _infantry = _logic getVariable ["Infantry",0];
private _delete = _logic getVariable ["Behavior","MONITOR"] == "INITIATE";
private _filter = _logic getVariable ["Filter","false"];
private _loadEval = _logic getVariable ["LoadEval","1"];
private _itemInit = _logic getVariable ["ItemInit",""];

if (_filter isEqualType "") then {
	if (_filter isEqualTo "") then {_filter = "false"};
	_filter = compile _filter;
	_logic setVariable ["Filter",_filter];
};

if (_loadEval isEqualType "") then {
	if (_loadEval isEqualTo "") then {_loadEval = "1"};
	_loadEval = compile _loadEval;
	_logic setVariable ["LoadEval",_loadEval];
};

if (_itemInit isEqualType "") then {
	_itemInit = compile _itemInit;
	_logic setVariable ["ItemInit",_itemInit];
};

private _initObj = {call FUNC(refInitObject)};
private _initMan = {call FUNC(refInitMan)};
private _initGroup = {call FUNC(refInitGroup)};
private _list = [];
private _groups = [];

{
	if (!(_x isKindOf "AllVehicles" || _x isKindOf "Thing") ||
		{_x isKindOf "Animal"} ||
		{_x isKindOf "ThingEffect"} ||
		{_x call _filter}
	) then {continue};
		
	if (_x isKindOf "CAManBase") then {
		switch _infantry do {
			case 0 : {continue};
			case 1 : {[_initMan,[getUnitLoadout _x,_itemInit,_x getVariable [QGVAR(init),{}],_x getVariable [QGVAR(args),[]]]]};
			case 2 : {
				private _group = group _x;

				if (_group in _groups) then {continue};
				_groups pushBack _group;

				private _totalLoad = 0;
				private _loadouts = [];
				private _units = [];

				{
					if (!alive _x) then {continue};

					private _load = _x getVariable QGVAR(load);
					if (isNil "_load") then {_load = _x call _loadEval};

					_totalLoad = _totalLoad + _load;
					_loadouts pushBack getUnitLoadout _x;
					_units pushBack typeOf _x;

					if (_delete) then {deleteVehicle _x};
				} forEach units _group;

				if (_units isEqualTo []) then {continue};

				_group getVariable [QGVAR(formatting),[]] params [["_name",""],["_icon",""],["_tooltip",""],["_info",""]];
				if (_name isEqualTo "") then {_name = groupId _group};
				if (_icon isEqualTo "") then {_icon = ICON_GROUP} else {_icon = _icon call EFUNC(common,icon)};

				_list pushBack [
					_units,
					[_name,_icon,_tooltip,_info],
					_initGroup,
					[_loadouts,_itemInit,_group getVariable [QGVAR(init),{}],_group getVariable [QGVAR(args),[]]],
					_totalLoad,
					_group getVariable [QGVAR(requestLimit),-1],
					_group getVariable [QGVAR(quantity),""]
				];

				continue;
			};
		};
	} else {
		[_initObj,[_x call BIS_fnc_getVehicleCustomization,_x call EFUNC(common,serializeInventory),_itemInit,_x getVariable [QGVAR(init),{}],_x getVariable [QGVAR(args),[]]]]
	} params ["_init","_args"];

	_x getVariable [QGVAR(formatting),[]] params [["_name",""],["_icon",""],["_tooltip",""],["_info",""]];
	if (_name isEqualTo "") then {_name = getText (configOf _x >> "displayName")};
	if (_icon isEqualTo "") then {_icon = [_x,true] call EFUNC(common,getIcon)} else {_icon = _icon call EFUNC(common,icon)};

	private _load = _x getVariable QGVAR(load);
	if (isNil "_load") then {_load = _x call _loadEval};

	_list pushBack [typeOf _x,[_name,_icon,_tooltip,_info],_init,_args,_load,_x getVariable [QGVAR(requestLimit),-1],_x getVariable [QGVAR(quantity),""]];

	if (_delete) then {
		deleteVehicleCrew _x;
		deleteVehicle _x;
	};
} forEach ((getPosATL _logic nearEntities ((_width max _length max _height) * 1.5)) inAreaArray _area);

[_logic getVariable ["Category",""],_list]
