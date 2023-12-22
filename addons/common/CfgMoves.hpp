class CfgMovesBasic {
	class DefaultDie;
	class ManActions {
		PVAR(fastrope) = QPVAR(fastrope);
	};
};

class CfgMovesMaleSdr: CfgMovesBasic {
	class States {
		class Crew;
		class PVAR(fastrope): Crew {
			file = QPATHTOF(anim\fastrope.rtm);
			interpolateTo[] = {"Unconscious",1};
			disableWeapons = 1;
			disableWeaponsLong = 1;
			enableOptics = 0;
			showWeaponAim = 0;
        	canPullTrigger = 0;
			canReload = 0;
			forceAim = 1;
			aiming = "aimingNo";
			aimingBody = "aimingNo";
			static = 1;
		};
	};
};
