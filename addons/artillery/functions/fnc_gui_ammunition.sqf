#include "script_component.hpp"

[{
	params ["_ctrlAmmunition","_lbCurSel"];

	private _ctrlPlan = ctrlParent _ctrlAmmunition displayCtrl IDC_INSTRUCTIONS_GROUP controlsGroupCtrl IDC_PLAN_GROUP controlsGroupCtrl IDC_PLAN;
	private _magazines = _ctrlAmmunition call EFUNC(sdf,lbSelection) apply {GVAR(magTypes) # _x};

	GVAR(plan) # GVAR(planIndex) set [2,_magazines];

	if (_magazines isEqualTo []) then {
		_ctrlPlan lnbSetText [[GVAR(planIndex),2],"---"];
		_ctrlPlan lnbSetTooltip [[GVAR(planIndex),2],""];
	} else {
		private _cfgMagazines = configFile >> "CfgMagazines";

		if (count _magazines > 1) then {
			_ctrlPlan lnbSetText [[GVAR(planIndex),2],LLSTRING(MixedAmmo)];
			_ctrlPlan lnbSetTooltip [[GVAR(planIndex),2],str (_magazines apply {getText (_cfgMagazines >> _x >> "displayName")})];
		} else {
			_ctrlPlan lnbSetText [[GVAR(planIndex),2],getText (_cfgMagazines >> _magazines # 0 >> "displayName")];
			_ctrlPlan lnbSetTooltip [[GVAR(planIndex),2],""];
		};
	};
	
	call FUNC(gui_verify);
},_this] call CBA_fnc_execNextFrame; // lbSelection doesn't work until next frame
