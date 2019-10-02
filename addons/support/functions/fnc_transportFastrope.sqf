#include "script_component.hpp"

params ["_entity","_vehicle"];

_vehicle setVariable ["SSS_fastropeUnits",(crew _vehicle) - (units group driver _vehicle),true];

private _positionASL = getPosASL _vehicle;
private _centerOfMass = getCenterOfMass _vehicle;
private _ropeLength = (getPos _vehicle) # 2 - 0.1;
private _ropes = [];
private _fnc_helpers = {
	params ["_vehicle","_obj"];
	_obj disableCollisionWith _vehicle;
	_obj allowDamage false;
};

{
	private _origin = _x;
	_origin set [2,(_vehicle worldToModel ASLToAGL _positionASL) # 2];

	private _hook = createVehicle ["ace_fastroping_helper",_vehicle modelToWorld _origin,[],0,"CAN_COLLIDE"];
	[_vehicle,_hook] call _fnc_helpers;
	_hook attachTo [_vehicle,_origin];

	private _dummy = createVehicle ["ace_fastroping_helper",_vehicle modelToWorld _origin,[],0,"CAN_COLLIDE"];
	[_vehicle,_dummy] call _fnc_helpers;
	private _rope = ropeCreate [_hook,[0,0,0],_dummy,[0,0,0],_ropeLength];

	_ropes pushBack [_hook,_rope,_dummy];
} forEach [
	_centerOfMass vectorAdd [0.8,0,0],
	_centerOfMass vectorAdd [-0.8,0,0]
];

[{
	params ["_entity","_vehicle","_ropes"];

	{
		_x params ["_hook","_rope","_dummy"];
		_dummy ropeDetach _rope;
		deleteVehicle _dummy;
	} forEach _ropes;

	[{
		params ["_args","_PFHID"];
		_args params ["_entity","_vehicle","_ropes"];
		private _fastropeUnits = (_vehicle getVariable ["SSS_fastropeUnits",[]]) select {alive _x};

		if (_fastropeUnits isEqualTo [] || !alive _vehicle || !alive driver _vehicle || isNull _entity || {_entity getVariable "SSS_interrupt"}) exitWith {
			[_PFHID] call CBA_fnc_removePerFrameHandler;
			//_vehicle setVariable ["SSS_hoverDone",true,true];
			_vehicle setVariable ["SSS_fastropeUnits",nil,true];
			["SSS_requestCompleted",[_entity,["HOVER",true]]] call CBA_fnc_globalEvent;

			{
				_x params ["_hook","_rope"];
				_hook ropeDetach _rope;
				deleteVehicle _hook;
				[{ropeDestroy _this},_rope,5] call CBA_fnc_waitAndExecute;
			} forEach _ropes;
		};

		private _unit = selectRandom (_fastropeUnits select {!(_x getVariable ["SSS_fastroping",false])});

		if (isNil "_unit") exitWith {};

		_unit setVariable ["SSS_fastroping",true,true];
		[_vehicle,_unit,_ropes] remoteExecCall [QFUNC(transportDoFastrope),_unit];
	},1.5,[_entity,_vehicle,_ropes]] call CBA_fnc_addPerFrameHandler;
},[_entity,_vehicle,_ropes],2] call CBA_fnc_waitAndExecute;
