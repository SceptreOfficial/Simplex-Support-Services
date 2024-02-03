#include "..\script_component.hpp"
#include "\A3\ui_f_curator\ui\defineResinclDesign.inc"

params ["_logic","_synced"];

if (!local _logic) exitWith {};

[{
	params ["_logic","_synced"];

	if (isNull findDisplay IDD_RSCDISPLAYCURATOR) then {
		_logic getVariable ["ObjectArea",[]] params [
			["_width",10,[0]],
			["_length",10,[0]],
			["_direction",0,[0]],
			["_isRectangle",true,[false]],
			["_height",10,[0]]
		];

		_logic setVariable [QEGVAR(common,drawShape3D),[[_logic,_width,_length,_direction,_isRectangle,_height]],true];

		if (_logic getVariable ["Behavior","MONITOR"] == "INITIATE") then {
			_logic setVariable [QGVAR(reference),_logic call FUNC(reference),true];
		};
	} else {
		_fnc_drawHelper = {
			params ["","_logic"];
			[[
				_logic,
				1 call EFUNC(sdf,getValue),
				2 call EFUNC(sdf,getValue),
				0 call EFUNC(sdf,getValue),
				4 call EFUNC(sdf,getValue),
				3 call EFUNC(sdf,getValue)
			]] call EFUNC(common,drawShape3D);
		};

		private _entities = (EGVAR(common,services) getOrDefault [QSERVICE,[]]) apply {[_x getVariable QPVAR(callsign),_x]};
		_entities sort true;
	
		[LLSTRING(moduleReferenceArea_name),[
			["SLIDER",DESC(direction),[[0,360,0],0],true,_fnc_drawHelper],
			["SLIDER","Width",[[0,50,1],10],true,_fnc_drawHelper],
			["SLIDER","Length",[[0,50,1],10],true,_fnc_drawHelper],
			["SLIDER","Height",[[0,50,1],10],true,_fnc_drawHelper],
			["TOOLBOX","Shape",[["Rectangle","Ellipse"],0,[true,false]],true,_fnc_drawHelper],
			["COMBOBOX",DESC(Behavior),[[
				[LLSTRING(Initiate_name),LLSTRING(Initiate_info)],
				[LLSTRING(Monitor_name),LLSTRING(Monitor_info)]
			],"MONITOR",["INITIATE","MONITOR"]]],
			["EDITBOX",DESC(Category),""],
			["COMBOBOX",DESC(Infantry),[[
				LELSTRING(common,disable),
				LLSTRING(individuals),
				LLSTRING(groups)
			],0]],
			["EDITBOX",DESC(Filter),"false"],
			["EDITBOX",DESC(LoadEval),"1"],
			["EDITBOX",DESC(ItemInit),""],
			["LISTNBOXCB","Apply to:",[_entities apply {[[_x # 0,"",_x # 1 getVariable QPVAR(icon)]]},[],4,_entities apply {_x # 1}]]
		],[{
			params ["_values","_logic"];
			_values params [
				"_dir",
				"_width",
				"_length",
				"_height",
				"_isRectangle",
				"_behavior",
				"_category",
				"_infantry",
				"_filter",
				"_loadEval",
				"_itemInit",
				"_entities"
			];

			_logic setDir _dir;
			_logic setVariable [QEGVAR(common,drawShape3D),[[_logic,_width,_length,_logic,_isRectangle]],true];
			_logic setVariable ["ObjectArea",[_width,_length,_dir,_isRectangle,_height],true];
			_logic setVariable ["Category",_category,true];
			_logic setVariable ["Infantry",_infantry,true];
			_logic setVariable ["Behavior",_behavior,true];
			_logic setVariable ["Filter",_filter,true];
			_logic setVariable ["LoadEval",_loadEval,true];
			_logic setVariable ["ItemInit",_itemInit,true];

			if (_behavior == "INITIATE") then {
				_logic setVariable [QGVAR(reference),_logic call FUNC(reference),true];
			};

			{_x setVariable [QPVAR(referenceAreas),(_x getVariable [QPVAR(referenceAreas),[]]) + [_logic],true]} forEach _entities;

			ZEUS_MESSAGE(LLSTRING(referenceAreaCreated));
		},{
			params ["","_logic"];
			false call EFUNC(common,drawShape3D);
			deleteVehicle _logic;
		}],_logic] call EFUNC(sdf,dialog);
	};
},_this,2] call CBA_fnc_execAfterNFrames;
