#!/bin/sh

echo Running 'ex1_original' 3x...
./ex1_original
./ex1_original
./ex1_original

echo Running 'ex2_objectOriented' 3x...
./ex2_objectOriented
./ex2_objectOriented
./ex2_objectOriented

echo Running 'ex3_handcrafted' 3x...
./ex3_handcrafted
./ex3_handcrafted
./ex3_handcrafted

echo Running 'ex4_metaprogramming' 3x...
./ex4_metaprogramming
./ex4_metaprogramming
./ex4_metaprogramming

echo Running 'ex5_meta_deadDuck1' 3x...
./ex5_meta_deadDuck1
./ex5_meta_deadDuck1
./ex5_meta_deadDuck1

echo Running 'ex5_meta_deadDuck2' 3x...
./ex5_meta_deadDuck2
./ex5_meta_deadDuck2
./ex5_meta_deadDuck2

echo Running 'ex6_meta_flex1_ctfe' 3x...
./ex6_meta_flex1_ctfe
./ex6_meta_flex1_ctfe
./ex6_meta_flex1_ctfe

echo Running 'ex6_meta_flex2_frontend' 3x...
./ex6_meta_flex2_frontend 5 2 true
./ex6_meta_flex2_frontend 5 2 true
./ex6_meta_flex2_frontend 5 2 true

echo Running 'example_runtimeToCompileTime' with args "1 2 99 2 2 2"...
./example_runtimeToCompileTime 1 2 99 2 2 2

echo Running 'example_runtimeToCompileTime' with args "10 99 0 10"...
./example_runtimeToCompileTime 10 99 0 10

echo Running 'example_runtimeToCompileTime' with args "3 3"...
./example_runtimeToCompileTime 3 3

echo Running 'ex6_meta_flex3_runtimeToCompileTime1' 3x...
./ex6_meta_flex3_runtimeToCompileTime1 5 2 true
./ex6_meta_flex3_runtimeToCompileTime1 5 2 true
./ex6_meta_flex3_runtimeToCompileTime1 5 2 true

echo Running 'ex6_meta_flex3_runtimeToCompileTime2' 3x...
./ex6_meta_flex3_runtimeToCompileTime2 5 2 true
./ex6_meta_flex3_runtimeToCompileTime2 5 2 true
./ex6_meta_flex3_runtimeToCompileTime2 5 2 true

echo Running 'ex6_meta_flex4_dynamicFallback1' 3x...
./ex6_meta_flex4_dynamicFallback1 5 2 true
./ex6_meta_flex4_dynamicFallback1 5 2 true
./ex6_meta_flex4_dynamicFallback1 5 2 true

echo Running 'ex6_meta_flex4_dynamicFallback2' 3x...
./ex6_meta_flex4_dynamicFallback2 5 2 true
./ex6_meta_flex4_dynamicFallback2 5 2 true
./ex6_meta_flex4_dynamicFallback2 5 2 true

echo Running 'ex7_meta_runtimeConversion' 3x...
./ex7_meta_runtimeConversion
./ex7_meta_runtimeConversion
./ex7_meta_runtimeConversion

echo Running 'example_anyGizmo'...
./example_anyGizmo
