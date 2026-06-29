extends TextureRect

signal on_start_arrow_pressed

@onready var menu_music: AudioStreamPlayer = %MenuMusic
@onready var arrow_pressed_sound: AudioStreamPlayer = %ArrowPressedSound
@onready var start_arrow: TextureButton = %StartArrow
@onready var menu_bus_idx = AudioServer.get_bus_index("Menu Music")

var PITCH_DOWN_EFFECT_DURATION = 1.6

func _on_start_arrow_pressed() -> void:
	on_start_arrow_pressed.emit()
	
	arrow_pressed_sound.play()
	play_menu_transition_sound()
	
	start_arrow.set_disabled(true)


func play_menu_transition_sound():
	var tween = create_tween().set_parallel(true)
	
	# 2. Grab the Audio Effects (Assuming they are the first and second effects)
	var pitch_shift = AudioServer.get_bus_effect(menu_bus_idx, 0) as AudioEffectPitchShift
	var low_pass = AudioServer.get_bus_effect(menu_bus_idx, 1) as AudioEffectLowPassFilter

	# 3. Animate Pitch to drop down (looney tunes effect) and filter to muffle the sound
	tween.tween_property(pitch_shift, "pitch_scale", 0.1, PITCH_DOWN_EFFECT_DURATION)
	tween.tween_property(low_pass, "cutoff_hz", 300, PITCH_DOWN_EFFECT_DURATION)
	# You can also tween the volume to fade it out at the same time
	tween.tween_property(menu_music, "volume_db", -40.0, PITCH_DOWN_EFFECT_DURATION)

	# 4. Wait for the tween to finish, then stop the audio and reset the effects
	await tween.finished
	menu_music.stop()
	
	# Reset values back to normal for the next time the menu opens
	pitch_shift.pitch_scale = 1.0
	low_pass.cutoff_hz = 20500
	menu_music.volume_db = 0.0
