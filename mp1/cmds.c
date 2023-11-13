/******************************************************************
*
*   file:     cmds.c
*   author:   betty o'neil
*   date:     Sep 23, 2023
*
*   semantic actions for commands called by tutor (cs341, mp1)
*
*   revisions:
*      9/90  eb   cleanup, convert function declarations to ansi
*      9/91  eb   changes so that this can be used for hw1
*      9/02  re   minor changes to quit command
*/
/* the Makefile arranges that #include <..> searches in the right
   places for these headers-- 200920*/

#include <stdio.h>
#include "slex.h"
/*===================================================================*
*
*   Command table for tutor program -- an array of structures of type
*   cmd -- for each command provide the token, the function to call when
*   that token is found, and the help message.
*
*   slex.h contains the typdef for struct cmd, and declares the
*   cmds array as extern to all the other parts of the program.
*   Code in slex.c parses user input command line and calls the
*   requested semantic action, passing a pointer to the cmd struct
*   and any arguments the user may have entered.
*
*===================================================================*/

PROTOTYPE int stop(Cmd *cp, char *arguments);
PROTOTYPE int mem_display(Cmd *cp, char *arguments);
PROTOTYPE int mem_set(Cmd *cp, char *arguments);
PROTOTYPE int help_command(Cmd *cp, char *arguments);

/* command table */

Cmd cmds[] = {{"md",  mem_display, "Memory display: MD <addr>"},
              {"ms", mem_set, "Memory set: MS <addr> <value>"},
              {"h", help_command, "Help: H <command>"},
              {"s",   stop,        "Stop" },
              {NULL,  NULL,        NULL}};  /* null cmd to flag end of table */

char xyz = 6;  /* test global variable  */
char *pxyz = &xyz;  /* test pointer to xyz */
/*===================================================================*
*		command			routines
*
*   Each command routine is called with 2 args, the remaining
*   part of the line to parse and a pointer to the struct cmd for this
*   command. Each returns 0 for continue or 1 for all-done.
*
*===================================================================*/

int stop(Cmd *cp, char *arguments)
{
  return 1;			/* all done flag */
}

/*===================================================================*
*
*   mem_display: display contents of 16 bytes in hex
*
*/


int mem_display(Cmd *cp, char *arguments)
{
  unsigned int addr;

  if (sscanf(arguments, "%x", &addr) != 1) {
    // If parsing the address fails, print diagnostic information
      printf("Reached mem_display, passed argument string: |%s|\n", arguments);
      printf("        help message: %s\n", cp->help);
  }
  
  // Attempt to parse the hexadecimal address from the arguments string
  // Print the formatted address
  printf("%08X ", addr);
  // Loop through 16 bytes of memory and print their hexadecimal values
  // addr + i allows you to increment addr by i
  for (int i = 0; i < 16; i++) {
      printf("%02X ", *((unsigned char *)(addr + i)));
  }
  // Loop through the byte to print out the characters.
  for (int j = 0; j < 16; j++) {
      unsigned char byte = *((unsigned char *)(addr + j));
      // Check if the byte is a printable ASCII character
      if (byte >= 0x20 && byte <= 0x7E) {
          // Print the ASCII character
          printf("%c", byte);
      } else {
          // Print a '.' for non-printable characters
          printf(".");
      }
  }
  // Print a newline character to end the line
  printf("\n");

  // Return 0 to indicate the function has completed
  return 0;	// not done
}

int mem_set(Cmd *cp, char *arguments) {
    unsigned int addr, value;

    // Use sscanf to convert the arguments to integers
    if (sscanf(arguments, "%x %x", &addr, &value) == 2) {
        // Set the memory at the given address to the specified value.
        *(unsigned char *)addr = value;
        printf("Set memory at address %08X to value %02X\n", addr, value);
    } else {
        printf("Invalid arguments for ms: %s\n", arguments);
        printf("        help message: %s\n", cp->help);
    }

    return 0; // Not done
}

int help_command(Cmd *cp, char *arguments) 
{
  int status, cmd_index, pos;

  // Reuse code that matches a command token 
  // it is to check if the argument is valid.
  status = slex(arguments, cmds, &cmd_index, &pos);

  if (status < 0) {  // If no command token found in args
    printf("     cmd    help message\n");
    printf("     ---    ------------\n");

    // Loop through the list of commands and print their help messages
    for (cp = cmds; cp->cmdtoken; cp++) {
      printf("%8s    %s\n", cp->cmdtoken, cp->help);
    }
  } else {  // Found a command token, just print that one's help message
    printf("%s\n", cmds[cmd_index].help);
    return 0;
  }
  return 0;
}