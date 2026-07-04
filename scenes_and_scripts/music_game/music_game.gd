extends Control

@onready var empty_cassette_player: TextureRect = %EmptyCassettePlayer
@onready var cassette_hand: TextureRect = %CassetteHand
@onready var hand_insert_pos: Control = %HandInsertPos

@onready var cassette_insert_sound: AudioStreamPlayer = %CassetteInsertSound

func play_insert_cassette_animation() -> void:
	empty_cassette_player.visible = true
	var org_hand_pos = cassette_hand.global_position
	
	var tween_move_hand = create_tween()
	var new_pos = hand_insert_pos.global_position
	tween_move_hand.tween_property(cassette_hand, "global_position", new_pos, 2)
	
	await tween_move_hand.finished
	
	cassette_insert_sound.play()
	empty_cassette_player.visible = false
	var tween_fade_hand = create_tween()
	tween_fade_hand.set_parallel(true)
	tween_fade_hand.tween_property(cassette_hand, "modulate:a", 0, 3)
	tween_fade_hand.tween_property(cassette_hand, "global_position", org_hand_pos, 3)
	
	await tween_fade_hand.finished
	cassette_hand.modulate.a = 1

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			play_insert_cassette_animation()
	
