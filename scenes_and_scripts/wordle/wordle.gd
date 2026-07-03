extends Control

@onready var theme_music: AudioStreamPlayer = %ThemeMusic

@onready var start_screen: Control = %StartScreen
@onready var word_screen: Control = %WordScreen

var WORD_LIST: Array[String] = ["DURAG"]

signal end(who_won: int)

var word_list = [
	"durag",
	"twist", "crown", "fresh", "swirl",
	"choir", "blues", "vinyl",
	"grits", "gumbo", "spice",

	"amber", "angle", "ankle", "apron", "baker",
	"basil", "beach", "blend", "brave", "brick",
	"brush", "cable", "canoe", "cedar", "charm",
	"chess", "climb", "cloud", "crane", "dance",
	"drift", "eagle", "flame", "flock", "frame",
	"glide", "grace", "grain", "grove", "harsh",
	"honey", "ideal", "ivory", "joint", "knife",
	"lemon", "light", "mango", "march", "melon",
	"noble", "ocean", "olive", "paint", "pearl",
	"plant", "pride", "quiet", "raven", "river",
	"roast", "scale", "shade", "shine", "skate",
	"smart", "smile", "sound", "spark", "stone",
	"sugar", "table", "toast", "trust", "urban",
	"value", "vivid", "water", "woven", "youth"
]

var starting_team: int = 1
var winning_team: int = 0

func _ready() -> void:
	check_if_out_of_words()

func setup_start_screen(team: int = 1) -> void:
	starting_team = team
	
	# Show start screen
	start_screen.visible = true
	word_screen.visible = false
	
	# Reset variables
	winning_team = 0
	word_screen.reset()


func _on_start_button_pressed() -> void:
	# Start word game
	word_screen.start(starting_team)
	
	# Show word screen
	word_screen.visible = true
	# Transition Screens
	word_screen.modulate.a = 0
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(word_screen, "modulate:a", 1, 1)
	tween.tween_property(start_screen, "modulate:a", 0, 1)
	
	await tween.finished
	start_screen.visible = false
	start_screen.modulate.a = 1
	
func check_if_out_of_words() -> void:
	if word_list.size() < GameData.wordle_game_max_rounds:
		GameData.out_of_wordle_words.emit()

func start_music() -> void:
	theme_music.play()
	
func get_new_word() -> String:
	word_list.shuffle()
	var new_word = word_list[0]
	word_list.remove_at(0)
	return new_word
