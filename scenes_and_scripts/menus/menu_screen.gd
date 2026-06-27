extends TextureRect

signal on_start_arrow_pressed

@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer

func _on_start_arrow_pressed() -> void:
	on_start_arrow_pressed.emit()
	audio_stream_player.stop()
