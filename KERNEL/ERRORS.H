// errors.h
#ifndef ERRORS_H
#define ERRORS_H

// Error codes
#define ERR_INVALID_CMD "Sys001"
#define ERR_MISSING_ARG "Sys002"
#define ERR_DIAG_FAIL   "Sys003"
#define ERR_UNKNOWN_DIAG "Sys004"
#define ERR_MISSING_FILE "Sys005"

// Function prototype
void print_error(const char *err_code);

#endif // ERRORS_H
