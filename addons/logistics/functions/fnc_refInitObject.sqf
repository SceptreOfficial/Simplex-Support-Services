#include "script_component.hpp"

([_this] + _thisArgs # 0) call BIS_fnc_initVehicle;
[_this,_thisArgs # 1] call EFUNC(common,deserializeInventory);

private _initGlobal = _thisArgs # 2;
private _init = _thisArgs # 3;
private _thisArgs = _thisArgs # 4;

_this call _init;
_this call _initGlobal;
