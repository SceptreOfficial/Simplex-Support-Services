#include "script_component.hpp"

params [["_service","",[""]],["_callsign","",[""]]];

GVAR(services) getOrDefault [toUpper _service,[]] select {_x getVariable QPVAR(callsign) == _callsign} param [0,objNull]
