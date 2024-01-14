#include "script_component.hpp"

params ["_vehicle"];

_vehicle getVariable QGVAR(flybyData) params ["_player","_entity","_request","_startPosASL"];

if (GVAR(cooldownTrigger) == "END") then {
	[_entity,true,"UNLOAD",[LSTRING(statusAirdropDropping),RGBA_YELLOW]] call EFUNC(common,setStatus);
};

NOTIFY(_entity,LSTRING(notifyAirdropDropping));

group _vehicle setVariable [QGVAR(flybyHold),true,true];

[{
	params ["_args","_PFHID"];
	_args params ["_vehicle","_player","_entity","_request","_startPosASL","_blanketGroup"];
	_request params ["_selection","_posASL","_signals","_aiHandling"];

	if (!alive _vehicle || isNil {_vehicle getVariable QGVAR(flybyData)}) exitWith {
		_PFHID call CBA_fnc_removePerFrameHandler;			
	};

	if (_selection isEqualTo []) exitWith {
		_PFHID call CBA_fnc_removePerFrameHandler;

		if (GVAR(cooldownTrigger) == "END") then {
			[_entity,true,"RTB",[LSTRING(statusAirdropComplete),RGBA_YELLOW]] call EFUNC(common,setStatus);
		};
		
		NOTIFY(_entity,LSTRING(notifyAirdropComplete));

		private _group = group _vehicle;
		[_group,currentWaypoint _group] setWaypointPosition [ASLtoAGL _startPosASL,0];
		[_group,currentWaypoint _group + 1] setWaypointPosition [ASLtoAGL _startPosASL,0];
		_group setVariable [QGVAR(flybyHold),nil,true];
	};

	_selection # 0 params ["_class","_formatting","_init","_thisArgs","_load","_requestLimit","_quantity",["_itemGroup",grpNull],["_itemVehicles",[]]];

	private _objectClass = if (_class isEqualType []) then {_class deleteAt 0} else {_class};
	private _spawnPosASL = _vehicle modelToWorldVisualWorld [0,-((sizeOf typeOf _vehicle + (_objectClass call EFUNC(common,sizeOf))) / 2),-1];
	private _object = objNull;
	private _group = grpNull;

	if (_objectClass isKindOf "CAManBase") then {
		if (_aiHandling == 0) then {
			_group = group _player;

			if (isNull _group) then {
				if (isNull _blanketGroup) then {
					_blanketGroup = createGroup [_entity getVariable QPVAR(side),true];
					_args set [5,_blanketGroup];
				};

				_group = _blanketGroup;
			};
		} else {
			if (_class isEqualType []) then {
				if (isNull _itemGroup) then {
					_itemGroup = createGroup [_entity getVariable QPVAR(side),true];
				};

				_group = _itemGroup;
			} else {
				if (isNull _blanketGroup) then {
					_blanketGroup = createGroup [_entity getVariable QPVAR(side),true];
					_args set [5,_blanketGroup];
				};

				_group = _blanketGroup;
			};
		};

		_selection # 0 set [7,_group];

		//_object = _group createUnit [_objectClass,ASLtoAGL _spawnPosASL,[],0,"NONE"];
		_object = _group createUnit [_objectClass,[0,0,0],[],0,"CAN_COLLIDE"];

		[EFUNC(common,paradropUnit),[_object,_entity getVariable [QPVAR(openAltitudeAI),200],""]] call CBA_fnc_execNextFrame;
	} else {
		//_object = createVehicle [_objectClass,ASLtoAGL _spawnPosASL,[],0,"NONE"];
		_object = _objectClass createVehicle [0,0,0];

		[EFUNC(common,paradropObject),[_object,_entity getVariable [QPVAR(openAltitudeObjects),-1],"",_signals]] call CBA_fnc_execNextFrame;

		_itemVehicles pushBack _object;
		_selection # 0 set [8,_itemVehicles];
	};

	_object setDir getDir _vehicle;
	_object setPosWorld _spawnPosASL;
	_object setVelocity (velocity _vehicle vectorMultiply 0.9);
	_object setVariable [QPVAR(requester),_player,true];

	_object call _init;
	_object call (_entity getVariable [QPVAR(itemInit),{}]);

	if (_class isEqualTo [] || _class isEqualType "") then {
		if (!isNull _itemGroup) then {
			{
				[{
					params ["_vehicle","_group"];
					isNull _group || !alive _vehicle || {isTouchingGround _vehicle && !(_vehicle getVariable [QEGVAR(common,paradropping),false])}
				},{
					params ["_vehicle","_group"];
					_group addVehicle _vehicle;
				},[_x,_itemGroup]] call CBA_fnc_waitUntilAndExecute;
			} forEach _itemVehicles;
		};

		_selection deleteAt 0;
	};
},_entity getVariable [QPVAR(ejectInterval),OPTION(ejectInterval)],[_vehicle,_player,_entity,+_request,_startPosASL,grpNull]] call CBA_fnc_addPerFrameHandler;
