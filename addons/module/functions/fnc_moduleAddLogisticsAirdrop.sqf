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

		[localize LSTRING(AddLogisticsAirdrop),[
			["EDITBOX",localize LSTRING(ClassnameName),_classname],
			["EDITBOX",[localize LSTRING(CallsignName),localize LSTRING(CallsignDescription)],localize LSTRING(CallsignLogisticsAirdropDefaultValue)],
			["EDITBOX",[localize LSTRING(SpawnPositionName),localize LSTRING(SpawnPositionDescription)],""],
			["EDITBOX",[localize LSTRING(SpawnDelayName),localize LSTRING(SpawnDelayDescription)],str DEFAULT_LOGISTICS_AIRDROP_SPAWN_DELAY],
			["EDITBOX",[localize LSTRING(FlyingHeightName),localize LSTRING(FlyingHeightDescription)],str DEFAULT_LOGISTICS_AIRDROP_FLYING_HEIGHT],
			["EDITBOX",[localize LSTRING(ListFunctionName),localize LSTRING(ListFunctionDescription)],"[]"],
			["EDITBOX",[localize LSTRING(UniversalInitCodeName),localize LSTRING(UniversalInitCodeDescription)],""],
			["EDITBOX",[localize LSTRING(MaxAmountName),localize LSTRING(MaxAmountDescription)],"1"],
			["COMBOBOX",[localize LSTRING(LandingSignalName),localize LSTRING(LandingSignalDescription)],[[localize LSTRING(LandingSignalNone),localize LSTRING(LandingSignalYellow),localize LSTRING(LandingSignalGreen),localize LSTRING(LandingSignalRed),localize LSTRING(LandingSignalBlue)],1]],
			["EDITBOX",[localize LSTRING(CooldownName),localize LSTRING(CooldownDescription)],str DEFAULT_COOLDOWN_LOGISTICS_AIRDROP],
			["EDITBOX",[localize LSTRING(CustomInitName),localize LSTRING(CustomInitDescription)],""],
			["COMBOBOX",[localize LSTRING(SideName),localize LSTRING(SideDescription)],[["BLUFOR","OPFOR","Independent"],0]],
			["EDITBOX",[localize LSTRING(AccessItemsName),localize LSTRING(AccessItemsDescription)],"itemMap"],
			["EDITBOX",[localize LSTRING(AccessConditionName),localize LSTRING(AccessConditionDescription)],"true"],
			["EDITBOX",[localize LSTRING(RequestApprovalConditionName),localize LSTRING(RequestApprovalConditionDescription)],"true"]
		],{
			(_this # 0) params [
				"_classname","_callsign","_spawnPosition","_spawnDelay",
				"_flyingHeight","_listFnc","_universalInitFnc","_maxAmount",
				"_landingSignal","_cooldown","_customInit","_sideSelection",
				"_accessItems","_accessCondition","_requestCondition"
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
				_accessCondition,
				_requestCondition
			] call EFUNC(support,addLogisticsAirdrop);

			ZEUS_MESSAGE(localize LSTRING(ZeusLogisticsAirdropAdded));
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
			_logic getVariable ["AccessCondition","true"],
			_logic getVariable ["RequestApprovalCondition","true"]
		] call EFUNC(support,addLogisticsAirdrop);
	};

	deleteVehicle _logic;
},_this] call CBA_fnc_directCall;
