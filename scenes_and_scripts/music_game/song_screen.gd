extends Control

@onready var play_window: Control = %PlayWindow
@onready var song_reveal_window: Control = %SongRevealWindow
@onready var who_won_window: Control = %WhoWonWindow

@onready var play_pos: Control = %PlayPos
@onready var song_reveal_pos: Control = %SongRevealPos
@onready var who_won_pos: Control = %WhoWonPos


@onready var cassette_insert_sound: AudioStreamPlayer = %CassetteInsertSound
@onready var success_sound: AudioStreamPlayer = %SuccessSound

@onready var empty_cassette_player: TextureRect = %EmptyCassettePlayer
@onready var cassette_hand: TextureRect = %CassetteHand
@onready var hand_insert_pos: Control = %HandInsertPos

@onready var team_one_name: Label = %TeamOneName
@onready var team_one_score_label: Label = %TeamOneScore
@onready var team_two_name: Label = %TeamTwoName
@onready var team_two_score_label: Label = %TeamTwoScore
@onready var round_label: Label = %RoundLabel

var team_one_score: int = 0
var team_two_score: int = 0
var current_round: int = 1

func _ready() -> void:
	team_one_name.text = GameData.team_one_name
	team_two_name.text = GameData.team_two_name
	team_one_name.label_settings.font_color = GameData.team_one_color
	team_two_name.label_settings.font_color = GameData.team_two_color
	
	team_one_score_label.label_settings.font_color = GameData.team_one_color
	team_two_score_label.label_settings.font_color = GameData.team_two_color
	
	round_label.text = "Round %s/%s" % [current_round, GameData.music_game_max_rounds]

func reset() -> void:
	current_round = 1
	team_one_score = 0
	team_two_score = 0
	team_one_score_label.text = str(team_one_score)
	team_two_score_label.text = str(team_two_score)
	round_label.text = "Round %s/%s" % [current_round, GameData.music_game_max_rounds]
	

func start() -> void:
	await play_insert_cassette_animation()
	# Load song for play window
	var song = get_parent().get_song()
	play_window.load_new_song(song)
	song_reveal_window.load_new_song(song)
	# Show Play Window
	pop_up_window(play_window, play_pos.global_position)


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
	
	await cassette_insert_sound.finished

func pop_up_window(window: Control, pos: Vector2) -> void:
	window.scale = Vector2(0, 0)
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(window, "scale", Vector2(1,1), .4)
	tween.tween_property(window, "global_position", pos, .4)

func close_window(window: Control) -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(window, "scale", Vector2(0,0), .4)
	tween.tween_property(window, "global_position", Vector2(0, get_viewport_rect().size.y), .4)
	
	await tween.finished
	window.scale = Vector2(1,1)

func _on_play_window_finished_song() -> void:
	await close_window(play_window)
	await pop_up_window(song_reveal_window, song_reveal_pos.global_position)
	song_reveal_window.play_song()
	pop_up_window(who_won_window, who_won_pos.global_position)


func _on_who_won_window_who_won(team: int) -> void:
	song_reveal_window.stop_song()
	if team > 0:
		success_sound.play()
	
	if team == 1:
		team_one_score += 1
		team_one_score_label.text = str(team_one_score)
	elif team == 2:
		team_two_score += 1
		team_two_score_label.text = str(team_two_score)
	
	await close_window(who_won_window)
	await close_window(song_reveal_window)
	
	
	start_next_song()

func start_next_song() -> void:
	current_round += 1
	
	if current_round > GameData.music_game_max_rounds:
		if team_one_score > team_two_score:
			get_parent().end_game(1)
		elif team_two_score > team_one_score:
			get_parent().end_game(2)
		else:
			get_parent().end_game(0)
		return 
	
	round_label.text = "Round %s/%s" % [current_round, GameData.music_game_max_rounds]
	await play_insert_cassette_animation()
	# Load song for play window
	var song = get_parent().get_song()
	play_window.load_new_song(song)
	song_reveal_window.load_new_song(song)
	# Show Play Window
	pop_up_window(play_window, play_pos.global_position)
