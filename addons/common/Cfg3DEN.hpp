class ctrlStatic;
class ctrlEdit;
class ctrlDefaultText;
class ctrlListbox : ctrlDefaultText {
	class ListScrollBar;
};

class Cfg3DEN {
	class Attributes {
		class Default;
		class Title : Default {
			class Controls {
				class Title;
			};
		};

		class EditXY : Title {
			class Controls : Controls {
				class Title;
				class TitleX;
				class ValueX;
				class TitleY;
				class ValueY;
			};
		};

		class PVAR(editMinMax) : EditXY {
			attributeLoad = "
				if (_value isEqualType '') then {
					if (_value isEqualTo '') exitWith {_value = []};
					_value = parseSimpleArray _value;
				};
				(_this controlsGroupCtrl 101) ctrlSetText str (_value param [0,0]);
				(_this controlsGroupCtrl 102) ctrlSetText str (_value param [1,0]);
			";
			attributeSave = "[parsenumber ctrlText (_this controlsGroupCtrl 101),parsenumber ctrlText (_this controlsGroupCtrl 102)]";
			onLoad = "";

			class Controls : Controls {
				class Title : Title {};
				class TitleX : TitleX {
					text = CSTRING(Min);
					x = "48 * (pixelW * pixelGrid * 0.5)";
					w = "10 * (pixelW * pixelGrid * 0.5)";
					colorBackground[] = {
						"profilenamespace getvariable ['GUI_BCG_RGB_R',0.77]",
						"profilenamespace getvariable ['GUI_BCG_RGB_G',0.51]",
						"profilenamespace getvariable ['GUI_BCG_RGB_B',0.08]",
						1
					};
				};
				class ValueX : ValueX {
					x = "58 * (pixelW * pixelGrid * 0.5)";
					w = "31 * (pixelW * pixelGrid * 0.5)";
				};
				class TitleY : TitleY {
					text = CSTRING(Max);
					x = "89 * (pixelW * pixelGrid * 0.5)";
					w = "10 * (pixelW * pixelGrid * 0.5)";
					colorBackground[] = {
						"profilenamespace getvariable ['GUI_BCG_RGB_R',0.77]",
						"profilenamespace getvariable ['GUI_BCG_RGB_G',0.51]",
						"profilenamespace getvariable ['GUI_BCG_RGB_B',0.08]",
						1
					};
				};
				class ValueY : ValueY {
					x = "99 * (pixelW * pixelGrid * 0.5)";
					w = "31 * (pixelW * pixelGrid * 0.5)";
				};
			};
		};

		class Toolbox : Title {
			class Controls : Controls {
				class Value;
			};
		};

		class PVAR(toggle) : Toolbox {
			attributeLoad = "
				private _ctrl = _this controlsGroupCtrl 100;
				lbClear _ctrl;

				{
					private _item = _ctrl lbAdd getText (_x >> 'name');
					_ctrl lbSetTooltip [_item,getText (_x >> 'tooltip')];
				} forEach configProperties [_config >> 'Values','isClass _x'];

				_ctrl lbSetCurSel _value;
			";
			attributeSave = "lbCurSel (_this controlsGroupCtrl 100)";

			class Controls : Controls {
				class Title : Title {};
				class Value : Value {
					idc = 100;
					rows = 1;
					columns = 2;
					strings[] = {"",""};
					values[] = {0,1};
					onToolboxSelChanged = "";
				};
			};
		};

