extends Control

@onready var song_player: AudioStreamPlayer = %Song
@onready var progress_bar: HSlider = %ProgressBar
@onready var seconds_label: RichTextLabel = %SecondsLabel

var is_dragging: bool = false
var drag_offset: Vector2

@export var PAUSE_TIMES = [.5, 1, 2, 4, 8, 30]

var current_pause_idx = 0
var song_start = 0

signal finished_song

func _ready() -> void:
	seconds_label.text = ""
	song_start = 0

func load_new_song(song: Dictionary) -> void:
	seconds_label.text = ""
	current_pause_idx = 0
	var song_path = song["song_path"]
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

func _process(delta: float) -> void:
	if song_player.playing == true:
		var song_time = song_player.get_playback_position()
		# Update slider
		progress_bar.change_value(song_time)
		if song_time >= PAUSE_TIMES[current_pause_idx]:
			song_player.stream_paused = true

func _on_play_button_pressed() -> void:
	update_seconds_label()
	song_player.stop()
	song_player.play(song_start)

func _on_prev_button_pressed() -> void:
	current_pause_idx = max(current_pause_idx - 1, 0)
	update_seconds_label()

func _on_next_button_pressed() -> void:
	current_pause_idx = min(current_pause_idx + 1, PAUSE_TIMES.size() - 1)
	update_seconds_label()

func update_seconds_label() -> void:
	var seconds_text = str(PAUSE_TIMES[current_pause_idx]) + "s"
	seconds_label.text = "[rainbow freq=0.5 sat=0.8 val=0.8 speed=1.0]%s[/rainbow]" % seconds_text


func _on_exit_button_pressed() -> void:
	song_player.stop()
	progress_bar.change_value(0)
	finished_song.emit()
