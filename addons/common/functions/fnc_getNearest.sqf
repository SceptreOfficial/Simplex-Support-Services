#include "script_component.hpp"

params ["_center","_list"];

private _distances = _list apply {_center distance _x};

_list # (_distances find selectMin _distances)
