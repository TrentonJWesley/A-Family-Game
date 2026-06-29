extends LineEdit

func _ready() -> void:
	self.text = GameData.team_one_name
	# Triggers when the user presses Enter
	text_submitted.connect(_on_text_submitted)
	# Triggers when the LineEdit loses focus (clicking away)
	focus_exited.connect(_on_focus_exited)

func _on_text_submitted(new_text: String) -> void:
	GameData.team_one_name = new_text
	release_focus()

func _on_focus_exited() -> void:
	GameData.team_one_name = text

func _input(event: InputEvent) -> void:
	# Check if the event is a left-click that was just pressed
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Check if the mouse is currently outside the LineEdit's rectangle
		if not get_global_rect().has_point(event.position):
			release_focus()
