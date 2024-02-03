#include "..\script_component.hpp"

params [["_fastrope",false,[false]],"_fastropeUnits"];

if !(_vehicle getVariable [QGVAR(pilotHelicopterReached),false]) then {
	doStop _vehicle;

	if (_fastrope) then {
		[_vehicle,_fastropeUnits] call FUNC(fastrope);
	};
};

_vehicle setVectorDirAndUp _endDirUp;
_vehicle setVelocity [0,0,0];

false
