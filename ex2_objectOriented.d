// Written in the D programming language
// by Nick Sabalausky
//
// Tested on DMD 2.053
//
// Gizmo Example
// Version: Object Oriented (Inherited Types, Runtime Features)

import std.datetime;
import std.stdio;

interface ISpinner
{
	@property bool isSpinnable();
	void spin();
}

final class SpinnerStub : ISpinner
{
	@property bool isSpinnable()
	{
		return false;
	}
	void spin()
	{
		// Do nothing
	}
}

final class Spinner : ISpinner
{
	@property bool isSpinnable()
	{
		return true;
	}
	int spinCount;
	void spin()
	{
		spinCount++; // Spinning! Wheeee!
	}
}

abstract class Gizmo
{
	this()
	{
		spinner = createSpinner();
	}
	
	@property int numPorts();
	void doStuff();

	ISpinner spinner;
	ISpinner createSpinner();
}

class OnePortGizmo : Gizmo
{
	override ISpinner createSpinner()
	{
		return new SpinnerStub();
	}
	
	private OutputPort[1] ports;
	override @property int numPorts()
	{
		return 1;
	}
	override void doStuff()
	{
		ports[0].zap();
	}
}

class TwoPortGizmo : Gizmo
{
	override ISpinner createSpinner()
	{
		return new SpinnerStub();
	}
	
	private OutputPort[2] ports;
	override @property int numPorts()
	{
		return 2;
	}
	override void doStuff()
	{
		ports[0].zap();
		ports[1].zap();
	}
}

class MultiPortGizmo : Gizmo
{
	this(int numPorts)
	{
		if(numPorts < 1)
			throw new Exception("A portless Gizmo is useless!");

		if(numPorts == 1 || numPorts == 2)
			throw new Exception("Wrong type of Gizmo!");

		ports.length = numPorts;
	}

	override ISpinner createSpinner()
	{
		return new SpinnerStub();
	}
	
	private OutputPort[] ports;
	override @property int numPorts()
	{
		return ports.length;
	}
	override void doStuff()
	{
		foreach(port; ports)
			port.zap();
	}
}

final class SpinnyOnePortGizmo : OnePortGizmo
{
	override ISpinner createSpinner()
	{
		return new Spinner();
	}
}

final class SpinnyTwoPortGizmo : TwoPortGizmo
{
	override ISpinner createSpinner()
	{
		return new Spinner();
	}
}

final class SpinnyMultiPortGizmo : MultiPortGizmo
{
	this(int numPorts)
	{
		super(numPorts);
	}

	override ISpinner createSpinner()
	{
		return new Spinner();
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

	void useGizmo(ref Gizmo gizmo)
	{
		gizmo.doStuff();
		gizmo.spinner.spin();
		
		if(gizmo.spinner.isSpinnable)
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
		foreach(i;      0..10_000) gizmos[i] = new OnePortGizmo();
		foreach(i; 10_000..20_000) gizmos[i] = new SpinnyOnePortGizmo();
		foreach(i; 20_000..30_000) gizmos[i] = new TwoPortGizmo();
		foreach(i; 30_000..40_000) gizmos[i] = new SpinnyTwoPortGizmo();
		foreach(i; 40_000..45_000) gizmos[i] = new MultiPortGizmo(5);
		foreach(i; 45_000..50_000) gizmos[i] = new SpinnyMultiPortGizmo(5);
		
		// Use gizmos
		foreach(i; 0..10_000)
		foreach(gizmo; gizmos)
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
	//auto g = new Gizmo(0, true);
}
