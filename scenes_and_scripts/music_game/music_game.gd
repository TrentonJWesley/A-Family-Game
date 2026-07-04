extends Control

@onready var start_screen: Control = %StartScreen
@onready var song_screen: Control = %SongScreen

@onready var theme_song: AudioStreamPlayer = %ThemeSong

signal end(who_won: int)

var song_dir: String = "res://game_data/music_game_data/songs/"
var song_data: Dictionary

var team_one_score: int  = 0
var team_two_score: int = 0

func _ready() -> void:
	load_song_data()
	check_if_out_of_songs()

func start_music() -> void:
	theme_song.play()

func stop_music() -> void:
	theme_song.stop()

func setup_start_screen(team: int = 1) -> void:
	# Show start screen
	start_screen.visible = true
	song_screen.visible = false
	song_screen.reset()

func _on_start_button_pressed() -> void:
	# Show word screen
	song_screen.visible = true
	# Transition Screens
	song_screen.modulate.a = 0
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(theme_song, "volume_db", -80, 2)
	tween.tween_property(song_screen, "modulate:a", 1, 2)
	tween.tween_property(start_screen, "modulate:a", 0, 2)
	
	await tween.finished
	stop_music()
	theme_song.volume_db = 0
	start_screen.visible = false
	start_screen.modulate.a = 1
	
	# Start word game
	song_screen.start()

func load_song_data() -> void:
	var file = FileAccess.open(song_dir + "song_info.json", FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()
	
	# 3. Parse the JSON string
	var json = JSON.new()
	json.parse(json_string)
		
	# 4. Get the parsed data map
	var raw_data: Dictionary = json.get_data()
	
	# 5. Loop through and build your custom dictionary structure
	for song_name in raw_data:
		var song_info: Dictionary = raw_data[song_name]
		
		# Build the absolute file path (assuming .mp3 extension)
		var full_path : String = song_dir + song_info["file_name"]
		var start_time : float = song_info["start_time"]
		
		# Store into the final database dictionary
		song_data[song_name] = {
			"file_path": full_path,
			"start_time": start_time
		}

func get_song() -> Dictionary:
	var song_list = song_data.keys()
	song_list.shuffle()
	
	var song_name = song_list[0]
	var song = {
		"song_name": song_name,
		"song_path": song_data[song_name]["file_path"],
		"start_time": song_data[song_name]["start_time"]
	}
	
	song_data.erase(song_name)
	
	return song

func check_if_out_of_songs() -> void:
	pass
