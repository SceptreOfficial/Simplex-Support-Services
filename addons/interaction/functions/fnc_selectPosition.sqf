#include "script_component.hpp"

SSS_mapWasOpened = visibleMap;
SSS_mapClicked = false;
openMap [true,false];
titleText ["Select Position","PLAIN",0.5];

["SSS_selectPosition","onMapSingleClick",{
	["SSS_selectPosition","onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;

	SSS_mapClicked = true;
	titleFadeOut 0.5;
	if (!SSS_mapWasOpened) then {
		openMap [false,false];
	};

	_this call FUNC(onMapClick);
},_this] call BIS_fnc_addStackedEventHandler;

[{!visibleMap || SSS_mapClicked},{
	if (!SSS_mapClicked) then {
		["SSS_selectPosition","onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;

		titleFadeOut 0.5;
		REQUEST_CANCELLED;
	};
}] call CBA_fnc_waitUntilAndExecute;
