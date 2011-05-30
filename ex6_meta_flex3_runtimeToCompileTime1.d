// Written in the D programming language
// by Nick Sabalausky
//
// Tested on DMD 2.053
//
// Gizmo Example
// Version: Metaprogramming - Flexibility Method #3 -
//    Convert a Runtime Value to Compile-Time

import std.conv;
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

	// Note this is templated
	void addGizmosTo(int numPorts, bool isSpinnable)(int numGizmos)
	{
		gizmos!(numPorts, isSpinnable).length += numGizmos;
	}

	void addGizmos(int numPorts, bool isSpinnable, int numGizmos)
	{
		// Dispatch to correct version of addGizmosTo.
		// Effectively converts a runtime value to compile-time.
		if(numPorts == 1)
		{
			if(isSpinnable)
				addGizmosTo!(1, true )(numGizmos);
			else
				addGizmosTo!(1, false)(numGizmos);
		}
		else if(numPorts == 2)
		{
			if(isSpinnable)
				addGizmosTo!(2, true )(numGizmos);
			else
				addGizmosTo!(2, false)(numGizmos);
		}
		else if(numPorts == 3)
		{
			if(isSpinnable)
				addGizmosTo!(3, true )(numGizmos);
			else
				addGizmosTo!(3, false)(numGizmos);
		}
		else if(numPorts == 5)
		{
			if(isSpinnable)
				addGizmosTo!(5, true )(numGizmos);
			else
				addGizmosTo!(5, false)(numGizmos);
		}
		else if(numPorts == 10)
		{
			if(isSpinnable)
				addGizmosTo!(10, true )(numGizmos);
			else
				addGizmosTo!(10, false)(numGizmos);
		}
		else
			throw new Exception(to!string(numPorts)~"-port Gizmo not supported.");
	}
		
	void run(int bigPort)(int extrasNumPorts, bool extrasIsSpinnable)
	{
		StopWatch stopWatch;
		stopWatch.start();

		// Create gizmos
		gizmos!(1, false).length = 10_000;
		gizmos!(1, true ).length = 10_000;
		gizmos!(2, false).length = 10_000;
		
		// Use the commandline parameters extrasNumPorts and extrasIsSpinnable
		// so 8,000 more of these will be made down below.
		gizmos!(2, true ).length = 2_000;
		
		gizmos!(bigPort, false).length = 5_000;
		gizmos!(bigPort, true ).length = 5_000;
		
		// Add in the extra Gizmos
		addGizmos(extrasNumPorts, extrasIsSpinnable, 8_000);
		
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

void main(string[] args)
{
	// Number of ports on each of the many-port Gizmos.
	// Normally 5
	int bigPort;
	
	// 8,000 extra Gizmos will be created with
	// this many ports and this spinnability.
	// Normally 2-port spinnable
	int  extrasNumPorts;
	bool extrasIsSpinnable;
	
	try
	{
		bigPort           = to!int (args[1]);
		extrasNumPorts    = to!int (args[2]);
		extrasIsSpinnable = to!bool(args[3]);
		if(bigPort != 3 && bigPort != 5 && bigPort != 10)
			throw new Exception("Invalid choice for bigPort");
	}
	catch(Throwable e)
	{
		writeln("Usage:");
		writeln("  ex6_meta_flex3_runtimeToCompileTime1 "~
			"{bigPort} {extrasNumPorts} {extrasIsSpinnable}");
		writeln("bigPort must be 3, 5 or 10");
		writeln("Example: ex6_meta_flex3_runtimeToCompileTime1 5 2 true");
		return;
	}
	
	UltraGiz ultra;
	// Dispatch to correct version of UltraGiz.run.
	// Effectively converts a runtime value to compile-time.
	if(bigPort == 3)
		ultra.run!3(extrasNumPorts, extrasIsSpinnable);
	else if(bigPort == 5)
		ultra.run!5(extrasNumPorts, extrasIsSpinnable);
	else if(bigPort == 10)
		ultra.run!10(extrasNumPorts, extrasIsSpinnable);
	
	// Compile time error: A portless Gizmo is useless!
	//auto g = Gizmo!(0, true);
}
