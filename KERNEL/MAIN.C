#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "errors.h"
#include <version.h>
#include <dos.h>

#define MAX_CMD_LENGTH 100

// Function prototypes
void show_help();
void greet_user(const char *name);
void exit_program();
void show_version();
void run_diagnostics();
void check_cpu();
void clear_screen();
void launch_gdi();

int main() {
    char command[MAX_CMD_LENGTH];
    char *args[10];
    int i;

	clear_screen();
    printf("Digital Notepad Computer Company (R) Stellar Graphical Interface Manager (R)\n");
    printf("Version %s : Pre-Alpha Release 1\n", VER_PRODUCTVERSION_STR);
    printf("INTERNAL DEVELOPER PREVIEW - UNAUTHORIZED USE IS NOT PERMITED\n");
    printf("Copyright (c) DNC Company. 2024-2025. All rights reserved.\n");

    while (1) {
        printf(">");
        fgets(command, MAX_CMD_LENGTH, stdin);
        command[strcspn(command, "\n")] = 0;

        i = 0;
        args[i] = strtok(command, " ");
        while (args[i] != NULL) {
            i++;
            args[i] = strtok(NULL, " ");
        }

        if (args[0] == NULL) {
            continue;
        } else if (strcmp(args[0], "help") == 0) {
            show_help();
        } else if (strcmp(args[0], "greet") == 0 && i > 1) {
            greet_user(args[1]);
        } else if (strcmp(args[0], "exit") == 0) {
            exit_program();
        } else if (strcmp(args[0], "ver") == 0) {
            show_version();
        } else if (strcmp(args[0], "diag") == 0) {
            run_diagnostics();
        } else if (strcmp(args[0], "gditst") == 0) {
            launch_gdi();
        } else {
            print_error(ERR_INVALID_CMD);
        }
    }

    return 0;
}

void show_help() {
    printf("Available commands:\n");
    printf("  help         - Show this help message\n");
    printf("  ver          - Shows the StellarGIM version\n");
    printf("  greet <name> - Greet the user with their name\n");
    printf("  exit         - Exit the CLI\n");
    printf("  diag         - Run system diagnostics\n");
	printf("  gditst       - Test and check the GDI.EXE\n");
}

void show_version() {
    printf("Version %s (Build %d: Pre-Alpha Release 1)\n", 
           VERSION, 
           VER_PRODUCTBUILD);
}

void greet_user(const char *name) {
    printf("Hello, %s!\n", name);
}

void exit_program() {
    printf("Exiting the Kernel. Returning to DOS\n");
    exit(0);
}

void run_diagnostics() {
    printf("Running system diagnostics...\n");
    print_error(ERR_DIAG_FAIL);
}

void check_cpu() {
    printf("Checking CPU type...\n");
	print_error(ERR_DIAG_FAIL);
    printf("Unknown or unsupported CPU detected.\n");
}

void clear_screen() {
    union REGS regs;

    // Clear screen using scroll window up (int 10h, function 06h)
    regs.h.ah = 0x06;     // Function: Scroll up
    regs.h.al = 0x00;     // Clear entire screen
    regs.h.bh = 0x07;     // Attribute: Normal video
    regs.x.cx = 0x0000;   // Top-left corner
    regs.x.dx = 0x184F;   // Bottom-right corner (80x25 screen)
    int86(0x10, &regs, &regs);

    // Move cursor to top-left (int 10h, function 02h)
    regs.h.ah = 0x02;     // Function: Set cursor position
    regs.h.bh = 0x00;     // Page number
    regs.h.dh = 0x00;     // Row
    regs.h.dl = 0x00;     // Column
    int86(0x10, &regs, &regs);
}

void launch_gdi() {
	union REGS regs;
    printf("Launching Graphical Display Interface...\n");
        
    // Prepare for DOS EXEC function (4Bh)
    regs.h.ah = 0x4B;    // EXEC function
    regs.h.al = 0x00;    // Load and execute
    regs.x.dx = (unsigned int)"GDI.EXE";  // Filename
    regs.x.bx = (unsigned int)"";         // Command line (empty)
    
    int86(0x21, &regs, &regs);
    
    // Check carry flag for error
    if (regs.x.cflag) {
        print_error(ERR_MISSING_FILE);
    }
}