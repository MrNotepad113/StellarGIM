       TITLE DOSINIT.ASM
;
; Copyright (c) 2024-2025, Digital Notepad Computer Company
;
; DOSINIT.ASM -- Dos Initializer Code
;
; History:
;   21-Jan-2025 Andrew Galliard (andrewg)
;   Created.
;

       .8086

DATA   SEGMENT
MAX_CMD_LENGTH    EQU     100
PROMPT            DB      '>$'
COMMAND_BUFFER    DB      MAX_CMD_LENGTH + 2 DUP(?)  ; DOS input buffer format
EXIT_CMD          DB      'exit', 0
EXIT_MSG          DB      'Exiting the Kernel. Returning to DOS$'
DATA   ENDS

CODE   SEGMENT
       ASSUME cs:CODE, ds:DATA, ss:STACK

START:
       ; Clears the screen before START
	   mov    ax, 0600h     ; Scroll window up
	   mov    bh, 07h       ; Normal video attribute
	   mov    cx, 0000h     ; Top left corner
	   mov    dx, 184Fh     ; Bottom right corner
	   int    10h
	   
	   ; Move cursor to top left
	   mov    ah, 02h
	   mov    bh, 0
	   mov    dx, 0
	   int    10h
	   
	   ; Data Segments
	   mov    ax, SEG DATA
       mov    ds, ax

SHELL_LOOP:
       ; Display prompt
       mov    dx, OFFSET PROMPT
       mov    ah, 09h
       int    21h

       ; Read command line using DOS buffered input
       mov    dx, OFFSET COMMAND_BUFFER
       mov    BYTE PTR [COMMAND_BUFFER], MAX_CMD_LENGTH  ; Max buffer length
       mov    ah, 0Ah
       int    21h

       ; Print newline after input
       mov    dl, 13
       mov    ah, 02h
       int    21h
       mov    dl, 10
       mov    ah, 02h
       int    21h

       ; Get actual input length
       mov    si, OFFSET COMMAND_BUFFER + 1
       mov    al, [si]      ; Length of input
       cmp    al, 0
       je     SHELL_LOOP    ; Skip empty input

       ; Null-terminate input
       cbw
       mov    si, OFFSET COMMAND_BUFFER + 2
       add    si, ax
       mov    BYTE PTR [si], 0

       ; Check for 'exit' command
       mov    si, OFFSET COMMAND_BUFFER + 2
       mov    di, OFFSET EXIT_CMD
       call   STRCMP
       jz     EXIT_SHELL

       jmp    SHELL_LOOP

; String comparison routine
; SI = first string, DI = second string
; Zero flag set if strings match
STRCMP:
       push   ax
STRCMP_LOOP:
       mov    al, [si]
       mov    ah, [di]
       cmp    al, ah
       jne    STRCMP_NOTEQUAL
       cmp    al, 0
       je     STRCMP_EQUAL
       inc    si
       inc    di
       jmp    STRCMP_LOOP
STRCMP_NOTEQUAL:
       clc
       jmp    STRCMP_END
STRCMP_EQUAL:
       stc
STRCMP_END:
       pop    ax
       ret

EXIT_SHELL:	   
       ; Display exit message
       mov    dx, OFFSET EXIT_MSG
       mov    ah, 09h
       int    21h	   
	   
	   ; Print newline
       mov    dl, 13
       mov    ah, 02h
       int    21h
       mov    dl, 10
       mov    ah, 02h
       int    21h
	   
	   ; Exit to DOS
       mov    ah, 4Ch
       int    21h

CODE   ENDS

STACK  SEGMENT STACK
       DW     64 DUP(?)
STACK  ENDS

       END    START
