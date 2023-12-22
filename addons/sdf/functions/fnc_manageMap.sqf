#include "script_component.hpp"

params [
	["_ctrlMap",controlNull,[controlNull]],
	["_pointData",[],[[]]],
	["_areaData",[],[[]]],
	["_lineData",[],[[]]],
	["_mode",0,[0]],
	"_onValueChanged"
];

_pointData params [["_points",[[0,0,0]],[[]]]];
_areaData params [["_area",[[0,0,0],0,0,0,true],[[]]]];
_lineData params [["_path",[]]];

private _mapPos = switch _mode do {
	case 0 : {[_points # 0,missionNamespace getVariable [QGVAR(mapCenter),getPos player]] select (_points # 0 in [[0,0],[0,0,0]])};
	case 1 : {[_area # 0,missionNamespace getVariable [QGVAR(mapCenter),getPos player]] select (_area # 0 isEqualTo [0,0,0])};
	case 2 : {[_path # 0,missionNamespace getVariable [QGVAR(mapCenter),getPos player]] select (_path isEqualTo [])};
};

if (_ctrlMap getVariable [QGVAR(anim),true]) then {
	_ctrlMap setVariable [QGVAR(anim),false];
	_ctrlMap ctrlMapAnimAdd [0,missionNamespace getVariable [QGVAR(mapScale),(ctrlMapScale _ctrlMap) * 2],_mapPos];
	ctrlMapAnimCommit _ctrlMap;
};

_ctrlMap setVariable [QGVAR(custom),true];
_ctrlMap setVariable [QGVAR(parameters),["MAP","",[_pointData,_areaData,_lineData,_mode]]];
_ctrlMap setVariable [QGVAR(onValueChanged),_onValueChanged];
_ctrlMap setVariable [QGVAR(value),+([_points,_area,_path] # _mode)];
_ctrlMap setVariable [QGVAR(pointData),_pointData];
_ctrlMap setVariable [QGVAR(areaData),_areaData];
_ctrlMap setVariable [QGVAR(lineData),_lineData];
_ctrlMap setVariable [QGVAR(mode),_mode];
_ctrlMap setVariable [QGVAR(modeCache),[_points,_area,_path]];
_ctrlMap setVariable [QGVAR(multiPoint),false];
_ctrlMap setVariable [QGVAR(areaSpecial),false];
_ctrlMap setVariable [QGVAR(areaSpecialMoving),{}];
_ctrlMap setVariable [QGVAR(areaSpecialKeyDown),{}];

[_ctrlMap,_mode,true] call FUNC(mapMode);

private _IDs = _ctrlMap getVariable QGVAR(manageIDs);

if (!isNil "_IDs") then {
	_ctrlMap ctrlRemoveEventHandler ["MouseButtonDown",_IDs # 0];
	_ctrlMap ctrlRemoveEventHandler ["MouseButtonUp",_IDs # 1];
	_ctrlMap ctrlRemoveEventHandler ["MouseMoving",_IDs # 2];
	_ctrlMap ctrlRemoveEventHandler ["MouseMoving",_IDs # 3];
	_ctrlMap ctrlRemoveEventHandler ["Destroy",_IDs # 4];
	_ctrlMap ctrlRemoveEventHandler ["KeyDown",_IDs # 5];
};

_ctrlMap setVariable [QGVAR(manageIDs),[
	// Value updating
	[_ctrlMap,"MouseButtonDown",{
		params ["_ctrlMap","_button","_xPos","_yPos","_shiftKey","_ctrlKey","_altKey"];

		if (_button != 0 || _ctrlMap getVariable [QGVAR(override),false]) exitWith {};

		private _pos = _ctrlMap posScreenToWorld [_xPos,_yPos];

		_ctrlMap setVariable [QGVAR(start),_pos];
		_ctrlMap setVariable [QGVAR(down),true];
		_ctrlMap setVariable [QGVAR(shiftDown),_shiftKey];
		_ctrlMap setVariable [QGVAR(ctrlDown),_ctrlKey];
		_ctrlMap setVariable [QGVAR(altDown),_altKey];

		switch (_ctrlMap getVariable QGVAR(mode)) do {
			case 1 : {
				_ctrlMap setVariable [QGVAR(inArea),_pos inArea (_ctrlMap getVariable QGVAR(value))];
				_ctrlMap setVariable [QGVAR(startCenter),(_ctrlMap getVariable QGVAR(value)) # 0];
				_ctrlMap setVariable [QGVAR(startDir),(_ctrlMap getVariable QGVAR(value)) # 3];

				//if (_shiftKey && _ctrlMap getVariable QGVAR(areaSpecial)) then {
				//	[_ctrlMap,uiNamespace getVariable QGVAR(arguments)] call (_ctrlMap getVariable QGVAR(areaSpecialKeyDown));
				//	// Shape switch
				//	//[_ctrlMap,!(_ctrlMap getVariable QGVAR(value) # 4)] call FUNC(mapAreaShape);
				//};
			};
			case 2 : {
				_ctrlMap setVariable [QGVAR(value),[+_pos]];

				[_ctrlMap,[_pos]] call (_ctrlMap getVariable QGVAR(onValueChanged));
			};
		};
	}] call CBA_fnc_addBISEventHandler,

	[_ctrlMap,"MouseButtonUp",{
		params ["_ctrlMap","_button","_xPos","_yPos","_shiftKey","_ctrlKey","_altKey"];

		if (_button != 0 || _ctrlMap getVariable [QGVAR(override),false]) exitWith {};

		_ctrlMap setVariable [QGVAR(down),false];

		if (_ctrlMap getVariable QGVAR(mode) != 0) exitWith {};

		private _pos = _ctrlMap getVariable QGVAR(start);
		
		if (isNil "_pos") exitWith {};
		
		_pos set [2,0];

		private _value = _ctrlMap getVariable QGVAR(value);
		private _markers = _ctrlMap getVariable [QGVAR(markers),[]];

		if (_ctrlMap getVariable QGVAR(ctrlDown) && _ctrlMap getVariable QGVAR(multiPoint)) then {
			_value pushBack _pos;
		} else {
			{deleteMarkerLocal _x} forEach _markers;
			_markers = [];
			_value = [_pos];
		};

		_ctrlMap getVariable QGVAR(pointData) params ["",["_type","mil_destroy"],["_text",""],["_color","Default"],["_angle",0],["_size",[0.8,0.8]],["_alpha",1]];
		
		if !(_ctrlMap getVariable [QGVAR(disableMarkers),false]) then {
			private _marker = createMarkerLocal [format ["%1%2_%3",QGVAR(marker),CBA_missionTime,random 1],_pos];
			_marker setMarkerShapeLocal "ICON";
			_marker setMarkerTypeLocal _type;
			_marker setMarkerTextLocal _text;
			_marker setMarkerColorLocal _color;
			_marker setMarkerDirLocal _angle;
			_marker setMarkerSizeLocal _size;
			_marker setMarkerAlphaLocal _alpha;
			_markers pushBack _marker;
		};
		
		_ctrlMap setVariable [QGVAR(markers),_markers];
		_ctrlMap setVariable [QGVAR(value),+_value];
			
		[_ctrlMap,_value] call (_ctrlMap getVariable QGVAR(onValueChanged));
	}] call CBA_fnc_addBISEventHandler,

	// Area functionality
	[_ctrlMap,"MouseMoving",{
		params ["_ctrlMap"];

		if (_ctrlMap getVariable QGVAR(mode) != 1 || _ctrlMap getVariable [QGVAR(override),false]) exitWith {};

		private _current = _ctrlMap posScreenToWorld getMousePosition;
		private _markers = _ctrlMap getVariable [QGVAR(markers),[]];
		private _marker = _markers # 0;

		if (_current inArea _marker) then {
			if (_ctrlMap getVariable QGVAR(areaSpecial)) then {
				_ctrlMap ctrlSetTooltip format [LLSTRING(mapTooltipSpecial),_ctrlMap getVariable QGVAR(areaSpecialTip)];
			} else {
				_ctrlMap ctrlSetTooltip LLSTRING(mapTooltip);
			};
		} else {
			_ctrlMap ctrlSetTooltip "";
		};
		
		if !(_ctrlMap getVariable [QGVAR(down),false]) exitWith {};

		private _start = _ctrlMap getVariable QGVAR(start);
		private _value = _ctrlMap getVariable QGVAR(value);
		private _isRectangle = _value # 4;

		// Special
		if (_ctrlMap getVariable [QGVAR(shiftDown),false] && _ctrlMap getVariable QGVAR(areaSpecial)) exitWith {
			[_ctrlMap,uiNamespace getVariable QGVAR(arguments)] call (_ctrlMap getVariable QGVAR(areaSpecialMoving));
		};

		// Rotation
		if (_ctrlMap getVariable [QGVAR(ctrlDown),false]) exitWith {
			private _dir = if (_ctrlMap getVariable [QGVAR(altDown),false]) then {
				(_value # 0) getDir _current
			} else {
				(_ctrlMap getVariable QGVAR(startDir)) + ((_value # 0 getDir _current) - (_value # 0 getDir _start))
			};
			
			// Normalize
			_dir = ((_dir % 360) + 360) % 360;

			_marker setMarkerDirLocal _dir;

			_value set [3,markerDir _marker];
			_ctrlMap setVariable [QGVAR(value),+_value];

			[_ctrlMap,_value] call (_ctrlMap getVariable QGVAR(onValueChanged));
		};

		// Resize
		if (_ctrlMap getVariable [QGVAR(altDown),false]) exitWith {
			private _hyp = _value # 0 distance2D _current;
			private _dir = (_value # 0 getDir _current) - _value # 3;
			private _width = abs (_hyp * sin _dir);
			private _height = abs (_hyp * cos _dir);

			_marker setMarkerSizeLocal [_width,_height];

			_ctrlMap setVariable [QGVAR(value),+[_value # 0,_width,_height,_value # 3,_isRectangle]];

			[_ctrlMap,[_value # 0,_width,_height,_value # 3,_isRectangle]] call (_ctrlMap getVariable QGVAR(onValueChanged));
		};

		// Movement
		if (_ctrlMap getVariable [QGVAR(inArea),false]) exitWith {
			private _center = (_ctrlMap getVariable QGVAR(startCenter)) vectorAdd (_current vectorDiff _start);
			_center set [2,0];
			_marker setMarkerPosLocal _center;

			_value set [0,_center];
			_ctrlMap setVariable [QGVAR(value),+_value];

			[_ctrlMap,_value] call (_ctrlMap getVariable QGVAR(onValueChanged));
		};

		// Drag creation
		private _center = [(_start # 0 + _current # 0) / 2,(_start # 1 + _current # 1) / 2,0];
		private _width = abs (_current # 0 - _center # 0);
		private _height = abs (_current # 1 - _center # 1);

		_marker setMarkerSizeLocal [_width,_height];
		_marker setMarkerPosLocal _center;
		_marker setMarkerDirLocal 0;

		_ctrlMap setVariable [QGVAR(value),+[_center,_width,_height,0,_isRectangle]];

		[_ctrlMap,[_center,_width,_height,0,_isRectangle]] call (_ctrlMap getVariable QGVAR(onValueChanged));
	}] call CBA_fnc_addBISEventHandler,

	// Line functionality
	[_ctrlMap,"MouseMoving",{
		params ["_ctrlMap"];

		if (
			_ctrlMap getVariable QGVAR(mode) != 2 ||
			!(_ctrlMap getVariable [QGVAR(down),false]) ||
			CBA_missionTime < (_ctrlMap getVariable [QGVAR(lineBuffer),-1]) ||
			_ctrlMap getVariable [QGVAR(override),false]
		) exitWith {};

		_ctrlMap setVariable [QGVAR(lineBuffer),CBA_missionTime + 0.05];

		private _value = _ctrlMap getVariable QGVAR(value);
		private _markers = _ctrlMap getVariable [QGVAR(markers),[]];
		private _current = _ctrlMap posScreenToWorld getMousePosition;

		_value pushBack _current;

		if (count _value > 1) then {
			(_markers # 0) setMarkerPolylineLocal flatten (_value apply {[_x # 0,_x # 1]});
		};

		_ctrlMap setVariable [QGVAR(value),+_value];

		[_ctrlMap,_value] call (_ctrlMap getVariable QGVAR(onValueChanged));
	}] call CBA_fnc_addBISEventHandler,

	// Deleting temp marker when control deletion
	[_ctrlMap,"Destroy",{
		params ["_ctrlMap"];
		{deleteMarkerLocal _x} forEach (_ctrlMap getVariable [QGVAR(markers),[]]);
	}] call CBA_fnc_addBISEventHandler,

	[_ctrlMap,"KeyDown",{
		params ["_ctrlMap","","_shiftKey"];
		
		if (_shiftKey && _ctrlMap getVariable QGVAR(areaSpecial)) then {
			[_ctrlMap,uiNamespace getVariable QGVAR(arguments)] call (_ctrlMap getVariable QGVAR(areaSpecialKeyDown));
		};
		
		false
	}] call CBA_fnc_addBISEventHandler
]];
