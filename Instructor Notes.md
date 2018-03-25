# PowerShell Workshop - Core Concepts
## Introduction and Basics
### What is PowerShell?
1. Task-based command line shell.
2. Scriptable.
3. Object Oriented.
4. Extensible though PowerShell-specific add-ons, .NET Framework, and native platform APIs.
5. Whole lotta other shit like an entire dialect built into the runtime but whatevs... TODO

### Why
1. Functional intersection of other tools which did not necessarily work well together.
    1. Command Prompt / cmd.exe – Command line interface. Easily scriptable.
    2. Windows Scripting Host / cscript.exe – VBScript, Jscript, etc… Native, object-oriented Windows scripting.
    3. .NET – Re-use investment in the .NET ecosystem, including integration into .NET based-software.
2. Monad manifesto link? Vision of common language across enterprise systems. TODO

## Before We Begin
### Verbosity and Aliases
1. Aliases will be avoided.
2. In most cases, commands will have all parameters qualified with their names.
3. Flowery, overly-verbose coding style.

### PowerShell Prompt
1. PowerShell is mostly the same at the interactive prompt and in scripts.
2. There are a few exceptions which will be noted as they come up.

## Syntax Basics
### Variables
1. Assignment – $Variable = value
2. Quotes – $Variable = “value”, $Variable = ‘value’, with and without interpolation. (show advanced interpolation in other modules? ${}$ .{})

### Objects
1. Properties – $Variable.Property
2. Everything is an object. – $Variable.GetType, $Variable.GetType(), (7).GetType()
3. Introspection is great but may catch you off guard due to PowerShell syntax.

### Commands – Cmdlets and Advanced Functions
#### About
1. PowerShell uses Spaces and dash-prefixed parameter names to define Cmdlet parameters.

#### Examples
1. Verb-Noun
2. Verb-Noun Parameter
3. Verb-Noun -ParameterName Data
4. Verb-Noun()

#### Additional Comments
1. Cmdlets are not functions, but can look similar.
2. Use spaces and explicit parameters whenever possible to avoid confusion and unexpected behaviors. Failure to use the preferred convention can lead to unexpected results.
3. Functions (discussed later) allow function-like syntax, but Cmdlets don’t.
4. Sometimes parameters may be auto-converted to a collection (discussed later.)

### Compound Statements
#### About
1. PowerShell expressions can be evaluated individually and incrementally, but the aim is to chain items to complete tasks.
2. It is necessary to understand and use additional elements to properly control code execution.

#### Examples
1. () – Grouping operator. Execute this first.
2. $() – Sub-expression operator. Execute this first in a sub-shell. Allows for complex statements, including multiple semicolon-separated statements.
3. {} – Script Block.

#### Additional Comments
1. Many other language features are based on these basic elements, such as control structures.

### Types and Casting
#### About
1. PowerShell is dynamically, implicitly, weakly typed.
2. Variables can (usually) change type. Type is figured out via context (usually). Types are automatically converted as needed at run-time (usually).
3. Casts (usually) apply to assigned variables, causing right-hand operands to be converted to the now explicitly declared type.

#### Examples
1. Cast to an Integer.
2. Cast between strings and integers.

#### Additional Comments
1. Dynamic typing can lead to awkward issues, or convenience, depending on the situation. Empty strings meaning false, etc…
2. This is important when looking at Function parameters and reference to .NET types.

### Collections
#### About
1. PowerShell (and .NET) have several types of Collections. The most commonly used are the Array and the Hashtable.

#### Examples
1. Array Use
2. Array immutability.
3. Hashtable Use
4. Hashtable appends.

#### Additional Comments
1. Other Collection types can be instantiated by referencing .NET.

### Comparators
#### About
1. For consistency and cleanliness PowerShell comparators look and work like Cmdlet parameters.

#### Examples
1. Mathematical symbols don’t work.
2. Numerical Comparators
3. Text Comparators
4. Comparators and Collections

#### Additional Comments
1. Be wary of Collection placement in comparisons. Left-hand versus right-hand can make a difference. @( 1, 2, 3 ) -ge 2 = @( 2, 3 ) versus 2 -ge @( 1, 2, 3 ) = ERROR
2. -contains versus -in is essentially the same thing with the left- and right-hand values reversed. -in was introduced in PowerShell 3.0, so -contains is more compatible.
3. The -match operator is very useful (regular expression matching) but isn’t covered here. See issues with automatic variables and Select-String.

### Getting Help

#### About
1. PowerShell help is generally good.

#### Examples
1. Tab Completion
2. Get-Help Verb-Noun
3. Get-Help about_*
4. Update-Help
5. Microsoft Developer Websites.

#### Additional Comments
1. When Googling look for docs.microsoft.com over technet.microsoft.com .
2. Be wary of content-farm websites and lazy example code.
3. PowerShell was designed to be clear, consistent, and expressive. Avoid help material that teaches you bad habits. See Perl.

