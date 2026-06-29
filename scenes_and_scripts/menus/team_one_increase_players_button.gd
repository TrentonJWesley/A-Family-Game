extends TextureButton


@export var hover_color: Color = Color(0.7, 0.7, 0.7, 0.85)
@onready var ORIGINAL_COLOR = self_modulate


func _ready() -> void:
	# Connect the mouse signals to our functions
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	self_modulate = hover_color

func _on_mouse_exited() -> void:
	self_modulate = ORIGINAL_COLOR
