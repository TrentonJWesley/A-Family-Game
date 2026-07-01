extends TextureRect

@onready var tween: Tween

func _ready():
	# Pass the correct dimensions to the shader so the circle is perfectly round
	material.set_shader_parameter("screen_width", size.x)
	material.set_shader_parameter("screen_height", size.y)

func play_iris_in(duration: float = 1.0):
	# "Looney Tunes" start (walls close in, revealing the center)
	self.visible = true
	material.set_shader_parameter("circle_size", 1.05)
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_method(set_circle_size, 1.05, 0.0, duration)

func play_iris_out(duration: float = 1.0):
	# "Looney Tunes" end (circle shrinks to black)
	material.set_shader_parameter("circle_size", 0.0)
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_method(set_circle_size, 0.0, 1.05, duration)
	
	await tween.finished
	self.visible = false

func set_circle_size(value: float):
	material.set_shader_parameter("circle_size", value)
