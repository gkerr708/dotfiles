# Corne (crkbd) Cheat Sheet

Keymap: `~/code/qmk_firmware/keyboards/crkbd/keymaps/gkerr708/keymap.c`
Controller: Blok (RP2040, UF2 bootloader) via `CONVERT_TO=blok`

## Flashing

1. Unplug the half you want to flash.
2. Run: `qmk flash -kb crkbd -km gkerr708`. Wait for it to say it's waiting for the bootloader.
3. Plug in the half while holding **BOOT** and tapping **RESET** on the controller.
   - Alternative: hold the **top-left key** (row 0, col 0) while plugging in the **left** half (Bootmagic). This doesn't work on the right half.
4. It shows up as the `RPI-RP2` drive. It doesn't auto-mount on Arch, so mount it by hand:
   ```
   lsblk -f
   udisksctl mount -b /dev/sdX1
   ```
5. The `.uf2` copies over and the half reboots. No need to unmount.
6. Repeat for the other half.

Compile only, then copy manually:
```
qmk compile -kb crkbd -km gkerr708
cp ~/code/qmk_firmware/*.uf2 /run/media/$USER/RPI-RP2/
```

## Keymap (copied from keymap.c)

Legend: `_______` = transparent (falls through to the layer below), `XXXXXXX` = does nothing

```c
    [0] = LAYOUT_split_3x6_3(
        MO(2),    KC_Q,    KC_W,    KC_E,    KC_R,    KC_T,                         KC_Y,    KC_U,    KC_I,    KC_O,   KC_P,  KC_BSPC,
       KC_TAB,    KC_A,    KC_S,    KC_D,    KC_F,    KC_G,                         KC_H,    KC_J,    KC_K,    KC_L, KC_SCLN, KC_QUOT,
      KC_LCTL,    KC_Z,    KC_X,    KC_C,    KC_V,    KC_B,                         KC_N,    KC_M, KC_COMM,  KC_DOT, KC_SLSH,  KC_ENT,
                                          KC_LALT, KC_LSFT, MO(1),     KC_ESC,  KC_SPC, KC_LGUI
    ),

    [1] = LAYOUT_split_3x6_3(
 LSFT(KC_GRV),    KC_1,    KC_2,    KC_3,    KC_4,    KC_5,                         KC_6,    KC_7,    KC_8,    KC_9,    KC_0,  KC_DEL,
      KC_PPLS, KC_PMNS, KC_PAST,  KC_EQL, KC_AMPR,  KC_DLR,                      KC_UNDS, KC_LPRN, KC_RPRN, KC_LCBR, KC_RCBR, KC_BSLS,
       KC_GRV, KC_EXLM,   KC_AT, KC_HASH,  KC_DLR, KC_PERC,                      KC_CIRC, KC_LBRC, KC_RBRC, _______, _______, _______,
                                          _______, _______, _______,    _______, _______, _______
    ),
    // NAV
    [2] = LAYOUT_split_3x6_3(
      _______,   KC_F1,   KC_F2,   KC_F3,   KC_F4,   KC_F5,                      KC_MPRV, KC_MPLY, KC_MSTP, KC_MNXT, KC_MUTE,_______,
      _______,   KC_F6,   KC_F7,   KC_F8,   KC_F9,  KC_F10,                      KC_LEFT, KC_DOWN,   KC_UP,KC_RIGHT, KC_VOLD, KC_VOLU,
      XXXXXXX,  KC_F11,  KC_F12, XXXXXXX, XXXXXXX, XXXXXXX,                      KC_BRID, KC_BRIU, KC_CALC, XXXXXXX, XXXXXXX, XXXXXXX,
                                          _______, KC_CAPS, _______,    _______, _______, _______
    )
```

## What the keys mean

### Layer switching

| Code | What it does |
|---|---|
| `MO(n)` | **Momentary layer.** Layer n is active only while you hold the key. |
| `_______` | **Transparent.** Uses whatever this position does on the layer below. |
| `XXXXXXX` | **No-op.** The key does nothing and does not fall through. |

### Modifiers and thumb keys

