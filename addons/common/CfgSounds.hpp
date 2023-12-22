class CfgSounds {
	sounds[] = {};
	class PVAR(failure) {
		name = QPVAR(failure);
		sound[] = {QPATHTOF(sounds\failure.ogg),1,1};
		titles[] = {0,""};
	};
	class PVAR(success) {
		name = QPVAR(success);
		sound[] = {QPATHTOF(sounds\success.ogg),1,1};
		titles[] = {0,""};
	};
};
