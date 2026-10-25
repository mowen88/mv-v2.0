extends VBoxContainer

signal back_requested

@export var languages: Array[String] = ["en", "pl", "fr", "es", "de"]
@export var language_names: Array[String] = ["English", "Polski", "Français", "Español", "Deutsch"]

var current_index: int = 0
var temp_index: int = 0 # Temporary selection until confirmed

@onready var language_label: Label = $HBoxContainer/LanguageLabel
@onready var left_button: TextureButton = $HBoxContainer/LeftButton
@onready var right_button: TextureButton = $HBoxContainer/RightButton
@onready var back_button: Button = $BackButton

func _ready() -> void:
	# Match current active locale on startup
	var current_locale = TranslationServer.get_locale()
	if current_locale in languages:
		current_index = languages.find(current_locale)
	
	# Sync temporary index to current active game language
	temp_index = current_index
	update_language_display()
	
	# Connect button presses
	left_button.pressed.connect(_on_left_pressed)
	right_button.pressed.connect(_on_right_pressed)
	back_button.pressed.connect(_on_back_pressed)
	
	# Remove focus rings if desired
	for child in get_children():
		if child is Control:
			child.focus_mode = Control.FOCUS_NONE

func _on_left_pressed() -> void:
	temp_index = (temp_index - 1 + languages.size()) % languages.size()
	update_language_display()

func _on_right_pressed() -> void:
	temp_index = (temp_index + 1) % languages.size()
	update_language_display()

func update_language_display() -> void:
	# Only updates the UI label preview using the temporary index
	language_label.text = language_names[temp_index]

func _on_back_pressed() -> void:
	# Commit the temporary index as the real current index
	current_index = temp_index
	
	# Apply the language globally only when backing out / confirming
	var locale_code = languages[current_index]
	TranslationServer.set_locale(locale_code)
	
	back_requested.emit()
