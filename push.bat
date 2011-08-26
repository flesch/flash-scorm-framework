@ECHO OFF
for %%a in (%CD%) do set DIRECTORY=%%~nxa
NET USE A: \\obpserpnas01.odc.vzwcorp.com\courses courses001 /user:courses
ROBOCOPY . "A:\%DIRECTORY%" /MIR /XF *.bat .gitignore /XD .git