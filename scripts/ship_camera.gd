extends Camera2D

# TODO: Fix zoom() to incrementally increase or decrease zoom depending on mouse wheel input

func _input(event: InputEvent) -> void:
	@warning_ignore("unsafe_property_access")
	if event is InputEventMouseButton and event.pressed:
		@warning_ignore("unsafe_property_access")
		if event.button_index == MOUSE_BUTTON_WHEEL_UP :
			print("Scroll wheel up")
			zoom(true)
		@warning_ignore("unsafe_property_access")
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			print("Scroll wheel down")

func zoom(zoom_in: bool) -> void:
	var tween: Tween = create_tween()

	@warning_ignore("return_value_discarded")
	tween.tween_property(
		self,
		"global_position",
		get_viewport().get_mouse_position(),
		0.5
	)
	@warning_ignore("return_value_discarded")
	tween.parallel().tween_property(
		self,
		"zoom",
		Vector2(0.5, 0.5),
		0.5
	)
