#include "script_component.hpp"

params [["_msg",""],["_full",false]];

if (isLocalized _msg) then {
	_msg = localize _msg;
};

if (_full) then {
	_msg = format ["%1 - %2",toUpper QUOTE(PREFIX),_msg];
	diag_log text _msg;
	systemChat _msg;
} else {
	diag_log text format ["%1 - %2",toUpper QUOTE(PREFIX),_msg];
};
