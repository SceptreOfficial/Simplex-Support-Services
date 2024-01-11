#include "script_component.hpp"

params ["_player","_entity","_request"];

private _selection = _request getOrDefault ["selection",[]];
private _posASL = _request getOrDefault ["posASL",[0,0,0]];
private _signals = _request getOrDefault ["signals",["",""]];
private _aiHandling = _request getOrDefault ["aiHandling",0];

[_entity,true,"MOVE",[LSTRING(statusAirdropInbound),RGBA_YELLOW]] call EFUNC(common,setStatus);

private _spawnDistance = _entity getVariable [QPVAR(spawnDistance),6000];
private _speed = getNumber (configFile >> "CfgVehicles" >> _entity getVariable [QPVAR(class),""] >> "maxSpeed");
private _itemCount = count flatten (_selection apply {_x # 0});
private _offset = _speed * 0.35 * (_itemCount / 2 max 1) * (_entity getVariable [QPVAR(ejectInterval),OPTION(ejectInterval)]);

if (_offset > _spawnDistance / 2) then {
	_spawnDistance = _spawnDistance + _offset;
};

// if virtual runway overlaps the offset, the objects could be dropped the wrong direction or just weird...
// if the offset is further than the runway pos, i could just override the runway with the direction to target - ???

private _virtualRunway = _entity getVariable [QPVAR(virtualRunway),[0,0,0]];
private _ETADistance = [_virtualRunway distance2D _posASL,_spawnDistance] select (_virtualRunway isEqualTo [0,0,0]);
private _delay = (_entity getVariable QPVAR(spawnDelay)) call EFUNC(common,randomMinMax);
//DEBUG_1("Random delay: %1",_delay);

private _ETA = [_delay + _ETADistance / (_speed / 3.6)] call EFUNC(common,formatTime);
private _msg = {
	format [LLSTRING(notifyAirdropInbound),_this # 0 call EFUNC(common,formatGrid),_this # 1]
};

NOTIFY_2(_entity,_msg,_posASL,_ETA);

_entity setVariable [QPVAR(cooldownTimer),(_entity getVariable [QPVAR(cooldown),0]) + _itemCount * (_entity getVariable [QPVAR(itemCooldown),0]),true];

if (GVAR(cooldownTrigger) == "START") then {
	[EFUNC(common,cooldown),[_entity,false],1] call CBA_fnc_waitAndExecute;
};

[{
	params ["_player","_entity","_request","_spawnDistance","_offset"];
	_request params ["_selection","_posASL","_signals","_aiHandling"];

	private _vehicle = [
		_posASL,
		random 360,
		_spawnDistance,
		_entity getVariable QPVAR(altitude),
		[_entity getVariable QPVAR(class),_entity getVariable QPVAR(side)],
		_offset,
		"",
		_entity getVariable [QPVAR(virtualRunway),[0,0,0]]
	] call FUNC(flyby);

	_vehicle setVariable [QGVAR(flybyData),[_player,_entity,_request,getPosASL _vehicle],true];
	[_vehicle,_entity,false] call EFUNC(common,commission);
	[_vehicle,"Deleted",{
		if (GVAR(cooldownTrigger) == "END") then {
			[_thisArgs,false] call EFUNC(common,cooldown);
		};
	},_entity] call CBA_fnc_addBISEventHandler;
},[_player,_entity,+[_selection,_posASL,_signals,_aiHandling],_spawnDistance,_offset],_delay] call CBA_fnc_waitAndExecute;
