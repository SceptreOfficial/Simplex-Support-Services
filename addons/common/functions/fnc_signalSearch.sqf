#include "..\script_component.hpp"

params [["_type","",[""]],["_posAGL",[0,0,0],[[],objNull]],["_searchRadius",500,[0]],["_ignore",[]]];

if !(_ignore isEqualType []) then {_ignore = [_ignore]};

if (_type in ["","ANY"]) exitWith {
	(_posAGL nearObjects _searchRadius select {
		(_x isKindOf "FlareBase" || _x isKindOf "ACE_Handflare_Base" || _x isKindOf "SmokeShell" || _x isKindOf "IRStrobeBase") &&
		{!(_x isKindOf "Chemlight_base")} &&
		{vectorMagnitude velocity _x < 5 && getPos _x # 2 < 3}
	}) - _ignore // param [0,objNull];
};

switch (toUpper _type) do {
	case "SMOKE" : {
		((_posAGL nearObjects ["SmokeShell",_searchRadius]) select {
			vectorMagnitude velocity _x < 5 && getPos _x # 2 < 3
		}) - _ignore;
	};
	case "IR" : {
		((_posAGL nearObjects ["IRStrobeBase",_searchRadius]) select {
			vectorMagnitude velocity _x < 5 && getPos _x # 2 < 3
		}) - _ignore;
	};
	case "FLARE" : {
		((_posAGL nearObjects _searchRadius) select {
			(_x isKindOf "FlareBase" || _x isKindOf "ACE_G_Handflare_White") && 
			{vectorMagnitude velocity _x < 5 && getPos _x # 2 < 3}
		}) - _ignore;
	};
};

//((_posAGL nearObjects _searchRadius) select {
//	vectorMagnitude velocity _x < 5 && getPos _x # 2 < 3 &&
//	{_x isKindOf _type1 || {_x isKindOf _type2}}
//}) - _ignore // param [0,objNull];
