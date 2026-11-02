/*
 * happy_anniversary.c
 * For my husband, on 10/27/2026.
 * 16 years together. 8 years married.
 *
 * Compile:  gcc happy_anniversary.c -o happy_anniversary
 * Run:      ./happy_anniversary
 */

#include <stdio.h>
#include <string.h>
#include <ctype.h>

#ifdef _WIN32
#include <windows.h>
#define pause_ms(ms) Sleep(ms)
#else
#include <unistd.h>
#define pause_ms(ms) usleep((ms) * 1000)
#endif

#define TYPE_SPEED   45   /* ms per letter */
#define LINE_WIDTH   64   /* wrap long lines so they fit any terminal */

#define RED     "\033[1;31m"
#define PINK    "\033[1;35m"
#define DIM     "\033[2m"
#define RESET   "\033[0m"
#define CLEAR   "\033[2J\033[H"

#define HEART_ROWS 25
#define HEART_COLS 49

/* let Windows terminals understand colors too */
static void enable_colors(void) {
#ifdef _WIN32
    HANDLE h = GetStdHandle(STD_OUTPUT_HANDLE);
    DWORD mode = 0;
    if (GetConsoleMode(h, &mode))
        SetConsoleMode(h, mode | 0x0004 /* ENABLE_VIRTUAL_TERMINAL_PROCESSING */);
#endif
}

/* types text one letter at a time, no newline */
static void type_raw(const char *text) {
    for (const char *c = text; *c; c++) {
        putchar(*c);
        fflush(stdout);
        pause_ms(TYPE_SPEED);
    }
}

/* oops. backspace like a real person */
static void backspace(int n) {
    for (int i = 0; i < n; i++) {
        printf("\b \b");
        fflush(stdout);
        pause_ms(120);
    }
}

/* types a paragraph one letter at a time, wrapping at word breaks */
static void type_out(const char *text) {
    int col = 0;
    const char *p = text;

    while (*p) {
        const char *end = p;
        while (*end && *end != ' ') end++;
        int word_len = (int)(end - p);

        if (col > 0 && col + word_len > LINE_WIDTH) {
            putchar('\n');
            col = 0;
        }
        for (const char *c = p; c < end; c++) {
            putchar(*c);
            fflush(stdout);
            pause_ms(TYPE_SPEED);
            col++;
        }
        if (*end == ' ') {
            if (col > 0) { putchar(' '); col++; }
            end++;
        }
        p = end;
    }
    putchar('\n');
    pause_ms(900);
}

/* Loading 16 years of memories... */
static void loading_bar(void) {
    const int width = 32;
    printf(DIM "Loading 16 years of memories...\n" RESET);
    for (int i = 0; i <= width; i++) {
        printf("\r[");
        for (int j = 0; j < width; j++)
            printf(j < i ? PINK "#" RESET : " ");
        printf("] %3d%%", i * 100 / width);
        fflush(stdout);
        pause_ms(i < width - 3 ? 70 : 350);   /* the last bit takes its time */
    }
    printf("\n" DIM "Done. 0 errors. 0 regrets." RESET "\n\n");
    pause_ms(1200);
}

/* is this spot inside the heart? (the classic heart curve)
   scale < 1.0 makes it smaller, which is how it beats */
static int in_heart(int r, int c, double scale) {
    double y = (1.3 - 0.1 * r) / scale;
    double x = (-1.2 + 0.05 * c) / scale;
    double a = x * x + y * y - 1.0;
    return a * a * a - x * x * y * y * y <= 0.0;
}

/* each spot always gets the same letter, so the words stay put
   while the heart grows and shrinks around them */
static char heart_letter(int r, int c) {
    return "ILOVEYOU"[(r * HEART_COLS + c) % 8];
}

/* build one whole frame first, then show it all at once (no flicker) */
static void show_heart_frame(double scale) {
    static char frame[HEART_ROWS * (HEART_COLS + 1) + 1];
    int n = 0;
    for (int r = 0; r < HEART_ROWS; r++) {
        for (int c = 0; c < HEART_COLS; c++)
            frame[n++] = in_heart(r, c, scale) ? heart_letter(r, c) : ' ';
        frame[n++] = '\n';
    }
    frame[n] = '\0';

    printf("\033[%dA" RED "%s" RESET, HEART_ROWS, frame);  /* jump up, redraw */
    fflush(stdout);
}

