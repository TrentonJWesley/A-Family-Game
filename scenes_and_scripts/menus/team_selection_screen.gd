extends Panel

@onready var intro_sound: AudioStreamPlayer = %IntroSound

signal on_ready_pressed

func play_intro_sound() -> void:
	intro_sound.play()

func _on_ready_button_pressed() -> void:
	on_ready_pressed.emit()
