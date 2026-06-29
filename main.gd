extends Control

# Get Scenes
@export var team_selection_scene: PackedScene 
@export var game_scene: PackedScene 
@onready var menu_screen: TextureRect = %MenuScreen

var team_selection_screen: Panel

var TEAM_SELECTION_TRANSITION_TIME = 12

func _ready() -> void:
	# Spawn Scene 2 initially but position it right below the screen so it is hidden
	team_selection_screen = team_selection_scene.instantiate() as Panel
	team_selection_screen.position.y = get_viewport_rect().size.y
	add_child(team_selection_screen)
	team_selection_screen.on_ready_pressed.connect(_on_ready_pressed)

func transition_to_team_select() -> void:
	# Play transiton sound for team selection screen
	team_selection_screen.play_intro_sound()
	
	# Set up tween to transition scenes
	var tween = create_tween()
	# Optional: Set the transition easing for a smoother slide
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN)
	tween.set_parallel(true)
	
	# Slide both scenes upwards at the same time
	var screen_height = get_viewport_rect().size.y
	tween.tween_property(menu_screen, "position:y", -screen_height, 
						 TEAM_SELECTION_TRANSITION_TIME)
	tween.tween_property(team_selection_screen, "position:y", 0, 
						 TEAM_SELECTION_TRANSITION_TIME)
	
	# Clean up the first scene from memory when the transition finishes
	await tween.finished
	menu_screen.queue_free()


func _on_menu_screen_on_start_arrow_pressed() -> void:
	transition_to_team_select()

func _on_ready_pressed() -> void:
	print("Teams Created!")
	print("team_one_name: ", GameData.team_one_name)
	print("team_two_name: ", GameData.team_two_name)
	print("team_one_player_count: ", GameData.team_one_player_count)
	print("team_two_player_count: ", GameData.team_two_player_count)
	print("team_one_player_pictures: ", GameData.team_one_player_pictures)
	print("team_two_player_pictures: ", GameData.team_two_player_pictures)
	transition_to_game()

func transition_to_game() -> void:
	var game_screen = game_scene.instantiate() as TextureRect
	add_child(game_screen)
	move_child(game_screen, 0)
	
	var tween = create_tween()
	tween.tween_property(team_selection_screen, "modulate:a", 0, 1.5)
	
	# Remove Selection Screen once animation finishes
	await tween.finished
	team_selection_screen.queue_free()
	
