#define IDC_TITLE_BG 			1
#define IDC_TITLE_LOGO 			2
#define IDC_TITLE_TEXT 			3
#define IDC_BG 					4
#define IDC_CLOSE 				5
#define IDC_CONFIRM 			6
#define IDC_MAP 				7
#define IDC_MAP_TEXT 			8
#define IDC_SERVICE_TEXT 		9
#define IDC_SERVICE 			10
#define IDC_ENTITY_TEXT 		11
#define IDC_ENTITY 				12
#define IDC_STATUS_TEXT 		13
#define IDC_STATUS 				14
#define IDC_ABORT 				15
#define IDC_INSTRUCTIONS_TEXT 	16
#define IDC_INSTRUCTIONS_BG 	17
#define IDC_INSTRUCTIONS_GROUP 	18

#define DECLARE_COMMON_GUI_CLASSES \
	class EGVAR(common,titleBG); \
	class EGVAR(common,titleLogo); \
	class EGVAR(common,titleText); \
	class EGVAR(common,background); \
	class EGVAR(common,close); \
	class EGVAR(common,confirm); \
	class EGVAR(common,serviceText); \
	class EGVAR(common,service); \
	class EGVAR(common,entityText); \
	class EGVAR(common,entity); \
	class EGVAR(common,statusText); \
	class EGVAR(common,status); \
	class EGVAR(common,abort); \
	class EGVAR(common,map); \
	class EGVAR(common,mapText); \
	class EGVAR(common,instructionsText); \
	class EGVAR(common,instructionsBG); \
	class EGVAR(common,instructionsGroup); \
	class EGVAR(sdf,Checkbox); \
	class EGVAR(sdf,Text); \
	class EGVAR(sdf,StructuredText); \
	class EGVAR(sdf,ControlsGroup); \
	class EGVAR(sdf,ButtonSimple); \
	class EGVAR(sdf,Button); \
	class EGVAR(sdf,Combobox); \
	class EGVAR(sdf,ControlsGroupNoScrollbars); \
	class EGVAR(sdf,Editbox); \
	class EGVAR(sdf,Tree); \
	class EGVAR(sdf,Slider); \
	class EGVAR(sdf,Listbox); \
	class EGVAR(sdf,ListNBox); \
	class EGVAR(sdf,ListNBoxCB); \
	class EGVAR(sdf,ListNBoxMulti); \
	class EGVAR(sdf,Toolbox); \
	class EGVAR(sdf,ToolboxLoiter); \
	class RscPictureKeepAspect

#define COMMON_GUI_CONTROLS_BG \
	class GVAR(titleBG) : EGVAR(common,titleBG) {}; \
	class GVAR(titleLogo) : EGVAR(common,titleLogo) {}; \
	class GVAR(titleText) : EGVAR(common,titleText) {}; \
	class GVAR(background) : EGVAR(common,background) {}; \
	class GVAR(map) : EGVAR(common,map) {}; \
	class GVAR(instructionsText) : EGVAR(common,instructionsText) {}; \
	class GVAR(instructionsBG) : EGVAR(common,instructionsBG) {}

#define COMMON_GUI_CONTROLS \
	class GVAR(close) : EGVAR(common,close) {}; \
	class GVAR(confirm) : EGVAR(common,confirm) {}; \
	class GVAR(serviceText) : EGVAR(common,serviceText) {}; \
	class GVAR(service) : EGVAR(common,service) {}; \
	class GVAR(entityText) : EGVAR(common,entityText) {}; \
	class GVAR(entity) : EGVAR(common,entity) {}; \
	class GVAR(statusText) : EGVAR(common,statusText) {}; \
	class GVAR(status) : EGVAR(common,status) {}; \
	class GVAR(abort) : EGVAR(common,abort) {}; \
	class GVAR(mapText) : EGVAR(common,mapText) {}; \
	class GVAR(instructionsGroup) : EGVAR(common,instructionsGroup)
