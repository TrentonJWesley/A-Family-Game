extends Label


func _ready() -> void:
	self.text = str(GameData.team_one_player_count)
	

func _on_team_one_decrease_players_button_pressed() -> void:
	if GameData.team_one_player_count <= 1:
		return
	GameData.team_one_player_count -= 1
	self.text = str(GameData.team_one_player_count)


func _on_team_one_increase_players_button_pressed() -> void:
	if GameData.team_one_player_count >= 6:
		return
	GameData.team_one_player_count += 1
	self.text = str(GameData.team_one_player_count)