		class PVAR(checkboxes) : Title {
			attributeLoad = "
				private _ctrl = _this controlsGroupCtrl 100;
				private _cfgValues = _config >> 'Values';
				if (isClass _cfgValues) then {
					{
						private _item = _ctrl lbAdd getText (_x >> 'name');
						private _checked = if (_value isEqualType [] && _value isNotEqualTo []) then {
							parseNumber (_value param [_forEachIndex,false])
						} else {
							getNumber (_x >> 'value')
						};
						_ctrl lbSetValue [_item,_checked];
						_ctrl lbSetPicture [_item,[
							getText (configFile >> 'ctrlCheckbox' >> 'textureUnchecked'),
							getText (configFile >> 'ctrlCheckbox' >> 'textureChecked')
						] select _checked];
						_ctrl lbSetPictureRight [_item,getText (_x >> 'pictureRight')];
						_ctrl lbSetTooltip [_item,getText (_x >> 'tooltip')];
					} foreach configProperties [_cfgValues,'isClass _x'];
				};
				if (_value isEqualType true) then {
					_value = [];
					for '_i' from 0 to (lbSize _ctrl - 1) do {
						_value pushBack ((_ctrl lbValue _i) isEqualTo 1);
					};
				};
			";
			attributeSave = "
				private _ctrl = _this controlsGroupCtrl 100;
				private _array = [];
				for '_i' from 0 to (lbSize _ctrl - 1) do {
					_array pushBack ((_ctrl lbValue _i) isEqualTo 1);
				};
				_array
			";
			h = "4 * 5 * (pixelH * pixelGrid * 0.50)";
			class Controls : Controls {
				class Title : Title {
					h = "4 * 5 * (pixelH * pixelGrid * 0.50)";
				};
				class Value : ctrlListbox {
					idc = 100;
					x = "48 * (pixelW * pixelGrid * 0.50)";
					w = "82 * (pixelW * pixelGrid * 0.50)";
					h = "4 * 5 * (pixelH * pixelGrid * 0.50)";
					colorSelectBackground[] = {0,0,0,0};
					colorSelectBackground2[] = {0,0,0,0};
					onLBSelChanged = "
						private _ctrl = _this select 0;
						private _item = _this select 1;
						private _checked = ((_ctrl lbValue _item) + 1) % 2;
						_ctrl lbSetValue [_item,_checked];
						_ctrl lbSetPicture [_item,[
							getText (configFile >> 'ctrlCheckbox' >> 'textureUnchecked'),
							getText (configFile >> 'ctrlCheckbox' >> 'textureChecked')
						] select _checked];
					";
				};
			};
		};

		class Checkbox : Title {
			class Controls : Controls {
				class Title;
				class Value;
			};
		};

		class PVAR(relocation) : Checkbox {
			attributeLoad = "
				if (_value isEqualType '') then {
					if (_value isEqualTo '') exitWith {_value = []};
					_value = parseSimpleArray _value;
				};
				(_this controlsGroupCtrl 101) cbSetChecked (_value param [0,true]);
				(_this controlsGroupCtrl 102) ctrlSetText str (_value param [1,60]);
			";
			attributeSave = "[cbChecked (_this controlsGroupCtrl 101),parsenumber ctrlText (_this controlsGroupCtrl 102)]";
			onLoad = "";

			class Controls : Controls {
				class Title : Title {};
				class Allow : Value {
					idc = 101;
				};
				class TimeIcon : ctrlStatic {
					text = "\a3\ui_f\data\gui\rsc\rscdisplayarsenal\watch_ca.paa";
					style = "0x30 + 0x0800";
					shadow = 0;
					x = "53 * (pixelW * pixelGrid * 0.5)";
					w = "5 * (pixelW * pixelGrid * 0.5)";
					h = "5 * (pixelH * pixelGrid * 0.50)";
				};
				class Time : ctrlEdit {
					idc = 102;
					x = "58 * (pixelW * pixelGrid * 0.5)";
					w = "72 * (pixelW * pixelGrid * 0.5)";
					h = "5 * (pixelH * pixelGrid * 0.50)";
				};
			};
		};

		class PVAR(hidden) : Default {
			attributeLoad = "";
			attributeSave = "";
		};
	};

	class Object {
		class AttributeCategories {
			class PVAR(attributes) {
				displayName = "";//CSTRING(AuthAttribute);
				collapsed = 1;
				class Attributes {
					class PVAR(key) {
						property = QPVAR(key);
						control = QPVAR(hidden);
						displayName = QPVAR(key);
						tooltip = "";
						expression = QUOTE(if (_value isNotEqualTo '') then {_this setVariable [ARR_3('%s',_value,true)]};);
						typeName = "STRING";
						defaultValue = "''";
						condition = "0";
					};
				};
			};
		};
	};
};



