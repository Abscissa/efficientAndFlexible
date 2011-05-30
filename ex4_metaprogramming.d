// Written in the D programming language
// by Nick Sabalausky
//
// Tested on DMD 2.053
//
// Gizmo Example
// Version: Metaprogramming (Specialized Types, Compile Time Features)

import std.datetime;
import std.stdio;

struct Gizmo(int _numPorts, bool _isSpinnable)
{
	// So other generic code can determine the
	// number of ports and spinnability:
	static immutable numPorts    = _numPorts;
	static immutable isSpinnable = _isSpinnable;

	static if(numPorts < 1)
		static assert(false, "A portless Gizmo is useless!");

	private OutputPort[numPorts] ports;
	void doStuff()
	{
		static if(numPorts == 1)
			ports[0].zap();
		else static if(numPorts == 2)
		{
			ports[0].zap();
			ports[1].zap();
		}
		else
		{
			foreach(port; ports)
				port.zap();
		}
	}

	static if(isSpinnable)
		int spinCount;

	void spin()
	{
		static if(isSpinnable)
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
	// We could still use gizmosA, gizmosB, etc. just like before,
	// but templating them will make things a little easier:
	template gizmos(int numPorts, bool isSpinnable)
	{
		Gizmo!(numPorts, isSpinnable)[] gizmos;
	}

	int numTimesUsedSpinny;
	int numTimesUsedTwoPort;

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

		// Create gizmos
		gizmos!(1, false).length = 10_000;
		gizmos!(1, true ).length = 10_000;
		gizmos!(2, false).length = 10_000;
		gizmos!(2, true ).length = 10_000;
		gizmos!(5, false).length =  5_000;
		gizmos!(5, true ).length =  5_000;
		
		// Use gizmos
		foreach(i; 0..10_000)
		{
			foreach(ref gizmo; gizmos!(1, false)) useGizmo(gizmo);
			foreach(ref gizmo; gizmos!(1, true )) useGizmo(gizmo);
			foreach(ref gizmo; gizmos!(2, false)) useGizmo(gizmo);
			foreach(ref gizmo; gizmos!(2, true )) useGizmo(gizmo);
			foreach(ref gizmo; gizmos!(5, false)) useGizmo(gizmo);
			foreach(ref gizmo; gizmos!(5, true )) useGizmo(gizmo);
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
	
	// Compile time error: A portless Gizmo is useless!
	//auto g = Gizmo!(0, true);
}
