extends ScrollContainer

@export var scroll_speed: int = 100
@onready var card_title: RichTextLabel = $CardTitle

var text_loop_width: float = 0.0
var precise_scroll: float = 0.0

func _ready() -> void:
	# 1. Store the raw BBCode text to duplicate the visual tags properly
	var original_bbcode = card_title.text
	card_title.text = original_bbcode + "             " + original_bbcode
	
	# Wait one frame for the text engine to parse the new tags
	await get_tree().process_frame
	
	# 2. Get the clean text WITHOUT BBCode tags for the measurement
	var clean_text_segment = card_title.get_parsed_text().split("             ")[0] + "             "
	
	# 3. Measure ONLY the actual visible characters + the trailing space gap
	var font = card_title.get_theme_font("normal_font")
	var font_size = card_title.get_theme_font_size("normal_font_size")
	text_loop_width = font.get_string_size(clean_text_segment, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x


func _process(delta: float) -> void:
	# 1. Accumulate the precise floating-point movement
	precise_scroll += scroll_speed * delta
	
	# 2. Apply the integer portion to the container's scrollbar
	scroll_horizontal = int(precise_scroll)
	
	# 3. Check for the loop condition using the precise float value
	if text_loop_width > 0 and precise_scroll >= text_loop_width:
		precise_scroll = 0.0
		scroll_horizontal = 0
