extends VideoStreamPlayer

enum window_type {
	DEFAULT, LANDSCAPE, PORTRAIT, SQUARE
}

var window_type_dimensions: Dictionary = {
	window_type.LANDSCAPE: {
		"width": 1778,
		"length": 1000
	},
	window_type.PORTRAIT: {
		"width": 562.5,
		"length": 1000
	},
	window_type.SQUARE: {
		"width": 1000,
		"length": 1000
	}
}

signal on_pause
signal on_finish

@export var window: window_type = window_type.DEFAULT

enum states {
	START, STARTING, PAUSED, FINISHING, FINISHED
}
var current_state: states = states.START

var video_start = 0
var video_pause = 0
var video_end = INF

func initialize(video: WhatTheHorseVideo) -> void:
	current_state = states.START
	# Set Video file
	var video_resource = load(video.file_path)
	self.stream = video_resource
	# Set video window type
	if video.window_type == "square":
		window = window_type.SQUARE
	elif video.window_type == "portrait":
		window = window_type.PORTRAIT
	elif video.window_type == "landscape":
		window = window_type.LANDSCAPE
	set_window_size()
	# Set video settings
	video_start = video.video_start
	video_pause = video.video_pause
	video_end = video.video_end

func set_window_size() -> void:
	var x = window_type_dimensions[window]["width"]
	var y = window_type_dimensions[window]["length"]
	self.size = Vector2(x, y)

func start_video() -> void:
	current_state = states.STARTING
	self.set_stream_position(video_start)
	self.play()

func _process(delta: float) -> void:
	if current_state == states.STARTING and self.stream_position >= video_pause:
		current_state = states.PAUSED
		on_pause.emit()
		self.set_paused(true)
	if current_state == states.FINISHING and self.stream_position >= video_end:
		current_state = states.FINISHED
		on_finish.emit()
		self.stop()
	if current_state == states.FINISHING and not(self.is_playing()):
		current_state = states.FINISHED
		on_finish.emit()

func unpause_video() -> void:
	current_state = states.FINISHING
	self.set_paused(false)
