#pragma once
#include "audio_songs.h"

// Config initial and final sound
#ifdef AUDIO_ENABLE
    #define STARTUP_SONG SONG(STILL_DRE_CUSTOM)
    #define GOODBYE_SONG SONG(STILL_DRE_CUSTOM) // Reset key
    #define MUSIC_OFF_SONG SONG(NO_SOUND)
    #define MUSIC_ON_SONG SONG(ZELDA_PUZZLE_CUSTOM)
#endif

// Config mouse constant mode
#define MOUSEKEY_INTERVAL 16
#define MOUSEKEY_DELAY 0
#define MOUSEKEY_TIME_TO_MAX 60
#define MOUSEKEY_MAX_SPEED 7
#define MOUSEKEY_WHEEL_DELAY 0