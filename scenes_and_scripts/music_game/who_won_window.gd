extends Control

@onready var team_one_label: RichTextLabel = %TeamOneLabel
@onready var team_two_label: RichTextLabel = %TeamTwoLabel

var is_dragging: bool = false
var drag_offset: Vector2

signal who_won(team: int)

func _ready() -> void:
	team_one_label.text = "[color=%s]%s[/color]" % [GameData.team_one_color.to_html(), GameData.team_one_name]
	team_two_label.text = "[color=%s]%s[/color]" % [GameData.team_two_color.to_html(), GameData.team_two_name]

func _input(event: InputEvent) -> void:
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


func _on_team_one_button_pressed() -> void:
	who_won.emit(1)

func _on_team_two_button_pressed() -> void:
	who_won.emit(2)

func _on_nobody_button_pressed() -> void:
	who_won.emit(0)
