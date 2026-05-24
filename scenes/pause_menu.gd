extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

func _pause() -> void:
	FSM.set_state(FSM.State.PAUSE)
	visible = true

func _unpause() -> void:
	visible = false
	FSM.set_state(FSM.State.GAME)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("Pause")):
		if (FSM.current == FSM.State.PAUSE):
			_unpause()
		elif (FSM.current == FSM.State.GAME):
			_pause()

func _on_button_button_up() -> void:
	_unpause()
