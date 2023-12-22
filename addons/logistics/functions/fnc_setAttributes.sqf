#include "script_component.hpp"

params [["_object",objNull,[objNull]],["_formatting","",["",[]]],"_init","_args","_load","_requestLimit","_quantity"];
_formatting params [["_name","",[""]],["_icon","",[""]],["_tooltip","",[""]],["_info","",[""]]];

_object setVariable [QGVAR(formatting),[_name,_icon,_tooltip,_info],true];

if (!isNil "_init" && {_init isEqualType {}}) then {
	_object setVariable [QGVAR(init),_init,true];
};

if (!isNil "_args") then {
	_object setVariable [QGVAR(args),_args,true];
};

if (!isNil "_load" && {_load isEqualType 0}) then {
	_object setVariable [QGVAR(load),_load,true];
};

if (!isNil "_requestLimit" && {_requestLimit isEqualType 0}) then {
	_object setVariable [QGVAR(requestLimit),_requestLimit,true];
};

if (!isNil "_quantity" && {_quantity isEqualTypeAny [0,""]}) then {
	_object setVariable [QGVAR(quantity),_quantity,true];
};
