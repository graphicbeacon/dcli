# 0.24.1
Updated readme to refer to the new gitbook manual.
touch : now returns the path that was passed in.
Documentation improvements. Added Ask.any and Ask.all. Exposed all of the built in validators as methods.

# 0.24.0
added method to get overriden dependencies.

# 0.23.0
Breaking changes:
Added requirements for privileges when installing so we can set up paths for sudo usage of dcli. Also added option to disable the requirement primarily for unit testing.
Changed the names of all validators to start with AskValidator. The aim is to make auto completion in ide's work better.

Non breaking changes
Rewrote the find command so that it works even if a directory contains a file for which we don't have permissions.
Performance improvements for the find command by reducing the amount of heap allocation going on. We now re-use arrays as much as possible. We can process 1.3M files in 3 seconds. The performance problems start when we push the files into the Progress stream.
Updated doco to remove any references to setEnv
Changed from Platform.isWindows to Settings().isWindows so that we can mock the platform when unit testing.
createDir now returns the path that it created.
Marked some tests as skip until we work out what tests are required now we have changed how we handle pubspec.yaml

# 0.22.0
removed env() and setEnv() and replaced them with operators env[] and env[]=

# 0.21.2
Fixed a bug in the Progress.stream mehthod. It was only outputing stdout and it needs
to also output stderr. It now does.

# 0.21.1
renamed _pubCacheBinDir to _pubCacheBinPath for consistency.
Changed the default stream method so that it now includes stderr by default as this is generally what people expect (e.g. stream what I would normally see).
Fixed the verbose messages that mis-reported why stream output was being ignored.



# 0.21.0

Breaking changes:
Refactored methods names related to paths. They now all start with a pathTo prefix. 
The aim is to make it easier to find the methods and for ide auto-completion to be more useful.

All methods that refer to the PATH environment variable now use the capitalised word PATH in the method name.


# 0.20.2
Pubspec - Added support for fetching a list of executables.

# 0.20.0
Renamed dshell to dcli to better reflect its functionality and improve its discoverability on the pub.dev store.

Also took the opportunity to change the version no. to 0.x to reflect the fact that the api is still in flux.


# 1.11.1
Changed how we determine the packages path as a work around for #95
reduce logging for start method.
Forced fqdn to lowercase.

# 1.11.0
Breaking changes:  

Changed the 'prompt' argument on ask and confirm to be a positional argument.  This feels like a more natual use and is an easy fix where it breaks code.

# 1.10.21
Fixed a bug in Shell.loggedInUser. If you use sudo and the system has multiple users logged in then the wrong username would be returned.
updated doco for setEnv.

# 1.10.20
Exposed the PubCache class as part of the public api as part of the tooling we are providing to explore the scripts dart environment.
# 1.10.19
dcli doctor wasn't printing the dart version as the cli output from dart --version had changed. Improved the parsing method so it should be more robust in the face of future changes.
Added coverage switch to run_unit_tests.dart
corrected the name of the coverage directory.
create_project_test: Fixed a bug in the set of expeced filenames after upgrading to dart 2.9.
Added pid to Shell.
Unit test incorrectly had paths presenting as absolute after glob expansion when we only get relative paths.

# 1.10.18
Set the working directory to pwd if not passed.
Glob: fixed bug where globs like middle/.* where not being expanded correctly. Also modified the exception handling so that if the glob describes a directory that doesn't exist we now throw an exception rather than suppressing it. This is not the same as bash. If the glob doesn't match a valid directory it will just pass back the original glob.  The new approach however is more consistent with dclis philosophy that any invalid paths should generate an exception. Added unit tests around the above concepts.

# 1.10.17
Fixed the compile for scripts with a 'local' pubspec.yaml
removed stray print statment.

# 1.10.16
Fixed dcli compile so it works with 2.9.

# 1.10.15
moved to support the new .dart_tools directory so we work with dart 2.9.
Added an addition check for runnable that the package config exists.

# 1.10.14
Fixed a bug in parsing the results of who which resulting the logged in user name being reported incorrectly.

# 1.10.13
Fixed #81 NamedLocks where allowing multiple isolates/processes through. 
Added logic to ensure that streams are fully process to the Progress even when a non-zero exit code is returned. .run will now fully output both stdout and stderr even if a non-zero exit code is returned.
doco on exceptions when the default value is invalid. Improved the message output when the defaultValue fails validation.
Added code to clean up the temp directory after unit tests complete.

# 1.10.12
Fixed a bug where the username had a trialing space char.
improved doco.

