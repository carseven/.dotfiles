#include QMK_KEYBOARD_H
#include "keymap_spanish.h"

enum planck_layers {
  _QWERTY,
  _LOWER,
  _RAISE,
  _MOV,
  _ADJUST,
  _MAC
};

enum planck_keycodes {
  QWERTY = SAFE_RANGE
};

// Mod keys
#define SPCMOV LT(_MOV, KC_SPC) // Hold to move to layer MOV. Un tap es el space.
#define TABMEH MEH_T(KC_TAB) // Hold=MEH and Tap=TAB
#define DEL_MAC LT(_MAC, KC_DEL) // Hold=MEH and tap=Del
#define LOWER MO(_LOWER)
#define RAISE MO(_RAISE)
#define HYP_ESC HYPR_T(KC_ESC) // Hold=Hyper and Tap=ESC
#define SHIFT_CAPS LSFT_T(KC_CAPSLOCK) // Hold=Shift and tap=Toggle CAPLOCKS
#define SHIFT_ENTER SFT_T(KC_ENT) // Hold=Shift and tap Enter

// macos
#define SEL_LEFT LALT(LSFT(KC_LEFT))
#define SEL_RIGHT LALT(LSFT(KC_RIGHT))

// Navegador
#define KC_BACK LGUI(KC_LEFT) // Browser Backward
#define KC_FORW LGUI(KC_RIGHT) // Browser Forward
#define KC_PTAB LCTL(LSFT(KC_TAB)) // Browser tab backward
#define KC_NTAB RCTL(KC_TAB) // Browser tab Forward

