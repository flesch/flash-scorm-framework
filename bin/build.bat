:: #! C:\WINDOWS\system32 cmd

:: build.bat
:: Sync the VZLearn Savage drive with your local course's working copy.

@ECHO OFF

:: If we're not passing any arguments, get to the good stuff.
if [%1] == [] goto :BUILD

:: You can't read minds? Fine! Here are a couple hints.
if %1 == --help goto :HELP
if %1 == /help goto :HELP

:: How much do you want to bet that noone will ever run `build --about`? So expect an easter egg in the future...
if %1 == --about goto :ABOUT
if %1 == /about goto :ABOUT

: BUILD (

	:: We're in the "bin" directory, so let's move up one level.
	CD ../
	
	:: Are we pushing something that will work on the VZLearn servers?
	if not exist "index.html" goto :ERROR
	
	:: Let me work some magic to figure the current folder name.
	for %%a in (%CD%) do set DIRECTORY=%%~nxa%*
	
	:: Make sure to log this push. This will help us track down the original folder when we're on the VZLearn Production server.
	echo %DATE% %TIME% ^| %USERNAME% ^| %DIRECTORY% >> README
	
	:: If "savage" isn't mapped for you, I'll do it for you. I'm nice.
	if not exist A:\ NET USE A: \\obpserpnas01.odc.vzwcorp.com\courses courses001 /user:courses
	
	:: Some VZW storage locations don't let us store `.exe` files, so before we can use robocopy.exe we need to rename it.
	REN bin\robocopy robocopy.exe
	
	:: Now I'll sync your remote with the local directory, ignoring any of the fancy development stuff you might have.
	bin\robocopy.exe . "A:\%DIRECTORY%" /MIR /XF *.as *.bat *.fla .gitignore README.md core.css api-wrapper.js json2.js /XD .git bin source
	
	:: Rename the exe back to what it was, because we like to leave things as they were.
	REN bin\robocopy.exe robocopy
	
	:: Move back into the "bin" directory.
	CD bin
	
	goto :END

)

:: We'll include some simple error checking, with the idea that this will become more a more robust application in the future.
:: Right now, we're really only checking if we've navigated to the root of the course folder.
: ERROR (
	echo [error] I couldn't find "index.html" in the root of your folder, so I couldn't upload it to the savage drive.
	cd bin
	goto :END
)

:: Help
: HELP (
	echo [help] To upload your course folder without any options, simply run: build
	echo [help] If you want to append a peice of text to the folder name, use this syntax: build -2
	echo [help]    where "-2" is what should be added, resutling in "course-folder-2"
	goto :END
)

:: About
: ABOUT (
	echo [about] build.bat is teh awesome!
	goto :END
)

:END
