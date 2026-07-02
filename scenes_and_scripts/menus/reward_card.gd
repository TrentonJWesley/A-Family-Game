extends Button

@onready var hover_sound: AudioStreamPlayer = %HoverSound
@onready var reward_image: TextureRect = %RewardImage

var reward_name = ""

func _ready() -> void:
	# Connect the mouse signals to our functions
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", 5, 0.2)
	hover_sound.play()

func _on_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", 0, 0.2)

func set_reward(directory: String, file_name: String) -> void:
	reward_name = file_name
	reward_image.set_texture(load("res://images/accessories/%s" % file_name))
