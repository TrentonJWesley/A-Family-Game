extends RichTextLabel


func activate() -> void:
	self.visible = true
	# Fade in animation
	modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 4.0)
