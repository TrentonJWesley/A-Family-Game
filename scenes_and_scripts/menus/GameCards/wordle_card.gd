extends Button


func _ready() -> void:
	# Connect the mouse signals to our functions
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	print("huh")
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", 5, 0.2)

func _on_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", 0, 0.2)
