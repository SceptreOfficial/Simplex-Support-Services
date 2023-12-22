#include "script_component.hpp"

disableSerialization;
params [["_index",0,[0]],["_parentPath",[],[[]]],["_entry",[],[[]]]];
_entry params [["_item","",["",[]]],["_data","",[""]],["_children",[],[[]]]];
_item params [["_text","",[""]],["_tooltip","",[""]],["_icon","",[""]],["_RGBA",[1,1,1,1],[[]],4]];

private _ctrl = (uiNamespace getVariable QGVAR(controls)) # _index;

private _path = _parentPath + [_ctrl tvAdd [_parentPath,_text]];
_ctrl tvSetData [_path,_data];
_ctrl tvSetPicture [_path,_icon];
_ctrl tvSetTooltip [_path,_tooltip];
_ctrl tvSetPictureColor [_path,_RGBA];
