#include "..\script_component.hpp"
#define IDD_RSCDISPLAYCURATOR 312
#define IDC_RSCDISPLAYCURATOR_FEEDBACKMESSAGE 15512

disableSerialization;
params [["_message","<NO MESSAGE>",[""]],["_sound","RscDisplayCurator_error01",[""]],["_duration",1,[0]]];

private _display = findDisplay IDD_RSCDISPLAYCURATOR;

if (isNull _display) exitWith {};

private _ctrlMessage = _display displayCtrl IDC_RSCDISPLAYCURATOR_FEEDBACKMESSAGE;

playSound _sound;
_ctrlMessage ctrlSetText toUpper _message;
_ctrlMessage ctrlSetFade 0;
_ctrlMessage ctrlCommit 0;

[{
	_this ctrlSetFade 1;
	_this ctrlCommit 0.5;
},_ctrlMessage,_duration] call CBA_fnc_waitAndExecute;
