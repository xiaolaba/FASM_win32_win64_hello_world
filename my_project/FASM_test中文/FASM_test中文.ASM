;; share the code, https://board.flatassembler.net/topic.php?t=23595

;; refs: https://board.flatassembler.net/topic.php?p=217706
;;       https://board.flatassembler.net/topic.php?t=938
;; Unicode in FASM
;; FASM 1.73.32
;; win10 64 bit, CHT version
;; uses other editor, save this source code as UTF-8, FASM IDE is be able to process CHT input
;; open FSAM IDE, load/compile this code, it is displaying UTF-8 CHT char properly, data type must be DU
;; by xiaolaba

format PE GUI
entry start

include '\fasm\include\win32w.inc'
include '\fasm\include\encoding\utf8.inc'

section '.data' data readable writeable
IS64 du '64位元 Windows',0
IS32 du '32位元 Windows',0

argv	dd ?
argc	dd ?

dummyW dw 'AB'	;2 bytes, 0x41 0x42, compile ok
;dummyW dw 'ABCD'	;2 words, error, could not compile, value out of range
dummyU du 'AB'	;4 bytes, 41 00 42 00 ;compile ok

;;;; https://www.compart.com/en/unicode/U+4E2D
;;;; '中'	
;;;; UTF-8 encoding 0xE4 0xB8 0xAD
;;;; UTF-16 4E2D
;dummyWZ dw '中'	;compile error, value out of range
dummyWZ du '中'		;2D 4E, compile ok
dummyUZ du '中文'	;2D 4E 87 65, compile ok

; Define the wide (2-byte) strings for MessageBox
;messageBoxTitle dw 'U','T','F','-','8',' ',' ','中','文','測', '試',0  ; dw, Wide string for MessageBox title, did not work
;debugMessage	 dw 'F','A','S','M',' ','S','t','a','r','t','e','d','中','文','測','試',0  ; Wide string for debug message

; Define the U (4-byte) strings for MessageBox
;messageBoxTitle du 'U','T','F','-','8',' ',' ','中','文','測', '試',0  ; du, Wide string for MessageBox title, working
;debugMessage	du 'F','A','S','M',' ','S','t','a','r','t','e','d','-','中','文','測','試',0  ; Wide string for debug message
messageBoxTitle du 'UTF8-中文測試',0  ; du, Wide string for MessageBox title, working
debugMessage	du 'FASM Started-中文測試',0  ; Wide string for debug message

晚安 du '晚安',0

section '.code' code readable executable

start:


  ; Display debug message to verify execution
  invoke MessageBoxW, NULL, debugMessage, messageBoxTitle, MB_OK

  invoke MessageBoxW, NULL, IS64, messageBoxTitle, MB_OK

  invoke GetCommandLineW
  invoke CommandLineToArgvW, eax, argc
  mov	 [argv], eax

  ; Check if we have at least one argument
  cmp	 dword [argc], 1
  jbe	 exit

  ; Init loop
  mov	 ecx, 1
  mov	 eax, [argv]

@@:
  ; Get argument pointer
  mov	 edx, [eax + 4 * ecx]
  invoke MessageBoxW, NULL, edx, messageBoxTitle, MB_OK

  ; Repeat until ecx = argc
  inc	 ecx
  cmp	 ecx, dword [argc]
  jb	 @B

exit:
  invoke MessageBoxW, NULL, 晚安, messageBoxTitle, MB_OK
  invoke ExitProcess, 0





section '.idata' import data readable writeable

  library kernel32, 'kernel32.dll', \
	  user32, 'user32.dll', \
	  shell32, 'shell32.dll'

  import kernel32, \
	 GetCommandLineW, 'GetCommandLineW', \
	 ExitProcess, 'ExitProcess'

  import user32, \
	 MessageBoxW, 'MessageBoxW'

  import shell32, \
	 CommandLineToArgvW, 'CommandLineToArgvW'
