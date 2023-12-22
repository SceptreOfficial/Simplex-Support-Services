class RscTitleDisplayEmpty;
class RscStructuredText;

class RscTitles {
	class GVAR(popup) {
		idd = -1;
		onLoad = QUOTE(uiNamespace setVariable [ARR_2(QQGVAR(popup),_this select 0)]);
		//onUnload = QUOTE(uiNamespace setVariable [ARR_2(QQGVAR(popup),nil)]);
		fadeIn = POPUP_FADE_IN;
		fadeOut = POPUP_FADE_OUT;
		duration = POPUP_DURATION;
		movingEnable = 0;

		class Controls {
			class Title : RscStructuredText {
				idc = IDC_POPUP_TITLE;
				x = QUOTE(profileNamespace getVariable [ARR_2('TRIPLES(IGUI,GVAR(popupGrid),X)',POPUP_X)]);
				y = QUOTE(profileNamespace getVariable [ARR_2('TRIPLES(IGUI,GVAR(popupGrid),Y)',POPUP_Y)]);
				w = QUOTE(POPUP_W);
				h = QUOTE(POPUP_TITLE_H);
				colorBackground[] = {0,0,0,0.4};
				sizeEx = QUOTE(GUI_GRID_H);
			};
			class Body: RscStructuredText {
				idc = IDC_POPUP_BODY;
				x = QUOTE(profileNamespace getVariable [ARR_2('TRIPLES(IGUI,GVAR(popupGrid),X)',POPUP_X)]);
				y = QUOTE(POPUP_TITLE_H + POPUP_GAP_H + (profileNamespace getVariable [ARR_2('TRIPLES(IGUI,GVAR(popupGrid),Y)',POPUP_Y)]));
				w = QUOTE(POPUP_W);
				h = QUOTE(POPUP_CONTENT_H);
				colorBackground[] = {0,0,0,0.3};
				sizeEx = QUOTE(GUI_GRID_H);
			};
		};
	};
};
