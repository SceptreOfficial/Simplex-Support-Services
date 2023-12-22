#include "script_component.hpp"

params ["_ctrlEntity"];

private _entities = [call CBA_fnc_currentUnit,GVAR(guiService),PVAR(terminalEntity)] call FUNC(getEntities);

lbClear _ctrlEntity;

{
	_ctrlEntity lbAdd (_x getVariable [QPVAR(callsign),""]);
	_ctrlEntity lbSetPicture [_forEachIndex,_x getVariable [QPVAR(icon),""]];

	if (_x == PVAR(terminalEntity)) then {
		_ctrlEntity lbSetPictureRight [_forEachIndex,ICON_TERMINAL];
	};
} forEach _entities;

_ctrlEntity setVariable [QGVAR(entities),_entities];

_ctrlEntity lbSetCurSel (_entities find PVAR(guiEntity));

_ctrlEntity ctrlAddEventHandler ["LBSelChanged",{
	params ["_ctrlEntity","_lbCurSel"];

	if (_lbCurSel < 0) exitWith {
		ERROR("No longer exists");
	};

	private _entities = _ctrlEntity getVariable [QEGVAR(common,entities),[objNull]];
	private _entity = _entities select _lbCurSel;

	if (isNil "_entity" || isNull _entity || isNil {_entity getVariable QPVAR(service)}) exitWith {
		ERROR("No longer exists");
	};

	private _oldEntity = PVAR(guiEntity);
	GVAR(guiCache) set [GVAR(guiService),_entity];

	[QPVAR(entityChanged),[_entity,_oldEntity]] call CBA_fnc_localEvent;

	if (_entity getVariable QPVAR(gui) != _oldEntity getVariable QPVAR(gui)) exitWith {
		[GVAR(guiService),_entity,PVAR(terminalEntity) == _entity] call FUNC(openGUI);
	};

	PVAR(guiEntity) = _entity;

	[_ctrlEntity,_entity] call (_ctrlEntity getVariable QGVAR(onEntityChanged));
}];
