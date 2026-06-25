extends Button

const TEAM_1_ANSWER_CHOICE_HOVER_DISABLED_STYLE = preload("res://game_data/what_the_horse_game_data/styles/team_1_answer_choice_hover_disabled_style.tres")
const TEAM_1_ANSWER_CHOICE_PRESSED_STYLE = preload("res://game_data/what_the_horse_game_data/styles/team_1_answer_choice_pressed_style.tres")
const TEAM_2_ANSWER_CHOICE_HOVER_DISABLED_STYLE = preload("res://game_data/what_the_horse_game_data/styles/team_2_answer_choice_hover_disabled_style.tres")
const TEAM_2_ANSWER_CHOICE_PRESSED_STYLE = preload("res://game_data/what_the_horse_game_data/styles/team_2_answer_choice_pressed_style.tres")
const DEFAULT_DISABLED_STYLE = preload("res://game_data/what_the_horse_game_data/styles/default_disabled_style.tres")

@export var number: int
@onready var answer_number: Label = %AnswerNumber
@onready var answer: Label = %Answer

signal on_answer_choice_selected(answer_number: int, team: int)

var current_team = 1

func _ready() -> void:
	answer_number.text = str(number)

func change_team(team: int) -> void:
	current_team = team
	
	var pressed_stylebox = null
	var hover_disabled_stylebox = null
	if team == 1:
		pressed_stylebox = TEAM_1_ANSWER_CHOICE_PRESSED_STYLE
		hover_disabled_stylebox = TEAM_1_ANSWER_CHOICE_HOVER_DISABLED_STYLE
	else:
		pressed_stylebox = TEAM_2_ANSWER_CHOICE_PRESSED_STYLE
		hover_disabled_stylebox = TEAM_2_ANSWER_CHOICE_HOVER_DISABLED_STYLE
	
	add_theme_stylebox_override("pressed", pressed_stylebox)
	add_theme_stylebox_override("hover", hover_disabled_stylebox)
	add_theme_stylebox_override("disabled", hover_disabled_stylebox)

func change_text(video: WhatTheHorseVideo) -> void:
	answer.text = video.answer_choices[number - 1]

func change_visibility(visible: bool) -> void:
	self.visible = visible

func _on_pressed() -> void:
	self.disabled = true
	on_answer_choice_selected.emit(self.number, current_team)

func change_to_default_theme() -> void:
	add_theme_stylebox_override("disabled", DEFAULT_DISABLED_STYLE)
