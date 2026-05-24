extends Camera2D

func _input(event: InputEvent) -> void:
	@warning_ignore("unsafe_property_access")
	if event is InputEventMouseButton and event.pressed:
		@warning_ignore("unsafe_property_access")
		if event.button_index == MOUSE_BUTTON_WHEEL_UP :
			print("Scroll wheel up")
			zoom_in(true)
		@warning_ignore("unsafe_property_access")
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			print("Scroll wheel down")
			zoom_in(false)

func zoom_in(is_in: bool) -> void:
	var zoom_step: float = 0.14
	var target_zoom: Vector2 = self.zoom

	if is_in:
		target_zoom += Vector2.ONE * zoom_step
		if target_zoom >= Vector2(1.0, 1.0):
			target_zoom = Vector2(1.0, 1.0)
	else:
		target_zoom -= Vector2.ONE * zoom_step
		if target_zoom <= Vector2(0.2, 0.2):
			target_zoom = Vector2(0.2, 0.2)

	var tween: Tween = create_tween()

	#@warning_ignore("return_value_discarded") # BUG: Chaotic zoom
	#tween.tween_property(
		#self,
		#"global_position",
		#get_viewport().get_mouse_position(),
		#0.5
	#)
	@warning_ignore("return_value_discarded")
	tween.tween_property(
		self,
		"zoom",
		target_zoom,
		0.5
	)
