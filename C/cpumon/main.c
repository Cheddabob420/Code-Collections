#include <ncurses.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#define BAR_WIDTH 40

bool read_cpu(unsigned long *total, unsigned long *idle_all);

int main(void) {
  unsigned long total1, idle_all1, total2, idle_all2, total_diff, idle_diff;
  double usage;

  if (!read_cpu(&total1, &idle_all1)) {
    printf("Could not read /proc/stat\n");
    return EXIT_FAILURE;
  }

  initscr();
  curs_set(0);
  noecho(); // don't print typed keys
  timeout(1000);
  start_color();                          // turns on color mode
  use_default_colors();                   // use terminal background
  init_pair(1, COLOR_GREEN, -1);          // pair 1 = green text
  init_pair(2, COLOR_YELLOW, -1);         // pair 2 = yellow text
  init_pair(3, COLOR_RED, -1);            // pair 3 = red text
  mvprintw(0, 0, "cpumon - CPU Monitor"); // banner
  mvprintw(LINES - 1, 0, "Press q to quit");

  while (true) {
    int ch = getch(); // get the key typed and put it into ch or ERR if nothing
                      // pressed
    if (ch == 'q' || ch == 'Q') {
      break;
    }
    if (!read_cpu(&total2, &idle_all2)) {
      endwin();
      printf("Could not read /proc/stat\n");
      return EXIT_FAILURE;
    }

    total_diff = total2 - total1; // be sure to put the newer value first
    idle_diff =
        idle_all2 - idle_all1; // if ul goes neg it will wrap into a big num

    if (total_diff == 0) { // don't divide by zero
      continue;
    }

    usage =
        100.0 * (total_diff - idle_diff) /
        total_diff; // makes C do the calculation with decimals from the start
    int filled =
        (int)(usage * BAR_WIDTH / 100.0); // (int) is a cast/ turns the result
                                          // of the operation into an int
    int color;
    if (usage < 50.0) {
      color = 1;
    } else if (usage < 80.0) {
      color = 2;
    } else {
      color = 3;
    }
    attron(COLOR_PAIR(color));
    mvprintw(2, 0, "CPU: [");
    for (int i = 0; i < BAR_WIDTH; i++) {
      if (i < filled) {
        addch('#'); //  places # until i meets filled
      } else {
        addch(' '); // fills the rest with blanks
      }
    }
    printw("] %5.1f%%", usage);
    attroff(COLOR_PAIR(color));
    refresh();
    total1 = total2;       // recycle the value so
    idle_all1 = idle_all2; // we don't have to run the function again
  }
  endwin();
  return EXIT_SUCCESS;
}

bool read_cpu(unsigned long *total, unsigned long *idle_all) {
  FILE *fp =
      fopen("/proc/stat", "r"); // opens the file /proc/stat in "r" read mode
  if (fp == NULL) {
    return false;
  }
  char line[256];
  if (fgets(line, sizeof(line), fp) == NULL) {
    fclose(fp);
    return false;
  }
  fclose(fp);
  unsigned long user, nice, system, idle, iowait, irq, softirq, steal;
  // this declares the variables that we will put the numbers into
  int count = sscanf(line, "cpu %lu %lu %lu %lu %lu %lu %lu %lu", &user, &nice,
                     &system, &idle, &iowait, &irq, &softirq, &steal);
  // sscanf can be looked at like a reverse printf where we read a line and put
  // the values into the types we want
  if (count != 8) {
    return false;
  }
  *total = user + nice + system + idle + iowait + irq + softirq +
           steal;            // total of all the numbers
  *idle_all = idle + iowait; // total time cpu spent doing nothing

  return true;
}
