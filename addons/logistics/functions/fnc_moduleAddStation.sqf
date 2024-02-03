#include "..\script_component.hpp"
#include "\A3\ui_f_curator\ui\defineResinclDesign.inc"

params ["_logic","_synced"];

if (!local _logic) exitWith {};

[{
	params ["_logic","_synced"];

	if (isNull findDisplay IDD_RSCDISPLAYCURATOR) then {
		private _entity = [
			getPosASL _logic,
			getDir _logic,
			_logic getVariable ["Callsign",""],
			_logic getVariable ["Cooldown",0],
			_logic getVariable ["ClearingRadius",0],
			synchronizedObjects _logic select {_x isKindOf QGVAR(moduleReferenceArea)},
			_logic getVariable ["ListFunction",""],
			_logic getVariable ["ItemInit",""],
			[west,east,independent,civilian] # (_logic getVariable ["Side",0]),
			_logic getVariable ["RemoteAccess",true],
			[_logic getVariable ["AccessItems",""]] call EFUNC(common,parseList),
			_logic getVariable ["AccessItemsLogic",0] isEqualTo 1,
			_logic getVariable ["AccessCondition","true"],
			_logic getVariable ["RequestCondition","true"],
			[_logic getVariable [QPVAR(auth),""]] call EFUNC(common,parseArray)
		] call FUNC(addStation);

		[_logic,_entity] call EFUNC(common,addTerminals);
	} else {
		[getPosASL _logic] call FUNC(moduleAddStation_zeus);
	};

	deleteVehicle _logic;
},_this] call CBA_fnc_execNextFrame;