| Code | What it does |
|---|---|
| `KC_LCTL` | Left Ctrl |
| `KC_LALT` | Left Alt |
| `KC_LSFT` | Left Shift |
| `KC_LGUI` | Left GUI, also called Meta / Super / Windows key |
| `KC_ESC` | Escape |
| `KC_SPC` | Space |
| `KC_CAPS` | Caps Lock. Only on layer 2, left inner thumb. |

### Punctuation and editing

| Code | What it does |
|---|---|
| `KC_BSPC` | Backspace |
| `KC_DEL` | Delete (forward) |
| `KC_TAB` | Tab |
| `KC_ENT` | Enter |
| `KC_SCLN` | `;` |
| `KC_QUOT` | `'` |
| `KC_COMM` | `,` |
| `KC_DOT` | `.` |
| `KC_SLSH` | `/` |
| `KC_BSLS` | `\` |
| `KC_GRV` | `` ` `` (backtick) |
| `LSFT(KC_GRV)` | Shift + backtick, which types `~` |
| `KC_EQL` | `=` |
| `KC_UNDS` | `_` |
| `KC_PPLS` | `+` (keypad plus) |
| `KC_PMNS` | `-` (keypad minus) |
| `KC_PAST` | `*` (keypad asterisk) |
| `KC_AMPR` | `&` |
| `KC_DLR` | `$` (appears twice on layer 1) |
| `KC_EXLM` | `!` |
| `KC_AT` | `@` |
| `KC_HASH` | `#` |
| `KC_PERC` | `%` |
| `KC_CIRC` | `^` |
| `KC_LPRN` / `KC_RPRN` | `(` and `)` |
| `KC_LCBR` / `KC_RCBR` | `{` and `}` |
| `KC_LBRC` / `KC_RBRC` | `[` and `]` |

### Navigation and function keys (layer 2)

| Code | What it does |
|---|---|
| `KC_LEFT` / `KC_DOWN` / `KC_UP` / `KC_RIGHT` | Arrow keys. They sit where H, J, K, L are (vim style). |
| `KC_F1` to `KC_F12` | Function keys. F1-F5 top row left, F6-F10 middle row left, F11-F12 bottom row left. |

### Media and system (layer 2)

| Code | What it does |
|---|---|
| `KC_MPRV` | Previous track |
| `KC_MPLY` | Play / pause |
| `KC_MSTP` | Stop media |
| `KC_MNXT` | Next track |
| `KC_MUTE` | Mute |
| `KC_VOLD` / `KC_VOLU` | Volume down / up |
| `KC_BRID` / `KC_BRIU` | Screen brightness down / up |
| `KC_CALC` | Open the calculator |

## Where things are, at a glance

```
Layer 0 (base)
 MO(2)  Q W E R T | Y U I O P Bspc
 Tab    A S D F G | H J K L ; '
 Ctrl   Z X C V B | N M , . / Enter
        Alt Shift MO(1) | Esc Space Meta

Layer 1 (hold left inner thumb): numbers and symbols
Layer 2 (hold top-left):         F-keys, arrows, media, volume, brightness
```

## Ideas for later

- **QK_BOOT key** on a layer, so you can enter the bootloader from the keyboard.
- **Repeat Key / Alternate Repeat** (`QK_REP`, `QK_AREP`) for double letters and undo/redo.
- **One-shot layers / mods** (`OSL`, `OSM`): tap instead of hold.
- **Caps Word** (`CW_TOGG`, needs `CAPS_WORD_ENABLE = yes`).
- **Tap dance, Leader key, combos, key overrides.**
- **Luna OLED pet**, WPM meter, layer indicator on the OLED.
- **Mouse keys** (`KC_MS_*`, `KC_BTN*`, `KC_WH_*`, needs `MOUSEKEY_ENABLE = yes`).
- **Extra media/system keys**: `KC_MSEL`, `KC_MAIL`, `KC_WHOM`, `KC_WBAK`, `KC_WFWD`, `KC_F13`–`KC_F24` (bind to anything in your WM).
- **Unicode / emoji** (`UC()`, needs `UNICODE_ENABLE`).
- **Autocorrect** (`AUTOCORRECT_ENABLE = yes`).
- **Layers removed and possible to restore**: CSGO, StarCraft, Dota game layers. Check git history before the "added caps lock" commit.
