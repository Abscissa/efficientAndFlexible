// Written in the D programming language
// by Nick Sabalausky
//
// Tested on DMD 2.053
//
// Gizmo Example
// Version: Metaprogramming - Flexibility Method #4 - Dynamic Fallback - Less Repetitive

import std.conv;
import std.datetime;
import std.stdio;
import std.typetuple;

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

// This is identical to the original Gizmo in 'ex1_original.d',
// just with a different name.
struct DynamicGizmo
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
	template gizmos(T)
	{
		T[] gizmos;
	}
	
	// Shortcut for non-dynamic gizmos, so we can still say:
	//   gizmos!(2, true)
	// instead of needing to use the more verbose:
	//   gizmos!( Gizmos!(2, true) )
	template gizmos(int numPorts, bool isSpinnable)
	{
		alias gizmos!( Gizmo!(numPorts, isSpinnable) ) gizmos;
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
		
	void run(int bigPort, int extrasNumPorts, bool extrasIsSpinnable)
	{
		StopWatch stopWatch;
		stopWatch.start();

		// Create gizmos
		gizmos!(1, false).length = 10_000;
		gizmos!(1, true ).length = 10_000;
		gizmos!(2, false).length = 10_000;
		
		// Use the commandline parameters extrasNumPorts and extrasIsSpinnable
		// so 8,000 more of these will be made down below as dynamic gizmos.
		gizmos!(2, true ).length = 2_000;
		
		gizmos!(DynamicGizmo).length = 18_000;
		foreach(i;       0..5_000)
			gizmos!(DynamicGizmo)[i] = DynamicGizmo(bigPort, false);
			
		foreach(i;  5_000..10_000)
			gizmos!(DynamicGizmo)[i] = DynamicGizmo(bigPort, true);
			
		foreach(i; 10_000..18_000)
			gizmos!(DynamicGizmo)[i] = DynamicGizmo(extrasNumPorts, extrasIsSpinnable);
		
		// Use gizmos
		foreach(i; 0..10_000)
		{
			// Think of this as an array of types:
			alias TypeTuple!(
				Gizmo!(1, false),
				Gizmo!(1, true ),
				Gizmo!(2, false),
				Gizmo!(2, true ),
				DynamicGizmo,
			) AllGizmoTypes;
			
			foreach(T; AllGizmoTypes)
			foreach(ref gizmo; gizmos!T)
				useGizmo(gizmo);
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
	}
	catch(Throwable e)
	{
		writeln("Usage:");
		writeln("  ex6_meta_flex4_dynamicFallback2 "~
			"{bigPort} {extrasNumPorts} {extrasIsSpinnable}");
		writeln("Example: ex6_meta_flex4_dynamicFallback2 5 2 true");
		return;
	}
	
	UltraGiz ultra;
	ultra.run(bigPort, extrasNumPorts, extrasIsSpinnable);
	
	// Compile time error: A portless Gizmo is useless!
	//auto g1 = Gizmo!(0, true);
	
	// Runtime error: A portless Gizmo is useless!
	//auto g2 = DynamicGizmo(0, true);
}