static void beating_heart(void) {
    printf("\033[?25l");   /* hide the blinking cursor while it animates */

    /* first, draw it in slowly, row by row */
    printf(RED);
    for (int r = 0; r < HEART_ROWS; r++) {
        for (int c = 0; c < HEART_COLS; c++)
            putchar(in_heart(r, c, 1.0) ? heart_letter(r, c) : ' ');
        putchar('\n');
        fflush(stdout);
        pause_ms(90);
    }
    printf(RESET);
    pause_ms(700);

    /* then let it beat, smoothly: ba-dum ... ba-dum ... ba-dum */
    const double squeeze[] = { 0.96, 0.92, 0.89, 0.92, 0.96, 1.0 };
    const int steps = sizeof squeeze / sizeof squeeze[0];

    for (int beat = 0; beat < 3; beat++) {
        for (int thump = 0; thump < 2; thump++) {          /* ba ... dum */
            for (int s = 0; s < steps; s++) {
                show_heart_frame(squeeze[s]);
                pause_ms(35);
            }
            pause_ms(thump == 0 ? 90 : 650);
        }
    }

    printf("\033[?25h");   /* bring the cursor back */
}

/* the only correct answer is yes */
static void movie_night(void) {
    char answer[64];

    for (;;) {
        printf("\n");
        type_raw("Movie night tonight? Phones off. (y/n) ");
        if (!fgets(answer, sizeof answer, stdin))
            return;

        char *a = answer;
        while (isspace((unsigned char)*a)) a++;

        if (tolower((unsigned char)*a) == 'y') {
            printf("\n");
            type_raw("Best answer ever. It's a date.");
            printf("\n");
            pause_ms(500);
            type_raw("Fair warning: we probably won't finish the movie. ;)");
            printf("\n\n");
            return;
        }
        type_raw("Wrong answer. Try again.");
        printf("\n");
        pause_ms(500);
    }
}

int main(void) {
    enable_colors();

    printf(CLEAR);
    printf("\n" PINK "  Happy Anniversary  " RESET "\n\n");
    printf(DIM "  Press Enter to begin..." RESET);
    fflush(stdout);
    getchar();

    printf(CLEAR "\n");
    loading_bar();

    printf(RED);
    type_out("Hey Love,");
    printf(RESET "\n");

    const char *letter[] = {
        "We made it 16 years together. 8 years ago I vowed to always "
        "support you and never leave your side, and I still mean every "
        "word. Through the good and the bad, I'm staying right here.",

        "At 17, I couldn't get enough of you. We spent every day together "
        "and never got tired of each other. Sixteen years later, I still "
        "love watching the way you light up when one of your ideas or "
        "projects comes together, even when it's not finished yet. It's "
        "one of my favorite things about you. Right up there with what an "
        "amazing dad you are.",

        "This year has been a hard one. I feel like somewhere along the way "
        "we drifted into our own corners. I miss us. I miss curling up "
        "together to watch a movie we never actually finish. ;)",

        "So I hope we can have more talking, more laughing, and more "
        "unfinished movies. We've built a whole life together, and I would "
        "build it all over again with you."
    };
    int count = sizeof letter / sizeof letter[0];

    for (int i = 0; i < count; i++) {
        type_out(letter[i]);
        putchar('\n');
    }

    /* the typo that fixes itself */
    type_raw("I like");
    pause_ms(900);
    backspace(4);
    pause_ms(300);
    type_raw("love you. We're in this together, always.");
    printf("\n\n");
    pause_ms(1000);

    beating_heart();
    putchar('\n');

    type_raw("Love,");
    printf("\n");
    pause_ms(400);
    printf(RED);
    type_raw("Mandi");
    printf(RESET "\n");
    pause_ms(1200);

    movie_night();

    return 0; /* no errors. just us. */
}
