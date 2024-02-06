#include "..\script_component.hpp"

params ["_entity",["_format",0]];

_entity getVariable QPVAR(status) params [["_statusText",""],["_statusColor",[1,1,1,1]]];

switch _format do {
	case 0 : {[localize _statusText,_statusColor]};
	case 1 : {
		format [
			"<t size='0.1'>&#160;</t><br/>%1",
			format ["<t color='%1'>%2</t>",_statusColor call BIS_fnc_colorRGBAtoHTML,localize _statusText]
		]
	};
};
