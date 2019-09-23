#include "script_component.hpp"

params ["_logic"];

if (!local _logic) exitWith {};

disableSerialization;
if (!isNull (findDisplay 312)) then {
	private _object = attachedTo _logic;
	private _classname = "";
	private _callsign = "";
	private _weaponSet = [];

	if (_object isKindOf "Plane") then {
		_classname = typeOf _object;
		_callsign = getText (configFile >> "CfgVehicles" >> typeOf _object >> "displayName");
		_weaponSet = str ((weapons _object) select {
			toLower ((_x call BIS_fnc_itemType) # 1) in ["machinegun","rocketlauncher","missilelauncher","bomblauncher"]
		});
	};

	["Add CAS Plane",[
		["EDITBOX","Classname",_classname],
		["EDITBOX","Callsign",_callsign],
		["EDITBOX",["Weapon set","Array of weapon classnames or array of [weapon,magazine] arrays. Empty array for vehicle defaults"],_weaponSet],
		["COMBOBOX","Side",[["BLUFOR","OPFOR","Independent"],0]],
		["EDITBOX","Cooldown",SSS_DEFAULT_COOLDOWN_PLANES_STR],
		["EDITBOX",["Custom init code","Code executed when physical vehicle is spawned (vehicle = _this)"],""]
	],{
		params ["_values"];
		_values params ["_classname","_callsign","_weaponSet","_sideSelection","_cooldown"];

		[
			[],
			_classname,
			_callsign,
			parseSimpleArray _weaponSet,
			[west,east,independent] # _sideSelection,
			parseNumber _cooldown
		] call FUNC(addCASPlane);

		ZEUS_MESSAGE("CAS Plane added");
	}] call EFUNC(CDS,dialog);
} else {
	private _requesters = [];

	{
		if (typeOf _x == "SSS_Module_AssignRequesters") then {
			_requesters append ((synchronizedObjects _x) select {!(_x isKindOf "Logic")});
		};
	} forEach synchronizedObjects _logic;

	[
		_requesters,
		_logic getVariable ["Classname",""],
		_logic getVariable ["Callsign",""],
		parseSimpleArray (_logic getVariable ["WeaponSet","[]"]),
		[west,east,independent] # (_logic getVariable ["Side",0]),
		parseNumber (_logic getVariable ["Cooldown",SSS_DEFAULT_COOLDOWN_PLANES_STR]),
		_logic getVariable ["CustomInit",""]
	] call FUNC(addCASPlane);
};

deleteVehicle _logic;
