extends TextureButton

@onready var portrait_screen: Control = %PortraitScreen
@onready var mini_game_screen: Control = %MiniGameScreen
@onready var go_to_games_arrow: TextureButton = %GoToGamesArrow
@onready var ORIGINAL_POSITION = position

var BOB_DISTANCE = 20
var BOB_DURATION = 1

func _ready() -> void:
	start_bobbing()
	
	# Connect signals
	pressed.connect(_on_pressed)


func start_bobbing() -> void:
	var tween_bob = create_tween()
	tween_bob.set_loops()
	# Set arrow position
	position.x -= BOB_DISTANCE
	# Move the arrow down
	tween_bob.tween_property(self, "position:x", ORIGINAL_POSITION.x + BOB_DISTANCE, BOB_DURATION)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	# Move the arrow back up to the original position
	tween_bob.tween_property(self, "position:x", ORIGINAL_POSITION.x - BOB_DISTANCE, BOB_DURATION)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
		
func _on_pressed() -> void:
	# Disable button
	self.disabled = true
	self.visible = false
	
	# Get viewport width
	var screen_width = get_viewport_rect().size.x
	var tween_move_screens = create_tween()
	tween_move_screens.set_parallel(true)
	tween_move_screens.tween_property(mini_game_screen, "position:x", screen_width, 1.5)
	
	# Set up MiniGame Screen
	portrait_screen.position.x = -screen_width
	portrait_screen.visible = true
	tween_move_screens.tween_property(portrait_screen, "position:x", 0, 1.5)
	
	await tween_move_screens.finished
	mini_game_screen.visible = false
	go_to_games_arrow.visible = true
	go_to_games_arrow.disabled = false
	
