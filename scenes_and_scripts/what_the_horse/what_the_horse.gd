extends Control

@onready var horse_reward_screen: Panel = %HorseRewardScreen
@onready var video_stream_player: VideoStreamPlayer = %VideoStreamPlayer
@onready var play_button: TextureButton = %PlayButton
@onready var pause_button: TextureButton = %PauseButton
@onready var button: Button = %Button
@onready var button_2: Button = %Button2
@onready var button_3: Button = %Button3
@onready var button_4: Button = %Button4
@onready var pause_title: RichTextLabel = %PauseTitle
@onready var finish_title: RichTextLabel = %FinishTitle

@onready var team_1_turn_label: Label = %Team1TurnLabel
@onready var team_2_turn_label: Label = %Team2TurnLabel

@onready var shoot_sound: AudioStreamPlayer = %ShootSound
@onready var waiting_sound: AudioStreamPlayer = %WaitingSound
@onready var answer_choice_sound: AudioStreamPlayer = %AnswerChoiceSound

@onready var crown_icon: PanelContainer = %CrownIcon
@onready var round_label: Label = %RoundLabel



var video_playlist: Array[WhatTheHorseVideo] = []

var current_team = 1
var current_round = 0



func _ready() -> void:
	load_videos_from_json("res://game_data/what_the_horse_game_data/video_data.json")
	#pick_video_by_name("Flip a Bottle for a Pint")
	start_random_video()

func _on_button_on_answer_choice_selected(answer_number: int, team: int) -> void:
	set_answer(answer_number, team)
	var new_team = 1 if team == 2 else 2
	change_button_teams(new_team)


func _on_button_2_on_answer_choice_selected(answer_number: int, team: int) -> void:
	set_answer(answer_number, team)
	var new_team = 1 if team == 2 else 2
	change_button_teams(new_team)

func _on_button_3_on_answer_choice_selected(answer_number: int, team: int) -> void:
	set_answer(answer_number, team)
	var new_team = 1 if team == 2 else 2
	change_button_teams(new_team)

func _on_button_4_on_answer_choice_selected(answer_number: int, team: int) -> void:
	set_answer(answer_number, team)
	var new_team = 1 if team == 2 else 2
	change_button_teams(new_team)

func change_button_teams(new_team: int) -> void:
	current_team = new_team
	if button.disabled == false:
		button.change_team(new_team)
	if button_2.disabled == false:
		button_2.change_team(new_team)
	if button_3.disabled == false:
		button_3.change_team(new_team)
	if button_4.disabled == false:
		button_4.change_team(new_team)
		
	if (team_1_choice != 0 and team_2_choice == 0) or (team_2_choice != 0 and team_1_choice == 0):
		show_whose_turn_it_is()

var correct_answer = null
func start_random_video() -> void:
	var random_num = randi_range(0, video_playlist.size() - 1)
	pick_video_by_num(random_num)

func pick_video_by_num(video_num: int) -> void:
	var video = video_playlist[video_num]
	start_video(video, video_num)

func pick_video_by_name(video_name: String) -> void:
	var video_num = 0 
	for video in video_playlist:
		if video.video_title == video_name:
			start_video(video, video_num)
		video_num += 1

func start_video(video: WhatTheHorseVideo, video_num: int):
	update_round()
	# Initialize text and video
	video_stream_player.initialize(video)
	button.change_text(video)
	button_2.change_text(video)
	button_3.change_text(video)
	button_4.change_text(video)
	
	# Show play button
	play_button.set_visible(true)
	
	# Save correct answer
	correct_answer = video.correct_answer
	# Remove randomly selected video from playlist
	video_playlist.remove_at(video_num)

func update_round() -> void:
	current_round += 1
	round_label.text = "Round %s" % current_round
	round_label.set_visible(true)

