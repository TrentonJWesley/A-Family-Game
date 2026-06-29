extends TextureButton

@export var hover_color: Color = Color(0.7, 0.7, 0.7, 0.85)

@onready var ORIGINAL_POSITION = position
@onready var ORIGINAL_COLOR = self_modulate
var BOB_DISTANCE = 30
var BOB_DURATION = 1

func _ready() -> void:
	# Connect the mouse signals to our functions
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	# Fade arrow in after a little delay
	self.modulate.a = 0
	var tween_fade_in = create_tween()
	tween_fade_in.tween_property(self, "modulate:a", 1, 5).set_delay(5)
	
	# Have arrow bob up and down
	var tween_bob = create_tween()
	tween_bob.set_loops()
	# Move the arrow down
	tween_bob.tween_property(self, "position:y", ORIGINAL_POSITION.y + BOB_DISTANCE, BOB_DURATION)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	# Move the arrow back up to the original position
	tween_bob.tween_property(self, "position:y", ORIGINAL_POSITION.y, BOB_DURATION)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)


func _on_mouse_entered() -> void:
	self_modulate = hover_color

func _on_mouse_exited() -> void:
	self_modulate = ORIGINAL_COLOR # Resets to the original texture colors


func _on_pressed() -> void:
	self.set_disabled(true)
