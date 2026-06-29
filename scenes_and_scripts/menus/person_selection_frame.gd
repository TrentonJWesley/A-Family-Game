extends Control

@export var team_num: int = 1
@export var picture_frame_num: int = 1

@onready var photo: TextureRect = %Photo

var FILE_EXTENSIONS = ["jpg", "png"]

var selfie_folder_paths: Array[String] = []
var current_selfie_path: String = ""

func _ready() -> void:
	# Get all selfies
	var selfie_folder_path := "res://images/selfies/"
	var dir := DirAccess.open(selfie_folder_path)
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.get_extension() in FILE_EXTENSIONS:
			selfie_folder_paths.append(selfie_folder_path + file_name)
		file_name = dir.get_next()
	
	# Set current selfie
	var first_selfie_num = wrapi(picture_frame_num, 0, selfie_folder_paths.size())
	set_seflie(first_selfie_num)

func _process(delta: float) -> void:
	if team_num == 1:
		if GameData.team_one_player_count < picture_frame_num:
			if self.visible:
				self.set_visible(false)
		else:
			if not(self.visible):
				self.set_visible(true)
	else:
		if GameData.team_two_player_count < picture_frame_num:
			if self.visible:
				self.set_visible(false)
		else:
			if not(self.visible):
				self.set_visible(true)


func _on_left_arrow_pressed() -> void:
	change_selfie(-1)


func _on_right_arrow_pressed() -> void:
	change_selfie(1)
	
func change_selfie(idx_change: int) -> void:
	var index = selfie_folder_paths.find(current_selfie_path)
	var next_index = wrapi(index + idx_change, 0, selfie_folder_paths.size())
	set_seflie(next_index)
	#current_selfie_path = selfie_folder_paths[next_index]
	#photo.set_texture(load(current_selfie_path))

func set_seflie(idx: int) -> void:
	current_selfie_path = selfie_folder_paths[idx]
	photo.set_texture(load(current_selfie_path))
	if team_num == 1:
		GameData.team_one_player_pictures[picture_frame_num] = current_selfie_path
	else:
		GameData.team_two_player_pictures[picture_frame_num] = current_selfie_path
