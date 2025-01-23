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

DATA   segment
STRING db     "Hello, World!", 13, 10, "$"
DATA   ends

CODE   segment
       assume cs:CODE, ds:DATA
START:
       mov    ax, seg DATA
	   mov    ds, ax
	   mov    dx, offset STRING
	   mov    ah, 9
	   int    21h
	   mov    ah, 4Ch
	   int    21h
CODE   ends

STACK  segment stack
       assume ss:STACK
	   dw     64 dup(?)
STACK  ends
	   
	   end    START

