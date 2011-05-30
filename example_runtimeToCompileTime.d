// Written in the D programming language
// by Nick Sabalausky
//
// Tested on DMD 2.053
//
// Runtime Value to Compile-Time Value Example

import std.conv;
import std.stdio;

// Remember, this is a completely different type
// for every value of compileTimeValue.
class Foo(int compileTimeValue)
{
	static immutable theCompileTimeValue = compileTimeValue;
	
	static int count = 0;
	this()
	{
		count++;
	}
	
	static void display()
	{
		writefln("Foo!(%s).count == %s", theCompileTimeValue, count);
	}
}

void main(string[] args)
{
	foreach(arg; args[1..$])
	{
		int runtimeValue = to!int(arg);

		// Dispatch runtime value to compile-time
		switch(runtimeValue)
		{
		// Note:
		// case {runtime value}: new Foo!{equivalent compile time value}();
		case  0: new Foo!0();  break;
		case  1: new Foo!1();  break;
		case  2: new Foo!2();  break;
		case  3: new Foo!3();  break;
		case 10: new Foo!10(); break;
		case 99: new Foo!99(); break;
		default:
			throw new Exception(text("Value ",runtimeValue," not supported."));
		}
	}
	
	Foo!( 0).display();
	Foo!( 1).display();
	Foo!( 2).display();
	Foo!( 3).display();
	Foo!(10).display();
	Foo!(99).display();
}

