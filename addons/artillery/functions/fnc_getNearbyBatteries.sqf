#include "..\script_component.hpp"

params ["_entity","_center","_magazines"];

if (_magazines isEqualTo []) exitWith {[]};

private _coordinationType = _entity getVariable [QPVAR(coordinationType),0];
private _nearbyBatteries = [];

{
	if (!alive _x) then {continue};

	private _xEntity = _x getVariable [QPVAR(entity),objNull];

	if (_xEntity isEqualTo _entity || _xEntity in _nearbyBatteries) then {continue};

	if (isNull _xEntity) then {
		if (_coordinationType isEqualTo 0) exitWith {};

		private _xMagazines = if (_x isKindOf "B_Ship_MRLS_01_base_F") then {
			["magazine_Missiles_Cruise_01_x18","magazine_Missiles_Cruise_01_Cluster_x18"]
		} else {
			getArtilleryAmmo [_x]
		};

		if ((_magazines arrayIntersect _xMagazines) isEqualTo _magazines) then {
			_nearbyBatteries pushBack _x;
		};
	} else {
		if (_coordinationType isEqualTo 1 || _xEntity getVariable [QPVAR(service),""] isNotEqualTo QSERVICE) exitWith {};

		private _xCenter = (_xEntity getVariable [QPVAR(vehicles),[]]) call EFUNC(common,positionAvg);

		if (_center distance2D _xCenter < (_xEntity getVariable [QPVAR(coordinationDistance),1e39]) &&
			{(_magazines arrayIntersect ((_xEntity getVariable QPVAR(ammunition)) apply {_x # 0})) isEqualTo _magazines}
		) then {
			_xEntity setVariable [QGVAR(center),_xCenter];
			_nearbyBatteries pushBack _xEntity;
		};
	};
} forEach (ASLtoAGL _center nearEntities (_entity getVariable [QPVAR(coordinationDistance),100]));

[_nearbyBatteries,true,{
	private _entity = _x getVariable [QPVAR(entity),objNull];

	if (isNull _entity) then {
		_center distance2D _x
	} else {
		_center distance2D (_entity getVariable QGVAR(center))
	}
}] call EFUNC(common,sortBy)
