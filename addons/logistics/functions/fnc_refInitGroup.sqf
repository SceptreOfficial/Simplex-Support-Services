#include "script_component.hpp"

_this setUnitLoadout ((_thisArgs # 0) deleteAt 0);

private _initGlobal = _thisArgs # 1;
private _init = _thisArgs # 2;
private _thisArgs = _thisArgs # 3;

_this call _init;
_this call _initGlobal;
