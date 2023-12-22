#include "script_component.hpp"
#define CTRL(IDC) _ctrlGroup controlsGroupCtrl IDC

params ["_ctrlGroup","_request",["_hasAuto",true]];

private _ctrlIngress = CTRL(IDC_INGRESS);
private _ctrlIngressSlider = CTRL(IDC_INGRESS_SLIDER);
private _ctrlIngressSliderEdit = CTRL(IDC_INGRESS_SLIDER_EDIT);
private _ctrlIngressToggle = CTRL(IDC_INGRESS_TOGGLE);
private _ctrlEgress = CTRL(IDC_EGRESS);
private _ctrlEgressSlider = CTRL(IDC_EGRESS_SLIDER);
private _ctrlEgressSliderEdit = CTRL(IDC_EGRESS_SLIDER_EDIT);
private _ctrlEgressToggle = CTRL(IDC_EGRESS_TOGGLE);

if (_hasAuto) then {
	[_ctrlIngressSlider,_ctrlIngressSliderEdit,[-1,359,0],"ingress",-1,"°",[[-1,LELSTRING(common,dirAuto)]],FUNC(gui_ingress)] call FUNC(gui_slider);
	[_ctrlEgressSlider,_ctrlEgressSliderEdit,[-1,359,0],"egress",-1,"°",[[-1,LELSTRING(common,dirAuto)]],FUNC(gui_egress)] call FUNC(gui_slider);
	[[-1,0,45,90,135,180,225,270,315],-1]
} else {
	[_ctrlIngressSlider,_ctrlIngressSliderEdit,[0,359,0],"ingress",0,"°",[],FUNC(gui_ingress)] call FUNC(gui_slider);
	[_ctrlEgressSlider,_ctrlEgressSliderEdit,[0,359,0],"egress",0,"°",[],FUNC(gui_egress)] call FUNC(gui_slider);
	[[0,45,90,135,180,225,270,315],0]
} params ["_angles","_default"];

_ctrlIngress setVariable [QGVAR(angles),_angles];
_ctrlEgress setVariable [QGVAR(angles),_angles];

private _ingress = _request getOrDefault ["ingress",_default];
private _egress = _request getOrDefault ["egress",_default];
_ctrlIngress lbSetCurSel (_angles find _ingress);
_ctrlEgress lbSetCurSel (_angles find _egress);

private _showSlider = _request getOrDefault ["ingressToggle",false];
_ctrlIngressToggle cbSetChecked _showSlider;
_ctrlIngress ctrlShow !_showSlider;
_ctrlIngressSlider ctrlShow _showSlider;
_ctrlIngressSliderEdit ctrlShow _showSlider;

private _showSlider = _request getOrDefault ["egressToggle",false];
_ctrlEgressToggle cbSetChecked _showSlider;
_ctrlEgress ctrlShow !_showSlider;
_ctrlEgressSlider ctrlShow _showSlider;
_ctrlEgressSliderEdit ctrlShow _showSlider;
