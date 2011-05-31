import std.stdio;

struct Gizmo(int _numPorts, bool _isSpinnable)
{
	// So other generic code can determine the
	// number of ports and spinnability:
	static immutable numPorts    = _numPorts;
	static immutable isSpinnable = _isSpinnable;
	
	// The rest here...
}

struct AnyGizmo
{
	TypeInfo currentType;
	GizmoUnion gizmoUnion;

	union GizmoUnion
	{
		Gizmo!(1, false) gizmo1NS;
		Gizmo!(1, true ) gizmo1S;
		Gizmo!(2, false) gizmo2NS;	
		Gizmo!(2, true ) gizmo2S;
		Gizmo!(5, false) gizmo5NS;
		Gizmo!(5, true ) gizmo5S;
	}

	void set(T)(T value)
	{
		static if(is(T==Gizmo!(1, false)))
			gizmoUnion.gizmo1NS = value;

		else static if(is(T==Gizmo!(1, true)))
			gizmoUnion.gizmo1S = value;

		else static if(is(T==Gizmo!(2, false)))
			gizmoUnion.gizmo2NS = value;

		else static if(is(T==Gizmo!(2, true)))
			gizmoUnion.gizmo2S = value;

		else static if(is(T==Gizmo!(5, false)))
			gizmoUnion.gizmo5NS = value;

		else static if(is(T==Gizmo!(5, true)))
			gizmoUnion.gizmo5S = value;
		
		currentType = typeid(T);
	}
}

void useGizmo(T)(T gizmo)
{
	writeln("Using a gizmo:");
	writeln("  ports=", gizmo.numPorts);
	writeln("  isSpinnable=", gizmo.isSpinnable);
}

void main()
{
	AnyGizmo anyGizmo;
	anyGizmo.set( Gizmo!(2, true)() );
	
	if( anyGizmo.currentType == typeid(Gizmo!(1, false)) )
		useGizmo( anyGizmo.gizmoUnion.gizmo1NS );
		
	else if( anyGizmo.currentType == typeid(Gizmo!(1, true)) )
		useGizmo( anyGizmo.gizmoUnion.gizmo1S );
		
	else if( anyGizmo.currentType == typeid(Gizmo!(2, false)) )
		useGizmo( anyGizmo.gizmoUnion.gizmo2NS );
		
	else if( anyGizmo.currentType == typeid(Gizmo!(2, true)) )
		useGizmo( anyGizmo.gizmoUnion.gizmo2S );
		
	else if( anyGizmo.currentType == typeid(Gizmo!(5, false)) )
		useGizmo( anyGizmo.gizmoUnion.gizmo5NS );
		
	else if( anyGizmo.currentType == typeid(Gizmo!(5, true)) )
		useGizmo( anyGizmo.gizmoUnion.gizmo5S );

	else
		throw new Exception("Unexpected type");
}
