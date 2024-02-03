#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"
#include "initSettings.inc.sqf"

if (isServer && is3DEN) then {
	//[QEGVAR(common,ConnectionChanged3DEN),FUNC(syncAttributes)] call CBA_fnc_addEventHandler;

	if !(uiNamespace getVariable [QGVAR(edenEH),false]) then {
		private _edenDisplay = findDisplay IDD_DISPLAY3DEN;

		// Mark Eden display as cleared if it unloads. 
		_edenDisplay displayAddEventHandler ["Unload",{
			uiNamespace setVariable [QGVAR(edenEH),false];
			false
		}];

		add3DENEventHandler ["OnConnectingEnd",{
			params ["_class","_from","_to"];
			if (_class != "Sync" || isNil "_to") exitWith {};
			{_x call FUNC(syncAttributes)} forEach _from;
			_to call FUNC(syncAttributes);
		}];

		uiNamespace setVariable [QGVAR(edenEH),true];
	};

	[QGVAR(reinitialize)] collect3DENHistory {
		{if (_x isKindOf "Module_F") then {_x call FUNC(syncAttributes)}} forEach (all3DENEntities # 3);
	};
};

if (isServer) then {
	[QGVAR(request),{
		params ["_player","_entity","_request"];

		_entity setVariable [QPVAR(requester),_player,true];
		_entity setVariable [QPVAR(request),+_request];

		private _recompile = false;

		{
			private _count = _entity getVariable [_x # 6,-1];
			if (_count >= 0) then {
				_recompile = true;
				_entity setVariable [_x # 6,(_count - 1) max 0,true];
			};
		} forEach (_request getOrDefault ["selection",[]]);

		if (_recompile) then {
			[QGVAR(recompileList),[_entity]] call CBA_fnc_globalEvent;
		};

		switch (_entity getVariable QPVAR(supportType)) do {
			case "AIRDROP" : FUNC(airdropRequest);
			case "SLINGLOAD" : FUNC(slingloadRequest);
			case "STATION" : FUNC(stationRequest);
		};

		[QPVAR(requestSubmitted),[_player,_entity,_request]] call CBA_fnc_globalEvent;
	}] call CBA_fnc_addEventHandler;

	[QGVAR(abort),{
		params ["_player","_entity"];

		switch (_entity getVariable QPVAR(supportType)) do {
			case "AIRDROP" : FUNC(airdropAbort);
			case "SLINGLOAD" : FUNC(slingloadAbort);
		};

		[QPVAR(requestAborted),[_player,_entity,_entity getVariable QPVAR(request)]] call CBA_fnc_globalEvent;
	}] call CBA_fnc_addEventHandler;

	[QGVAR(flybyPosReached),FUNC(flybyPosReached)] call CBA_fnc_addEventHandler;
	[QGVAR(flybyEnd),FUNC(flybyEnd)] call CBA_fnc_addEventHandler;
	[QGVAR(flybyKilled),FUNC(flybyEnd)] call CBA_fnc_addEventHandler;
};

[QPVAR(guiConfirm),FUNC(gui_confirm)] call CBA_fnc_addEventHandler;

[QPVAR(guiAbort),FUNC(gui_abort)] call CBA_fnc_addEventHandler;

[QPVAR(guiUnload),{
	params ["_service","_entity"];
	if (_service != QSERVICE) exitWith {};
	_entity setVariable [QGVAR(cache),+[GVAR(list),GVAR(request)]];
}] call CBA_fnc_addEventHandler;

[QPVAR(entityChanged),{
	params ["_entity","_oldEntity"];
	if (_oldEntity getVariable QPVAR(service) != QSERVICE) exitWith {};
	_oldEntity setVariable [QGVAR(cache),+[GVAR(list),GVAR(request)]];
}] call CBA_fnc_addEventHandler;

ADDON = true;