## Basic Workflow
### Pipelining
#### About
1. PowerShell can be executed sequentially, or through the use of common control stuctures.
2. Being workflow oriented, the KillerApp approach is to set up workflow Pipelines, moving objects through in one go.
3. PowerShell pipelines pass objects to different commands, not plain text. (Though text can be an object.)
4. OBJECTlivey better than other languages since PowerShell passes objects rather than text.
5. Can stream data out in real time.
6. Not all Cmdlets accept Pipeline input.

#### Examples
1. Use Select-Object to alter returned data via Pipeline.

#### Additional Comments
1. Pipeline is how PowerShell is designed to be used.
2. Pipelines generally process in a stream.
3. Continuous stream of data means lower memory requirements, but often slower execution.
4. PowerShell sometimes lies. About_Format.ps1xml .
5. Default display can execute code, so consider performance implications.

### Filtering
#### About
1. Pipeline with Where-Object Cmdlet.
2. $_ / $PSItem automatic variable can be used in Pipelines to refer to the “current” object.

#### Examples
1. Get processes and filter for PowerShell.
2. $PSItem vs $_
3. FilterScript vs Paramaeter -comparison Value

#### Additional Comments
1. Comparison Statement syntax (no Script Block) introduced in PowerShell 3.0.
2. Comparison Statement syntax reads better but is limited.
3. Multiple comparators and inline calculations require the full Script Block syntax.

### File Data
#### About
1. PowerShell provides several built-in Cmdlets for handling file I/O.
2. They work fairly well if paradigms are respected.

#### Examples
1. Write a list of PowerShell processes to a file.
2. Write a list of processes to a file, read back, and filter for PowerShell.
3. Write a list of processes to a structured file, read back, and filter for PowerShell.
4. Serialize a list of process to a file, read back, and filter for PowerShell.
5. Create a Lookup Map from file data using a Hashtable.

#### Additional Comments
1. PowerShell types have default views which determine how they are output to a console by default. Be aware.
2. Built-in Cmdlets have built-in magic that sometimes creates unexpected results. A key example is plain text files line to array conversion.
3. Built-in magic adds overhead to native file I/O Cmdlets.
4. Using .NET I/O API is faster (discussed later.)
5. Deserialized objects may behave inconsistently.

### Filesystem
#### About
1. File and Directory manipulation is done though PowerShell’s generic Data Store Provider / Item model.
2. Providers provide access to data stores, such as the file system, in a somewhat standard way.
#### Examples
1. Create, get, and delete a file.
2. Create a file in the current directory, then list the contents of the current directory.
3. Get an object reference to a file, then use the object to delete the file.
4. List the contents of the current directory as file names, not full objects.
5. List all files into a variable.

#### Additional Comments
1. PowerShell makes Filesystem manipulation very easy.
2. Be wary of performance and memory usage since everything is object-based. A lot more than a simple “dir” is going on. Even if managed correctly Garbage Collection cycles may mean long stretches of high memory utilization.
3. Be mindful of object and backing item linkages.

### Registry
#### About
1. Registry manipulation also uses the Provider / Item model.
2. Registry Keys are Items.
3. Registry Values are Properties of Keys.

#### Examples
1. Read Current User Auto-Run entries.
2. Create an Auto-Run entry for Notepad.exe.
3. Navigate the Registry like the filesystem.

#### Additional Comments
1. Only HKCU and HKLM are provided by default.
2. Interactive, complex registry manipulation can be challenging due to the intersection of child objects and properties.

##	Scripting
### Execution Policy
#### About
1. Execution Policy defines when PowerShell will execute a script or block execution.
2. Scopes are LocalMachine, CurrentUser, Process.
3. The most specific scope’s policy wins.

#### Examples
1. Get and set the Execution Policy.

#### Additional Comments
1. Despite Microsoft’s claims Execution Policy isn’t a “security” feature. “Safety” is more apt.
2. Article “15 Ways to Bypass the PowerShell Execution Policy” exists, so clearly it is not a real security feature.

### Conditionals and Flow Control
#### About
1. If / Then / Else
2. Switch
3. For / ForEach
4. While / Do While
5. Try / Catch / Finally

#### Examples
1. (Examples of each structure.)

#### Additional Comments
1. Try, Catch, Finally does support multiple Catch blocks.
2. ForEach vs ForEachObject
    1. ForEach-Object is generally for Pipeline customization such as wrapping Cmdlets that do not accept Pipeline input.
    2. ForEach-Object allows for multiple statements per input object in a Pipeline.
    3. ForEach is an alias for ForEach-Object in interactive mode. There is no difference.
    4. ForEach in scripts behaves differently. Pipeline is broken but can still output.
    5. ForEach results in higher memory utilization than ForEach-Object (caching during broken Pipeline) but can be faster.

### Functions and Advanced Functions and Cmdlets
#### About – frees up memory as well when you function-scope!
1. Functions allow compartmentalization of code for re-use.
2. Advanced Functions mimic Cmdlets.

#### Examples
1. Basic Function
2. Function with a Parameter (Inline declaration)
3. Function with a Parameter (Block declaration)
4. Function with Pipeline Input
5. Advanced Function / Script Cmdlet

