extends Control

# Minigames
@onready var what_the_horse: Control = %WhatTheHorse
@onready var wordle: Control = %Wordle
@onready var trivia: Control = %Trivia

@onready var mini_game_transition_screen: TextureRect = %MiniGameTransitionScreen
@onready var mini_game_screen: Control = %MiniGameScreen

@onready var game_transition_sound: AudioStreamPlayer = %GameTransitionSound
@onready var game_menu_music: AudioStreamPlayer = %GameMenuMusic

@onready var end_screen: Control = %EndScreen
@onready var end_label: Label = %EndLabel
@onready var reward_screen: Control = %RewardScreen
@onready var choose_reward_label: RichTextLabel = %ChooseRewardLabel
@onready var go_to_portraits_arrow: TextureButton = %GoToPortraitsArrow

@onready var team_picking_label: RichTextLabel = %TeamPickingLabel

var current_team = 1

func _ready() -> void:
	team_picking_label.text = "[color=%s]%s[/color], pick a game!" % [GameData.team_one_color.to_html(), GameData.team_one_name]

func _on_what_the_horse_card_pressed() -> void:
	start_transition_sound()
	transition_to_game(what_the_horse)
	

func _on_wordle_card_pressed() -> void:
	start_transition_sound()
	transition_to_game(wordle)

func _on_trivia_card_pressed() -> void:
	start_transition_sound()
	transition_to_game(trivia)

func _on_music_card_pressed() -> void:
	start_transition_sound()

func start_transition_sound() -> void:
	game_transition_sound.play()
	game_menu_music.stop()


func transition_to_game(game: Control) -> void:
	mini_game_transition_screen.play_iris_in(2)
	
	await mini_game_transition_screen.tween.finished
	game.visible = true
	game.setup_start_screen(current_team)
	current_team = 1 if current_team == 2 else 2
	update_picking_label()
	mini_game_transition_screen.play_iris_out(3)
	
	await mini_game_transition_screen.tween.finished
	game.start_music()

func update_picking_label() -> void:
	var team_color: String
	var team_name: String
	if current_team == 1:
		team_color = GameData.team_one_color.to_html()
		team_name = GameData.team_one_name
	else:
		team_color = GameData.team_two_color.to_html()
		team_name = GameData.team_two_name
	
	team_picking_label.text = "[color=%s]%s[/color], pick a game!" % [team_color, team_name]

## On Game Ends
func _on_what_the_horse_end(who_won: int) -> void:
	end_game_and_transition(who_won, what_the_horse)

func _on_wordle_end(who_won: int) -> void:
	end_game_and_transition(who_won, wordle)

func _on_trivia_end(who_won: int) -> void:
	end_game_and_transition(who_won, trivia)


func update_score(who_won: int) -> void:
	if who_won == 1:
		GameData.team_one_score += 1
	if who_won == 2:
		GameData.team_two_score += 1

func end_game_and_transition(who_won: int, game: Control) -> void:
	update_score(who_won)
	game_transition_sound.play()
	mini_game_transition_screen.play_iris_in(2)
	
	await mini_game_transition_screen.tween.finished
	
	# Show End Result Screen
	end_screen.visible = true
	end_screen.tie = false
	print("Who One?")
	if who_won == 1:
		print("Team One Won")
		end_label.text = "%s wins!" % GameData.team_one_name
		end_label.self_modulate = GameData.team_one_color
		choose_reward_label.text = "[color=%s]%s[/color], choose a reward!" % [GameData.team_one_color.to_html(), GameData.team_one_name]
	elif who_won == 2:
		print("Team Two Won")
		end_label.text = "%s wins!" % GameData.team_two_name
		end_label.self_modulate = GameData.team_two_color
		choose_reward_label.text = "[color=%s]%s[/color], choose a reward!" % [GameData.team_two_color.to_html(), GameData.team_two_name]
	else:
		print("It was a tie!")
		end_screen.tie = true
		end_label.text = "It's a tie!"
		end_label.self_modulate = Color("#ffffff")
	
	game.visible = false
	mini_game_screen.visible = false
	
	go_to_portraits_arrow.visible = false
	reward_screen.winning_team = who_won
	reward_screen.display_new_rewards()
	
	mini_game_transition_screen.play_iris_out(3)
	
	await mini_game_transition_screen.tween.finished
	game_menu_music.play()
