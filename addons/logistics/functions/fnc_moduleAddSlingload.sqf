#include "..\script_component.hpp"
#define IDD_RSCDISPLAYCURATOR 312

params ["_logic","_synced"];

if (!local _logic) exitWith {};

[{
	params ["_logic","_synced"];

	if (isNull findDisplay IDD_RSCDISPLAYCURATOR) then {
		private _entity = [
			_logic getVariable ["AircraftClass",""],
			_logic getVariable ["Callsign",""],
			[_logic getVariable ["Cooldown",60],_logic getVariable ["ItemCooldown",10]],
			_logic getVariable ["Altitude",500],
			_logic getVariable ["UnloadAltitude",15],
			_logic getVariable ["VirtualRunway",[0,0,0]],
			_logic getVariable ["SpawnDistance",8000],
			_logic getVariable ["SpawnDelay",[0,0]],
			_logic getVariable ["Capacity",10],
			["SINGLE","MULTI"] param [_logic getVariable ["Fulfillment",0],"MULTI"],
			synchronizedObjects _logic select {_x isKindOf QGVAR(moduleReferenceArea)},
			_logic getVariable ["ListFunction",""],
			_logic getVariable ["ItemInit",""],
			_logic getVariable ["VehicleInit",""],
			[west,east,independent,civilian] # (_logic getVariable ["Side",0]),
			_logic getVariable ["RemoteAccess",true],
			[_logic getVariable ["AccessItems",""]] call EFUNC(common,parseList),
			_logic getVariable ["AccessItemsLogic",0] isEqualTo 1,
			_logic getVariable ["AccessCondition","true"],
			_logic getVariable ["RequestCondition","true"],
			[_logic getVariable [QPVAR(auth),""]] call EFUNC(common,parseArray)
		] call FUNC(addSlingload);

		[_logic,_entity] call EFUNC(common,addTerminals);
	} else {
		(attachedTo _logic) call FUNC(moduleAddSlingload_zeus);
	};

	deleteVehicle _logic;
},_this] call CBA_fnc_execNextFrame;
