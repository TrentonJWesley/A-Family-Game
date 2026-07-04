extends Control

@onready var song_player: AudioStreamPlayer = %Song

@onready var song_name: RichTextLabel = %SongName

var is_dragging: bool = false
var drag_offset: Vector2

var song_start: int = 0

func play_song() -> void:
	song_player.play(song_start)

func stop_song() -> void:
	song_player.stop()

func load_new_song(song: Dictionary) -> void:
	var song_path = song["song_path"]
	song_name.text = song["song_name"]
	song_player.stream = load(song_path)
	song_start = song["start_time"]

func _input(event: InputEvent) -> void:
	# Start dragging when clicked
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and get_global_rect().has_point(event.position):
				is_dragging = true
				drag_offset = global_position - get_global_mouse_position()
			elif not event.pressed:
				is_dragging = false
	# Move the node with the mouse
	elif event is InputEventMouseMotion and is_dragging:
		global_position = get_global_mouse_position() + drag_offset
