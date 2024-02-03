#include "..\script_component.hpp"

_valueData params [["_pointData",[],[[]]],["_areaData",[],[[]]],["_lineData",[],[[]]],["_mode",0,[0]]];

private _ctrl = _display ctrlCreate ["RscMapControl",-1];

// Map controls don't work right in control groups
// We just need to set the static position with relative coordinates
_position = [_position # 0 + _posX,_position # 1 + _posY,_position # 2,_position # 3];
_ctrl ctrlSetPosition _position;
_ctrl ctrlCommit 0;

_pointData params [["_points",[[0,0,0]],[[]]]];
_areaData params [["_area",[[0,0,0],0,0,0,true],[[]]]];
_lineData params [["_path",[]]];

private _mapDefault = switch _mode do {
	case 0 : {[_points # 0,getPos player] select (_points # 0 in [[0,0],[0,0,0]])};
	case 1 : {[_area # 0,getPos player] select (_area # 0 isEqualTo [0,0,0])};
	case 2 : {[_path # 0,getPos player] select (_path isEqualTo [])};
};

private _offset = getPos player vectorDiff (_ctrl ctrlMapScreenToWorld [_position # 0 + (_position # 2 / 2),_position # 1 + (_position # 3 / 2)]);
_ctrl ctrlMapAnimAdd [0,(ctrlMapScale _ctrl) * 2,_mapDefault vectorAdd (_offset vectorMultiply 2)];
ctrlMapAnimCommit _ctrl;

_ctrl setVariable [QGVAR(parameters),[_type,_description,_valueData]];
_ctrl setVariable [QGVAR(position),_position];
_ctrl setVariable [QGVAR(onValueChanged),_onValueChanged];
_ctrl setVariable [QGVAR(enableCondition),_enableCondition];
_ctrl setVariable [QGVAR(value),+([_points,_area,_path] # _mode)];
_ctrl setVariable [QGVAR(pointData),_pointData];
_ctrl setVariable [QGVAR(areaData),_areaData];
_ctrl setVariable [QGVAR(lineData),_lineData];
_ctrl setVariable [QGVAR(mode),_mode];
_ctrl setVariable [QGVAR(modeCache),[_points,_area,_path]];
_ctrl setVariable [QGVAR(multiPoint),false];
_ctrl setVariable [QGVAR(areaSpecial),false];
_ctrl setVariable [QGVAR(areaSpecialMoving),{}];
_ctrl setVariable [QGVAR(areaSpecialKeyDown),{}];

_controls pushBack _ctrl;

[_ctrl,_mode,true] call FUNC(mapMode);

// Value updating
[_ctrl,"MouseButtonDown",{
	params ["_ctrl","_button","_xPos","_yPos","_shiftKey","_ctrlKey","_altKey"];

	if (_button != 0) exitWith {};

	private _pos = _ctrl posScreenToWorld [_xPos,_yPos];

	_ctrl setVariable [QGVAR(start),_pos];
	_ctrl setVariable [QGVAR(down),true];
	_ctrl setVariable [QGVAR(shiftDown),_shiftKey];
	_ctrl setVariable [QGVAR(ctrlDown),_ctrlKey];
	_ctrl setVariable [QGVAR(altDown),_altKey];

	switch (_ctrl getVariable QGVAR(mode)) do {
		case 1 : {
			_ctrl setVariable [QGVAR(inArea),_pos inArea (_ctrl getVariable QGVAR(value))];
			_ctrl setVariable [QGVAR(startCenter),(_ctrl getVariable QGVAR(value)) # 0];
			_ctrl setVariable [QGVAR(startDir),(_ctrl getVariable QGVAR(value)) # 3];

			//if (_shiftKey && _ctrl getVariable QGVAR(areaSpecial)) then {
			//	[_ctrl,uiNamespace getVariable QGVAR(arguments)] call (_ctrl getVariable QGVAR(areaSpecialKeyDown));
			//	// Shape switch
			//	//[_ctrl,!(_ctrl getVariable QGVAR(value) # 4)] call FUNC(mapAreaShape);
			//};
		};
		case 2 : {
			_ctrl setVariable [QGVAR(value),[+_pos]];

			if (GVAR(skipOnValueChanged)) exitWith {};

			[[_pos],uiNamespace getVariable QGVAR(arguments),_ctrl] call (_ctrl getVariable QGVAR(onValueChanged));
		};
	};
}] call CBA_fnc_addBISEventHandler;

[_ctrl,"MouseButtonUp",{
	params ["_ctrl","_button","_xPos","_yPos","_shiftKey","_ctrlKey","_altKey"];

	if (_button != 0) exitWith {};

	_ctrl setVariable [QGVAR(down),false];

	if (_ctrl getVariable QGVAR(mode) != 0) exitWith {};

	private _pos = _ctrl getVariable QGVAR(start);
	_pos set [2,0];
	private _value = _ctrl getVariable QGVAR(value);
	private _markers = _ctrl getVariable [QGVAR(markers),[]];

	if (_ctrl getVariable QGVAR(ctrlDown) && _ctrl getVariable QGVAR(multiPoint)) then {
		_value pushBack _pos;
	} else {
		{deleteMarkerLocal _x} forEach _markers;
		_markers = [];
		_value = [_pos];
	};

	_ctrl getVariable QGVAR(pointData) params ["",["_type","mil_destroy"],["_text",""],["_color","Default"],["_angle",0],["_size",[0.8,0.8]],["_alpha",1]];
	
	if !(_ctrl getVariable [QGVAR(disableMarkers),false]) then {
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
	
	_ctrl setVariable [QGVAR(markers),_markers];
	_ctrl setVariable [QGVAR(value),+_value];

	if (GVAR(skipOnValueChanged)) exitWith {};
		
	[_value,uiNamespace getVariable QGVAR(arguments),_ctrl] call (_ctrl getVariable QGVAR(onValueChanged));
}] call CBA_fnc_addBISEventHandler;

// Area functionality
[_ctrl,"MouseMoving",{
	params ["_ctrl"];

	if (_ctrl getVariable QGVAR(mode) != 1) exitWith {};

	private _current = _ctrl posScreenToWorld getMousePosition;
	private _markers = _ctrl getVariable [QGVAR(markers),[]];
	private _marker = _markers # 0;

	if (_current inArea _marker) then {
		if (_ctrl getVariable QGVAR(areaSpecial)) then {
			_ctrl ctrlSetTooltip format [LLSTRING(mapTooltipSpecial),_ctrl getVariable QGVAR(areaSpecialTip)];
		} else {
			_ctrl ctrlSetTooltip LLSTRING(mapTooltip);
		};
	} else {
		_ctrl ctrlSetTooltip "";
	};
	
	if !(_ctrl getVariable [QGVAR(down),false]) exitWith {};

	private _start = _ctrl getVariable QGVAR(start);
	private _value = _ctrl getVariable QGVAR(value);
	private _isRectangle = _value # 4;

	// Special
	if (_ctrl getVariable [QGVAR(shiftDown),false] && _ctrl getVariable QGVAR(areaSpecial)) exitWith {
		[_ctrl,uiNamespace getVariable QGVAR(arguments)] call (_ctrl getVariable QGVAR(areaSpecialMoving));
	};

	// Rotation
	if (_ctrl getVariable [QGVAR(ctrlDown),false]) exitWith {
		private _dir = if (_ctrl getVariable [QGVAR(altDown),false]) then {
			(_value # 0) getDir _current
		} else {
			(_ctrl getVariable QGVAR(startDir)) + ((_value # 0 getDir _current) - (_value # 0 getDir _start))
		};
		
		// Normalize
		_dir = ((_dir % 360) + 360) % 360;

		_marker setMarkerDirLocal _dir;

		_value set [3,markerDir _marker];
		_ctrl setVariable [QGVAR(value),+_value];

		if (GVAR(skipOnValueChanged)) exitWith {};

		[_value,uiNamespace getVariable QGVAR(arguments),_ctrl] call (_ctrl getVariable QGVAR(onValueChanged));
	};

	// Resize
	if (_ctrl getVariable [QGVAR(altDown),false]) exitWith {
		private _hyp = _value # 0 distance2D _current;
		private _dir = (_value # 0 getDir _current) - _value # 3;
		private _width = abs (_hyp * sin _dir);
		private _height = abs (_hyp * cos _dir);

		_marker setMarkerSizeLocal [_width,_height];

		_ctrl setVariable [QGVAR(value),+[_value # 0,_width,_height,_value # 3,_isRectangle]];

		if (GVAR(skipOnValueChanged)) exitWith {};

		[[_value # 0,_width,_height,_value # 3,_isRectangle],uiNamespace getVariable QGVAR(arguments),_ctrl] call (_ctrl getVariable QGVAR(onValueChanged));
	};

	// Movement
	if (_ctrl getVariable [QGVAR(inArea),false]) exitWith {
		private _center = (_ctrl getVariable QGVAR(startCenter)) vectorAdd (_current vectorDiff _start);
		_marker setMarkerPosLocal _center;

		_value set [0,_center];
		_ctrl setVariable [QGVAR(value),+_value];

		if (GVAR(skipOnValueChanged)) exitWith {};

		[_value,uiNamespace getVariable QGVAR(arguments),_ctrl] call (_ctrl getVariable QGVAR(onValueChanged));
	};

	// Drag creation
	private _center = [(_start # 0 + _current # 0) / 2,(_start # 1 + _current # 1) / 2,0];
	private _width = abs (_current # 0 - _center # 0);
	private _height = abs (_current # 1 - _center # 1);

	_marker setMarkerSizeLocal [_width,_height];
	_marker setMarkerPosLocal _center;
	_marker setMarkerDirLocal 0;

	_ctrl setVariable [QGVAR(value),+[_center,_width,_height,0,_isRectangle]];

	if (GVAR(skipOnValueChanged)) exitWith {};

	[[_center,_width,_height,0,_isRectangle],uiNamespace getVariable QGVAR(arguments),_ctrl] call (_ctrl getVariable QGVAR(onValueChanged));
}] call CBA_fnc_addBISEventHandler;

// Line functionality
[_ctrl,"MouseMoving",{
	params ["_ctrl"];

	if (
		_ctrl getVariable QGVAR(mode) != 2 ||
		!(_ctrl getVariable [QGVAR(down),false]) ||
		CBA_missionTime < (_ctrl getVariable [QGVAR(lineBuffer),-1])
	) exitWith {};

	_ctrl setVariable [QGVAR(lineBuffer),CBA_missionTime + 0.05];

	private _value = _ctrl getVariable QGVAR(value);
	private _markers = _ctrl getVariable [QGVAR(markers),[]];
	private _current = _ctrl posScreenToWorld getMousePosition;

	_value pushBack _current;

	if (count _value > 1) then {
		(_markers # 0) setMarkerPolylineLocal flatten (_value apply {[_x # 0,_x # 1]});
	};

	_ctrl setVariable [QGVAR(value),+_value];

	if (GVAR(skipOnValueChanged)) exitWith {};

	[_value,uiNamespace getVariable QGVAR(arguments),_ctrl] call (_ctrl getVariable QGVAR(onValueChanged));
}] call CBA_fnc_addBISEventHandler;

// Deleting temp marker when control deletion
[_ctrl,"Destroy",{
	params ["_ctrl"];
	{deleteMarkerLocal _x} forEach (_ctrl getVariable [QGVAR(markers),[]]);
}] call CBA_fnc_addBISEventHandler;

// Handle focus between map and control group since map isn't inside group
[_display,"MouseMoving",{
	_thisArgs params ["_position","_ctrl","_ctrlGroup"];
	_position params ["_mapX","_mapY","_mapW","_mapH"];

	if (getMousePosition inArea [[_mapX + (_mapW / 2),_mapY + (_mapH / 2)],_mapW / 2,_mapH / 2,0,true]) then {
		if (_ctrl getVariable [QGVAR(notFocused),true]) then {
			ctrlSetFocus _ctrl;
			_ctrlGroup setVariable [QGVAR(notFocused),true];
			_ctrl setVariable [QGVAR(notFocused),false];
		};
	} else {
		if (_ctrlGroup getVariable [QGVAR(notFocused),true]) then {
			ctrlSetFocus _ctrlGroup;
			_ctrlGroup setVariable [QGVAR(notFocused),false];
			_ctrl setVariable [QGVAR(notFocused),true];
		};
	};
},[_position,_ctrl,_ctrlGroup]] call CBA_fnc_addBISEventHandler;

[_ctrl,"KeyDown",{
	params ["_ctrl","","_shiftKey"];
	
	if (_shiftKey && _ctrl getVariable QGVAR(areaSpecial)) then {
		[_ctrl,uiNamespace getVariable QGVAR(arguments)] call (_ctrl getVariable QGVAR(areaSpecialKeyDown));
	};
	
	false
}] call CBA_fnc_addBISEventHandler;
