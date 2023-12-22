#include "script_component.hpp"

disableSerialization;

params [["_ctrl",controlNull,[controlNull]],["_position",[0,0,1,1],[[]],4],["_bufferW",true,[false]],["_bufferH",true,[false]]];

_position params ["_ctrlX","_ctrlY","_ctrlW","_ctrlH"];

if (ctrlType _ctrl == 15) then {
	_ctrl ctrlSetPosition [
		GD_W(_ctrlX),
		GD_H(_ctrlY),
		GD_W(_ctrlW),
		GD_H(_ctrlH)
	];
} else {
	_ctrl ctrlSetPosition [
		[CTRL_X_BUFFER(_ctrlX),CTRL_X(_ctrlX)] select _bufferW,
		[CTRL_Y_BUFFER(_ctrlY),CTRL_Y(_ctrlY)] select _bufferH,
		[CTRL_W_BUFFER(_ctrlW),CTRL_W(_ctrlW)] select _bufferW,
		[CTRL_H_BUFFER(_ctrlH),CTRL_H(_ctrlH)] select _bufferH
	];
};