# 1.10.11
Added method to Shell to return the current shell. This replaces having to call ShellDetection().detectShell();
Removed ShellDetection from the public api.

# 1.10.10
Fixed isComple.
# 1.10.9
Added a method to detect if the script is compiled. Also fixed #83 by not trying to read the annotation from the scrsipt when the script is compiled.

# 1.10.8
Added a new method to Script so you can get the currently running script.
Work on testing .run and handling of stderr and stdout.
added unit test timeouts as the github actions run rather slowly.
work on generating test coverage.

# 1.10.7
Fixed a bug where glob was ignoring hidden files even when the pattern was .* I'm not certain if this is the right solution. Need more usage patterns.

# 1.10.6
argh. managed to delete the working directory arg.

# 1.10.5
Fixed a bug in the start command. Needed a default for priviledged.

# 1.10.4
Added a 'privildeged' option to the run/start commands which attempts to escalate privildges if not currently running as a privildeged user.
Currently only supported under Linux

# 1.10.3
Now throws a RunException if the passed working directory doesn't exists. We found that if the working directory is invalid then for some reason searching the PATH fails. You end up with a command not found error rather than the real error which is that the working directory doesn't exists.

# 1.10.2
Added test for quote expansion with a complex mysql command.
A number of functions where not passing down the working directory and the nothrow setting.

# 1.10.1
Fixed a bug when the move command has to fall back to a copy/delete it wasn't passing down the overwrite flag.

# 1.10.0
Fixed a bug with glob expansion that was returning absolute paths when apps expect relative paths. Was causing problems when trying to zip a directory and the files being expanded with absolute paths into the zip file.

Its unlikely that any apps dependend on the prior behaviour and going forward this must be changed in order to get the expected behaviour.

# 1.9.18
Added methods to check file permission access. Only implemented on linux at this point.

# 1.9.17
Fixed a bug where Progress.stream was missing a default value for a bool

# 1.9.16
Exposed TableAlign and privatePath.
Setting up more detailed testing of .run and toList with intent to display stderr for .run.

# 1.9.15
Changed defaultValue to defaultOption to better indicate that it should be from the list of options. Fixed a bug when the defaultOption is null. Documented defaultOption.

# 1.9.14
unit test for ask and menu.
Added a Range validator to ask.
Added default value to menu.

# 1.9.13
Added defaultValue option to ask function.
Added code to test for child shutdown.

# 1.9.12
Improved the progress.stream method so that it streams data even when the called process is long running. It also waits for stderr/stdout streams to be fully processed before shutting down.

# 1.9.11
Fixed defaults for runInShell and nothrow for string_as_process stream.

# 1.9.11
Fixed defaults for runInShell and nothrow.

# 1.9.10
Added stream option to string_as_process.
Added the ability to return a stream from a progress.

# 1.9.9
Fixed the fetch unit tests as the download path had moved after re-org of test directory.
Unit tests for VirtualProject.doctor to address #71
Fixed a bug in split where it always tried to create a project even when it already exists.
Added method createOrLoad.  Fixed a bug in the loading of local projects where the pubspec path was not being set correctly.
Fixed doco. Changed getProjectRoot to a getter.
wording.

# 1.9.8
Exposed the Script class as part of the public api as it has some useful methods.
experiments with generating coverage.
Minor documentation fix.

# 1.9.7
FIX: split command now works!

tweaked doco on pubspec locations.
Fixes for activatelocal.dart We now compile the local dcli and set the path correctly. We also change the version no. so you can see that we are running the local version.
added unit tests for annotated pubspecs.
Added tests for the more liberal parsing of annotations.
removed color coding on verbose output as it was distracting.
updated doco to reflect that [local] pubspec also have a projectRootPath that is actual.
Fixed a bug which stripped required indentation on pubspec annotations.
Added unit test for pubspec annotations and enhanced the parser to handle more commenting styles.
Added support for install quiet option to the tab completion installer.
Added printStdErr progression which only prints to stderr.
Added a quiet option to the installer to suppress progress messages.
restructured test folders to match src folders

# 1.9.6
Added a method to remove a symbolic link.


# 1.9.5
enhanced the logic for tradititional builds to work even if the file is deeply nested under a prescribed directory.

# 1.9.4
Fixed lints.

# 1.9.3
Fixed the compile path to .packages for the traditional projects.

# 1.9.2
dcli was failing to return non-zero exit codes.

# 1.9.1
Fixed a bug in the call to setVerbose when disabling verbose.