// Capturas de pantalla
#define KC_CAPW LGUI(LSFT(KC_2)) // Capture whole screen
#define KC_CAPA LGUI(LSFT(KC_3)) // Capture active window
#define KC_CAPP LGUI(LSFT(KC_4)) // Capture portion of screen

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {

/* Qwerty
 * ,-----------------------------------------------------------------------------------.
 * |TabMeh|   Q  |   W  |   E  |   R  |   T  |   Y  |   U  |   I  |   O  |   P  | Bksp |
 * |------+------+------+------+------+------+------+------+------+------+------+------|
 * |EscHyp|   A  |   S  |   D  |   F  |   G  |   H  |   J  |   K  |   L  |   ;  |  "   |
 * |------+------+------+------+------+------+------+------+------+------+------+------|
 * | Shift|   Z  |   X  |   C  |   V  |   B  |   N  |   M  |   ,  |   .  |   /  |Enter |
 * |------+------+------+------+------+------+------+------+------+------+------+------|
 * | Del  | Ctrl | Alt  | GUI  |Lower |Space | Space| Raise| Left | Down |  Up  |Right |
 * `-----------------------------------------------------------------------------------'
 */
[_QWERTY] = LAYOUT_planck_grid(
  TABMEH,    KC_Q,    KC_W,    KC_E,    KC_R,    KC_T,    KC_Y,    KC_U,    KC_I,    KC_O,    KC_P,    KC_BSPC,
  HYP_ESC,   KC_A,    KC_S,    KC_D,    KC_F,    KC_G,    KC_H,    KC_J,    KC_K,    KC_L,    ES_SCLN, ES_QUOT,
  SHIFT_CAPS,KC_Z,    KC_X,    KC_C,    KC_V,    KC_B,    KC_N,    KC_M,    ES_COMM, ES_DOT,  ES_SLSH, SHIFT_ENTER,
  DEL_MAC,   KC_LCTL, KC_LALT, KC_LGUI, LOWER,   SPCMOV,  SPCMOV,  RAISE,   KC_LEFT, KC_DOWN, KC_UP,   KC_RGHT
),

/* Lower layer: number row replacement & F keys
 * ,-----------------------------------------------------------------------------------------------------------------------.
 * |         |   F1    |   F2    |   F3    |   F4    |   F5    |   F6    |   F7    |   F8    |   F9    |   F10   |   Bksp  |
 * |---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+---------|
 * |         |    1    |    2    |    3    |    4    |    5    |    6    |    7    |    8    |    9    |    0    |         |
 * |---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+---------|
 * |         |    -    |    +    |    *    |    =    |         |    Ñ    |    ´    |         |    ¡    |    ¿    |         |
 * |---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+---------|
 * |         |         |         |         |  ***    |         |         |         | PrevTAB | BrowserB| BrowserF| NextTAB |
 * `-----------------------------------------------------------------------------------------------------------------------'
 */
[_LOWER] = LAYOUT_planck_grid(
    _______,  KC_F1,     KC_F2,     KC_F3,    KC_F4,    KC_F5,    KC_F6,    KC_F7,   KC_F8,    KC_F9,    KC_F10, KC_BSPC,
    _______,  KC_1,       KC_2,      KC_3,     KC_4,     KC_5,     KC_6,     KC_7,     KC_8,     KC_9,     KC_0,  _______,
    _______,  ES_MINS,  ES_PLUS,  ES_ASTR,   ES_EQL,  XXXXXXX,  ES_NTIL,  ES_ACUT,  _______,  _______,  ES_IQUE,  _______,
    _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  KC_PTAB,  KC_BACK,  KC_FORW,  KC_NTAB
),

/* Raise layer: shifted versions of number layer & extended F keys
 * ,-----------------------------------------------------------------------------------------------------------------------.
 * |         |   F11   |   F12   |   F13   |   F14   |   F15   |   F16   |   F17   |   F18   |    [    |    ]    |  Bksp   |
 * |---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+---------|
 * |         |    !    |    @    |    #    |    $    |    %    |    ^    |    &    |    |    |    (    |    )    |         |
 * |---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+---------|
 * |         |    -    |    +    |    *    |    =    |    `    |    \    |    _    |    ~    |    {    |    }    |         |
 * |---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+---------|
 * |         |         |         |         |         |         |         |  ***    |         |         |         |         |
 * `-----------------------------------------------------------------------------------------------------------------------'
 */
[_RAISE] = LAYOUT_planck_grid(
    _______,   KC_F11,   KC_F12,    KC_F13,   KC_F14,   KC_F15,   KC_F16,   KC_F17,   KC_F18,  ES_LBRC,  ES_RBRC,  KC_BSPC,
    _______,  ES_EXLM,    ES_AT,   ES_HASH,   ES_DLR,  ES_PERC,  ES_CIRC,  ES_AMPR,  ES_PIPE,  ES_LPRN,  ES_RPRN,  _______,
    _______,  ES_MINS,    ES_PLUS, ES_ASTR,   ES_EQL,   ES_GRV,  ES_BSLS,  ES_UNDS,  ES_TILD,  ES_LCBR,  ES_RCBR,  _______,
    KC_DEL ,  _______,  _______,  _______,  _______,  _______,   _______,  _______,  _______,  _______,  _______,  _______
),

/* Mac
 * ,-----------------------------------------------------------------------------------------------------------------------.
 * |         |         |         |         |         |         |         |         |         |         |         |         |
 * |---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+---------|
 * |         |         |         |         |         |         |         |         |         |         |         |         |
 * |---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+---------|
 * |         |         |         |         |         |         |         |         |         |         |         |         |
 * |---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+---------|
 * |   ***   |         |         |         |         |         |         |         |         |         |         |         |
 * `-----------------------------------------------------------------------------------------------------------------------'
 */
[_MAC] = LAYOUT_planck_grid(
    _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,
    _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,
    _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  KC_GRV,   KC_TILD,  _______,  _______,
    _______ , _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______
),

/* MOV
* ,-----------------------------------------------------------------------------------.
* |      |  M1  | MOUSU|  M2  |sc UP |      |      | Home | PgDW | PgUp |  End | Bksp |
* |------+------+------+------+------+-------------+------+------+------+------+------|
* |      | MOUSL| MOUSD| MOUSR|scDown|      |      | Left | Down |  Up  |Right |      |
* |------+------+------+------+------+------|------+------+------+------+------+------|
* |      | sc <-|      |sc -> |      |      |      |  SEL |      |      |  SEL |      |
* |------+------+------+------+------+------+------+------+------+------+------+------|
* |      |      |      |      |      |  *** | ***  |      |      |      |      |      |
* `-----------------------------------------------------------------------------------'
*
*/
[_MOV] = LAYOUT_planck_grid(  
  XXXXXXX    , XXXXXXX , KC_BTN1       , KC_MS_U , KC_BTN2        , KC_MS_WH_UP   , XXXXXXX , KC_HOME , KC_PGDN , KC_PGUP , KC_END   , KC_BSPC ,
  XXXXXXX    , XXXXXXX , KC_MS_L       , KC_MS_D , KC_MS_R        , KC_MS_WH_DOWN , XXXXXXX , KC_LEFT , KC_DOWN , KC_UP   , KC_RGHT  , XXXXXXX ,
  SHIFT_CAPS , XXXXXXX , KC_MS_WH_LEFT , XXXXXXX , KC_MS_WH_RIGHT , XXXXXXX       , XXXXXXX , SEL_LEFT, XXXXXXX , XXXXXXX , SEL_RIGHT, XXXXXXX ,
  XXXXXXX    , XXXXXXX , XXXXXXX       , XXXXXXX , XXXXXXX        , XXXXXXX       , XXXXXXX , XXXXXXX , XXXXXXX , XXXXXXX , XXXXXXX  , XXXXXXX
),

/* Adjust (Lower + Raise)
* ,-----------------------------------------------------------------------------------.
* | Reset|      |      |      |      |      |      | Vol- | Mute | Vol+ |Screen|togAUD|
* |------+------+------+------+------+-------------+------+------+------+------+------|
* |      |      |      | Wake | Sleep|      |      | <<   | Play |  >>  |Screen|togRGB|
* |------+------+------+------+------+------|------+------+------+------+------+------|
* |      |      |      |      |      |      |      | Bri- |      | Bri+ |Screen|      |
* |------+------+------+------+------+------+------+------+------+------+------+------|
* |PowerD|      |      |      | **** |      |      | **** |      |      |      |      |
* `-----------------------------------------------------------------------------------'
*/
[_ADJUST] = LAYOUT_planck_grid(
  RESET   , XXXXXXX , XXXXXXX , XXXXXXX , XXXXXXX , XXXXXXX, XXXXXXX , KC_VOLD, KC_MUTE, KC_VOLU, KC_CAPP, AU_TOG,
  XXXXXXX , XXXXXXX , XXXXXXX , KC_WAKE , KC_SLEP , XXXXXXX, XXXXXXX , KC_MRWD, KC_MPLY, KC_MFFD, KC_CAPA, RGB_TOG,
  XXXXXXX , XXXXXXX , XXXXXXX , XXXXXXX , XXXXXXX , XXXXXXX, XXXXXXX , KC_BRID, XXXXXXX, KC_BRIU, KC_CAPW, XXXXXXX,
  KC_PWR  , XXXXXXX , XXXXXXX , XXXXXXX , XXXXXXX , XXXXXXX, XXXXXXX , XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX
)

};

layer_state_t layer_state_set_user(layer_state_t state) {
  return update_tri_layer_state(state, _LOWER, _RAISE, _ADJUST);
}

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
  switch (keycode) {
    case QWERTY:
      if (record->event.pressed) {
        set_single_persistent_default_layer(_QWERTY);
      }
      return false;
      break;
  }
  return true;
}

// Feature DOC https://github.com/JonasGessner/qmk_firmware/blob/key-overrides/docs/feature_key_overrides.md
// Replicated ANSI shifted keys in ISO spanish

// This globally defines all key overrides to be used
const key_override_t **key_overrides = (const key_override_t *[]){
	&ko_make_basic(MOD_MASK_SHIFT, ES_QUOT, ES_DQUO),
  &ko_make_basic(MOD_MASK_SHIFT, ES_SCLN, ES_COLN),
  &ko_make_basic(MOD_MASK_SHIFT, ES_SLSH, ES_QUES),
  &ko_make_basic(MOD_MASK_SHIFT, ES_DOT, ES_RABK),
  &ko_make_basic(MOD_MASK_SHIFT, ES_COMM, ES_LABK),
	NULL // Null terminate the array of overrides!
};