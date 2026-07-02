extends PanelContainer

@onready var default_global_pos = self.get_global_position()

func reveal_answer(new_global_pos: Vector2) -> void:
	# Reset horse
	self.set_position(default_global_pos)
	self.scale = Vector2(1, 1)
	self.modulate.a = 1.0
	
	self.visible = true
	# Fade in animation
	var tween_pos = create_tween()
	var tween_scale = create_tween()
	var tween_a = create_tween()
	var adjusted_position = new_global_pos + Vector2(15, 15)
	tween_pos.tween_property(self, "global_position", adjusted_position, 4.0)
	tween_scale.tween_property(self, "scale", Vector2(0.3, 0.3), 4.0)
	tween_a.tween_property(self, "modulate:a", 0.70, 4.0)
