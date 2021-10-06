#include QMK_KEYBOARD_H

enum planck_layers {
  _QWERTY,
  _LOWER,
  _RAISE,
  _MOV,
  _NUM,
  _ADJUST,
};

enum planck_keycodes {
  QWERTY = SAFE_RANGE
};

// Mod keys
#define SPCMOV LT(_MOV, KC_SPC) // Hold to move to layer MOV. Un tap es el space.
#define TABNUM LT(_NUM, KC_TAB) // Hold to move to layer NUM. Un tap es el tab.
#define RAISE LT(_RAISE, KC_ENT) // Hold to move to layer Raise. Un tap es el enter.
#define LOWER LT(_LOWER, KC_BSPC) // Hold to move to layer lower. Un tap es el backspace.
#define HYP_ESC HYPR_T(KC_ESC) // Hold=Hyper and Tap=ESC
#define SHIFT_CAPS LSFT_T(KC_CAPSLOCK) // Hold=Shift and tap=Toggle CAPLOCKS
 
const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {

/* Qwerty
 * ,-----------------------------------------------------------------------------------.
 * | Tab  |   Q  |   W  |   E  |   R  |   T  |   Y  |   U  |   I  |   O  |   P  | Bksp |
 * |------+------+------+------+------+------+------+------+------+------+------+------|
 * | Esc  |   A  |   S  |   D  |   F  |   G  |   H  |   J  |   K  |   L  |   ;  |  "   |
 * |------+------+------+------+------+------+------+------+------+------+------+------|
 * | Shift|   Z  |   X  |   C  |   V  |   B  |   N  |   M  |   ,  |   .  |   /  |Enter |
 * |------+------+------+------+------+------+------+------+------+------+------+------|
 * | Del  | Ctrl | Alt  | GUI  |Lower |Space | Space|Raise | Left | Down |  Up  |Right |
 * `-----------------------------------------------------------------------------------'
 */
[_QWERTY] = LAYOUT_planck_grid(
  TABNUM,    KC_Q,    KC_W,    KC_E,    KC_R,    KC_T,    KC_Y,    KC_U,    KC_I,    KC_O,    KC_P,    KC_BSPC,
  HYP_ESC,   KC_A,    KC_S,    KC_D,    KC_F,    KC_G,    KC_H,    KC_J,    KC_K,    KC_L,    KC_SCLN, KC_QUOT,
  SHIFT_CAPS,KC_Z,    KC_X,    KC_C,    KC_V,    KC_B,    KC_N,    KC_M,    KC_COMM, KC_DOT,  KC_SLSH, KC_ENT ,
  KC_DEL,    KC_LCTL, KC_LALT, KC_LGUI, LOWER,   SPCMOV,  SPCMOV,  RAISE,   KC_LEFT, KC_DOWN, KC_UP,   KC_RGHT
),

/* Lower
* ,-----------------------------------------------------------------------------------.
* |   `  |   1  |   2  |   3  |   4  |   5  |   6  |   7  |   8  |   9  |   0  | Bksp |
* |------+------+------+------+------+-------------+------+------+------+------+------|
* |      |      |      |      |      |      |   \  |   -  |   =  |   [  |   ]  |      |
* |------+------+------+------+------+------|------+------+------+------+------+------|
* |      |      |      |      |      |      |      |      |      |      |      |      |
* |------+------+------+------+------+------+------+------+------+------+------+------|
* |      |      |      |      | **** |             |      |      |      |      |      |
* `-----------------------------------------------------------------------------------'
*/
[_LOWER] = LAYOUT_planck_grid(
  KC_GRV  , KC_1    , KC_2    , KC_3    , KC_4    , KC_5    , KC_6    , KC_7    , KC_8    , KC_9    , KC_0    , KC_BSPC ,
  _______ , _______ , _______ , _______ , _______ , _______ , KC_BSLS , KC_MINS , KC_EQL  , KC_LBRC , KC_RBRC , _______ ,
  _______ , _______ , _______ , _______ , _______ , _______ , _______ , _______ , _______ , _______ , _______ , _______ ,
  _______ , _______ , _______ , _______ , _______ , _______ , _______ , _______ , _______ , _______ , _______ , _______
),

/* Raise
* ,-----------------------------------------------------------------------------------.
* |   ~  |   !  |   @  |   #  |   $  |   %  |   ^  |   &  |   *  |   (  |   )  | Bksp |
* |------+------+------+------+------+-------------+------+------+------+------+------|
* |      |      |      |      |      |      |   |  |   _  |   +  |   {  |   }  |      |
* |------+------+------+------+------+------|------+------+------+------+------+------|
* |      |      |      |      |      |      |      |      |      |      |      |      |
* |------+------+------+------+------+------+------+------+------+------+------+------|
* |      |      |      |      |      |             | **** |      |      |      |      |
* `-----------------------------------------------------------------------------------'
*/
[_RAISE] = LAYOUT_planck_grid(
  KC_TILD , KC_EXLM , KC_AT   , KC_HASH , KC_DLR  , KC_PERC , KC_CIRC , KC_AMPR   , KC_ASTR    , KC_LPRN , KC_RPRN , KC_BSPC ,
  _______ , _______ , _______ , _______ , _______ , _______ , KC_PIPE , KC_UNDS   , KC_PLUS    , KC_LCBR , KC_RCBR , _______ ,
  _______ , _______ , _______ , _______ , _______ , _______ , _______ , _______   , _______    , _______ , _______ , _______ ,
  _______ , _______ , _______ , _______ , _______ , _______ , _______ , _______   , _______    , _______ , _______ , _______
),

/* MOV
* ,-----------------------------------------------------------------------------------.
* |      |      |      |      |      | PgUp | CIns |      |      |      | SIns | Bksp |
* |------+------+------+------+------+-------------+------+------+------+------+------|
* |      | Home | End  | Shift| Ctrl |PgDown| Left | Down |  Up  | Right|      |      |
* |------+------+------+------+------+------|------+------+------+------+------+------|
* |      |      |      |      |      |      |      |      |      |      |      |      |
* |------+------+------+------+------+------+------+------+------+------+------+------|
* |      |      |      |      |      |  *** | ***  | Enter|      |      |      |      |
* `-----------------------------------------------------------------------------------'
*
* - Y outputs Control + Insert
* - P outputs Shift + Insert
*/
[_MOV] = LAYOUT_planck_grid(
  XXXXXXX , XXXXXXX , XXXXXXX , XXXXXXX , XXXXXXX , KC_PGUP , C(KC_INS) , XXXXXXX , XXXXXXX , XXXXXXX  , S(KC_INS) , KC_BSPC ,
  KC_BSPC , KC_HOME , KC_END  , KC_LSFT , KC_LCTL , KC_PGDN , KC_LEFT   , KC_DOWN , KC_UP   , KC_RIGHT , XXXXXXX   , _______,
  _______ , XXXXXXX , XXXXXXX , KC_CAPS , XXXXXXX , XXXXXXX , XXXXXXX   , XXXXXXX , XXXXXXX , XXXXXXX  , XXXXXXX   , _______,
  _______ , _______ , _______ , _______ , XXXXXXX , _______ , _______   , KC_ENT  , _______ , _______  , _______   , _______
),

/* NUM
* ,-----------------------------------------------------------------------------------.
* | **** |  F1  |  F2  |  F3  |  F4  |  F5  |      |   7  |   8  |   9  |   *  | Bksp |
* |------+------+------+------+------+-------------+------+------+------+------+------|
* |      |  F6  |  F7  |  F8  |  F9  |  F10 |      |   4  |   5  |   6  |   +  | Del  |
* |------+------+------+------+------+------|------+------+------+------+------+------|
* |      |      |      |      |  F11 |  F12 |      |   1  |   2  |   3  |   -  | Enter|
* |------+------+------+------+------+------+------+------+------+------+------+------|
* |      |      |      |      |      |      |      |   0  |   ,  |   .  |      |      |
* `-----------------------------------------------------------------------------------'
*/
[_NUM] = LAYOUT_planck_grid(
  _______ , KC_F1   , KC_F2   , KC_F3   , KC_F4   , KC_F5   , XXXXXXX , KC_7 , KC_8    , KC_9    , KC_PAST , KC_BSPC,
  XXXXXXX , KC_F6   , KC_F7   , KC_F8   , KC_F9   , KC_F10  , XXXXXXX ,  KC_4 , KC_5    , KC_6    , KC_PPLS , KC_DEL ,
  XXXXXXX , XXXXXXX , XXXXXXX , XXXXXXX , KC_F11  , KC_F12  , XXXXXXX  ,KC_1 , KC_2    , KC_3    , KC_PMNS , KC_ENT ,
  XXXXXXX , XXXXXXX , XXXXXXX , _______ , XXXXXXX , XXXXXXX , XXXXXXX , KC_0 , KC_COMM , KC_DOT  , XXXXXXX , XXXXXXX
),

/* Adjust (Lower + Raise)
* ,-----------------------------------------------------------------------------------.
* | Reset|      |      |      |      |      |      |      | MOUSU|      |      | Mute |
* |------+------+------+------+------+-------------+------+------+------+------+------|
* |      |      |      |      | MOUS1| MOUS2|      | MOUSL| MOUSD| MOUSR|      | Play |
* |------+------+------+------+------+------|------+------+------+------+------+------|
* |BLtogg|color+| sat+ | Bri+ |      |      |      | ACC0 | ACC1 | ACC2 |      | Vol+ |
* |------+------+------+------+------+------+------+------+------+------+------+------|
* |      |color-| sat- | Bri- | **** |      |      | **** |      |      |      | Vol- |
* `-----------------------------------------------------------------------------------'
*/
[_ADJUST] = LAYOUT_planck_grid(
  RESET   , _______ , _______ , RGB_VAI , XXXXXXX , XXXXXXX, XXXXXXX , _______, KC_MS_U, _______, _______, KC_MUTE,
  XXXXXXX , XXXXXXX , _______ , RGB_VAD , KC_BTN1 , KC_BTN2, _______ , KC_MS_L, KC_MS_D, KC_MS_R, XXXXXXX, KC_MPLY,
  RGB_TOG , RGB_HUI , RGB_SAI , RGB_VAI , _______ , _______, _______ , KC_ACL0, KC_ACL1, KC_ACL2, _______, KC_VOLU,
  XXXXXXX , RGB_HUD , RGB_SAD , RGB_VAD , _______ , XXXXXXX, XXXXXXX , _______, XXXXXXX, XXXXXXX, XXXXXXX, KC_VOLD
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