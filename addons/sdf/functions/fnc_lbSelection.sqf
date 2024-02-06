#include "..\script_component.hpp"

params ["_ctrl"];

private _size = if (ctrlType _ctrl isEqualTo CT_LISTNBOX) then {
	lnbSize _ctrl # 0
} else {
	lbSize _ctrl
};

lbSelection _ctrl select {_x < _size}
