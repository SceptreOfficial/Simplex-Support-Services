#include "..\script_component.hpp"
#include "\A3\ui_f_curator\ui\defineResinclDesign.inc"

params ["_logic","_synced"];

if (!local _logic) exitWith {};

[{
	params ["_logic","_synced"];

	if (isNull findDisplay IDD_RSCDISPLAYCURATOR) then {
		private _entity = [
			_synced select {alive _x && !(_x isKindOf "Logic")},
			_logic getVariable ["Callsign",""],
			_logic getVariable ["RespawnDelay",60],
			[_logic getVariable ["Relocation",0] == 0,_logic getVariable ["RelocationDelay",60],_logic getVariable ["RelocationSpeed",60]],
			[_logic getVariable ["Cooldown",60],_logic getVariable ["RoundCooldown",10]],
			[_logic getVariable ["Ammunition","[]"]] call EFUNC(common,parseArray),
			_logic getVariable ["VelocityOverride",0] == 1,
			_logic getVariable ["CoordinationDistance",1000],
			_logic getVariable ["CoordinationType",2],
			_logic getVariable ["IconSelection",""],
			_logic getVariable ["ExecutionDelay",[0,0]],
			_logic getVariable ["FiringDelay",[0,0]],
			[SHEAF_TYPES,_logic getVariable "SheafTypes"] call EFUNC(common,parseCheckboxes),
			_logic getVariable ["MaxLoops",10],
			_logic getVariable ["MaxLoopDelay",300],
			_logic getVariable ["MaxTasks",-1],
			_logic getVariable ["MaxRounds",50],
			_logic getVariable ["MaxExecutionDelay",300],
			_logic getVariable ["MaxFiringDelay",30],
			_logic getVariable ["VehicleInit",""],
			_logic getVariable ["RemoteControl",1] == 0,
			[west,east,independent,civilian] # (_logic getVariable ["Side",0]),
			_logic getVariable ["RemoteAccess",true],
			[_logic getVariable ["AccessItems",""]] call EFUNC(common,parseList),
			_logic getVariable ["AccessItemsLogic",0] == 1,
			_logic getVariable ["AccessCondition","true"],
			_logic getVariable ["RequestCondition","true"],
			[_logic getVariable [QPVAR(auth),""]] call EFUNC(common,parseArray)
		] call FUNC(add);

		[_logic,_entity] call EFUNC(common,addTerminals);
	} else {
		private _vehicle = attachedTo _logic;

		if (alive _vehicle && _vehicle isKindOf "AllVehicles") then {
			[[[_vehicle]]] call FUNC(moduleAdd_zeus);
		} else {
			FUNC(moduleAdd_zeus) call EFUNC(common,zeusSelection);
		};
	};

	deleteVehicle _logic;
},_this] call CBA_fnc_execNextFrame;
