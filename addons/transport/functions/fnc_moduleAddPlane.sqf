#include "script_component.hpp"
#include "\A3\ui_f_curator\ui\defineResinclDesign.inc"

params ["_logic","_synced"];

if (!local _logic) exitWith {};

[{
	params ["_logic","_synced"];

	if (isNull findDisplay IDD_RSCDISPLAYCURATOR) then { 
		private _entity = [
			_synced param [_synced findIf {alive _x && !(_x isKindOf "Logic")},objNull],
			[west,east,independent] # (_logic getVariable ["Side",0]),
			_logic getVariable ["Callsign",""],
			_logic getVariable ["RespawnDelay",60],
			[PLANE_TASK_TYPES,_logic getVariable "TaskTypes"] call EFUNC(common,parseCheckboxes),
			_logic getVariable ["FlyingHeights",[0,3000]],
			_logic getVariable ["VirtualRunway",[0,0,0]],
			_logic getVariable ["MaxTasks",-1],
			_logic getVariable ["MaxTimeout",300],
			_logic getVariable ["VehicleInit",""],
			_logic getVariable ["RemoteAccess",true],
			[_logic getVariable ["AccessItems","itemMap"]] call EFUNC(common,parseList),
			_logic getVariable ["AccessItemsLogic",0] isEqualTo 1,
			_logic getVariable ["AccessCondition","true"],
			_logic getVariable ["RequestCondition","true"],
			[_logic getVariable [QPVAR(auth),""]] call EFUNC(common,parseArray)
		] call FUNC(addPlane);

		[_logic,_entity] call EFUNC(common,addTerminals);
	} else {
		private _vehicle = attachedTo _logic;

		if (alive _vehicle && _vehicle isKindOf "AllVehicles") then {
			[[[_vehicle]]] call FUNC(moduleAddPlane_zeus);
		} else {
			FUNC(moduleAddPlane_zeus) call EFUNC(common,zeusSelection);
		};
	};

	deleteVehicle _logic;
},_this] call CBA_fnc_execNextFrame;