#include "script_component.hpp"
/*
	Authors: Sceptre

	Checks if a player is authorized to use a support entity.
	If admin access options are enabled, normal checks are bypassed.
	Authorization check order:
		1: Entity exists
		2: Entity and player share the same side
		3: Remote access is enabled for the entity or the entity is being interacted with directly/terminal
		4: Player's unique key is in entity's key authorization list (may be ignored for direct access)
		5: Custom access condition code returns true
		6: Player possesses an 'access item' (may be ignored for direct access/terminal)

	Parameters:
	0: Player <OBJECT>
	1: Support entity <OBJECT>
	2: Terminal access (used via interaction) <BOOL>

	Returns:
	Authorization validity <BOOL>
*/
params [["_unit",objNull],["_entity",objNull],["_terminalAccess",false,[false]]];

if (isNull _unit || isNull _entity) exitWith {false};

if (OPTION(adminAccess) && {serverCommandAvailable "#kick" || !isMultiplayer}) exitWith {
	if (OPTION(adminSide)) then {
		_entity getVariable QPVAR(side) == side group _unit
	} else {
		true
	};
};

_entity getVariable QPVAR(side) == side group _unit && {
	_entity getVariable QPVAR(remoteAccess) || _terminalAccess
} && {
	private _key = _unit getVariable QPVAR(key);
	private _auth = _entity getVariable [QPVAR(auth),[]];

	if (isNil "_key") then {
		_key = call FUNC(generateKey);
		_unit setVariable [QPVAR(key),_key,true];
	};

	_auth isEqualTo [] || _key in _auth || {_terminalAccess && !OPTION(terminalRequireAuth)}
} && {
	private _accessItems = _entity getVariable QPVAR(accessItems);
	private _items = _unit call FUNC(uniqueUnitItems);
	private _cfgWeapons = configFile >> "CfgWeapons";

	[_unit,_items,_accessItems,_entity] call (_entity getVariable QPVAR(accessCondition)) && {
		_accessItems isEqualTo [] || {
			if (_entity getVariable QPVAR(accessItemsLogic)) then {
				// Check for any matching item
				_accessItems arrayIntersect _items isNotEqualTo []
			} else {
				// Require all items
				_accessItems arrayIntersect _items isEqualTo _accessItems
			}
		} || {
			// Radio mod compat - checks for parent classes
			_items findIf {
				private _item = _x;
				_accessItems findIf {_item isKindOf [_x,_cfgWeapons] || {_item isKindOf _x}} > -1
			} > -1
		} || {
			_terminalAccess && !OPTION(terminalRequireItems)
		}
	}
}
