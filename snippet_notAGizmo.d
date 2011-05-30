struct BoatDock_NotAGizmo
{
	// Places to park your boat
	int numPorts;
	
	void doStuff()
	{
		manageBoatTraffic();
	}
	
	// Due to past troubles with local salt-stealing porcupines
	// swimming around and clogging up the hydraulics,
	// some boat docks feature a special safety mechanism:
	// "Salty-Porcupines in the Intake are Nullified",
	// affectionately called "spin" by the locals.
	bool isSpinnable;
	void spin()
	{
		blastTheCrittersAway();
	}
}
