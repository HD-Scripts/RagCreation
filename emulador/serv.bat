@ECHO OFF
IF "%1"=="" GOTO DIRETO
IF "%2"=="" GOTO DIRETO
IF NOT EXIST "%1" GOTO NAOENCONTRADO
GOTO INICIO

REM == How RESTART_9X and RESTART_NT works =========================
REM On Windows 9x only the first 8 characters are significant for
REM labels, and the first matching one is called (RESTART_(9X)).
REM Windows NT calls the exact named label (RESTART_NT).
REM Separation between 9X and NT is required, because CHOICE has
REM different syntax on these platforms or does not exist as all.
REM ================================================================

REM Windows 95, 98, ME
:RESTART_9X
REM Old Ctrl+C in PING does not work, because that only stops ping,
REM not the batch file.
CHOICE /C:rc /N /T:R,15 Reiniciando em 15 segundos, pressione 'C' para cancelar.
IF NOT ERRORLEVEL 2 GOTO INICIO
GOTO FIM

REM Windows 2000, XP, Vista, 7
:RESTART_NT
REM There is no CHOICE in 2000 and XP, but you get asked whether to
REM abort the batch file, when pressing Ctrl+C in PING.
ECHO Reiniciando em 15 segundos, pressione 'Ctrl+C' para cancelar.
PING -n 15 127.0.0.1 > NUL

:INICIO
%1
ECHO.
REM Return value > 1 is exception&~0xC0000000
IF ERRORLEVEL 2 GOTO ERRO
REM Return value 1 is EXIT_FAILURE
IF ERRORLEVEL 1 GOTO SAIDA1
REM Return value 0 is EXIT_SUCCESS
ECHO %2 terminou com êxito.
GOTO RESTART_NT

:SAIDA1
ECHO.
ECHO %2 terminou anormalmente.
GOTO RESTART_NT

:ERRO
ECHO.
ECHO %2 deu erro!
GOTO RESTART_NT

:DIRETO
ECHO.
ECHO Não inicie este arquivo diretamente. Ele é usado pelo logserv-sql.bat,
ECHO charserv-sql.bat e mapserv-sql.bat.
ECHO.
GOTO FIM

:NAOENCONTRADO
ECHO.
ECHO O %2 não foi encontrado.
ECHO Muito provavelmente, você esqueceu de compilar o emulador.
ECHO Por favor, leia na seção Guias e Tutoriais do Cronus para
ECHO saber como compilar.
ECHO.
GOTO FIM

:FIM
PAUSE
