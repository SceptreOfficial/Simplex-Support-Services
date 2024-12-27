#include "..\script_component.hpp"

if ([QSERVICE,QGVAR(gui)] call EFUNC(common,gui_verify)) exitWith {};

private _display = uiNamespace getVariable QEGVAR(sdf,display);
private _player = call CBA_fnc_currentUnit;
private _entity = PVAR(guiEntity);

(_display displayCtrl IDC_ABORT) ctrlEnable !(_entity getVariable [QPVAR(task),""] in ["","RESPAWN","COOLDOWN"]);

// Verify plan
private _ctrlGroup = _display displayCtrl IDC_INSTRUCTIONS_GROUP;
private _ctrlRelocateGroup = _ctrlGroup controlsGroupCtrl IDC_RELOCATE_GROUP;
private _ctrlConfirm = _display displayCtrl IDC_CONFIRM;
private _ctrlCoordination = ((_display displayCtrl IDC_INSTRUCTIONS_GROUP) controlsGroupCtrl IDC_PLAN_OPTIONS_GROUP) controlsGroupCtrl IDC_COORDINATION;
private _busy = _entity getVariable [QPVAR(busy),false];

lnbClear _ctrlCoordination;

DELETE_GUI_MARKERS;

if (GVAR(guiTab) == 1) exitWith {
	GVAR(coordinated) = [];
	_ctrlConfirm ctrlEnable (!_busy && {+[_player,_entity,"RELOCATE",[GVAR(relocatePosASL)]] call (_entity getVariable QPVAR(requestCondition))});
};

if (GVAR(plan) isEqualTo []) exitWith {
	GVAR(coordinated) = [];
	_ctrlConfirm ctrlEnable false;
};

if ((_entity getVariable QPVAR(sheafTypes)) isEqualTo ["NONE"]) exitWith {
	_ctrlConfirm ctrlEnable false;
};

private _ctrlAmmunition = (_ctrlGroup controlsGroupCtrl IDC_TASK_GROUP) controlsGroupCtrl IDC_AMMUNITION;
private _ctrlETA = (_ctrlGroup controlsGroupCtrl IDC_TASK_GROUP) controlsGroupCtrl IDC_ETA;
private _ctrlPlan = _ctrlGroup controlsGroupCtrl IDC_PLAN_GROUP controlsGroupCtrl IDC_PLAN;

private _valid = true;
private _vehicles = _entity getVariable QPVAR(vehicles);
private _vehiclesCount = count _vehicles;

