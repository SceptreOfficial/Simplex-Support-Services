#include "script_component.hpp"

_position = [GD_W(_ctrlX),GD_H(_ctrlY),GD_W(_ctrlW) min safeZoneW,GD_H(_ctrlH) min safeZoneH];
private _ctrlGroup = _display ctrlCreate [QGVAR(ControlsGroup),-1,_ctrlGroup];
_ctrlGroup ctrlSetPosition _position;
_ctrlGroup ctrlCommit 0;

_ctrlGroup setVariable [QGVAR(parameters),[_type,"",""]];
_ctrlGroup setVariable [QGVAR(position),_position];
_ctrlGroup setVariable [QGVAR(onValueChanged),{}];
_ctrlGroup setVariable [QGVAR(enableCondition),{true}];
_ctrlGroup setVariable [QGVAR(value),[]];
_ctrlGroup setVariable [QGVAR(ctrlDescription),_ctrlGroup];
_ctrlGroup setVariable [QGVAR(controlCount),count _valueData];

_controls pushBack _ctrlGroup;

{[2,_x] call FUNC(initialize)} forEach _valueData;