# 1.9.0
Added support for running scripts from a standard dart project structure. We now detect the correct pubspec.yaml and run from there.
This is a fairly significant change as it fixes a long standing hole in dclis execurtion model.

Fixed a bug where the releaseLock would be called even when the lock had failed.
Improved the timeout exception so that you actually know the locked timed out. Change the retry interval to 100ms (down from 1s). Now guarentee that at least one lock attempt will be made even if the timeout is less then 100ms.
reverted start returning a progress as that doesn't work as the stream has already been processed by the time start returns. Added a unit test for same.

# 1.8.23
'command'.start() now returns a progress.


# 1.8.22
made tests OS specific.
Fixed duplication of windows paths during install issue.
test script for path manipulation.
move pub_cache back to util.
restored the correct pathSeparator method and renamed it pathDelimiter to make it clearer what its purpose is.

# 1.8.21
Work on improving the windows installer.
Exposed the Env class as it has a number of useful PATH related methods.
Windows Installer now checks that developer mode is enabled so we can use symlinks.

Added resets between pub-cache tests. Looks like join recognizes both slashes so no need to use platform specific slash.
marked reset method in a number of classes as only visible for unit testing. renamed pubcache unitTestrest to reset for consitency.
Looks like c:\ is prefixed also need to reset pubcache between tests.
removed pathSeparator as it duplicated dart Platform functionality.
Fixes for bugs with locating pub cache on windows and added unit tests.
Added addition paths to the windows PATH.
Added pathPutIfAbsent. Also renamed all the path functions to begin with 'path'.
Added pubcache and .dcli/bin to path.
Fixed a bug in the format of setx.
Added dcli path and now launches bash shell to do dev in. Not certain its what we need.
incomplete docker script to do local dev.
Added logic to delete the install dir if it already exists.
Added a check for install preconditions. If they are not met the installer will exit. For powershell we now check that developer mode is enabled as we require this for symlinks. We nolonger allow an install from the old command shell.
Added methods to manipulate the path.
Removed a sperious print statement.
# 1.8.20
Fixed a bug in the default script which had an extra /

# 1.8.19
Work on getting dcli to install under alpine docker image.
reduced progress messages when ansi not supported.
Added logic to move the dart-sdk to the write directory after expanding it. Added execute permissions to files in dart/bin directory. reduced the no. of progress messages.
Now printing out the dir dart is installed into.
Terminal: added method to check if ansi escapses are supported.
suppressed asking the user to confirm the install path.
Fixed a bug where moveTree wasn't actually recursive.
Added a fallback mechanism on linux system to install from the archive if apt isn't found.

# 1.8.18
Fixed a number of bugs around shell detection when one can't be determined.
exists() - added test for null or empty path.
dcli install - added a --nodart option to suppress installation of dart.
Fixed bugs in windows stackframe parsing.
Added install link for windows dcli_install.

# 1.8.17
another script path error.

# 1.8.16
Fixed for doctor when some paths missing.

# 1.8.15
Created github actions to generated linux and windows installer for dcli and dart.
Change copyDir to copyTree.
Changed moveDir to moveTree.
Created new simplified moveDir that just moves the top level dir.
Created a 'fetch' method for downloading files.
add logic to check if shell has a start script. Only trys to add a path when it does.
Fixed a npe when who doesn't return a user.
trying to improve the error message with .run is called and fails.
fixed an npe if the SHELL env var doesn't exist.
change paths to use truepath for consistency.
fixed broken brackets in readme.md
Developed code to download dartsdk from google archive and wrote test for same.
refactored the ansi classes and introduced additional methods for controlling a terminal.
added method to format a double as a percentage.
added cursor management.
dart_install for linux
workflow to create installer each time we do a release.

### 1.8.14
moved mockit to dev dependencies.
For the moment I've wound back the privileged requirements for install as it makes unit tests fail.
fixed unit tests to deal with unordered file lists.
Added logic to handling moving files between partitions. We fallback to doing a copy then delete.
Added .dcli/bin to path during install.
work on improving shell detection
Now using our own version of recase.
now using official pub_release.
changed writeToFile to saveToFile as felt it was more evocative.
removed dependancy on recase as was causing conflicts and we only use one line from it.
now exporting pubspec_file as its a useful class.
Added nothrow option to string start method.
restructured shell related classes as part of work to improve shell detection.
incorrect case in help.
seplling.
Fixed a bug where running 'dcli help <command>' wouldn't print the command help but did print the entire usage.
made the path columns wider.
colour coded the shell name.
fixed warning.
v 0.1.0 of docker cli for dcli.
Work on installing dcli using sudo and as a root user. Added priviledged required message.
The default script was using a relative path when it should be using a package.