private _allMagazines = flatten (GVAR(plan) apply {_x # 2});
private _ammoCount = createHashMapFromArray (+(_entity getVariable QPVAR(ammunition)) apply {
	_x params ["_class","_roundLimit"];

	private _index = GVAR(magTypes) find _class;
	
	if (_index != -1) then {
		if (_roundLimit >= 0) then {
			_ctrlAmmunition lnbSetText [[_index,0],str _roundLimit];
		} else {
			_ctrlAmmunition lnbSetPicture [[_index,0],ICON_INFINITE];
		};
	};

	[_x,[_class,1e39]] select (_roundLimit < 0)
});

{
	_x params ["_area","_sheaf","_magazines","_rounds","_execDelay","_firingDelay"];

	{_ammoCount set [_x,(_ammoCount get _x) - _rounds]} forEach _magazines;

	_ctrlPlan lnbSetColor [[_forEachIndex,0],[1,1,1,1]];	
	_ctrlPlan lnbSetColor [[_forEachIndex,3],[1,1,1,1]];
} forEach GVAR(plan);

private _center = _vehicles call EFUNC(common,positionAvg);
private _nearbyBatteries = [_entity,_center,_allMagazines arrayIntersect _allMagazines] call FUNC(getNearbyBatteries);

_ctrlCoordination setVariable [QGVAR(nearbyBatteries),_nearbyBatteries];
GVAR(coordinated) = _nearbyBatteries arrayIntersect GVAR(coordinated);

{
	if (isNil {_x getVariable QPVAR(vehicles)}) then {
		_ctrlCoordination lnbAddRow ["","",getText (configOf _x >> "displayName")];
		_ctrlCoordination lnbSetPicture [[_forEachIndex,2],getText (configOf _x >> "icon")];
		_ctrlCoordination lnbSetPicture [[_forEachIndex,0],[ICON_UNCHECKED2,ICON_CHECKED2] select (_x in GVAR(coordinated))];
	} else {
		_ctrlCoordination lnbAddRow ["","",_x getVariable QPVAR(callsign)];
		_ctrlCoordination lnbSetPicture [[_forEachIndex,2],_x getVariable QPVAR(icon)];
		_ctrlCoordination lnbSetPicture [[_forEachIndex,0],[ICON_UNCHECKED2,ICON_CHECKED2] select (_x in GVAR(coordinated))];
	};
} forEach _nearbyBatteries;

{
	_x params ["_area","_sheaf","_magazines","_rounds","_execDelay","_firingDelay"];
	
	private _activeIndex = _forEachIndex == GVAR(planIndex);
	private _isParallel = _sheaf isEqualTo "PARALLEL";
	private _dispersion = [_area # 1,_area # 2];
	private _target = _area # 0;
	private _ETAs = [];

	{
		if (!_isParallel) then {
			[_x,_target,_magazines,true] call FUNC(canFire) params ["_canFire","_ETA"];			
			if (_canFire) then {_ETAs pushBack _ETA};
			continue;
		};

		private _target = AGLToASL (_x getPos [_center distance2D _target,_center getDir _target]);
		[_x,_target,_magazines,true] call FUNC(canFire) params ["_canFire","_ETA"];
		private _color = if (_canFire && !_busy) then {
			_ETAs pushBack _ETA;
			"ColorGreen"
		} else {
			"ColorRed"
		};

		if (!_activeIndex || !GVAR(visualAids)) then {
			continue;
		};

		private _marker = createMarkerLocal [GEN_STR(_x),_target];
		_marker setMarkerTypeLocal "mil_destroy";
		_marker setMarkerColorLocal _color;
		_marker setMarkerSizeLocal [0.4,0.4];
		PVAR(guiMarkers) pushBack _marker;

		private _markerDisp = createMarkerLocal [GEN_STR(_x),_target];
		_markerDisp setMarkerShapeLocal "ELLIPSE";
		_markerDisp setMarkerBrushLocal "Grid";
		_markerDisp setMarkerColorLocal _color;
		_markerDisp setMarkerAlphaLocal 0.25;
		_markerDisp setMarkerSizeLocal _dispersion;
		PVAR(guiMarkers) pushBack _markerDisp;
	} forEach _vehicles;

	if (_ETAs isEqualTo []) then {
		[false,-1]
	} else {
		[count _ETAs isEqualTo _vehiclesCount,ceil (_ETAs call BIS_fnc_arithmeticMean)]
	} params ["_canFire","_ETA"];

	if (_activeIndex) then {
		if (GVAR(visualAids) && _sheaf in "CONVERGED") then {
			private _marker = createMarkerLocal [GEN_STR(_entity),_target];
			_marker setMarkerShapeLocal "ELLIPSE";
			_marker setMarkerBrushLocal "Grid";
			_marker setMarkerColorLocal (["ColorRed","ColorGreen"] select (_canFire && !_busy));
			_marker setMarkerSizeLocal _dispersion;
			PVAR(guiMarkers) pushBack _marker;
		};

		_ctrlETA ctrlSetText (_ETA call EFUNC(common,formatTime));
		_ctrlETA ctrlSetTextColor ([RGBA_RED,RGBA_GREEN] select (_canFire && !_busy));
	};

	if (!_canFire || _busy) then {
		_ctrlPlan lnbSetColor [[_forEachIndex,0],RGBA_RED];
		_valid = false;
	};

	if (_magazines findIf {_ammoCount get _x < 0} > -1) then {
		_ctrlPlan lnbSetColor [[_forEachIndex,3],RGBA_RED];
		_valid = false;
	};

	{
		private _isActive = _x getVariable [QPVAR(busy),false];
		private _canFire = true;
		private _inCoordinated = _x in GVAR(coordinated);

		{
			private _color = "ColorRed";
			private _target = if (_isParallel) then {
				AGLToASL (_x getPos [_center distance2D _target,_center getDir _target])
			} else {
				_target
			};

			if ([_x,_target,_magazines,false] call FUNC(canFire)) then {
				_color = "ColorGreen";
			} else {
				_canFire = false;
			};

			if (_isActive || !isNull (_x getVariable [QPVAR(host),objNull])) then {
				_isActive = true;
				_color = "ColorRed";
			};

			if (!_inCoordinated || !_isParallel || !_activeIndex || !GVAR(visualAids)) then {
				continue;
			};

			private _marker = createMarkerLocal [GEN_STR(_x),_target];
			_marker setMarkerTypeLocal "mil_destroy";
			_marker setMarkerColorLocal _color;
			_marker setMarkerSizeLocal [0.4,0.4];
			PVAR(guiMarkers) pushBack _marker;

			private _markerDisp = createMarkerLocal [GEN_STR(_x),_target];
			_markerDisp setMarkerShapeLocal "ELLIPSE";
			_markerDisp setMarkerBrushLocal "Grid";
			_markerDisp setMarkerColorLocal _color;
			_markerDisp setMarkerAlphaLocal 0.25;
			_markerDisp setMarkerSizeLocal _dispersion;
			PVAR(guiMarkers) pushBack _markerDisp;
		} forEach (_x getVariable [QPVAR(vehicles),[_x]]);

		_x setVariable [QGVAR(canFire),_canFire];
		_x setVariable [QGVAR(isActive),_isActive];
	} forEach _nearbyBatteries;
} forEach GVAR(plan);

{
	private _cell1 = [_forEachIndex,1];

	if (_x getVariable [QGVAR(isActive),false]) then {
		_ctrlCoordination lnbSetPicture [_cell1,"\a3\3DEN\Data\Attributes\TaskStates\canceled_ca.paa"];
		_ctrlCoordination lnbSetPictureColor [_cell1,RGBA_YELLOW];
		_ctrlCoordination lnbSetPictureColorSelected [_cell1,RGBA_YELLOW];
		_ctrlCoordination lnbSetTooltip [_cell1,LLSTRING(unavailable)];
		continue;
	};

	if (_x getVariable [QGVAR(canFire),false]) then {
		_ctrlCoordination lnbSetPicture [_cell1,"\a3\3DEN\Data\Attributes\TaskStates\succeeded_ca.paa"];
		_ctrlCoordination lnbSetPictureColor [_cell1,RGBA_GREEN];
		_ctrlCoordination lnbSetPictureColorSelected [_cell1,RGBA_GREEN];
		_ctrlCoordination lnbSetTooltip [_cell1,LLSTRING(readyToFire)];
		continue;
	};
	
	_ctrlCoordination lnbSetPicture [_cell1,"\a3\3DEN\Data\Attributes\TaskStates\failed_ca.paa"];
	_ctrlCoordination lnbSetPictureColor [_cell1,RGBA_RED];
	_ctrlCoordination lnbSetPictureColorSelected [_cell1,RGBA_RED];
	_ctrlCoordination lnbSetTooltip [_cell1,LLSTRING(invalidRange)];
} forEach _nearbyBatteries;

_ctrlConfirm ctrlEnable (
	_valid && !_busy &&
	{+[_player,_entity,["FIRE MISSION",[
		GVAR(plan),
		GVAR(loops),
		GVAR(loopDelay),
		GVAR(coordinated)
	]]] call (_entity getVariable QPVAR(requestCondition))}
);
