TITLE GDI.ASM
;
; Copyright (c) 2024-2025, Digital Notepad Computer Company
;
; GDI.ASM -- Graphical Device Interface Base with Text Rendering
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
HELLO_MSG db   'Hello World!', 0
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

       ; Draw rectangle
       call   DRAW_RECTANGLE

       ; Display text inside rectangle using pixel-based rendering
       mov    cx, 180   ; X position (pixel coordinates)
       mov    dx, 100   ; Y position (pixel coordinates)
       call   DRAW_TEXT_PIXEL

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

; Subroutine to draw rectangle
DRAW_RECTANGLE:
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
       ret

; Subroutine to draw text using pixel-based character rendering
; Input: CX = X position (pixels), DX = Y position (pixels)
DRAW_TEXT_PIXEL:
       push   si
       push   bx
       push   ax
       push   cx
       push   dx
       
       mov    si, offset HELLO_MSG
       
TEXT_LOOP:
       mov    al, [si]  ; Get character
       cmp    al, 0     ; Check for null terminator
       je     TEXT_DONE
       
       ; Draw character using pixels
       call   DRAW_CHAR
       
       inc    si        ; Next character
       add    cx, 8     ; Move 8 pixels right for next character
       jmp    TEXT_LOOP
       
TEXT_DONE:
       pop    dx
       pop    cx
       pop    ax
       pop    bx
       pop    si
       ret

; Subroutine to draw a single character (simplified)
; Input: AL = character, CX = X position, DX = Y position
DRAW_CHAR:
       push   si
       push   cx
       push   dx
       push   ax
       
       ; Simple implementation: just draw the character code as pixels
       ; For a real font, you'd use a font table lookup
       mov    ah, 0Ch   ; Write pixel
       mov    bh, 0     ; Page 0
       mov    bl, al    ; Use character value for some pattern
       
       ; Draw a simple 8x8 pattern representing the character
       mov    al, 1     ; White color
       int    10h       ; Draw center pixel
       
       inc    cx
       int    10h       ; Draw another pixel
       
       inc    dx
       int    10h       ; Draw pixel below
       
       dec    cx
       int    10h       ; Draw pixel to left
       
       pop    ax
       pop    dx
       pop    cx
       pop    si
       ret

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
	   
