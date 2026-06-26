extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	FSM.on_inspect_started.connect(_end)

func _end() -> void:
	visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_re_start_game_button_pressed() -> void:
	visible = false
	FSM.set_state(FSM.State.MENU)
	get_tree().reload_current_scene()
