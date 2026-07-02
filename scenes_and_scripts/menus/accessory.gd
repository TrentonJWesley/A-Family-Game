extends TextureRect

@onready var finish_button: Button = %FinishButton
@onready var resize_slider: VSlider = %ResizeSlider

@onready var parent_control: Control = get_parent()
#var parent_control: Control = Control.new()

var draggable = true
var is_dragging = false
var drag_offset = Vector2.ZERO

signal finished

func _input(event: InputEvent) -> void:
	if not(draggable):
		return
	self.scale = Vector2(resize_slider.value, resize_slider.value)
	# Start dragging when clicked
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and get_global_rect().has_point(event.position):
				is_dragging = true
				drag_offset = global_position - get_global_mouse_position()
			elif not event.pressed:
				is_dragging = false
	# Move the node with the mouse
	elif event is InputEventMouseMotion and is_dragging:
		global_position = get_global_mouse_position() + drag_offset


# Call this function when the button is pressed
func lock_position_in_parent() -> void:
	finish_button.visible = false
	finish_button.disabled = true
	resize_slider.visible = false
	
	draggable = false
	
	# Calculate the position relative to the parent Control node
	var new_pos = global_position - parent_control.global_position
	
	# Detach the rect and add it as a child to the locked Control node
	# (Note: skip re-parenting if the TextureRect is already a child)
	var current_parent = get_parent()
	if current_parent != parent_control:
		current_parent.remove_child(self)
		parent_control.add_child(self)
	
	# Permanently lock the position
	global_position = global_position # Keep current screen position
	set_anchors_preset(Control.PRESET_TOP_LEFT) # Reset anchors
	position = new_pos # Lock exact coordinate


func _on_finish_button_pressed() -> void:
	lock_position_in_parent()
	finished.emit()
