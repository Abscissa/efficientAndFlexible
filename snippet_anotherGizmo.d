struct AnotherGizmo  // Even a class would work, too!
{
	mixin(declareInterface("IGizmo", "AnotherGizmo"));
	
	// Implement all the required members of IGizmo here...
}
