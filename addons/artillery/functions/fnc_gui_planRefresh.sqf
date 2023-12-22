#include "script_component.hpp"

private _display = uiNamespace getVariable QEGVAR(sdf,display);
private _ctrlPlan = _display displayCtrl IDC_INSTRUCTIONS_GROUP controlsGroupCtrl IDC_PLAN_GROUP controlsGroupCtrl IDC_PLAN;
private _cfgMagazines = configFile >> "CfgMagazines";
private _entity = PVAR(guiEntity);

lnbClear _ctrlPlan;

{
	_x params ["_area","_sheaf","_magazines","_rounds","_execDelay","_firingDelay"];

	private _magName = "---";
	private _magToolTip = "";
	private _mag = "";

	if (_magazines isNotEqualTo []) then {
		_mag = _magazines # 0;

		if (count _magazines > 1) then {
			_magName = LLSTRING(MixedAmmo);
			_magToolTip = str (_magazines apply {getText (_cfgMagazines >> _x >> "displayName")});
		} else {
			_magName = getText (_cfgMagazines >> _mag >> "displayName");
		};
	};

	[_area # 0] call EFUNC(common,getMapGridFromPos) params ["_easting","_northing"];

	// LOCALIZE THIS
	_ctrlPlan lnbAddRow [
		format ["%1 E %2 N",_easting,_northing],
		GVAR(sheafNames) get _sheaf,
		_magName,
		str _rounds,//format ["%1 x %2",_rounds,count (_entity getVariable QPVAR(vehicles))],//str _rounds,
		str _execDelay,
		str _firingDelay
	];

	_ctrlPlan lnbSetTooltip [[_forEachIndex,2],_magToolTip];
} forEach GVAR(plan);
