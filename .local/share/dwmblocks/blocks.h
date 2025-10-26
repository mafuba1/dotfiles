#ifndef BLOCKS_H
#define BLOCKS_H

static const Block blocks[] = {
    {"", "~/.local/bin/playing", 0, 2},
    {"", "~/.local/bin/keyboard.sh", 0, 1},
    {"", "~/.local/bin/datetime.sh", 30, 0},
    {"", "~/.local/bin/battery.sh 1", 30, 0},
    {"", "~/.local/bin/battery.sh 0", 30, 0},
};

static char delim[] = " | ";
static unsigned int delimLen = 5;

#endif // BLOCKS_H

