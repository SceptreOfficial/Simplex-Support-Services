#include "script_component.hpp"

params [["_target",objNull,[objNull]],["_player",objNull,[objNull]],["_entity",objNull,[objNull]]];

if (isNull _entity) exitWith {};

COMPILE_LOGISTICS_LISTS;

if (_list isEqualTo []) exitWith {
	SSS_ERROR(localize LSTRING(InvalidLogisticsList));
};

[localize LSTRING(SelectObject),[
	["EDITBOX",localize LSTRING(Find),"",true,{
		params ["_value","_args"];
		
		private _searchList = _args # 3;
		private _search = toLower _value;
		private _result = -1;
		private _listbox = (uiNamespace getVariable QEGVAR(CDS,controls)) # 1;
		private _listboxSelection = lnbCurSelRow _listbox;	

		if (_key == 0x1C) then {
			{
				if (_forEachIndex > _listboxSelection && {_search in _x}) exitWith {
					_result = _forEachIndex;
				};
			} forEach _searchList;
		};

		if (_result == -1) then {
			_result = _searchList findIf {_search in _x};
		};

		if (_result >= 0) then {
			_listbox lnbSetCurSelRow _result;
		};
	}],
	["LISTNBOX",localize LSTRING(AvailableObjects),[_beautifiedList,0,10]]
],{
	params ["_values","_args"];
	_values params ["_find","_selection"];
	_args params ["_entity","_player","_list"];

	if (_selection isEqualTo -1) exitWith {};

	["SSS_requestSubmitted",[_entity,[_selection]]] call CBA_fnc_globalEvent;
	
	(_list # _selection) params ["_objClass","_objText","_objInitFnc"];

	private _object = if (_objClass isKindOf "CAManBase") then {
		private _side = [east,west,independent,civilian] # (getNumber (configFile >> "CfgVehicles" >> _objClass >> "side"));
		private _group = createGroup [_side,true];
		private _object = _group createUnit [_objClass,ASLToAGL (_entity getVariable "SSS_spawnPointASL"),[],0,"NONE"];
		private _dir = (_entity getVariable "SSS_spawnDir");
		_object setFormDir _dir;
		_object setDir _dir;

		_object
	} else {
		private _object = createVehicle [_objClass,ASLToAGL (_entity getVariable "SSS_spawnPointASL"),[],0,"NONE"];
		_object setDir (_entity getVariable "SSS_spawnDir");

		_object
	};

	_object setVariable ["SSS_requester",_player,true];

	NOTIFY(_entity,FORMAT_1(localize LSTRING(ObjectDelivered),_objText));
	
	["SSS_requestCompleted",[_entity,[_object]]] call CBA_fnc_globalEvent;

	_object call _objInitFnc;
	_object call (_entity getVariable ["SSS_universalInitFnc",{}]);
},{},[_entity,_player,_list,_searchList]] call EFUNC(CDS,Dialog);
