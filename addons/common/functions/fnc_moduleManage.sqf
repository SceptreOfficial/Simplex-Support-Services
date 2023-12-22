#include "script_component.hpp"
#include "\A3\ui_f_curator\ui\defineResinclDesign.inc"

params ["_logic","_synced"];

if (!local _logic || isNull findDisplay IDD_RSCDISPLAYCURATOR) exitWith {};

deleteVehicle _logic;

{
	private _service = GVAR(manageService);
	private _services = keys GVAR(services) select {(GVAR(services) get _x) isNotEqualTo []};

	if (_service isEqualTo "" || !(_service in _services)) then {
		_service = _services param [0,""];
	};

	if (_service isEqualTo "") exitWith {
		LOG_FULL("NO SERVICES AVAILABLE");
	};

	private _entities = (GVAR(services) get _service) apply {[_x getVariable QPVAR(callsign),_x]};
	_entities sort true;

	private _cfgServices = configFile >> QPVAR(services);

	[LLSTRING(moduleManage_name),[
		["COMBOBOX",LLSTRING(guiService),[_services apply {getText (_cfgServices >> _x >> "name")},_service,_services],true,{
			params ["_service"];

			if (_service == GVAR(manageService)) exitWith {};
			
			GVAR(manageService) = _service;

			private _entities = (GVAR(services) get _service) apply {[_x getVariable QPVAR(callsign),_x]};
			_entities sort true;

			private _entity = GVAR(manageCache) getOrDefault [_service,objNull];
			
			if (isNull _entity && _entities isNotEqualTo []) then {
				_entity = _entities # 0 # 1
			};

			[1,[
				_entities apply {[_x # 0,"",_x # 1 getVariable QPVAR(icon)]},
				_entity,
				_entities apply {_x # 1}
			]] call EFUNC(sdf,setValueData);
		}],
		["COMBOBOX",LLSTRING(guiEntity),[
			_entities apply {[_x # 0,"",_x # 1 getVariable QPVAR(icon)]},
			GVAR(manageCache) getOrDefault [_service,_entities # 0 # 1],
			_entities apply {_x # 1}
		],true,{
			params ["_entity"];

			if (isNull _entity || isNil {_entity getVariable QPVAR(service)}) exitWith {
				GVAR(manageCache) set [0 call EFUNC(sdf,getValue),objNull];
				systemChat LLSTRING(CeasedExistence);
				[{[objNull] call FUNC(moduleRestrictAccess)},false] call EFUNC(sdf,close);
			};

			GVAR(manageCache) set [0 call EFUNC(sdf,getValue),_entity];

			private _auth = _entity getVariable [QPVAR(auth),[]];
			private _players = [];

			{
				private _unit = _x;

				if (_unit isKindOf "HeadlessClient_F") then {continue};
				
				private _key = _unit getVariable QPVAR(key);

				if (isNil "_key") then {
					_key = call FUNC(generateKey);
					_unit setVariable [QPVAR(key),_key,true];
				};

				_players pushBack [name _unit,_unit,_key];
			} forEach allPlayers;

			_players sort true;

			[3,_entity getVariable [QPVAR(remoteAccess),true]] call EFUNC(sdf,setValueData);
			[4,_auth isNotEqualTo []] call EFUNC(sdf,setValueData);
			[5,[
				_players apply {[_x # 0,"",_x # 2]},
				_players select {_x # 2 in _auth} apply {_x # 1},
				8,
				_players apply {_x # 1}
			]] call EFUNC(sdf,setValueData);
			
		}],
		["CHECKBOX",LLSTRING(remove),false],
		["CHECKBOX",LLSTRING(RemoteAccess_name),true],
		["CHECKBOX",LLSTRING(ApplyRestrictions),false],
		["LISTNBOXCB",LLSTRING(AuthorizedPlayers),[[],[],8,[]]]
	],{
		_values params ["_service","_entity","_remove","_remoteAccess","_restrict","_players"];

		if (_entity isEqualType 0) exitWith {};

		if (_remove) exitWith {
			_entity call FUNC(removeEntity);
		};

		_entity setVariable [QPVAR(remoteAccess),_remoteAccess,true];

		if (_restrict) then {
			_players = _players select {!isNull _x && !isNil {_x getVariable QPVAR(key)}};
			_entity setVariable [QPVAR(auth),[call FUNC(generateKey)] + (_players apply {_x getVariable QPVAR(key)}),true];
		} else {
			_entity setVariable [QPVAR(auth),[],true];
		};
	}] call EFUNC(sdf,dialog);
} call CBA_fnc_execNextFrame;