func load_videos_from_json(path: String) -> void:
	# Check if file exists
	if not FileAccess.file_exists(path):
		print("JSON file not found!")
		return
	
	# Open and read the file
	var file = FileAccess.open(path, FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()
	
	# Parse the JSON string into a Dictionary
	var json = JSON.new()
	var error = json.parse(json_string)
	if error != OK:
		print("JSON Parse Error: ", json.get_error_message())
		return
	var data: Dictionary = json.get_data()
	# Populate video playlist
	for title in data:
		var video_data: Dictionary = data[title]
		var video_settings: Dictionary = video_data["settings"]
		
		# Create video class
		var video = WhatTheHorseVideo.new()
		video.video_title = title
		video.file_path = "res://game_data/what_the_horse_game_data/videos/%s" % video_data["file"]
		video.answer_choices = video_data["answer_choices"]
		video.correct_answer = video_data["correct_answer"]
		video.window_type = video_settings["window_type"]
		video.video_start = video_settings["video_start"]
		video.video_pause = video_settings["video_pause"]
		video.video_end = video_settings["video_end"] if video_settings["video_end"] != null else INF
		
		# Add video to playlist
		video_playlist.append(video)
	
	print("Successfully loaded ", video_playlist.size(), " videos.")


func _on_play_button_pressed() -> void:
	round_label.set_visible(false)
	play_button.set_visible(false)
	
	## Change video position
	#var video_size = video_stream_player.get_size()
	#var viewport_size = get_viewport().get_size()
	#var new_position = Vector2(viewport_size / 2) - Vector2(video_size / 2)
	#video_stream_player.set_position(new_position)
	
	# Start video
	video_stream_player.start_video()

var showing_answers = false
var current_answer_to_show = 0
func _on_video_stream_player_on_pause() -> void:
	pause_button.set_visible(true)
	showing_answers = true
	current_answer_to_show = 0
	shoot_sound.play()
	# Show pause title
	pause_title.activate()
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if showing_answers == true:
				show_next_button()
			if time_to_reveal == true:
				time_to_reveal = false
				finish_video()
			if answer_revealed == true:
				video_stream_player.set_visible(false)
				determine_winner()
				show_reward_screen()
				answer_revealed = false
				reset_scene()

func show_next_button() -> void:
	match current_answer_to_show:
		0:
			button.set_visible(true)
			answer_choice_sound.play()
		1:
			button_2.set_visible(true)
			answer_choice_sound.play()
		2:
			button_3.set_visible(true)
			answer_choice_sound.play()
		3:
			button_4.set_visible(true)
			answer_choice_sound.play()
		_:
			showing_answers = false
			activate_buttons()
			show_whose_turn_it_is()
			waiting_sound.play()
	current_answer_to_show += 1

func activate_buttons() -> void:
	set_buttons_disability(false)
	change_button_teams(current_team)

var team_1_choice = 0
var team_2_choice = 0
var time_to_reveal = false
func set_answer(answer_number: int, team: int) -> void:
	answer_choice_sound.play()
	if team == 1:
		team_1_choice = answer_number
	if team == 2:
		team_2_choice = answer_number
	if team_1_choice != 0 and team_2_choice != 0:
		freeze_answers()
		team_1_turn_label.set_visible(false)
		team_2_turn_label.set_visible(false)
		time_to_reveal = true

func finish_video() -> void:
	waiting_sound.stop()
	video_stream_player.unpause_video()
	pause_title.set_visible(false)
	pause_button.set_visible(false)
	set_buttons_visibility(false)
	
func freeze_answers() -> void:
	# Change disabled theme for buttons that were not pressed
	if button.disabled == false:
		button.change_to_default_theme()
	if button_2.disabled == false:
		button_2.change_to_default_theme()
	if button_3.disabled == false:
		button_3.change_to_default_theme()
	if button_4.disabled == false:
		button_4.change_to_default_theme()
	# Disable all buttons
	set_buttons_disability(true)

func set_buttons_visibility(button_vis: bool):
	button.set_visible(button_vis)
	button_2.set_visible(button_vis)
	button_3.set_visible(button_vis)
	button_4.set_visible(button_vis)

func set_buttons_disability(button_dis: bool):
	button.disabled = button_dis
	button_2.disabled = button_dis
	button_3.disabled = button_dis
	button_4.disabled = button_dis

var answer_revealed = false
func _on_video_stream_player_on_finish() -> void:
	set_buttons_visibility(true)
	
	# Wait one frame so VBoxContainer/HBoxContainer update layout
	await get_tree().process_frame
	
	reveal_answer()
	waiting_sound.play(55.5)
	finish_title.activate()
	answer_revealed = true

func reveal_answer() -> void:
	print("Correct Answer: ", correct_answer)
	crown_icon.reveal_answer(get_answer_location())

func get_answer_location() -> Vector2:
	var answer_pos = get_correct_answer_button().get_global_rect().position
	return answer_pos


func get_correct_answer_button() -> Button:
	match correct_answer:
		1:
			return button
		2:
			return button_2
		3:
			return button_3
		4:
			return button_4
		_:
			push_error("Invalid correct_answer: %s" % correct_answer)
			return button

func reset_scene() -> void:
	# Fix and hide Buttons
	set_buttons_disability(false)
	change_button_teams(current_team)
	freeze_answers()
	set_buttons_visibility(false)
	# Hide everything else
	finish_title.set_visible(false)
	crown_icon.set_visible(false)
	# Stop sounds
	waiting_sound.stop()
	shoot_sound.stop()
	# Reset variables
	team_1_choice = 0
	team_2_choice = 0
	current_answer_to_show = 0
	winning_team = 0

var winning_team = 0
func show_reward_screen() -> void:
	print("huh?")
	horse_reward_screen.set_visible(true)
	horse_reward_screen.show_result(winning_team)

func determine_winner() -> void:
	if team_1_choice == correct_answer:
		winning_team = 1
	elif team_2_choice == correct_answer:
		winning_team = 2


func _on_horse_reward_screen_on_next_video() -> void:
	horse_reward_screen.set_visible(false)
	video_stream_player.set_visible(true)
	current_team = 1 if current_team == 2 else 2
	start_random_video()

func show_whose_turn_it_is() -> void:
	team_1_turn_label.set_visible(current_team == 1)
	team_2_turn_label.set_visible(current_team == 2)
	if team_1_choice == 0 and team_2_choice == 0:
		if current_team == 1:
			team_1_turn_label.text = "Team 1 goes first!"
		else:
			team_2_turn_label.text = "Team 2 goes first!"
	else:
		if current_team == 1:
			team_1_turn_label.text = "Now it's Team 1's turn!"
		else:
			team_2_turn_label.text = "Now it's Team 2's turn!"
