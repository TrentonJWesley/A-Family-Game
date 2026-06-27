extends Control

# Get Scenes
@export var team_selection_scene: PackedScene 
@export var game_selection_scene: PackedScene 
@onready var menu_screen: TextureRect = %MenuScreen

var team_selection_screen: Panel

func _ready() -> void:
	# Spawn Scene 2 initially but position it right below the screen so it is hidden
	team_selection_screen = team_selection_scene.instantiate() as Panel
	team_selection_screen.position.y = get_viewport_rect().size.y
	add_child(team_selection_screen)
	
	team_selection_screen.on_ready_pressed.connect(_on_ready_pressed)

func transition_scenes() -> void:
	var tween = create_tween()
	# Optional: Set the transition easing for a smoother slide
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel(true)
	
	# Slide both scenes upwards at the same time
	var screen_height = get_viewport_rect().size.y
	tween.tween_property(menu_screen, "position:y", -screen_height, 4.0)
	tween.tween_property(team_selection_screen, "position:y", 0, 4.0)
	
	# Clean up the first scene from memory when the transition finishes
	await tween.finished
	menu_screen.queue_free()


func _on_menu_screen_on_start_arrow_pressed() -> void:
	transition_scenes()

func _on_ready_pressed() -> void:
	print("yup!")
