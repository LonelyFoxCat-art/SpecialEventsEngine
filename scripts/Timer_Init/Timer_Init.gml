function Timer_Init(){
	globalvar TIMERMODE;
	
	TIMERMODE = {
		NONE: false,
		LOOP: "Loop",
		FINITELOOP: "FiniteLoop"
	}
	
	return {
		TimerList: { },
		UpdateStep: Timer_Update
	};
}