// errors.h
#ifndef ERRORS_H
#define ERRORS_H

// Error codes
#define ERR_INVALID_CMD "Sys021"
#define ERR_MISSING_ARG "Sys022"
#define ERR_DIAG_FAIL   "Sys023"
#define ERR_UNKNOWN_DIAG "Sys024"

// Function prototype
void print_error(const char *err_code);

#endif // ERRORS_H
