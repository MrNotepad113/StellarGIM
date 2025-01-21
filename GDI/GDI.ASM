       TITLE GDI.ASM
;
; Copyright (c) 2024-2025, Digital Notepad Computer Company
;
; GDI.ASM -- Graphical Device Interface Base
;
; History:
;   20-Jan-2025 Andrew Galliard (andrewg)
;   Created.
;
       .8086
DATA   segment
RECT_X1 equ    100      ; Left X coordinate
RECT_Y1 equ    50       ; Top Y coordinate
RECT_X2 equ    300      ; Right X coordinate
RECT_Y2 equ    150      ; Bottom Y coordinate
DATA   ends

CODE   segment
       assume cs:CODE, ds:DATA
START:
       mov    ax, seg DATA
       mov    ds, ax

       ; Set video mode 6 (640x200, 2 colors)
       mov    ah, 0     ; Function: Set video mode
       mov    al, 6     ; Mode 6: 640x200, B/W
       int    10h       ; Video BIOS interrupt

       ; Draw top horizontal line
       mov    cx, RECT_X1  ; Starting X
       mov    dx, RECT_Y1  ; Y coordinate
TOP_LINE:
       call   PLOT_PIXEL
       inc    cx
       cmp    cx, RECT_X2
       jle    TOP_LINE

       ; Draw bottom horizontal line
       mov    cx, RECT_X1  ; Starting X
       mov    dx, RECT_Y2  ; Y coordinate
BOTTOM_LINE:
       call   PLOT_PIXEL
       inc    cx
       cmp    cx, RECT_X2
       jle    BOTTOM_LINE

       ; Draw left vertical line
       mov    cx, RECT_X1  ; X coordinate
       mov    dx, RECT_Y1  ; Starting Y
LEFT_LINE:
       call   PLOT_PIXEL
       inc    dx
       cmp    dx, RECT_Y2
       jle    LEFT_LINE

       ; Draw right vertical line
       mov    cx, RECT_X2  ; X coordinate
       mov    dx, RECT_Y1  ; Starting Y
RIGHT_LINE:
       call   PLOT_PIXEL
       inc    dx
       cmp    dx, RECT_Y2
       jle    RIGHT_LINE

       ; Wait for key press
       mov    ah, 0
       int    16h

       ; Restore text mode
       mov    ah, 0     ; Function: Set video mode
       mov    al, 3     ; Mode 3: 80x25 text
       int    10h

       ; Exit program
       mov    ah, 4ch
       int    21h

; Subroutine to plot a pixel
; Input: CX = X coordinate, DX = Y coordinate
PLOT_PIXEL:
       push   ax
       push   bx
       push   cx
       push   dx

       mov    ah, 0Ch   ; Function: Write pixel
       mov    al, 1     ; Color (1 = white)
       mov    bh, 0     ; Page number
       int    10h       ; Video BIOS interrupt

       pop    dx
       pop    cx
       pop    bx
       pop    ax
       ret

CODE   ends

STACK  segment stack
       assume ss:STACK
       dw     64 dup(?)
STACK  ends
       end    START
	   
