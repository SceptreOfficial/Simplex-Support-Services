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
_targetItems = _targetItems arrayIntersect _targetItems;

private _cfgWeapons = configFile >> "CfgWeapons";

SSS_entities select {
	private _accessItems = _x getVariable "SSS_accessItems";
	private _hasAccessItems = if (_accessItems isEqualTo [] || !((_accessItems arrayIntersect _targetItems) isEqualTo [])) then {true} else {
		{
			private _item = _x;
			{
				_item isKindOf [_x,_cfgWeapons] || {_item isKindOf _x}
			} count _accessItems > 0;
		} count _targetItems > 0
	};

	!isNull _x && {
	(_x getVariable "SSS_service") == _service && {
	_x getVariable "SSS_side" == _targetSide && {
	_hasAccessItems && {
	[] call (_x getVariable "SSS_accessCondition")
}}}}}
