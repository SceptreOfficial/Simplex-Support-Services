#include "..\script_component.hpp"

if ([QSERVICE,QGVAR(gui)] call EFUNC(common,gui_verify)) exitWith {};

private _display = uiNamespace getVariable QEGVAR(sdf,display);
private _player = call CBA_fnc_currentUnit;
private _entity = PVAR(guiEntity);

(_display displayCtrl IDC_STATUS) ctrlSetStructuredText parseText ([_entity,1] call EFUNC(common,status));
(_display displayCtrl IDC_ABORT) ctrlEnable (_entity getVariable [QPVAR(task),""] in ["MOVE","UNLOAD"]);

private _ctrlGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP;
private _ctrlItemsGroup = _ctrlGroup controlsGroupCtrl IDC_ITEMS_GROUP;
private _ctrlItems = _ctrlItemsGroup controlsGroupCtrl IDC_ITEMS;
private _ctrlSelection = _ctrlItemsGroup controlsGroupCtrl IDC_SELECTION;

private _overloaded = GVAR(load) > GVAR(capacity);
private _loadColor = [[1,1,1,1],RGBA_RED] select _overloaded;

private _ctrlLoad = _ctrlItemsGroup controlsGroupCtrl IDC_LOAD;
_ctrlLoad ctrlSetText format ["%1/%2",GVAR(load),GVAR(capacity)];
_ctrlLoad ctrlSetTextColor _loadColor;

private _overObjectLimit = GVAR(objectLimit) >= 0 && GVAR(objectCount) > GVAR(objectLimit);
private _objectColor = [[1,1,1,1],RGBA_RED] select _overObjectLimit;
private _overCrewLimit = GVAR(crewLimit) >= 0 && GVAR(crewCount) > GVAR(crewLimit);
private _crewColor = [[1,1,1,1],RGBA_RED] select _overCrewLimit;

private _ctrlObjectLimit = _ctrlItemsGroup controlsGroupCtrl IDC_OBJECT_LIMIT;
_ctrlObjectLimit ctrlSetText format ["%1/%2",GVAR(objectCount),GVAR(objectLimit)];
_ctrlObjectLimit ctrlSetTextColor _objectColor;

private _ctrlCrewLimit = _ctrlItemsGroup controlsGroupCtrl IDC_CREW_LIMIT;
_ctrlCrewLimit ctrlSetText format ["%1/%2",GVAR(crewCount),GVAR(crewLimit)];
_ctrlCrewLimit ctrlSetTextColor _crewColor;

private _overLimits = _overObjectLimit || _overCrewLimit;
private _selectionSize = (lnbSize _ctrlSelection) # 0;
private _selection = [];

for "_i" from 0 to (_selectionSize - 1) do {
	private _itemKey = _ctrlSelection lnbData [_i,0];
	private _item = GVAR(list) param [parseNumber _itemKey,[]];
	_selection pushBack _item;

	_ctrlSelection lnbSetColorRight [[_i,1],_loadColor];

	private _selectionCount = _ctrlItems getVariable [_itemKey,0];
	private _requestLimit = _item # 5;
	private _count = _entity getVariable [_item # 6,-1];

	if (_count >= 0) then {
		if (_requestLimit >= 0) then {
			_requestLimit = _requestLimit min _count;
		} else {
			_requestLimit = _requestLimit max _count;
		};
	};

	if (_requestLimit >= 0) then {
		private _color = if (_selectionCount > _requestLimit) then {
			_overLimits = true;
			RGBA_RED
		} else {
			[1,1,1,1]
		};

		_ctrlSelection lnbSetColor [[_i,1],_color];
		_ctrlSelection lnbSetText [[_i,1],format ["[%1/%2]",_selectionCount,_requestLimit]];
	};

	private _class = _item # 0;
	if (_class isEqualType "") then {_class = [_class]};

	private _flag = false;

	{
		if (_x isKindOf "CAManBase") then {
			if (!_overCrewLimit) then {continue};
			_flag = true;
		} else {
			if (!_overObjectLimit) then {continue};
			_flag = true;
		};

		if (_flag) exitWith {};
	} forEach _class;

	_ctrlSelection lnbSetColor [[_i,0],[[1,1,1,1],RGBA_RED] select _flag];
};

private _ctrlConfirm = _display displayCtrl IDC_CONFIRM;

if (_selectionSize == 0 || _overloaded || _overLimits || _entity getVariable [QPVAR(busy),false]) exitWith {
	_ctrlConfirm ctrlEnable false;
};

private _request = +GVAR(request);
_request set ["selection",_selection];

_ctrlConfirm ctrlEnable (+[_player,_entity,_request] call (_entity getVariable QPVAR(requestCondition)));
