#include "script_component.hpp"

params ["_ctrlMap"];

private _mapPos = ctrlMapPosition _ctrlMap;
EGVAR(sdf,mapCenter) = _ctrlMap posScreenToWorld [_mapPos # 0 + _mapPos # 2 / 2,_mapPos # 1 + _mapPos # 3 / 2];
EGVAR(sdf,mapScale) = ctrlMapScale _ctrlMap;
