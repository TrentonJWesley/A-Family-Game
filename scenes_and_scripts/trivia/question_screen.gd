extends Control

@onready var team_one_name: Label = %TeamOneName
@onready var team_two_name: Label = %TeamTwoName

@onready var team_one_score_label: Label = %TeamOneScore
@onready var team_two_score_label: Label = %TeamTwoScore

@onready var pick_screen: Control = %PickScreen
@onready var pick_label: RichTextLabel = %PickLabel

@onready var question_choice_one: Button = %QuestionChoiceOne
@onready var question_choice_two: Button = %QuestionChoiceTwo
@onready var question_choice_three: Button = %QuestionChoiceThree

@onready var display_screen: Control = %DisplayScreen
@onready var which_team_label: RichTextLabel = %WhichTeamLabel
@onready var question_box: Label = %QuestionBox
@onready var reveal_button: Button = %RevealButton
@onready var answer_box: Label = %AnswerBox

@onready var correct_button_one: TextureButton = %CorrectButtonOne
@onready var incorrect_button_one: TextureButton = %IncorrectButtonOne
@onready var correct_button_two: TextureButton = %CorrectButtonTwo
@onready var incorrect_button_two: TextureButton = %IncorrectButtonTwo

@onready var correct_sound: AudioStreamPlayer = %CorrectSound

@onready var round_label: Label = %RoundLabel

var current_round = 1
var max_rounds = GameData.trivia_game_max_rounds
var current_team = 0
var team_one_score = 0
var team_two_score = 0

var question_selections: Array = []

var current_question: String = ""
var current_answer: String = ""

func _ready() -> void:
	team_one_name.text = GameData.team_one_name
	team_two_name.text = GameData.team_two_name
	team_one_name.label_settings.font_color = GameData.team_one_color
	team_two_name.label_settings.font_color = GameData.team_two_color
	
	team_one_score_label.label_settings.font_color = GameData.team_one_color
	team_two_score_label.label_settings.font_color = GameData.team_two_color
	
func reset() -> void:
	current_round = 1
	current_team = 0
	team_one_score = 0
	team_two_score = 0
	
	pick_screen.visible = false
	display_screen.visible = false
	answer_box.visible = false

func start(starting_team: int) -> void:
	team_one_score_label.text = str(team_one_score)
	team_two_score_label.text = str(team_two_score)
	current_team = starting_team
	round_label.text = "Round %s/%s" % [current_round, GameData.trivia_game_max_rounds]
	show_questions(current_team)

func show_questions(team: int) -> void:
	pick_screen.visible = true
	if team == 1:
		pick_label.text = "[color=%s]%s[/color], pick a question!" % [GameData.team_one_color.to_html(), GameData.team_one_name]
	else:
		pick_label.text = "[color=%s]%s[/color], pick a question!" % [GameData.team_two_color.to_html(), GameData.team_two_name]
	
	# Get questions to choose from
	var new_questions = get_parent().get_new_questions()
	question_selections = new_questions
	
	var question_one_parts = new_questions[0].split(" ").slice(0, 2)
	question_choice_one.text =  " ".join(question_one_parts) + "..."
	
	var question_two_parts = new_questions[1].split(" ").slice(0, 2)
	question_choice_two.text =  " ".join(question_two_parts) + "..."
	var question_three_parts = new_questions[2].split(" ").slice(0, 2)
	question_choice_three.text =  " ".join(question_three_parts) + "..."


func _on_question_choice_one_pressed() -> void:
	pick_question(question_selections[0])


func _on_question_choice_two_pressed() -> void:
	pick_question(question_selections[1])


func _on_question_choice_three_pressed() -> void:
	pick_question(question_selections[2])

func pick_question(question: String) -> void:
	current_question = question
	current_answer = get_parent().pick_question(question)
	
	# Show question and answer in console
	print("Current Question: ", current_question)
	print("Current Answer: ", current_answer)
	
	## Transition Screens
	display_screen.visible = true
	display_screen.modulate.a = 0
	reveal_button.visible = true
	reveal_button.modulate.a = 0
	
	# Set question and team label
	question_box.text = current_question
	answer_box.text = "Answer: " + current_answer
	if current_team == 1:
		which_team_label.text = "[color=%s]%s[/color]" % [GameData.team_one_color.to_html(), GameData.team_one_name]
	else:
		which_team_label.text = "[color=%s]%s[/color]" % [GameData.team_two_color.to_html(), GameData.team_two_name]
		
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(display_screen, "modulate:a", 1, 2)
	tween.tween_property(pick_screen, "modulate:a", 0, 2)
	
	await tween.finished
	pick_screen.visible = false
	pick_screen.modulate.a = 1
	
	var tween_reveal = create_tween()
	tween_reveal.tween_property(reveal_button, "modulate:a", 1, 2)


func _on_reveal_button_pressed() -> void:
	answer_box.visible = true
	answer_box.modulate.a = 0
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(answer_box, "modulate:a", 1, 2)
	tween.tween_property(reveal_button, "modulate:a", 0, 1)
	
	await tween.finished
	reveal_button.visible = false
	reveal_button.modulate.a = 1
	
	
	correct_button_one.visible = true
	correct_button_two.visible = true
	incorrect_button_one.visible = true
	incorrect_button_two.visible = true
	
	correct_button_one.modulate.a = 0
	correct_button_two.modulate.a = 0
	incorrect_button_one.modulate.a = 0
	incorrect_button_two.modulate.a = 0
	
	var tween_buttons = create_tween()
	if current_team == 1:
		tween_buttons.tween_property(correct_button_one, "modulate:a", 1, 1)
		tween_buttons.tween_property(incorrect_button_one, "modulate:a", 1, 1)
	else:
		tween_buttons.tween_property(correct_button_two, "modulate:a", 1, 1)
		tween_buttons.tween_property(incorrect_button_two, "modulate:a", 1, 1)
	


func _on_correct_button_one_pressed() -> void:
	team_one_score += 1
	team_one_score_label.text = str(team_one_score)
	correct_sound.play()
	next_question()



func _on_incorrect_button_one_pressed() -> void:
	next_question()


func _on_correct_button_two_pressed() -> void:
	team_two_score += 1
	team_two_score_label.text = str(team_two_score)
	correct_sound.play()
	next_question()


func _on_incorrect_button_two_pressed() -> void:
	next_question()

func next_question() -> void:
	current_team = 1 if current_team == 2 else 2
	current_round += 1
	
	correct_button_one.visible = false
	correct_button_two.visible = false
	incorrect_button_one.visible = false
	incorrect_button_two.visible = false
	
	if current_round > max_rounds:
		end_game()
		return
	else:
		round_label.text = "Round %s/%s" % [current_round, GameData.trivia_game_max_rounds]
		
	show_questions(current_team)
	
	pick_screen.modulate.a = 0
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(pick_screen, "modulate:a", 1, 2)
	tween.tween_property(display_screen, "modulate:a", 0, 2)
	
	await tween.finished
	display_screen.modulate.a = 1
	display_screen.visible = false
	answer_box.visible = false

func end_game() -> void:
	var tween = create_tween()
	tween.tween_property(display_screen, "modulate:a", 0, 2)
	
	await tween.finished
	display_screen.modulate.a = 1
	display_screen.visible = false
	
	get_parent().check_if_out_of_questions()
	
	if team_one_score > team_two_score:
		get_parent().end.emit(1)
	elif team_two_score > team_one_score:
		get_parent().end.emit(2)
	else:
		get_parent().end.emit(0)
