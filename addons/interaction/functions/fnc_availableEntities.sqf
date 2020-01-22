#include "script_component.hpp"

params ["_target","_service"];

private _targetSide = side group _target;

if (SSS_setting_adminFullAccess && {serverCommandAvailable "#kick" || !isMultiplayer}) exitWith {
	if (SSS_setting_adminLimitSide) then {
		SSS_entities select {!isNull _x && {(_x getVariable "SSS_service") == _service && {_x getVariable "SSS_side" == _targetSide}}}
	} else {
		SSS_entities select {!isNull _x && {(_x getVariable "SSS_service") == _service}}
	}
};

private _targetItems = assignedItems _target;
_targetItems append uniformItems _target;
_targetItems append vestItems _target;
_targetItems append backpackItems _target;
_targetItems append [
	headgear _target,
	goggles _target,
	uniform _target,
	vest _target,
	backpack _target,
	primaryWeapon _target,
	secondaryWeapon _target,
	handgunWeapon _target
];
_targetItems = _targetItems apply {toLower _x};

SSS_entities select {
	private _accessItems = _x getVariable "SSS_accessItems";

	!isNull _x && {
	(_x getVariable "SSS_service") == _service && {
	_x getVariable "SSS_side" == _targetSide && {
	(_accessItems isEqualTo [] || !((_accessItems arrayIntersect _targetItems) isEqualTo [])) && {
	[] call (_x getVariable "SSS_accessCondition")
}}}}}
