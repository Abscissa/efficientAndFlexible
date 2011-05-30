// Written in the D programming language
// by Nick Sabalausky
//
// Tested on DMD 2.053
//
// Gizmo Example
// Version: Handcrafted (Specialized Types, Hardcoded Features)

import std.datetime;
import std.stdio;

struct OnePortGizmo
{
	static immutable isSpinnable = false;
	static immutable numPorts    = 1;
	
	private OutputPort[numPorts] ports;
	void doStuff()
	{
		ports[0].zap();
	}

	void spin()
	{
		// Do nothing
	}
}

struct TwoPortGizmo
{
	static immutable isSpinnable = false;
	static immutable numPorts    = 2;
	
	private OutputPort[numPorts] ports;
	void doStuff()
	{
		ports[0].zap();
		ports[1].zap();
	}

	void spin()
	{
		// Do nothing
	}
}

struct MultiPortGizmo
{
	this(int numPorts)
	{
		if(numPorts < 1)
			throw new Exception("A portless Gizmo is useless!");

		if(numPorts == 1 || numPorts == 2)
			throw new Exception("Wrong type of Gizmo!");

		ports.length = numPorts;
	}
	
	static immutable isSpinnable = false;
	
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

	void spin()
	{
		// Do nothing
	}
}

struct SpinnyOnePortGizmo
{
	static immutable isSpinnable = true;
	static immutable numPorts    = 1;

	private OutputPort[numPorts] ports;
	void doStuff()
	{
		ports[0].zap();
	}

	int spinCount;
	void spin()
	{
		spinCount++; // Spinning! Wheeee!
	}
}

struct SpinnyTwoPortGizmo
{
	static immutable isSpinnable = true;
	static immutable numPorts    = 2;

	private OutputPort[numPorts] ports;
	void doStuff()
	{
		ports[0].zap();
		ports[1].zap();
	}

	int spinCount;
	void spin()
	{
		spinCount++; // Spinning! Wheeee!
	}
}

struct SpinnyMultiPortGizmo
{
	this(int numPorts)
	{
		if(numPorts < 1)
			throw new Exception("A portless Gizmo is useless!");

		if(numPorts == 1 || numPorts == 2)
			throw new Exception("Wrong type of Gizmo!");

		ports.length = numPorts;
	}

	static immutable isSpinnable = true;

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

	int spinCount;
	void spin()
	{
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
	OnePortGizmo[]         gizmosA;
	SpinnyOnePortGizmo[]   gizmosB;
	TwoPortGizmo[]         gizmosC;
	SpinnyTwoPortGizmo[]   gizmosD;
	MultiPortGizmo[]       gizmosE;
	SpinnyMultiPortGizmo[] gizmosF;

	int numTimesUsedSpinny;
	int numTimesUsedTwoPort;

	// Ok, technically this is a simple form of metaprogramming, so I'm
	// cheating slightly. But I just can't bring myself to copy/paste the
	// exact same function six times even for the sake of an example.
	void useGizmo(T)(ref T gizmo)
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
		gizmosA.length = 10_000;
		gizmosB.length = 10_000;
		gizmosC.length = 10_000;
		gizmosD.length = 10_000;
		gizmosE.length =  5_000;
		gizmosF.length =  5_000;
		foreach(i; 0..gizmosE.length) gizmosE[i] = MultiPortGizmo(5);
		foreach(i; 0..gizmosF.length) gizmosF[i] = SpinnyMultiPortGizmo(5);
		
		// Use gizmos
		foreach(i; 0..10_000)
		{
			foreach(ref gizmo; gizmosA) useGizmo(gizmo);
			foreach(ref gizmo; gizmosB) useGizmo(gizmo);
			foreach(ref gizmo; gizmosC) useGizmo(gizmo);
			foreach(ref gizmo; gizmosD) useGizmo(gizmo);
			foreach(ref gizmo; gizmosE) useGizmo(gizmo);
			foreach(ref gizmo; gizmosF) useGizmo(gizmo);
		}
		
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
	//auto g = MultiPortGizmo(0, true);
}
