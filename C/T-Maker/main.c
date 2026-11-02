#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>

#define MAKEFILE "Makefile"
#define MAINFILE "main.c"

int main(int argc, char *args[]) {
  char *pname = NULL;
  char makepath[256];
  char mainpath[256];
  if (argc < 2) {
    fprintf(stderr, "Error: Need Name Argument\nUsage: %s <projectName>\n",
            args[0]);
    return EXIT_FAILURE;
  }

  pname = args[1];
  if (mkdir(pname, 0755) != 0) {
    if (errno == EEXIST) {
      fprintf(stderr, "Project Directory Already Exists!\nExiting...\n");
      return EXIT_FAILURE;
    }
    perror("mkdir");
    return EXIT_FAILURE;
  }
  printf("Creating Files\n");
  snprintf(makepath, sizeof(makepath), "%s/%s", pname, MAKEFILE);
  snprintf(mainpath, sizeof(mainpath), "%s/%s", pname, MAINFILE);
  FILE *makef = fopen(makepath, "w");
  if (makef == NULL) {
    perror("fopen");
    fprintf(stderr,
            "Warning!! Directory %s was created! Do with that as you want...\n",
            pname);
    return EXIT_FAILURE;
  }
  fputs("main: main.c\n", makef);
  fputs("\tgcc -Wall -Wextra main.c -o main\n\n", makef);
  fputs("run: main\n", makef);
  fputs("\t./main\n\n", makef);
  fputs(".PHONY: run\n", makef);
  fclose(makef);

  FILE *mainf = fopen(mainpath, "w");
  if (mainf == NULL) {
    perror("fopen");
    fprintf(stderr,
            "Warning!! Directory %s was created as well as %s! Do with that "
            "as you want...\n",
            pname, makepath);
    return EXIT_FAILURE;
  }
  fputs("#include <stdlib.h>\n", mainf);
  fputs("#include <stdio.h>\n", mainf);
  fputs("\n\nint main(void) {\n", mainf);
  fputs("\n\tprintf(\"Testing\\n\");\n", mainf);
  fputs("\treturn EXIT_SUCCESS;\n", mainf);
  fputs("}\n", mainf);
  fclose(mainf);
  printf("\nProject %s Created!\n", pname);

  return EXIT_SUCCESS;
}