#### Additional Comments
1. Data written out during a function is the function’s output.
2. Normal Functions are basic.
3. Advanced Functions can be created by either using CmdletBinding or by using Parameter attributes.
4. Begin, Process, and End blocks are required for pipeline input.
5. Pipeline input can be very tricky. When in doubt, fall back to ValueFromPipelineByPropertyName .
6. Get-Help about_Functions_Advanced_Parameters

### Splatting
#### About
1. Pass a Hashtable of parameters instead of or in addition to explicitly defined parameters.
2. Allows for run-time parameterization. We can define not just what the value of passed parameters are, but what parameters are passed.
3. Avoids messy scripts with large sets If/Then statement blocks for different parameter sets to the same command.
4. Main uses are accounting for Switch parameters and parameter sets.

#### Examples
1. Passing a parameter via Splatting.
2. Adding a Switch parameter to an existing splatting Hashtable.

#### Additional Comments
1. $PSBoundParameters can be used with wrapper scripts for an intercept-and-pass-through model.
2. Even though PowerShell passes by value be careful about Hashtable reuse in loops.

### Custom Objects
#### About
1. Custom objects can be created and used for better control over output.
2. Custom objects can be streamed out of the pipeline in a collection.
3. Outputting Hashtables yields a collection of Hashtables with keys which may match, but each Hashtable is still a rendered separately.
4. Outputting a collection of PSObject yields clean, consistent PowerShell output.

#### Examples
1. Create a basic custom object with two properties.

#### Additional Comments
1. It is possible to update the Default Display Property Set to control what is shown on the console by default. (Remember Get-Process.)
2. Additional member types including methods can be added if necessary.

### ArrayLists
#### About
1. PowerShell Arrays are immutable by default.
2. Appending data to an Array means creating a third array from the two given ones. (Original, Addition, Target.)
3. ArrayLists solve this problem.

#### Examples
1. Array versus ArrayList

#### Additional Comments
1. Scripts should try to continue moving objects through the pipeline, streaming them until the end.
2. When that’s not desirable or possible, use ArrayLists.
3. Be sure to consume or discard the output from [ArrayList].Add(). Output is the index of the element added.

## Modules
### Finding, Loading and Using Modules
#### About
1. PowerShell code can be packaged and distributed in Modules.
2. All Cmdlets are implemented in a Module.
3. Snap-Ins are similar to Modules, but they are compiled .NET assemblies. Snap-Ins are deprecated.
4. As of PowerShell 3.0 Modules will be auto-loaded.

#### Examples
1. List modules and module contents.
2. Force Load and Unload a module.
3. Use a Module Qualified Name.

#### Additional Comments
1. Combine Aliases, Module Qualified Names, and Splatting to make Cmdlet “hooks”. These can be used to implement utilities such as pluggable logging modules.
2. Override or intercept modules by installing them in higher precedence locations. User Directory > Program Files > System .
3. Module auto-loading can be disabled by setting $PSModuleAutoloadingPreference to ‘None’ .
### Authoring Modules
#### About
1. Authoring modules allows for clean, compatible distribution of related code.

#### Examples
1. Simple one-file module.
2. Full module.

#### Additional Comments
1. PowerShell has easy support for multi-line string literals.
2. Using Module Manifests is preferred as it allows for versioning.
3. Use #Requires -Modules in scripts to force dependency on a module. Specific versions can be specified.

## Code Execution
### Packaging and Execution
#### About
1. PowerShell code can be executed with similar means one would use for any other program or script.
2. Special care should be taken to account for PowerShell’s feature set.

#### Examples
1. Basic invocation of code with powershell.exe.
2. Execution of Base64 encoded scripts.

#### Additional Comments
1. Be aware of PowerShell output console rendering when invoking scripts though powershell.exe .
2. Output often must be captured and converted to plain text before final output. See Out-String.
3. EncodedCommand lets you execute code in-line via any job scheduling engine such as Task Scheduler, GPO Scripts, etc…
4. For both patterns of invocation there is a limit of 8191 characters that can be passed to a new process. This includes any passed parameters and environment variables.

## .NET IO
### Random File IO
#### About
1. PowerShell file I/O cmdlets often try to be helpful.
2. Unexpected behavior and poor performance may be noticed.
3. Using .NET file I/O directly gives great performance and plenty of control.

#### Examples
1. .NET File I/O
2. Random file I/O
3. Read a file into memory and compress using streams.

#### Additional Comments
1. PowerShell “magic” might not be available. Provide full paths, etc…

### .NET I/O Streams
#### About
1. Like PowerShell Pipelines, .NET I/O streams represent a workflow.
2. Build the stream, put data in one side, and get results out of the other.
3. Streams can be more efficient than writing and performing steps procedurally.

#### Examples
1. Read a file into memory and compress using streams.

#### Additional Comments
1. Streams may have a few quirks to be aware of, such as buffering. Always explicitly flush and/or close streams.
