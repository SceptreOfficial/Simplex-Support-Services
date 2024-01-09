#include "script_component.hpp"

params [["_message",""],["_rpt",true],["_chat",true]];

if (isLocalized _message) then {_message = localize _message};
if (_rpt) then {diag_log text _message};
if (_chat) then {systemChat _message};
