@echo off

echo Building 'ex1_original.d'...
dmd -release -inline -O ex1_original.d

echo Building 'ex2_objectOriented.d'...
dmd -release -inline -O ex2_objectOriented.d

echo Building 'ex3_handcrafted.d'...
dmd -release -inline -O ex3_handcrafted.d

echo Building 'ex4_metaprogramming.d'...
dmd -release -inline -O ex4_metaprogramming.d

echo Building 'ex5_meta_deadDuck1.d'...
dmd -release -inline -O ex5_meta_deadDuck1.d

echo Building 'ex5_meta_deadDuck2.d'...
dmd -release -inline -O ex5_meta_deadDuck2.d

echo Building 'ex6_meta_flex1_ctfe.d'...
dmd -release -inline -O ex6_meta_flex1_ctfe.d

echo Building 'ex6_meta_flex2_frontend.d'...
dmd -release -inline -O ex6_meta_flex2_frontend.d

echo Building 'example_runtimeToCompileTime.d'...
dmd -release -inline -O example_runtimeToCompileTime.d

echo Building 'ex6_meta_flex3_runtimeToCompileTime1.d'...
dmd -release -inline -O ex6_meta_flex3_runtimeToCompileTime1.d

echo Building 'ex6_meta_flex3_runtimeToCompileTime2.d'...
dmd -release -inline -O ex6_meta_flex3_runtimeToCompileTime2.d

echo Building 'ex6_meta_flex4_dynamicFallback1.d'...
dmd -release -inline -O ex6_meta_flex4_dynamicFallback1.d

echo Building 'ex6_meta_flex4_dynamicFallback2.d'...
dmd -release -inline -O ex6_meta_flex4_dynamicFallback2.d

echo Building 'ex7_meta_runtimeConversion.d'...
dmd -release -inline -O ex7_meta_runtimeConversion.d

echo Building 'example_anyGizmo.d'...
dmd -release -inline -O example_anyGizmo.d
