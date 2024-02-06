#include "..\script_component.hpp"

params ["_ctrlStatus"];

addMissionEventHandler ["EachFrame",{
	_thisArgs params ["_ctrlStatus"];

	if (isNull _ctrlStatus) exitWith {
		removeMissionEventHandler [_thisEvent,_thisEventHandler];
	};

	_ctrlStatus ctrlSetStructuredText parseText ([PVAR(guiEntity),1] call EFUNC(common,status));

	if (PVAR(guiEntity) getVariable [QPVAR(task),""] isEqualTo "COOLDOWN") then {
		_ctrlStatus ctrlSetTooltip ((PVAR(guiEntity) getVariable [QPVAR(cooldownTimer),0]) call FUNC(formatTime)); 
	} else {
		_ctrlStatus ctrlSetTooltip "";
	};
},[_ctrlStatus]];

false
