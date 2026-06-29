extends TextureRect

@onready var game_menu_music: AudioStreamPlayer = %GameMenuMusic

func activate_music() -> void:
	game_menu_music.play()
