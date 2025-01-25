.8086
.model small
.stack 100h

DATA segment
    ; Menu items
    FILE_MENU    db 'File$'
    EDIT_MENU    db 'Edit$'
    VIEW_MENU    db 'View$'
    HELP_MENU    db 'Help$'

    ; Coordinates for menu bar
    MENU_X1      equ 0       ; Left X coordinate
    MENU_Y1      equ 0       ; Top Y coordinate
    MENU_X2      equ 639     ; Right X coordinate
    MENU_Y2      equ 10      ; Bottom Y coordinate

    ; Current menu selection
    CURRENT_MENU dw 0        ; 0=File, 1=Edit, 2=View, 3=Help
DATA ends

CODE segment
    assume cs:CODE, ds:DATA

START:
    mov ax, seg DATA
    mov ds, ax

    ; Set video mode 6 (640x200, 2 colors)
    mov ah, 0     
    mov al, 6     ; Mode 6: 640x200, B/W
    int 10h       

    ; Draw menu bar
    call DRAW_MENU_BAR

MENU_LOOP:
    ; Wait for key press
    mov ah, 0
    int 16h

    ; Check key
    cmp ah, 75    ; Left arrow
    je HANDLE_LEFT
    cmp ah, 77    ; Right arrow
    je HANDLE_RIGHT
    cmp ah, 1     ; Esc key
    jne MENU_LOOP

    ; Exit program
    jmp EXIT_PROGRAM

HANDLE_LEFT:
    dec word ptr [CURRENT_MENU]
    cmp word ptr [CURRENT_MENU], 0
    jge REDRAW_MENU
    mov word ptr [CURRENT_MENU], 3
    jmp REDRAW_MENU

HANDLE_RIGHT:
    inc word ptr [CURRENT_MENU]
    cmp word ptr [CURRENT_MENU], 3
    jle REDRAW_MENU
    mov word ptr [CURRENT_MENU], 0
    jmp REDRAW_MENU

REDRAW_MENU:
    call DRAW_MENU_BAR
    jmp MENU_LOOP

; Draw menu bar
DRAW_MENU_BAR proc near
    push ax
    push bx
    push cx
    push dx
    push si

    ; Clear menu bar area
    mov cx, MENU_X1
    mov dx, MENU_Y1
CLEAR_MENU_BAR:
    call PLOT_PIXEL
    inc cx
    cmp cx, MENU_X2
    jle CLEAR_MENU_BAR

    ; Draw menu items
    mov si, offset FILE_MENU
    mov cx, 10    ; X position
    mov dx, 2     ; Y position
    cmp word ptr [CURRENT_MENU], 0
    jne DRAW_FILE_MENU
    call DRAW_SELECTED_TEXT
    jmp DRAW_EDIT_MENU

DRAW_FILE_MENU:
    call DRAW_NORMAL_TEXT

DRAW_EDIT_MENU:
    mov si, offset EDIT_MENU
    mov cx, 100   ; X position
    mov dx, 2     ; Y position
    cmp word ptr [CURRENT_MENU], 1
    jne DRAW_EDIT_NORMAL
    call DRAW_SELECTED_TEXT
    jmp DRAW_VIEW_MENU

DRAW_EDIT_NORMAL:
    call DRAW_NORMAL_TEXT

DRAW_VIEW_MENU:
    mov si, offset VIEW_MENU
    mov cx, 190   ; X position
    mov dx, 2     ; Y position
    cmp word ptr [CURRENT_MENU], 2
    jne DRAW_VIEW_NORMAL
    call DRAW_SELECTED_TEXT
    jmp DRAW_HELP_MENU

DRAW_VIEW_NORMAL:
    call DRAW_NORMAL_TEXT

DRAW_HELP_MENU:
    mov si, offset HELP_MENU
    mov cx, 280   ; X position
    mov dx, 2     ; Y position
    cmp word ptr [CURRENT_MENU], 3
    jne DRAW_HELP_NORMAL
    call DRAW_SELECTED_TEXT
    jmp MENU_BAR_DONE

DRAW_HELP_NORMAL:
    call DRAW_NORMAL_TEXT

MENU_BAR_DONE:
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
DRAW_MENU_BAR endp

; Draw text in normal (unselected) mode
DRAW_NORMAL_TEXT proc near
    push ax
    push bx
    push cx
    push dx
DRAW_CHAR:
    lodsb
    cmp al, '$'
    je DONE_NORMAL_TEXT
    call DRAW_CHAR_PIXEL
    inc cx
    jmp DRAW_CHAR
DONE_NORMAL_TEXT:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
DRAW_NORMAL_TEXT endp

; Draw text in selected mode
DRAW_SELECTED_TEXT proc near
    push ax
    push bx
    push cx
    push dx
DRAW_SEL_CHAR:
    lodsb
    cmp al, '$'
    je DONE_SELECTED_TEXT
    call DRAW_INVERTED_CHAR_PIXEL
    inc cx
    jmp DRAW_SEL_CHAR
DONE_SELECTED_TEXT:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
DRAW_SELECTED_TEXT endp

; Draw character pixel by pixel
DRAW_CHAR_PIXEL:
    push ax
    push cx
    push dx
    mov dx, 0     ; Top row of character
CHAR_ROW:
    push cx
    mov bx, 8     ; 8 bits per character row
CHAR_BIT:
    shl al, 1     ; Shift to check bit
    jnc SKIP_PIXEL
    call PLOT_PIXEL
SKIP_PIXEL:
    inc cx
    dec bx
    jnz CHAR_BIT
    pop cx
    inc dx
    cmp dx, 8     ; 8 rows per character
    jl CHAR_ROW
    pop dx
    pop cx
    pop ax
    ret

; Draw inverted character pixel by pixel
DRAW_INVERTED_CHAR_PIXEL:
    push ax
    push cx
    push dx
    mov dx, 0     ; Top row of character
INVERTED_CHAR_ROW:
    push cx
    mov bx, 8     ; 8 bits per character row
INVERTED_CHAR_BIT:
    shl al, 1     ; Shift to check bit
    jc SKIP_INVERTED_PIXEL
    call PLOT_PIXEL
SKIP_INVERTED_PIXEL:
    inc cx
    dec bx
    jnz INVERTED_CHAR_BIT
    pop cx
    inc dx
    cmp dx, 8     ; 8 rows per character
    jl INVERTED_CHAR_ROW
    pop dx
    pop cx
    pop ax
    ret

; Plot a pixel
; Input: CX = X coordinate, DX = Y coordinate
PLOT_PIXEL:
    push ax
    push bx
    push cx
    push dx
    mov ah, 0Ch   ; Function: Write pixel
    mov al, 1     ; Color (1 = white)
    mov bh, 0     ; Page number
    int 10h       ; Video BIOS interrupt
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; Exit program
EXIT_PROGRAM:
    ; Restore text mode
    mov ah, 0
    mov al, 3     ; Mode 3: 80x25 text
    int 10h

    mov ah, 4Ch
    int 21h

CODE ends
end START