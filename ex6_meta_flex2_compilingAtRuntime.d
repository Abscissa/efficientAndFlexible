// Written in the D programming language
// by Nick Sabalausky
//
// Tested on DMD 2.053
//
// Gizmo Example
// Version: Metaprogramming - Flexibility Method #2 - Compiling at Runtime

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

struct UltraGiz(int bigPort, int extrasNumPorts, bool extrasIsSpinnable)
{
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

		// Use the template parameters extrasNumPorts and extrasIsSpinnable
		// so 8,000 more of these will be made down below.
		gizmos!(2, true ).length =  2_000;

		gizmos!(bigPort, false).length = 5_000;
		gizmos!(bigPort, true ).length = 5_000;
		
		// Add in the extra Gizmos
		gizmos!(extrasNumPorts, extrasIsSpinnable).length += 8_000;
		
		// Use gizmos
		foreach(i; 0..10_000)
		{
			foreach(ref gizmo; gizmos!(1, false)) useGizmo(gizmo);
			foreach(ref gizmo; gizmos!(1, true )) useGizmo(gizmo);
			foreach(ref gizmo; gizmos!(2, false)) useGizmo(gizmo);
			foreach(ref gizmo; gizmos!(2, true )) useGizmo(gizmo);
			foreach(ref gizmo; gizmos!(bigPort, false)) useGizmo(gizmo);
			foreach(ref gizmo; gizmos!(bigPort, true )) useGizmo(gizmo);
		}
		
		writeln(stopWatch.peek.msecs, "ms");
	}
}

void main()
{
	mixin(import("ex6_meta_flex2_config.d"));

	UltraGiz!(conf_bigPort, conf_extrasNumPorts, conf_extrasIsSpinnable) ultra;
	ultra.run();
	
	// Compile time error: A portless Gizmo is useless!
	//auto g = Gizmo!(0, true);
}
