// Written in the D programming language
// by Nick Sabalausky
//
// Tested on DMD 2.053
//
// Gizmo Example
// Version: Metaprogramming - Runtime Conversion

import std.algorithm;
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

	TOut convertTo(TOut)()
	{
		TOut newGizmo;
		
		static if(isSpinnable && TOut.isSpinnable)
			newGizmo.spinCount = this.spinCount;
		
		int portsToCopy = min(newGizmo.numPorts, this.numPorts);
		newGizmo.ports[0..portsToCopy] = this.ports[0..portsToCopy];
		
		// If there were any other data, we'd copy it to the newGizmo here
		
		return newGizmo;
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
			// Modify some gimos:
			// Save a 1-port non-spinny
			auto old1PortNoSpin = gizmos!(1, false)[i];
			
			// Convert a 2-port spinny to 1-port non-spinny
			gizmos!(1, false)[i] =
				gizmos!(2, true)[i].convertTo!( Gizmo!(1, false) )();

			// Convert a 5-port spinny to 2-port spinny
			gizmos!(2, true)[i] =
				gizmos!(5, true)[i%2].convertTo!( Gizmo!(2, true) )();
			
			// Convert the old 1-port non-spinny to 5-port spinny
			gizmos!(5, true)[i%2] =
				old1PortNoSpin.convertTo!( Gizmo!(5, true) )();
			
			// Use gizmos as usual
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
