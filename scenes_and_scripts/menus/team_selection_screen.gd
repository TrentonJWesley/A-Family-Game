extends Panel

@onready var intro_sound: AudioStreamPlayer = %IntroSound
@onready var ready_pressed_sound: AudioStreamPlayer = %ReadyPressedSound

signal on_ready_pressed

func play_intro_sound() -> void:
	intro_sound.play()

func _on_ready_button_pressed() -> void:
	ready_pressed_sound.play()
	on_ready_pressed.emit()
