#pragma once
#ifdef AUDIO_ENABLE
    #define STARTUP_SONG SONG(PLANCK_SOUND)
    // #define STARTUP_SONG SONG(NO_SOUND)

    #define DEFAULT_LAYER_SONGS { SONG(QWERTY_SOUND) }
#endif

// Configurar modo constante de mouse keys
// #define MK_3_SPEED
// #define MK_MOMENTARY_ACCEL