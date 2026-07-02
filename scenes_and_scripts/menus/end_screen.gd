extends Control

@onready var end_label: Label = %EndLabel
@onready var reward_screen: Control = %RewardScreen
@onready var mini_game_screen: Control = %MiniGameScreen
@onready var go_to_portraits_arrow: TextureButton = %GoToPortraitsArrow

@onready var mini_game_transition_screen: TextureRect = %MiniGameTransitionScreen
@onready var game_transition_sound: AudioStreamPlayer = %GameTransitionSound
@onready var game_menu_music: AudioStreamPlayer = %GameMenuMusic

var tie = false

func _input(event: InputEvent) -> void:
	if self.visible and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if tie:
				go_to_game_select()
			else:
				show_reward_screen()

func show_reward_screen() -> void:
	reward_screen.visible = true
	reward_screen.modulate.a = 0
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 0, 1)
	tween.tween_property(reward_screen, "modulate:a", 1, 1)
	
	await tween.finished
	self.visible = false
	self.modulate.a = 1

func go_to_game_select() -> void:
	game_transition_sound.play()
	game_menu_music.stop()
	mini_game_transition_screen.play_iris_in(2)
	
	await mini_game_transition_screen.tween.finished
	mini_game_screen.visible = true
	go_to_portraits_arrow.visible = true
	self.visible = false
	mini_game_transition_screen.play_iris_out(3)
	
	
	await mini_game_transition_screen.tween.finished
	game_menu_music.play()
