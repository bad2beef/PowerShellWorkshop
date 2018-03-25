# PowerShell Workshop
## Introduction
**This is Studly McBeefy’s and Beefy McStudly's PowerShell workshop.** The aim
of this workshop is to get you competent in PowerShell quickly. There are no
quirky gimmicks or “master class” shenaniganry here. Our approach is simple.
We’ll walk through a bunch of things you should know and see what happens. If
you’re the curious type you’ll dig deeper in each area on your own. If not, you
should still be able to fumble though quite a bit. At the end of it all you
should be able to read a lot of the PowerShell out there, and be able to churn
out simple code to accomplish a wide range of tasks for better or for worse.

_Other, more focused bolt-ons to the workshop may exist. Also, they may not._

Ideally, you’ll be taking this workshop with us. The content herein has been
created to facilitate guided exploration. If you’re doing this on your own a
few things may not be so clear. Still, in the interests of saving you from
skiddiedom open materials are provided. There is enough here to provide the
“what”, but the “why”, “when” and “how” may require some additional
instruction which is best spoken, rather than read.

## Topics Covered
### Core Workshop
Core workshop content is available to all on adjacent to this readme.
1. __Introduction and PowerShell Basics__ – What and Why, Basic Syntax, and Getting Help
2. __Basic Workflow__ – Pipeline, Filtering, File I/O, Filesystem and Registry
3. __Scripting__ – Execution Policy, Conditionals and Flow Control, Functions, Splatting, Custom Objects and ArrayLists.
4. __Modules__ – Finding, loading, and authoring modules.
5. __Code Execution__ – Packing and Execution of code.
6. __Basic .NET I/O__ – Use .NET I/O directly for speed and flexibility.

### Focused Modules
Focused modules are mix-and-match learning addons we'll work through during
in-person workshops based on event or organization audiences.
1. __Data Protection__ – Cryptography and the Data Protection API.
2. __Network Programming__ – Network and sockets programming.
3. __Scaling Out__ – Remoting, Jobs, and Event-Driven scripting.
4. __Web Services__ – Utilizing web services through web-based APIs and regular web sites.

## Prerequisites
1. Basic scripting or programming experience in just about any language. Some familiarity with concepts such as variables, conditionals, flow control, and basic object-oriented programming is required.
2. An Windows operating system with GUI and PowerShell 5.0 or later. It is possible to run through most workshop content on a headless Windows Core box, or a Linux or Mac OS operating system with PowerShell Core 6.0, however some of the more advanced material in the additional Focused Modules may not be accessible in such environments.
3. Local or remote system with WinRM enabled and usable. (For Remoting section only.) If using the provided Vagrant box one may connect back to localhost over the remoting protocols as an academic exercise. If attending an in-person workshop some network-available systems may be provided depending on venue.

## Workshop Materials
So, what’s in the box?
 * __PowerShell Workshop.ps1__ – The curriculum. _This is the meat._
 * __Examples/*__ – Simple example code to provide somewhat realistic examples
of PowerShell usages. _Delicious potatoes, of the Yukon Gold variety._
 * __Vagrantfile__ – A simple Vagrant configuration to allow you stand up a
quick and easy sandbox for learning. This isn’t necessary, but its advised you
use it. _Its fresh sausage gravy on top._
