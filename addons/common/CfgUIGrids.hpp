#include "popup.hpp"

class CfgUIGrids {
	class IGUI {
		class Presets {
			class Arma3 {
				class Variables {
					GVAR(popupGrid)[] = {
						{
							QUOTE(POPUP_X),
							QUOTE(POPUP_Y),
							QUOTE(POPUP_W),
							QUOTE(POPUP_H * POPUP_LIMIT)
						},
						QUOTE(GUI_GRID_W),
						QUOTE(GUI_GRID_H)
					};
				};
			};
		};
		class Variables {
			class GVAR(popupGrid) {
				displayName = QGVAR(popup);
				description = QGVAR(popup);
				preview = QPATHTOF(ui\popup.paa);
				saveToProfile[] = {0,1};
				canResize = 0;
			};
		};
	};
};
