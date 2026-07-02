extends HBoxContainer

@onready var guess_box_one: Panel = %GuessBoxOne
@onready var guess_box_two: Panel = %GuessBoxTwo
@onready var guess_box_three: Panel = %GuessBoxThree
@onready var guess_box_four: Panel = %GuessBoxFour
@onready var guess_box_five: Panel = %GuessBoxFive

@onready var letter_one: Label = %LetterOne
@onready var letter_two: Label = %LetterTwo
@onready var letter_three: Label = %LetterThree
@onready var letter_four: Label = %LetterFour
@onready var letter_five: Label = %LetterFive



var correct_guess: String = "World"
var team: int = 0

var guess: Array[String] = ["", "", "", "", ""]
var current_letter_idx = 0

var active = true

var DEFAULT_COLOR = Color("#161616")

signal guessed_correctly(team: int)
signal guessed_incorrectly(team: int)

func _ready() -> void:
	change_box_color(guess_box_one, DEFAULT_COLOR)
	change_box_color(guess_box_two, DEFAULT_COLOR)
	change_box_color(guess_box_three, DEFAULT_COLOR)
	change_box_color(guess_box_four, DEFAULT_COLOR)
	change_box_color(guess_box_five, DEFAULT_COLOR)
	
	letter_one.text = ""
	letter_two.text = ""
	letter_three.text = ""
	letter_four.text = ""
	letter_five.text = ""

func set_box_border_colors(color: Color) -> void:
	change_box_border_color(guess_box_one, color)
	change_box_border_color(guess_box_two, color)
	change_box_border_color(guess_box_three, color)
	change_box_border_color(guess_box_four, color)
	change_box_border_color(guess_box_five, color)

func _input(event: InputEvent) -> void:
	if not(active):
		return
	
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ENTER:
			if current_letter_idx >= 5:
				enter_guess()
		if event.keycode == KEY_BACKSPACE:
			remove_letter()
		
		var key_character: String = event.as_text_key_label()
		if key_character in "ABCDEFGHIJKLMNOPQRSTUVWXYZ":
			enter_letter(key_character)

func enter_guess() -> void:
	# Deactivate Guess Boxes
	active = false
	
	var temp_correct_guess = correct_guess
	var box_colors: Dictionary = {}
	var num_correct = 0
	# Find all perfect matches first
	for idx in range(guess.size()):
		var letter = guess[idx]
		if letter.to_lower() == correct_guess[idx].to_lower():
			num_correct += 1
			box_colors[idx] = Color("#6ca965")
			# Remove letter from temporary correct guess var
			var letter_idx = temp_correct_guess.to_lower().find(letter.to_lower())
			temp_correct_guess = temp_correct_guess.erase(letter_idx)
	
	# Give the other letters their colors
	for idx in range(guess.size()):
		if not(idx in box_colors):
			if guess[idx].to_lower() in temp_correct_guess.to_lower():
				box_colors[idx] = Color("#c8b653")
				# Remove letter from temporary correct guess var
				var letter_idx = temp_correct_guess.to_lower().find(guess[idx].to_lower())
				temp_correct_guess = temp_correct_guess.erase(letter_idx)
			else:
				box_colors[idx] = Color("#787c7f")
	
	# Display result
	var tween = create_tween()
	for idx in range(guess.size()):
		# Get color
		var color = box_colors[idx]
		# Get box
		var guess_box: Panel
		match idx:
			0:
				guess_box = guess_box_one
			1:
				guess_box = guess_box_two
			2:
				guess_box = guess_box_three
			3:
				guess_box = guess_box_four
			4:
				guess_box = guess_box_five
		# Animated box result
		await animate_box_flip(guess_box, color).finished
	
	if num_correct == 5:
		print("guessed_correctly signal emitted")
		guessed_correctly.emit(team)
	else:
		print("guessed_incorrectly signal emitted")
		guessed_incorrectly.emit(team)

func remove_letter() -> void:
	if current_letter_idx <= 0:
		return
	
	current_letter_idx -= 1
	
	update_guess("")
			

func enter_letter(letter: String) -> void:
	if current_letter_idx >= 5:
		return
	
	update_guess(letter)
	
	current_letter_idx += 1
	
func update_guess(letter: String) -> void:
	guess[current_letter_idx] = letter
	match current_letter_idx:
		0:
			letter_one.text = letter
		1:
			letter_two.text = letter
		2:
			letter_three.text = letter
		3:
			letter_four.text = letter
		4:
			letter_five.text = letter



func animate_box_flip(guess_box: Panel, color: Color) -> Tween:
	var tween = create_tween()
	
	guess_box.pivot_offset = guess_box.size / 2
	
	# Flip flat
	tween.tween_property(guess_box, "scale:y", 0.0, 0.15)
	
	# Change color and flip back
	tween.tween_callback(func(): change_box_color(guess_box, color))
	tween.tween_property(guess_box, "scale:y", 1.0, 0.15)
	
	return tween


func change_box_color(box: Panel, color: Color) -> void:
	var stylebox = box.get_theme_stylebox("panel").duplicate()
	# Get the current stylebox and duplicate it to make it unique
	
	# Change the background color to anything you like
	stylebox.bg_color = color
	
	# Apply the modified stylebox back to the Panel
	box.add_theme_stylebox_override("panel", stylebox)
	
func change_box_border_color(box: Panel, color: Color) -> void:
	var stylebox = box.get_theme_stylebox("panel").duplicate()
	# Get the current stylebox and duplicate it to make it unique
	
	# Change the background color to anything you like
	stylebox.border_color = color
	
	# Apply the modified stylebox back to the Panel
	box.add_theme_stylebox_override("panel", stylebox)
