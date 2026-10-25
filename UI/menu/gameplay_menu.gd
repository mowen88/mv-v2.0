extends VBoxContainer

# Define signal to pass a boolean (true for on, false for off)
signal screenshake_toggle_requested(is_on: bool)
signal vibrate_toggle_requested(is_on: bool) 
signal battery_saver_toggle_requested(is_on: bool) 
signal back_requested

func _ready() -> void:
	
	# 1. Update settings on disk
	$BatterySaverRow/BatterySaverCheckButton.button_pressed = SaveManager.SETTINGS_DATA["Battery Saver"]
	$ScreenshakeRow/ScreenshakeCheckButton.button_pressed = SaveManager.SETTINGS_DATA["Screenshake"]
	$VibrateRow/VibrateCheckButton.button_pressed = SaveManager.SETTINGS_DATA["Vibration"]
	
	# 2. Wire up the CheckBox
	$ScreenshakeRow/ScreenshakeCheckButton.toggled.connect(func(is_on): screenshake_toggle_requested.emit(is_on))
	$VibrateRow/VibrateCheckButton.toggled.connect(func(is_on): vibrate_toggle_requested.emit(is_on))
	$BatterySaverRow/BatterySaverCheckButton.toggled.connect(func(is_on): battery_saver_toggle_requested.emit(is_on))
	
	# 3. Wire up back navigation
	$BackButton.pressed.connect(func(): back_requested.emit())
	
	# Loop through children to avoid referencing non-existent 'SlotRow' nodes
	for child in get_children():
		if child is Control:
			child.focus_mode = Control.FOCUS_NONE
			# If you have nested buttons inside rows, you can add a sub-loop here:
			for sub_child in child.get_children():
				if sub_child is Control:
					sub_child.focus_mode = Control.FOCUS_NONE

	$BackButton.focus_mode = Control.FOCUS_NONE
