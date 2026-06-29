extends TextureRect

@export var team_num: int = 1
@export var player_num: int = 1

func activate() -> void:
	if team_num == 1:
		var file_path = GameData.team_one_player_pictures[player_num]
		if file_path and FileAccess.file_exists(file_path):
			self.set_texture(load(file_path))
	else:
		var file_path = GameData.team_two_player_pictures[player_num]
		if file_path and FileAccess.file_exists(file_path):
			self.set_texture(load(file_path))
