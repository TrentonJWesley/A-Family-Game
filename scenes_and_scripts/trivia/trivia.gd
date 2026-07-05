extends Control

@onready var trivia_theme: AudioStreamPlayer = %TriviaTheme

@onready var start_screen: Control = %StartScreen
@onready var question_screen: Control = %QuestionScreen

signal end(who_won: int)

var questions_filepath = "res://game_data/pop_culture_trivia_data/questions_answers.json"
var questions_dict: Dictionary

var starting_team: int = 1
var winning_team: int = 0

func _ready() -> void:
	load_question_list()
	check_if_out_of_questions()

func setup_start_screen(team: int = 1) -> void:
	starting_team = team
	
	# Show start screen
	start_screen.visible = true
	question_screen.visible = false
	
	# Reset variables
	winning_team = 0
	question_screen.reset()

func _on_start_button_pressed() -> void:
	# Start word game
	question_screen.start(starting_team)
	
	# Show word screen
	question_screen.visible = true
	# Transition Screens
	question_screen.modulate.a = 0
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(question_screen, "modulate:a", 1, 2)
	tween.tween_property(start_screen, "modulate:a", 0, 2)
	
	await tween.finished
	start_screen.visible = false
	start_screen.modulate.a = 1
	
func check_if_out_of_questions() -> void:
	if questions_dict.size() < GameData.trivia_game_max_rounds + 2:
		GameData.out_of_trivia_questions.emit()

func start_music() -> void:
	trivia_theme.play()
	
func stop_music() -> void:
	trivia_theme.stop()
	
func get_new_questions() -> Array:
	var all_questions = questions_dict.keys()
	all_questions.shuffle()
	return all_questions.slice(0, 3)

func pick_question(question: String) -> String:
	# Get answer
	var answer: String = str(questions_dict[question])
	# Remove question
	questions_dict.erase(question)
	
	return answer

func load_question_list() -> void:
	# Open and read the file
	var file = FileAccess.open(questions_filepath, FileAccess.READ)
	var json_text = file.get_as_text()
	file.close()
	
	# Parse the string into a Godot Dictionary
	questions_dict = JSON.parse_string(json_text)
