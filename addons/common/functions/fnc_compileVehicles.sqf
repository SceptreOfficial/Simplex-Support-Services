params [
	["_sides",[west,east,independent,civilian],[[],sideEmpty]],
	["_vehicleClasses",["men","car","armored","air","ship","submarine","support","autonomous"],[[],""]],
	["_blacklist",[],[[]]],
	["_tree",true,[false]]
];

if (_sides isEqualType sideEmpty) then {
	_sides = [_sides];
};

if (_vehicleClasses isEqualType "") then {
	_vehicleClasses = [_vehicleClasses];
};

private _sideHash = createHashMapFromArray [[west,1],[east,0],[independent,2],[civilian,3]];
private _cfgFactionClasses = configFile >> "CfgFactionClasses";
private _sideNumbers = _sides apply {_sideHash get _x};

_vehicleClasses = _vehicleClasses apply {toLower _x};
_blacklist = _blacklist apply {toLower _x};

if (_tree) then {
	private _tree = createHashMap;

	{
		private _class = configName _x;
		private _cfg = _x;

		if (_class != "" &&	getNumber (_cfg >> "scope") >= 2 && {!(toLower _class in _blacklist)}) then {
			private _vehicleClass = getText (_cfg >> "vehicleClass");
			
			{
				if (getNumber (_cfg >> "side") isEqualTo (_sideHash get _x) && {toLower _vehicleClass in _vehicleClasses}) then {
					private _faction = "#" + getText (_cfgFactionClasses >> getText (_cfg >> "faction") >> "displayName");

					(((_tree getOrDefault [_x,createHashMap,true]) getOrDefault [_faction,createHashMap,true]) getOrDefault ["#" + _vehicleClass,[],true]) pushBack [
						_class,
						getText (_cfg >> "displayName")
					];
				};
			} forEach _sides;
		};
	} forEach configProperties [configFile >> "CfgVehicles","isClass _x",true];

	call compile str (_tree apply {["#" + str _x,_y]})
} else {
	private _list = [];

	{
		private _class = configName _x;
		private _cfg = _x;

		if (_class != "" &&	getNumber (_cfg >> "scope") >= 2 && {!(toLower _class in _blacklist)}) then {
			private _vehicleClass = (getText (_cfg >> "vehicleClass"));
			
			if (getNumber (_cfg >> "side") in _sideNumbers && {toLower _vehicleClass in _vehicleClasses}) then {
				private _faction = getText (_cfgFactionClasses >> getText (_cfg >> "faction") >> "displayName");

				_list pushBack [
					_class,
					getText (_cfg >> "displayName") + " - " + _faction
				];
			};
		};
	} forEach configProperties [configFile >> "CfgVehicles","isClass _x",true];

	_list
};

//private _side = [1,0,2,3] # _lbCurSel;
//private _vehicleHash = createHashMap;
//private _cfgFactionClasses = configFile >> "CfgFactionClasses";
//private _cfgEditorSubcategories = configFile >> "CfgEditorSubcategories";
//
//{
//	if (getNumber (_x >> "scope") == 2 &&
//		{getNumber (_x >> "side") == _side} &&
//		{getText (_x >> "vehicleClass") == "Air"}
//	) then {
//		private _category = getText (_cfgEditorSubcategories >> getText (_x >> "editorSubcategory") >> "displayName");
//		private _faction = getText (_cfgFactionClasses >> getText (_x >> "faction") >> "displayName");
//
//		((_vehicleHash getOrDefault [_faction,createHashMap,true]) getOrDefault [_category,[],true]) pushBack [
//			configName _x,
//			getText (_x >> "displayName"),
//			getText (_x >> "picture")
//		];
//	};
//} forEach configProperties [configFile >> "CfgVehicles","isClass _x",true];