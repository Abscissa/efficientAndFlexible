// Written in the D programming language
// by Nick Sabalausky
//
// Tested on DMD 2.053
//
// Gizmo Example
// Frontend for:
// Version: Metaprogramming - Flexibility Method #2 - Compiling at Runtime

import std.conv;
import std.file;
import std.process;
import std.stdio;

void main(string[] args)
{
	immutable configFile     = "ex6_meta_flex2_config.d";
	immutable mainProgram    = "ex6_meta_flex2_compilingAtRuntime";
	immutable mainProgramSrc = "ex6_meta_flex2_compilingAtRuntime.d";
	
	version(Windows)
		immutable exeSuffix = ".exe";
	else
		immutable exeSuffix = "";
		
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
		writeln("  ex6_meta_flex2_frontend "~
			"{bigPort} {extrasNumPorts} {extrasIsSpinnable}");
		writeln("Example: ex6_meta_flex2_frontend 5 2 true");
		return;
	}
	
	// This is the content of the "ex6_meta_flex2_config.d" file to be generated.
	auto configContent = `
		immutable conf_bigPort           = `~to!string(bigPort)~`;
		immutable conf_extrasNumPorts    = `~to!string(extrasNumPorts)~`;
		immutable conf_extrasIsSpinnable = `~to!string(extrasIsSpinnable)~`;
	`;
	
	// Load old configuration
	writefln("Checking  \t%s...", configFile);
	string oldContent;
	if(exists(configFile))
		oldContent = cast(string)std.file.read(configFile);

	// Did the configuration change?
	bool configChanged = false;
	if(configContent != oldContent)
	{
		writefln("Saving  \t%s...", configFile);
		std.file.write(configFile, configContent);
		
		configChanged = true;
	}

	// Need to recompile?
	if(configChanged || !exists(mainProgram~exeSuffix))
	{
		writefln("Compiling  \t%s...", mainProgramSrc);
		system("dmd "~mainProgramSrc~" -release -inline -O -J.");
	}

	// Run the main program
	writefln("Running  \t%s...", mainProgram);
	version(Windows)
		system(mainProgram);
	else
		system("./"~mainProgram);
}
