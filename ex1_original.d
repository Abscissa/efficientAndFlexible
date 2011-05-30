// Written in the D programming language
// by Nick Sabalausky
//
// Tested on DMD 2.053
//
// Gizmo Example
// Version: Original (Single Unified Type, Runtime Features)

import std.datetime;
import std.stdio;

struct Gizmo
{
	this(int numPorts, bool isSpinnable)
	{
		if(numPorts < 1)
			throw new Exception("A portless Gizmo is useless!");

		ports.length = numPorts;
		_isSpinnable = isSpinnable;
	}

	private OutputPort[] ports;
	@property int numPorts()
	{
		return ports.length;
	}
	void doStuff()
	{
		foreach(port; ports)
			port.zap();
	}

	private bool _isSpinnable;
	@property int isSpinnable()
	{
		return _isSpinnable;
	}
	int spinCount;
	void spin()
	{
		// Attempting to spin a non-spinnable Gizmo is OK.
		// Like insulting a fishtank, it merely has no effect.
		if(isSpinnable)
			spinCount++; // Spinning! Wheeee!
	}
}

struct OutputPort
{
	int numZaps;
	void zap()
	{
		numZaps++;
	}
}

struct UltraGiz
{
	Gizmo[] gizmos;

	int numTimesUsedSpinny;
	int numTimesUsedTwoPort;

	private void useGizmo(ref Gizmo gizmo)
	{
		gizmo.doStuff();
		gizmo.spin();
		
		if(gizmo.isSpinnable)
			numTimesUsedSpinny++;
		
		if(gizmo.numPorts == 2)
			numTimesUsedTwoPort++;
	}
	
	void run()
	{
		StopWatch stopWatch;
		stopWatch.start();

		//  Create gizmos
		gizmos.length = 50_000;
		foreach(i;      0..10_000) gizmos[i] = Gizmo(1, false);
		foreach(i; 10_000..20_000) gizmos[i] = Gizmo(1, true );
		foreach(i; 20_000..30_000) gizmos[i] = Gizmo(2, false);
		foreach(i; 30_000..40_000) gizmos[i] = Gizmo(2, true );
		foreach(i; 40_000..45_000) gizmos[i] = Gizmo(5, false);
		foreach(i; 45_000..50_000) gizmos[i] = Gizmo(5, true );
		
		// Use gizmos
		foreach(i; 0..10_000)
		foreach(ref gizmo; gizmos)
			useGizmo(gizmo);
		
		writeln(stopWatch.peek.msecs, "ms");

		assert(numTimesUsedSpinny  == 25_000 * 10_000);
		assert(numTimesUsedTwoPort == 20_000 * 10_000);
	}
}

void main()
{
	UltraGiz ultra;
	ultra.run();
	
	// Runtime error: A portless Gizmo is useless!
	//auto g = Gizmo(0, true);
}
