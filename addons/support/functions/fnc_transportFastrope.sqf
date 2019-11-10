#include "script_component.hpp"

params ["_entity","_vehicle"];

_vehicle setVariable ["SSS_fastropeUnits",(crew _vehicle) - (units group driver _vehicle),true];

private _ropes = [];
private _centerOfMass = getCenterOfMass _vehicle;

{
	_x set [2,(0 boundingBoxReal _vehicle) # 0 # 2];

	private _hook = createVehicle ["ace_fastroping_helper",_vehicle modelToWorldVisual _x,[],0,"CAN_COLLIDE"];
	_hook allowDamage false;
	_hook attachTo [_vehicle,_x];
	
	private _end = createVehicle ["ace_fastroping_helper",_vehicle modelToWorldVisual _x,[],0,"CAN_COLLIDE"];
	_end allowDamage false;

	private _rope = ropeCreate [_hook,[0,0,0],_end,[0,0,0],1];
	ropeUnwind [_rope,7,getPosVisual _vehicle # 2 - 0.5];

	_ropes pushBack [_hook,_rope,_end];
} forEach [
	_centerOfMass vectorAdd [0.8,0,0],
	_centerOfMass vectorAdd [-0.8,0,0]
];

[{
	[{
		params ["_args","_PFHID"];
		_args params ["_entity","_vehicle","_ropes"];
		private _fastropeUnits = (_vehicle getVariable ["SSS_fastropeUnits",[]]) select {alive _x};

		if (_fastropeUnits isEqualTo [] || !alive _vehicle || !alive driver _vehicle || isNull _entity || {_entity getVariable "SSS_interrupt"}) exitWith {
			[_PFHID] call CBA_fnc_removePerFrameHandler;
			
			_vehicle setVariable ["SSS_fastropeUnits",nil,true];
			["SSS_requestCompleted",[_entity,["HOVER",true]]] call CBA_fnc_globalEvent;

			{
				_x params ["_hook","_rope","_end"];
				_hook ropeDetach _rope;
				deleteVehicle _hook;
				_end ropeDetach _rope;
				deleteVehicle _end;
				[{ropeDestroy _this},_rope,5] call CBA_fnc_waitAndExecute;
			} forEach _ropes;
		};

		private _unit = selectRandom (_fastropeUnits select {!(_x getVariable ["SSS_fastroping",false])});

		if (isNil "_unit") exitWith {};

		_unit setVariable ["SSS_fastroping",true,true];
		[_vehicle,_unit,_ropes] remoteExecCall [QFUNC(transportDoFastrope),_unit];
	},1.5,_this] call CBA_fnc_addPerFrameHandler;
},[_entity,_vehicle,_ropes],4] call CBA_fnc_waitAndExecute;
