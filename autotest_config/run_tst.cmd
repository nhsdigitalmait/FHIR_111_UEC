@echo off
rem
rem run tst tests
rem usage %0 <tstfile>+
rem
rem set OPTIONS=-Djavax.net.debug=all

for %%f in ( %* ) do (
	echo %%f
	"%JAVA_HOME%\bin\java" %OPTIONS% -jar %TKWROOT%\TKW.jar -autotest \mnt\encrypted\home\simonfarrow\Documents\TKW5.0Dev\TKW\config\FHIR_111_UEC\autotest_config\tkw-x-autotest.properties %%f
)
