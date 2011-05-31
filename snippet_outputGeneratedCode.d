// In the UltraGiz.addGizmos() function of
// 'ex6_meta_flex3_runtimeToCompileTime2.d',
// see the generated code by replacing this:

mixin(dispatch( [1, 2, 3, 5, 10] ));

// With this:

immutable code = dispatch( [1, 2, 3, 5, 10] );
pragma(msg, "code:\n"~code); // Displayed at compile-time
mixin(code);
