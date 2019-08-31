#include "script_component.hpp"

params ["_vehicle","_request"];

private _service = _vehicle getVariable "SSS_service";
SSS_mapClicked = false;
openMap [true,false];
titleText ["Select Position","PLAIN",0.5];

[QFUNC(selectMapPosition),"onMapSingleClick",{
	[QFUNC(selectMapPosition),"onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;

	SSS_mapClicked = true;
	titleFadeOut 0.5;
	openMap [false,false];

	_this call EFUNC(service,onMapClick);
},[_vehicle,_request,_service]] call BIS_fnc_addStackedEventHandler;

[{!visibleMap},{
	if (!SSS_mapClicked) then {
		[QFUNC(selectMapPosition),"onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;

		titleFadeOut 0.5;
		REQUEST_CANCELLED
	};
},[]] call CBA_fnc_waitUntilAndExecute;
