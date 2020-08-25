#include "script_component.hpp"

params [["_entity",objNull,[objNull]],["_position",[],[[]]],["_player",objNull,[objNull]]];

if (isNull _entity) exitWith {};

if ((_entity getVariable "SSS_cooldown") > 0) exitWith {
	NOTIFY_LOCAL_NOT_READY_COOLDOWN(_entity);
};

COMPILE_LOGISTICS_LISTS;

if (_list isEqualTo []) exitWith {
	SSS_ERROR(localize LSTRING(InvalidLogisticsList));
};

private _maxAmount = _entity getVariable "SSS_maxAmount";

[localize LSTRING(SelectObject),[
	["EDITBOX",localize LSTRING(Find),"",true,{
		params ["_value","_args"];
		
		private _searchList = _args # 4;
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
	["LISTNBOX",localize LSTRING(AvailableObjects),[_beautifiedList,0,10]],
	["SLIDER",localize LSTRING(Amount),[[1,_maxAmount,0],1],true,{},_maxAmount >= 1]
],{
	params ["_values","_args"];
	_values params ["_find","_selection","_amount"];
	_args params ["_entity","_position","_player","_list"];

	if (_selection isEqualTo -1) exitWith {};

	if ((_entity getVariable "SSS_cooldown") > 0) exitWith {
		NOTIFY_LOCAL_NOT_READY_COOLDOWN(_entity);
	};

	[_entity,_position,_player,_list # _selection,_amount] remoteExecCall [QFUNC(logisticsStartAirdrop),2];
},{},[_entity,_position,_player,_list,_searchList]] call EFUNC(CDS,Dialog);
