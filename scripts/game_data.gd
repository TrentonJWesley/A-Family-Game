extends Node


var team_one_name: String = "Blue Bandits"
var team_two_name: String = "Red Rebels"

var team_one_player_count: int = 1
var team_two_player_count: int = 1

var team_one_score: int = 0
var team_two_score: int = 0

var team_one_color: Color = Color("3b9aff")
var team_two_color: Color = Color("ff5454")

var team_one_player_pictures: Dictionary = {
	1: null,
	2: null,
	3: null,
	4: null,
	5: null,
	6: null,
}

var team_two_player_pictures: Dictionary = {
	1: null,
	2: null,
	3: null,
	4: null,
	5: null,
	6: null,
}

var horse_game_max_rounds = 6
var wordle_game_max_rounds = 4


signal out_of_horse_cards
