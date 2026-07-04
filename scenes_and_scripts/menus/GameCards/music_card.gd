extends Button

@onready var hover_sound: AudioStreamPlayer = %HoverSound
@onready var lock_screen: Panel = %LockScreen

func _ready() -> void:
	# Connect the mouse signals to our functions
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	GameData.out_of_music.connect(_on_out_of_music)
	lock_screen.visible = false

func _on_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", 5, 0.2)
	hover_sound.play()

func _on_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", 0, 0.2)

func _on_out_of_music() -> void:
	lock_screen.visible = true
