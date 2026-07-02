extends Control

const WORDLE_GUESS = preload("uid://cpss67udkycjm")

@onready var wordle_guess_container: VBoxContainer = %WordleGuessContainer

var num_guesses = 0

func _ready() -> void:
	start(1)

func start(starting_team: int) -> void:
	add_wordle_guess(starting_team)

func reset() -> void:
	pass

func add_wordle_guess(team: int) -> void:
	num_guesses += 1
	
	# Resize if needed
	if num_guesses > 1:
		await resize_guesses().finished
	
	var world_guess = WORDLE_GUESS.instantiate()
	wordle_guess_container.add_child(world_guess)
	print("added child")
	
	# Set border color and team
	print("team colors set")
	match team:
		1:
			world_guess.set_box_border_colors(GameData.team_one_color)
			world_guess.team = 1
		2:
			world_guess.set_box_border_colors(GameData.team_two_color)
			world_guess.team = 2
	
	# Connect signals
	print("signals connected")
	world_guess.guessed_correctly.connect(_on_guessed_correctly)
	world_guess.guessed_incorrectly.connect(_on_guessed_incorrectly)

func _on_guessed_correctly(team: int) -> void:
	print("_on_guessed_correctly")

func _on_guessed_incorrectly(team: int) -> void:
	print("_on_guessed_incorrectly")
	add_wordle_guess(1 if team == 2 else 2)

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
