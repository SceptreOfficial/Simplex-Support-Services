#include "script_component.hpp"

[{
	params ["_logic"];

	disableSerialization;
	if (!isNull (findDisplay 312)) then {
		if (!local _logic) exitWith {};

		private _object = attachedTo _logic;
		private _classname = "B_T_VTOL_01_vehicle_F";

		if (_object isKindOf "Air") then {
			_classname = typeOf _object;
		};

		["Add Logistics Airdrop",[
			["EDITBOX","Classname",_classname],
			["EDITBOX","Callsign","Logistics Airdrop"],
			["EDITBOX",["Fixed spawn position","In format [x,y] or [x,y,z]. Leave empty to generate random position from request location."],""],
			["EDITBOX",["Spawn delay","Time before air vehicle is spawned after request is submitted"],str DEFAULT_LOGISTICS_AIRDROP_SPAWN_DELAY],
			["EDITBOX",["Flying height","AGL altitude in meters"],str DEFAULT_LOGISTICS_AIRDROP_FLYING_HEIGHT],
			["EDITBOX",["List function","Code that must return an array of items that can be requested"],"[]"],
			["EDITBOX",["Universal init code","Code executed when request object is spawned"],""],
			["EDITBOX",["Maximum amount input","Maximum number of items that can be spawned per request"],"1"],
			["COMBOBOX",["Landing signal","Color of signal when item lands, or none for no signal. \nSmoke used during daytime, chemlights used at night."],[["None","Yellow","Green","Red","Blue"],1]],
			["EDITBOX","Cooldown",str DEFAULT_COOLDOWN_LOGISTICS_AIRDROP],
			["EDITBOX",["Custom init code","Code executed when physical vehicle is spawned \n(Vehicle = _this)"],""],
			["COMBOBOX","Side",[["BLUFOR","OPFOR","Independent"],0]],
			["EDITBOX",["Access items","Item classes that permit usage of support. \nSeparate with commas (eg. itemRadio,itemMap)"],"itemRadio"],
			["EDITBOX",["Access condition","Code evaluated on a requester's client that must return true for the support to be accessible. \n\nUsage example: \n\nAccess condition: \n    player getVariable [""canUseSSS"",false] \nPlayer init: \n    this setVariable [""canUseSSS"",true,true];"],"true"]
		],{
			(_this # 0) params [
				"_classname","_callsign","_spawnPosition","_spawnDelay",
				"_flyingHeight","_listFnc","_universalInitFnc","_maxAmount",
				"_landingSignal","_cooldown","_customInit","_sideSelection",
				"_accessItems","_accessCondition"
			];
			
			if (_spawnPosition == "") then {
				_spawnPosition = "[]";
			};

			[
				_classname,
				_callsign,
				parseSimpleArray _spawnPosition,
				parseNumber _spawnDelay,
				parseNumber _flyingHeight,
				_listFnc,
				_universalInitFnc,
				parseNumber _maxAmount,
				_landingSignal,
				parseNumber _cooldown,
				_customInit,
				[west,east,independent] # _sideSelection,
				STR_TO_ARRAY_LOWER(_accessItems),
				_accessCondition
			] call EFUNC(support,addLogisticsAirdrop);

			ZEUS_MESSAGE("Logistics airdrop added");
		}] call EFUNC(CDS,dialog);
	} else {
		if (!isServer) exitWith {};

		private _spawnPosition = _logic getVariable ["SpawnPosition","[]"];
		
		if (_spawnPosition == "") then {
			_spawnPosition = "[]";
		};

		[
			_logic getVariable ["Classname",""],
			_logic getVariable ["Callsign",""],
			parseSimpleArray _spawnPosition,
			parseNumber (_logic getVariable ["SpawnDelay",str DEFAULT_LOGISTICS_AIRDROP_SPAWN_DELAY]),
			parseNumber (_logic getVariable ["FlyingHeight",str DEFAULT_LOGISTICS_AIRDROP_FLYING_HEIGHT]),
			_logic getVariable ["ListFunction","[]"],
			_logic getVariable ["UniversalInitCode",""],
			parseNumber (_logic getVariable ["MaxAmount","1"]),
			_logic getVariable ["LandingSignal",1],
			parseNumber (_logic getVariable ["Cooldown",str DEFAULT_COOLDOWN_LOGISTICS_AIRDROP]),
			_logic getVariable ["CustomInit",""],
			[west,east,independent] # (_logic getVariable ["Side",0]),
			STR_TO_ARRAY_LOWER(_logic getVariable [ARR_2("AccessItems","itemRadio")]),
			_logic getVariable ["AccessCondition","true"]
		] call EFUNC(support,addLogisticsAirdrop);
	};

	deleteVehicle _logic;
},_this] call CBA_fnc_directCall;
