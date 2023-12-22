#include "script_component.hpp"

params ["_validService","_validGUI"];

private _display = uiNamespace getVariable [QEGVAR(sdf,display),displayNull];

if (!hasInterface ||
	isNull _display ||
	{uiNamespace getVariable [QEGVAR(sdf,displayClass),""] != _validGUI} ||
	{isNil QPVAR(guiEntity)} ||
	{PVAR(guiEntity) getVariable [QPVAR(service),""] != _validService}
) exitWith {true};

// Prevent spam
if (_display getVariable [QGVAR(frameNo),0] == diag_frameNo) exitWith {true};
_display setVariable [QGVAR(frameNo),diag_frameNo];

// Re-open gui if player loses authorization
if !([call CBA_fnc_currentUnit,PVAR(guiEntity),PVAR(terminalEntity) == PVAR(guiEntity)] call FUNC(isAuthorized)) exitWith {
	systemChat LLSTRING(LostAuthorization);
	_validService call FUNC(openGUI);
	true
};

// Update entity list statuses
private _ctrlEntity = _display displayCtrl IDC_ENTITY;

{
	if (isNull _x) then {
		_ctrlEntity lbSetText [_forEachIndex,"NULL"];
		_ctrlEntity lbSetTooltip [_forEachIndex,""];
		_ctrlEntity lbSetColor [_forEachIndex,RGBA_RED];
		_ctrlEntity lbSetPicture [_forEachIndex,""];
		_ctrlEntity lbSetPictureColor [_forEachIndex,RGBA_RED];
		continue;
	};
	
	[_x,0] call FUNC(status) params ["_statusText","_statusColor"];

	_ctrlEntity lbSetText [_forEachIndex,_x getVariable QPVAR(callsign)];
	_ctrlEntity lbSetTooltip [_forEachIndex,_statusText];
	_ctrlEntity lbSetColor [_forEachIndex,_statusColor];
	_ctrlEntity lbSetPicture [_forEachIndex,_x getVariable QPVAR(icon)];
	_ctrlEntity lbSetPictureColor [_forEachIndex,_statusColor];
} forEach (_ctrlEntity getVariable QGVAR(entities));

false
