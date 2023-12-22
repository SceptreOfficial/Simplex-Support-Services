#include "script_component.hpp"

/*
	Classes must be lowercase
	
	["vehicle_base_class",[default offset,[
		["specific_weapon_class",specific offset],
		["specific_weapon_class",specific offset]
	]]]
*/

GVAR(strafeElevationOffsets) = createHashMapFromArray [
	["o_heli_attack_02_dynamicloadout_f",[-3,[
		["gatling_30mm",0]
	]]],
	["vtol_02_base_f",[-3,[
		["gatling_30mm_vtol_02",5],
		["gatling_30mm_vtol_02",5]
	]]],
	//["rhs_melb_base",[-2,[
	//	["rhs_weap_m134_pylon",-2],
	//	["rhs_weap_ffarlauncher",-1.5]
	//]]],
	["rhs_a10",[2,[
		["rhs_weap_gau8",0]
	]]],
	["RHS_UH1Y",[-1,[]]]
];
