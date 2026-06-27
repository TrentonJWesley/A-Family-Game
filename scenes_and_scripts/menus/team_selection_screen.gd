extends Panel


signal on_ready_pressed

func _on_ready_button_pressed() -> void:
	on_ready_pressed.emit()
