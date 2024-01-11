#include "script_component.hpp"

params ["_vehicle","_ejections",["_interval",OPTION(ejectInterval)]];

_vehicle setVariable [QGVAR(unloadEnd),false,true];

[{
	params ["_args","_PFHID"];
	_args params ["_vehicle","_ejections"];

	if (!alive _vehicle || _ejections isEqualTo []) exitWith {
		_vehicle setVariable [QGVAR(unloadEnd),true,true];
		_PFHID call CBA_fnc_removePerFrameHandler;
	};

	private _item = _ejections deleteAt 0;

	[QEGVAR(common,execute),[[_item,_vehicle],{
		params ["_item","_vehicle"];

		if (_item isKindOf "CAManBase") then {
			unassignVehicle _item;
			[_item] orderGetIn false;
			moveOut _item;

			// Tell AI to make room
			if (!isPlayer _item) then {
				[{(_this # 0) doMove (_this # 1)},[_item,_vehicle getPos [sizeOf typeOf _vehicle / 2,random 360]],2] call CBA_fnc_execAfterNFrames;
			};
		} else {
			objNull setVehicleCargo _item;
		};
	}],_item] call CBA_fnc_targetEvent;
},_interval,[_vehicle,_ejections]] call CBA_fnc_addPerFrameHandler;
