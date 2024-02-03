#include "..\script_component.hpp"

params ["_entity"];

if (_entity isKindOf QGVAR(moduleRestrictAccess)) exitWith {
	private _modules = [];
	private _keys = [call FUNC(generateKey)];

	{
		_x params ["_connection","_object"];

		if (_connection isNotEqualTo "Sync") then {continue};

		if (_object isKindOf "CAManBase") then {
			private _key = _object get3DENAttribute QPVAR(key);
			
			if (_key in [[],[""]]) then {
				_key = [call FUNC(generateKey)];
				_object set3DENAttribute [QPVAR(key),_key # 0];
			};

			_keys pushBack (_key # 0);
		};

		if (typeOf _object in (uiNamespace getVariable [QGVAR(supportModules),[]])) then {
			_object set3DENAttribute [QPVAR(auth),""];
			_modules pushBack _object;
		};
	} forEach (get3DENConnections _entity);

	{_x set3DENAttribute [QPVAR(auth),str _keys]} forEach _modules;
};

if (typeOf _entity in (uiNamespace getVariable [QGVAR(supportModules),[]]) &&
	{(get3DENConnections _entity) findIf {(_x # 1) isKindOf QGVAR(moduleRestrictAccess)} == -1}
) exitWith {
	_entity set3DENAttribute [QPVAR(auth),""];
};
