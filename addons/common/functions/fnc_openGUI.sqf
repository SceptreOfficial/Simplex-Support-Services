#include "..\script_component.hpp"

if (!isNull (uiNamespace getVariable [QEGVAR(sdf,display),displayNull])) exitWith {
	[{isNull (_this # 0)},{(_this # 1) call FUNC(openGUI)},[
		uiNamespace getVariable [QEGVAR(sdf,display),displayNull],
		_this
	]] call CBA_fnc_waitUntilAndExecute;

	false call FUNC(gui_close);
};

[{
	params [
		["_service","",[""]],
		["_entity",objNull,[objNull]],
		["_terminalAccess",false,[false]]
	];

	_service = toUpper _service;
	private _player = call CBA_fnc_currentUnit;

	if (_service isEqualTo "") then {
		_service = GVAR(guiService);

		if (_service isEqualTo "") then {
			_service = keys GVAR(services) param [keys GVAR(services) findIf {[_player,_x] call FUNC(getEntities) isNotEqualTo []},""];
		};
	};

	if (_service isEqualTo "") exitWith {
		systemChat LLSTRING(noServices);
	};

	if (isNull _entity) then {
		_entity = GVAR(guiCache) getOrDefault [_service,objNull];
	};

	if !([_player,_entity,_terminalAccess] call FUNC(isAuthorized)) then {
		_entity = [_player,_service] call FUNC(getEntities) param [0,objNull];
	};

	if (isNull _entity) exitWith {
		GVAR(guiService) = "";
		[] call FUNC(openGUI);
	};

	GVAR(guiService) = _service;
	PVAR(guiEntity) = _entity;
	GVAR(guiCache) set [GVAR(guiService),_entity];

	if (_terminalAccess) then {
		PVAR(terminalEntity) = _entity;
	};
	
	//if (createDialog (getText (configFile >> QPVAR(services) >> _service >> "gui"))) then {

	if (createDialog (_entity getVariable QPVAR(gui))) then {
		[QPVAR(guiOpen),[_service,_entity]] call CBA_fnc_localEvent;
	};
},_this] call CBA_fnc_execNextFrame;
