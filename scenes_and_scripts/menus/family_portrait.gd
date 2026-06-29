extends TextureRect

@export var team_num: int = 1

@onready var photo: TextureRect = %Photo

@onready var player_count_1: Control = $PlayerCount1
@onready var player_count_2: Control = $PlayerCount2
@onready var player_count_3: Control = $PlayerCount3
@onready var player_count_4: Control = $PlayerCount4
@onready var player_count_5: Control = $PlayerCount5
@onready var player_count_6: Control = $PlayerCount6


func _ready() -> void:
	change_player_pic_teams(team_num)
	
	# Get player count
	var player_count = 0
	if team_num == 1:
		player_count = GameData.team_one_player_count
	else:
		player_count = GameData.team_two_player_count
		
	# Load family portrait
	var file_path = "res://images/family_portraits/family_portrait_%s.png" % player_count
	photo.set_texture(load(file_path))
	
	# Show correct Player Pictures
	match player_count:
		1:
			player_count_1.set_visible(true)
		2:
			player_count_2.set_visible(true)
		3:
			player_count_3.set_visible(true)
		4:
			player_count_4.set_visible(true)
		5:
			player_count_5.set_visible(true)
		6:
			player_count_6.set_visible(true)
	

func change_player_pic_teams(num: int) -> void:
	var internal_pics = find_children("*", "TextureRect", true, false)
	
	for child in internal_pics:
		if "team_num" in child: 
			child.team_num = num
			if child.has_method("activate"):
				child.activate()
