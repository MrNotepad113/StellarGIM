#include <stdio.h>
#include <string.h>
#include "errors.h"

void print_error(const char *err_code) {
    if (strcmp(err_code, ERR_INVALID_CMD) == 0) {
        printf("Sys001: Command not recognized.\n");
    } else if (strcmp(err_code, ERR_MISSING_ARG) == 0) {
        printf("Sys002: Provide required argument(s).\n");
    } else if (strcmp(err_code, ERR_DIAG_FAIL) == 0) {
        printf("Sys003: Unable to complete diagnostics.\n");
    } else if (strcmp(err_code, ERR_UNKNOWN_DIAG) == 0) {
        printf("Sys004: Unsupported diagnostic sub-command.\n");
    } else if (strcmp(err_code, ERR_MISSING_FILE) == 0) {
        printf("Sys005: System File not found or missing.\n");
    } else {
        printf("Unknown error code: %s\n", err_code);
    }
}
