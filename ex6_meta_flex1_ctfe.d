// Written in the D programming language
// by Nick Sabalausky
//
// Tested on DMD 2.053
//
// Gizmo Example
// Version: Metaprogramming - Flexibility Method #1 - Compile-Time Function Execution (CTFE)

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

	static int generateBigPorts()
	{
		// Big fancy computation to determine number of ports
		int num=0;
		for(int i=0; i<10; i++)
		{
			if(i >= 5)
				num++;
		}
		return num; // Ultimately, the result is 5
	}
	
	static int generateExtrasNumPorts(int input)
	{
		return input - 3;
	}
	
	static bool generateExtrasIsSpinnable(int input=9)
	{
		if(input == 0)
			return false;
			
		return !generateExtrasIsSpinnable(input-1);
	}
	
	static immutable bigPort           = generateBigPorts();
	static immutable extrasNumPorts    = generateExtrasNumPorts(bigPort);
	static immutable extrasIsSpinnable = generateExtrasIsSpinnable();

	void run()
	{
		StopWatch stopWatch;
		stopWatch.start();
		
		// Create gizmos
		gizmos!(1, false).length = 10_000;
		gizmos!(1, true ).length = 10_000;
		gizmos!(2, false).length = 10_000;

		// Use extrasNumPorts and extrasIsSpinnable
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

void main(string[] args)
{
	UltraGiz ultra;
	ultra.run();
	
	// Compile time error: A portless Gizmo is useless!
	//auto g = Gizmo!(0, true);
}
