#include "script_component.hpp"

params ["_target","_service"];

private _availableEntities = switch (true) do {
	case (SSS_setting_adminFullAccess && {serverCommandAvailable "#kick" || !isMultiplayer}) : {
		if (SSS_setting_adminLimitSide) then {
			private _side = side _target;
			SSS_entities select {!isNull _x && {(_x getVariable "SSS_service") == _service && {_x getVariable "SSS_side" == _side}}}
		} else {
			SSS_entities select {!isNull _x && {(_x getVariable "SSS_service") == _service}}
		}
	};

	case !(SSS_specialItemsArray isEqualTo []) : {
		private _items = assignedItems _target;
		_items append uniformItems _target;
		_items append vestItems _target;
		_items append backpackItems _target;

		private _hasSpecialItem = !(((_items apply {toLower _x}) arrayIntersect SSS_specialItemsArray) isEqualTo []);

		if (SSS_setting_specialItemsLogic) then {
			if (_hasSpecialItem) then {
				(_target getVariable ["SSS_assignedEntities",[]]) select {!isNull _x && {(_x getVariable "SSS_service") == _service}}
			} else {
				[]
			}
		} else {
			if (_hasSpecialItem) then {
				if (SSS_setting_specialItemsLimitSide) then {
					private _side = side _target;
					SSS_entities select {!isNull _x && {(_x getVariable "SSS_service") == _service && {_x getVariable "SSS_side" == _side}}}
				} else {
					SSS_entities select {!isNull _x && {(_x getVariable "SSS_service") == _service}}
				};
			} else {
				(_target getVariable ["SSS_assignedEntities",[]]) select {!isNull _x && {(_x getVariable "SSS_service") == _service}}
			}
		}
	};

	default {
		(_target getVariable ["SSS_assignedEntities",[]]) select {!isNull _x && {(_x getVariable "SSS_service") == _service}}
	};
};

_availableEntities