# 1.8.14-dev.3
Added null check around sourcePath.

# 1.8.14-dev.2
Removed ReCase as a dependency as its used in lots of other project causing dependency conflicts.

# 1.8.14-dev.1
Work on improving shell detection.
Added nothrow to string_as_process start method.
Exposed PubSpec_File class as part of the public api.

### 1.8.13
fixed indentation problem. released 1.8.13
exposed SortDirection required for FileSort.
applied effective dart.
Had max/min back to front for Menu options.

### 1.8.13-dev.1
[ENH] Work on a docker based cli for dcli.
[FIX] unknown shell no returns false for priviliged user to avoid npe.
[Fix] for macos which by default only supports 127.0.0.1.
[ENH] added logic to fix permission when dcli rans as root.
[FIX] bug when determing pub-cache path if environment variable set.
[ENH] added new methods loggedInUser and isPrivilegedUser.
[ENH] released dcli_install as a binary so people could easily install dcli.

### 1.8.12
[ENH] created a command to upgrade dcli.
[DOC] cleaned up the public interface by making a number a items private.
[IMP] changed color for command messages for consistency.
[IMP] removed clean all as when you first install as there should be no projects. dcli upgrade on the other hand does need to do a clean all.
[IMP] cleaned up invalid argument processing.
[FIX] Fixed a bug which allowed install to be run from sudo.

### 1.8.11
[enh] adding validation to ask.
[imp] moved the cleanall after the install has completed so that compile errors don't stop the install completeing.
[bug] Fix for Service.getIsolateID returning null in compiled script. The hashcode should be a stable substitute. The question is why is getIsolateID only failing in some compiled scripts.

### 1.8.10
Fixed bug in glob expansion where a relative path with ../ was mistaken for a hidden path.

### 1.8.9
second go at fixing the compile install bug.

### 1.8.8
[BUG] dcli compile was failing to install due to move bug.

reformatted error so you can copy paste cmdline for testing.
bug in move as overwrite did not have a default value.

### 1.8.7
[ENH] added copyDir and moveDir functions.

### 1.8.6
[BUG] bug in the quote handling of startsWithArgs

### 1.8.5
[ENH] Exposed NamedLock as part of the official dcli api.
    Tidied up the NamedLock documentation and removed internal implementation from the api. 
[ENH] changed how we handle quoted arguments when the startWithArgs method is called. We no longer strip quotes from passed arguments because if you pass quotes you probably really need them to be there. This differs from passing cmdLine where we need to strip the quotes as bash does.
[ENH] added logic to suppress color codes if terminal doesn't support them.
[ENH] added support for backspace when entering hidden text for ask.
[CLEANUP] dog fooding the internals of VirtualProject.

### 1.8.4

This release is primarily about getting dcli to work correctly under windows.
There is still a no. of significant issues that need to be resolve for windows.
This release however has sufficient improvements for general dcli users that I thought it was time for a release.
The core windows issues is that dart2native doesn't support symlinks so compilation doesn't work.
This is affecting unit tests so its a little hard to evaluate just how stable the windows release.
Having said that it does look like dcli is broadly working under windows.
I will be attempting to resolve these issues over the next week or so.

This release also fixes an issue that Mac uses had that stopped them compiling dcli.
It appears that the logger package has a problem (Invalid cid) that stopped compilation on Mac, windows and Rasp Pi. I've removed this package and now compilation seems to work fine.




### 1.8.3
[fix] Compile fixes when project has local pubspec.yaml.
[enh] Added experimental parser to string_process which allows reading and parsing a number of common file formats.
[enh] Added glob expansion when running command lines.
[enh] New NamedLock class provides an inter isoloate and inter process locking mechanism.
[enh] Improvements to documentation.
[enh] New method on FileSync to create a temp file.
[enh] Version of start which takes a command and an arg array to provide a simplified path
when complex escaping is involved.
[fix] For unit test so that all test can now complete in a single run.
[fix] Start was not passing the Progress down.
[fix] Bug in tab completion when expanding scripts.
[fix] Two compiler bugs. It was trying to compile scripts in subdirectories when we are only meant to compile scripts in the current directory.  Fixed bug where local pubspec.yaml was being ignored.

### 1.8.3
Added start method which takes an arg array to avoid escaping lots of quotes.


