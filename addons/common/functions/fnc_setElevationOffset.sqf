#include "..\script_component.hpp"

params [["_class",objNull,[objNull,""]],["_default",0,[0]],["_weaponHash",createHashMap,[createHashMap,[]]]];

if (_class isEqualType objNull) then {
	_class = toLower typeOf _class;
} else {
	_class = toLower _class;
};

if (_weaponHash isEqualType []) then {
	_weaponHash = createHashMapFromArray _weaponHash;
};

GVAR(strafeElevationOffsets) set [_class,[
	_default,
	createHashMapFromArray (_weaponHash apply {[toLower _x,_y]})
]];
