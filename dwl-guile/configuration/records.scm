(define-module (dwl-guile configuration records)
               #:use-module (srfi srfi-1)
               #:use-module (gnu services configuration)
               #:use-module (dwl-guile utils)
               #:export (
                         dwl-monitor-rule
                         dwl-monitor-rule?
                         <dwl-monitor-rule>

                         dwl-xkb-rule
                         dwl-xkb-rule?
                         <dwl-xkb-rule>

                         dwl-key
                         <dwl-key>
                         dwl-key?
                         dwl-key-modifiers
                         dwl-key-key
                         dwl-key-action

                         dwl-button
                         <dwl-button>
                         dwl-button?
                         dwl-button-modifiers
                         dwl-button-button
                         dwl-button-action

                         dwl-tag-keys
                         <dwl-tag-keys>
                         dwl-tag-keys?
                         dwl-tag-keys-keys
                         dwl-tag-keys-fields
                         dwl-tag-keys-view-modifiers
                         dwl-tag-keys-tag-modifiers
                         dwl-tag-keys-toggle-view-modifiers
                         dwl-tag-keys-toggle-tag-modifiers

                         dwl-layout
                         dwl-layout?
                         <dwl-layout>
                         dwl-layout-id
                         dwl-layout-symbol
                         dwl-layout-arrange

                         dwl-colors
                         dwl-colors?
                         <dwl-colors>
                         dwl-colors-root
                         dwl-colors-border
                         dwl-colors-focus

                         dwl-rule
                         dwl-rule?
                         <dwl-rule>))

; Color configuration
(define-configuration
  dwl-colors
  (root
    (rgb-color '(0.3 0.3 0.3 1.0))
    "Root color in RGBA format.")
  (border
    (rgb-color '(0.5 0.5 0.5 1.0))
    "Border color in RBA format.")
  (focus
    (rgb-color '(1.0 0.0 0.0 1.0))
    "Border focus color in RGBA format.")
  (no-serialization))

; Application rule configuration
(define-configuration
  dwl-rule
  (id
    (maybe-string #f)
    "Id of target application for rule.")
  (title
    (maybe-string #f)
    "Title of target application for rule.")
  ; TODO: Allow multiple tags?
  (tag
    (number 1)
    "Tag to place application on. 1 corresponds to the first tag in the @code{tags} list.")
  (floating?
    (boolean #f)
    "If the application should be floating initially.")
  (monitor
    (number 1)
    "The monitor to spawn the application on.")
  (alpha
    (number 0.9)
    "Default window transparency (0-1) for the application. Requires the @code{%patch-alpha} patch.")
  (no-serialization))

; https://xkbcommon.org/doc/current/structxkb__rule__names.html
(define-configuration
  dwl-xkb-rule
  (rules
    (string "")
    "The rules file to use.")
  (model
    (string "")
    "The keyboard model that should be used to interpret keycodes and LEDs.")
  (layouts
    (list-of-strings '())
    "A list of layouts (languages) to include in the keymap.")
  (variants
    (list-of-strings '())
    "A list of layout variants, one per layout.")
  (options
    (list-of-strings '())
    "A list of layout options.")
  (no-serialization))

; Monitor rule configuration
(define-configuration
  dwl-monitor-rule
  (name
    (maybe-string #f)
    "Name of monitor, e.g. eDP-1.")
  (master-factor
    (number 0.55)
    "Horizontal scaling factor for master windows.")
  (masters
    (number 1)
    "Number of windows that will be shown in the master area.")
  (scale
    (number 1)
    "Monitor scaling.")
  (layout
    (string)
    "Default layout (id) to use for monitor.")
  (transform
    (symbol 'TRANSFORM-NORMAL)
    "Monitor output transformations, e.g. rotation, reflect.")
  (x
    (number 0)
    "Position on the x-axis.")
  (y
    (number 0)
    "Position on the y-axis.")
  (no-serialization))

; Keybinding configuration
(define-configuration
  dwl-key
  (modifiers
    (list-of-modifiers '(SUPER))
    "List of modifiers to use for the keybinding")
  (key
    (keycode)
    "Keycode or keysym string to use for this keybinding")
  (action
    (maybe-exp #f)
    "Expression to call when triggered.")
  (no-serialization))

; Mouse button configuration
(define-configuration
  dwl-button
  (modifiers
    (list-of-modifiers '(SUPER))
    "List of modifiers to use for the button.")
  (button
    (symbol)
    "Mouse button to use for this binding.")
  (action
    (maybe-exp #f)
    "Expression to call when triggered.")
  (no-serialization))

; Tag keybindings configuration
(define-configuration
  dwl-tag-keys
  (view-modifiers
    (list-of-modifiers '(SUPER))
    "Modifier(s) that should be used to view a tag.")
  (tag-modifiers
    (list-of-modifiers '(SUPER SHIFT))
    "Modifier(s) that should be used to move windows to a tag.")
  (toggle-view-modifiers
    (list-of-modifiers '(SUPER CTRL))
    "Modifier(s) that should be used to toggle the visibilty of a tag.")
  (toggle-tag-modifiers
    (list-of-modifiers '(SUPER SHIFT CTRL))
    "Modifier(s) that should be used to toggle a tag for a window.")
  (keys
    (list-of-tag-key-pairs `(("1" . 1)
                             ("2" . 2)
                             ("3" . 3)
                             ("4" . 4)
                             ("5" . 5)
                             ("6" . 6)
                             ("7" . 7)
                             ("8" . 8)
                             ("9" . 9)))
    "List of key/tag pairs to generate tag keybindings for,
  e.g. @code{("1" . 1)} for mapping the key "1" to tag 1.
  The first value of the pair should be a valid keycode or keysym.")
  (no-serialization))

; Layout configuration
(define-configuration
  dwl-layout
  (id
    (string)
    "Id that can be used to reference a layout in your config, e.g. in a monitor rule.")
  (symbol
    (string)
    "Symbol that should be shown when layout is active.")
  (arrange
    (maybe-exp #f)
    "Expression to call when layout is selected.")
  (no-serialization))