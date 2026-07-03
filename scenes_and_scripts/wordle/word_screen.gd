extends Control

const WORDLE_GUESS = preload("uid://cpss67udkycjm")

@onready var wordle_guess_container: VBoxContainer = %WordleGuessContainer
@onready var success_sound: AudioStreamPlayer = %SuccessSound

@onready var round_label: Label = %RoundLabel
@onready var team_one_name: Label = %TeamOneName
@onready var team_two_name: Label = %TeamTwoName

@onready var team_one_word_pos: Control = %TeamOneWordPos
@onready var team_two_word_pos: Control = %TeamTwoWordPos

@onready var theme_music: AudioStreamPlayer = %ThemeMusic


var num_guesses = 0
var current_team = 0
var current_round = 1
var current_word: String
var max_rounds = GameData.wordle_game_max_rounds

var team_one_score = 0
var team_two_score = 0

func _ready() -> void:
	team_one_name.text = GameData.team_one_name
	team_two_name.text = GameData.team_two_name
	team_one_name.label_settings.font_color = GameData.team_one_color
	team_two_name.label_settings.font_color = GameData.team_two_color

func start(starting_team: int) -> void:
	
	current_team = starting_team
	var new_word: String = get_parent().get_new_word()
	current_word = new_word
	add_wordle_guess(starting_team, current_word)

func reset() -> void:
	team_one_score = 0
	team_two_score = 0
	num_guesses = 0
	current_round = 1
	round_label.text = "Round %s/%s" % [current_round, max_rounds]
	
	# Remove any obtained words
	for child in team_one_word_pos.get_children():
		child.queue_free()
	for child in team_two_word_pos.get_children():
		child.queue_free()
	
	# Fix container
	wordle_guess_container.scale = Vector2(1.0, 1.0)
	wordle_guess_container.global_position = get_viewport_rect().size / 2 - wordle_guess_container.size/2

func add_wordle_guess(team: int, new_word: String) -> void:
	num_guesses += 1
	
	# Resize if needed
	if num_guesses > 1:
		await resize_guesses().finished
	
	var wordle_guess = WORDLE_GUESS.instantiate()
	wordle_guess_container.add_child(wordle_guess)
	wordle_guess.reset()
	wordle_guess.correct_guess = new_word
	
	# Set border color and team
	match team:
		1:
			wordle_guess.set_box_border_colors(GameData.team_one_color)
			wordle_guess.team = 1
		2:
			wordle_guess.set_box_border_colors(GameData.team_two_color)
			wordle_guess.team = 2
	
	# Connect signals
	wordle_guess.guessed_correctly.connect(_on_guessed_correctly)
	wordle_guess.guessed_incorrectly.connect(_on_guessed_incorrectly)

func _on_guessed_correctly(team: int) -> void:
	success_sound.play()
	
	var last_guess = wordle_guess_container.get_child(-1)
	var last_guess_copy = last_guess.duplicate()
	last_guess_copy.scale = Vector2(.3, .3)
	last_guess_copy.active = false
	
	if team == 1:
		team_one_word_pos.add_child(last_guess_copy)
		var new_pos = team_one_word_pos.global_position
		new_pos -= last_guess_copy.size * .3 / 2
		last_guess_copy.global_position = new_pos + Vector2(0, 100) * team_one_score
	elif team == 2:
		team_two_word_pos.add_child(last_guess_copy)
		var new_pos = team_two_word_pos.global_position
		new_pos -= last_guess_copy.size * .3 / 2
		last_guess_copy.global_position = new_pos + Vector2(0, 100) * team_two_score
	
	last_guess_copy.modulate.a = 0
	# Animate last guess to below the winning team's name
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(last_guess_copy, "modulate:a", 1, 2)
	for child in wordle_guess_container.get_children():
		tween.tween_property(child, "modulate:a", 0, 2)
	
	await tween.finished
	
	for child in wordle_guess_container.get_children():
		child.queue_free()
	
	# Update scores
	if team == 1:
		team_one_score += 1
	elif team == 2:
		team_two_score += 1
	
	# Reset number of guesses
	num_guesses = 0
	
	next_round()

func next_round() -> void:
	current_round += 1
	if current_round > max_rounds:
		end_game()
		return
	
	# Update round
	round_label.text = "Round %s/%s" % [current_round, max_rounds]
	
	# Set up next guess
	var new_word: String = get_parent().get_new_word()
	current_word = new_word
	add_wordle_guess(1 if current_team == 2 else 2, current_word)
	current_team = 1 if current_team == 2 else 2

func end_game() -> void:
	theme_music.stop()
	get_parent().check_if_out_of_words()
	
	if team_one_score > team_two_score:
		get_parent().end.emit(1)
	elif team_two_score > team_one_score:
		get_parent().end.emit(2)
	else:
		get_parent().end.emit(0)

func _on_guessed_incorrectly(team: int) -> void:
	add_wordle_guess(1 if team == 2 else 2, current_word)

func resize_guesses() -> Tween:
	#wordle_guess_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var tween = create_tween()
	tween.set_parallel(true)
	if num_guesses == 6:
		var new_scale =  Vector2(.75, .75)
		var new_pos = get_viewport_rect().size / 2 - wordle_guess_container.size*.75/2
		tween.tween_property(wordle_guess_container, "scale", new_scale, 1)
		tween.tween_property(wordle_guess_container, "global_position", new_pos, 1)
	elif num_guesses == 8:
		var new_scale =  Vector2(.6, .6)
		var new_pos = get_viewport_rect().size / 2 - wordle_guess_container.size*.6/2
		tween.tween_property(wordle_guess_container, "scale", new_scale, 1)
		tween.tween_property(wordle_guess_container, "global_position", new_pos, 1)
	elif num_guesses == 10:
		var new_scale =  Vector2(.5, .5)
		var new_pos = get_viewport_rect().size / 2 - wordle_guess_container.size*.5/2
		tween.tween_property(wordle_guess_container, "scale", new_scale, 1)
		tween.tween_property(wordle_guess_container, "global_position", new_pos, 1)
	elif num_guesses == 12:
		var new_scale =  Vector2(.35, .35)
		var new_pos = get_viewport_rect().size / 2 - wordle_guess_container.size*.35/2
		tween.tween_property(wordle_guess_container, "scale", new_scale, 1)
		tween.tween_property(wordle_guess_container, "global_position", new_pos, 1)
	else:
		tween.tween_interval(0.5)
	return tween
