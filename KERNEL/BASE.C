#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MAX_CMD_LENGTH 100

int main() {
    char command[MAX_CMD_LENGTH];
    char *args[10];
    int i;

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
        } else if (strcmp(args[0], "exit") == 0) {
            break;
        }
    }
    return 0;
}