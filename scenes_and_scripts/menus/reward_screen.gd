extends Control

@onready var reward_card_1: Button = %RewardCard1
@onready var reward_card_2: Button = %RewardCard2
@onready var reward_card_3: Button = %RewardCard3

@onready var mini_game_transition_screen: TextureRect = %MiniGameTransitionScreen
@onready var mini_game_screen: Control = %MiniGameScreen
@onready var go_to_portraits_arrow: TextureButton = %GoToPortraitsArrow
@onready var game_menu_music: AudioStreamPlayer = %GameMenuMusic
@onready var game_transition_sound: AudioStreamPlayer = %GameTransitionSound

@onready var portrait_screen: Control = %PortraitScreen
@onready var family_portrait: TextureRect = %FamilyPortrait
@onready var family_portrait_2: TextureRect = %FamilyPortrait2
@onready var portrait_team_one_name: Label = %PortraitTeamOneName
@onready var portrait_team_two_name: Label = %PortraitTeamTwoName

const ACCESSORY = preload("uid://edxf4qxfnh33")


var REWARDS_PATH = "res://images/accessories/"

var reward_file_names: Array[String] = []
var winning_team = 0

func _ready() -> void:
	reward_file_names = get_all_png_files(REWARDS_PATH)
	print(reward_file_names)
	
func display_new_rewards():
	reward_file_names.shuffle()
	reward_card_1.set_reward(REWARDS_PATH, reward_file_names[0])
	reward_card_2.set_reward(REWARDS_PATH, reward_file_names[1])
	reward_card_3.set_reward(REWARDS_PATH, reward_file_names[2])
	toggle_button_disables(false)


func get_all_png_files(folder_path: String) -> Array[String]:
	var filtered_files: Array[String] = []
	
	if DirAccess.dir_exists_absolute(folder_path):
		var all_files = DirAccess.get_files_at(folder_path)
		
		for file_name in all_files:
			# Check for .png OR .png.import (handling the export bug mentioned before)
			if file_name.ends_with(".png") or file_name.ends_with(".png.import"):
				# Clean up the extension if Godot remapped it to .import
				var clean_name = file_name.replace(".import", "")
				
				# Prevent adding duplicates if both .png and .png.import exist in the editor
				if not filtered_files.has(clean_name):
					filtered_files.append(clean_name)
	else:
		print("Directory does not exist!")
		
	return filtered_files

func toggle_button_disables(disable: bool):
	reward_card_1.disabled = disable
	reward_card_2.disabled = disable
	reward_card_3.disabled = disable

func _on_reward_card_1_pressed() -> void:
	toggle_button_disables(true)
	add_reward_to_portrait(reward_card_1.reward_name)
	show_portrait()
	reward_file_names.remove_at(0)


func _on_reward_card_2_pressed() -> void:
	toggle_button_disables(true)
	add_reward_to_portrait(reward_card_2.reward_name)
	show_portrait()
	reward_file_names.remove_at(1)

func _on_reward_card_3_pressed() -> void:
	toggle_button_disables(true)
	add_reward_to_portrait(reward_card_3.reward_name)
	show_portrait()
	reward_file_names.remove_at(2)

func show_portrait() -> void:
	
	setup_enlarged_portrait()
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 0, 1)
	tween.tween_property(portrait_screen, "modulate:a", 1, 1)
	
	await tween.finished
	self.visible = false
	self.modulate.a = 1


var portrait_original_pos: Vector2 = Vector2(0, 0)
var portrait_original_scale: Vector2 = Vector2(0, 0)
var label_original_pos: Vector2 = Vector2(0, 0)
func setup_enlarged_portrait() -> void:
	family_portrait.hide_score()
	family_portrait_2.hide_score()
	portrait_screen.visible = true
	portrait_screen.modulate.a = 0
	if winning_team == 1:
		family_portrait_2.visible = false
		portrait_team_two_name.visible = false
		# Save original settings
		portrait_original_pos = family_portrait.global_position
		portrait_original_scale = family_portrait.scale
		label_original_pos = portrait_team_one_name.global_position
		# Change settings
		family_portrait.scale = Vector2(1, 1)
		family_portrait.global_position = Vector2(229, 0)
		portrait_team_one_name.global_position = Vector2(492.16, 0)
	elif winning_team == 2:
		family_portrait.visible = false
		portrait_team_one_name.visible = false
		# Save original settings
		portrait_original_pos = family_portrait_2.global_position
		portrait_original_scale = family_portrait_2.scale
		label_original_pos = portrait_team_two_name.global_position
		# Change settings
		family_portrait_2.scale = Vector2(1, 1)
		family_portrait_2.global_position = Vector2(229, 0)
		portrait_team_two_name.global_position = Vector2(492.16, 0)
		


func restore_portraits() -> void:
	family_portrait.visible = true
	family_portrait_2.visible = true
	portrait_team_one_name.visible = true
	portrait_team_two_name.visible = true
	if winning_team == 1:
		family_portrait.scale = portrait_original_scale
		family_portrait.global_position = portrait_original_pos
		portrait_team_one_name.global_position = label_original_pos
	elif winning_team == 2:
		family_portrait_2.scale = portrait_original_scale
		family_portrait_2.global_position = portrait_original_pos
		portrait_team_two_name.global_position = label_original_pos

func add_reward_to_portrait(reward_name) -> void:
	# Create accessory
	var accessory = ACCESSORY.instantiate() as TextureRect
	accessory.set_texture(load("res://images/accessories/%s" % reward_name))
	accessory.finished.connect(_on_accessory_finished)
	if winning_team == 1:
		family_portrait.add_child(accessory)
		accessory.global_position = family_portrait.global_position + family_portrait.size * family_portrait.scale / 2
	elif winning_team == 2:
		family_portrait_2.add_child(accessory)
		accessory.global_position = family_portrait_2.global_position + family_portrait.size * family_portrait.scale / 2

func _on_accessory_finished() -> void:
	game_transition_sound.play()
	game_menu_music.stop()
	mini_game_transition_screen.play_iris_in(2)
	
	await mini_game_transition_screen.tween.finished
	restore_portraits()
	mini_game_screen.visible = true
	go_to_portraits_arrow.visible = true
	family_portrait.update_score()
	family_portrait_2.update_score()
	
	mini_game_transition_screen.play_iris_out(3)
	
	await mini_game_transition_screen.tween.finished
	game_menu_music.play()
	
