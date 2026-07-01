extends Control


@onready var what_the_horse: Control = %WhatTheHorse

@onready var mini_game_transition_screen: TextureRect = %MiniGameTransitionScreen
@onready var mini_game_screen: Control = %MiniGameScreen

@onready var game_transition_sound: AudioStreamPlayer = %GameTransitionSound
@onready var game_menu_music: AudioStreamPlayer = %GameMenuMusic

@onready var end_screen: Control = %EndScreen
@onready var end_label: Label = %EndLabel

func _on_what_the_horse_card_pressed() -> void:
	start_transition_sound()
	transition_to_game(what_the_horse)
	

func _on_wordle_card_pressed() -> void:
	start_transition_sound()

func start_transition_sound() -> void:
	game_transition_sound.play()
	game_menu_music.stop()

func transition_to_game(game: Control) -> void:
	mini_game_transition_screen.play_iris_in(2)
	
	await mini_game_transition_screen.tween.finished
	game.visible = true
	game.setup_start_screen()
	mini_game_transition_screen.play_iris_out(3)
	
	await mini_game_transition_screen.tween.finished
	game.start_music()



func _on_what_the_horse_end(who_won: int) -> void:
	mini_game_transition_screen.play_iris_in(2)
	
	await mini_game_transition_screen.tween.finished
	# Show End Result Screen
	end_screen.visible = true
	if who_won == 1:
		end_label.text = "%s wins!" % GameData.team_one_name
		end_label.self_modulate = Color(.044, .323, 1)
	elif who_won == 2:
		end_label.text = "%s wins!" % GameData.team_two_name
		end_label.self_modulate = Color(1, 0.089, 0.089)
	else:
		end_label.text = "It's a tie!"
		end_label.self_modulate = Color(1, 0.089, 0.089)
		
	what_the_horse.visible = false
	mini_game_screen.visible = false
	mini_game_transition_screen.play_iris_out(3)
	
	await mini_game_transition_screen.tween.finished
	game_menu_music.play()
	
