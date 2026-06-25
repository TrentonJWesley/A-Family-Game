extends Panel

@onready var win_lose_label: Label = %WinLoseLabel
@onready var defeat_horse_head: PanelContainer = %DefeatHorseHead

@onready var initial_horse_head_position_1: Control = %InitialHorseHeadPosition1
@onready var initial_horse_head_position_2: Control = %InitialHorseHeadPosition2

@onready var win_sound_effect: AudioStreamPlayer = %WinSoundEffect
@onready var lose_sound_effect: AudioStreamPlayer = %LoseSoundEffect
@onready var happy_horse_noises: AudioStreamPlayer = %HappyHorseNoises
@onready var get_a_horse_sound: AudioStreamPlayer = %GetAHorseSound


const HORSE_HEAD = preload("uid://dkh55n37jaqmn")

const MAX_HORSE_HEAD_HEIGHT = 170.0
const HORSE_HEAD_SEPARATION = 180

var horse_head_paths: Array[String] = []

var team_1_horse_head_num = 0
var team_2_horse_head_num = 0

signal on_next_video

# For testing:
#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			#show_result(randi_range(1,2))

func _ready() -> void:
	# Get all horse head file paths
	var horse_heads_folder_path := "res://game_data/what_the_horse_game_data/horse_heads/"
	var dir := DirAccess.open(horse_heads_folder_path)
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.get_extension() == "ogv":
			horse_head_paths.append(horse_heads_folder_path + file_name)
		file_name = dir.get_next()

func show_result(winning_team: int) -> void:
	reset_scene()
	match winning_team:
		1:
			win_lose_label.text = "Team 1 won a Horse Head!!!"
			add_horse_head(winning_team)
		2:
			win_lose_label.text = "Team 2 won a Horse Head!!!"
			add_horse_head(winning_team)
		_:
			win_lose_label.text = "You are both losers :(\nNo Horse Heads for you."
			show_sad_horse_head()

func add_horse_head(team):
	play_happy_noises()
	if horse_head_paths.is_empty():
		push_warning("No horse head videos left!")
		return

	# Pick and remove random horse
	var random_num = randi_range(0, horse_head_paths.size() - 1)
	var horse_head_path = horse_head_paths[random_num]
	horse_head_paths.remove_at(random_num)
	
	# Create horse head
	var new_horse_head = HORSE_HEAD.instantiate() as Control
	self.add_child(new_horse_head)
	
	# Resize horse video
	var video_size = await resize_horse_head_to_max_height(new_horse_head, horse_head_path)
	
	# Set initial horse head position
	var viewport_size = get_viewport().get_size()
	new_horse_head.global_position = Vector2(viewport_size / 2) - Vector2(video_size / 2)
	
	var new_pos = null
	match team:
		1:
			var start_pos = initial_horse_head_position_1.get_global_rect().position
			var offset_pos = start_pos + Vector2(0, HORSE_HEAD_SEPARATION*team_1_horse_head_num)
			new_pos = offset_pos - Vector2(video_size.x/2, 0)
			team_1_horse_head_num += 1
		2: 
			var start_pos = initial_horse_head_position_2.get_global_rect().position
			var offset_pos = start_pos + Vector2(0, HORSE_HEAD_SEPARATION*team_2_horse_head_num)
			new_pos = offset_pos - Vector2(video_size.x/2, 0)
			team_2_horse_head_num += 1
	
	# Slowly move horse head to winning team's side
	var tween_pos = create_tween()
	tween_pos.tween_property(new_horse_head, "global_position", new_pos, 5)
	

func show_sad_horse_head() -> void:
	play_sad_noises()
	defeat_horse_head.set_visible(true)
	defeat_horse_head.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(defeat_horse_head, "modulate:a", 1.0, 5)
	
func reset_scene() -> void:
	defeat_horse_head.set_visible(false)

func stop_all_sounds() -> void:
	win_sound_effect.stop()
	lose_sound_effect.stop()
	happy_horse_noises.stop()
	get_a_horse_sound.stop()

func resize_horse_head_to_max_height(horse_head: Control, horse_head_path: String) -> Vector2:
	var video_player := horse_head.get_node("VideoStreamPlayer") as VideoStreamPlayer

	# Load video without expanding first so Godot can read its natural size.
	video_player.expand = false
	video_player.stream = load(horse_head_path)
	
	# Autoplay not working :(
	video_player.play()

	# Wait one frame so the VideoStreamPlayer updates its minimum size.
	await get_tree().process_frame

	var original_size := video_player.get_combined_minimum_size()

	if original_size.y <= 0:
		push_warning("Could not read video size. Using current node size instead.")
		original_size = video_player.size

	var scale_factor: float = MAX_HORSE_HEAD_HEIGHT / original_size.y
	var final_size: Vector2 = original_size * scale_factor

	# Now force it to the capped size.
	video_player.expand = true
	video_player.custom_minimum_size = final_size
	video_player.size = final_size

	# Also size the horse head container/root.
	horse_head.custom_minimum_size = final_size
	horse_head.size = final_size

	return final_size

func play_happy_noises() -> void:
	win_sound_effect.play()
	happy_horse_noises.play()

func play_sad_noises() -> void:
	lose_sound_effect.play()
	get_a_horse_sound.play()

func _on_next_video_button_pressed() -> void:
	stop_all_sounds()
	on_next_video.emit()
