extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	FSM.set_state(FSM.State.MENU)
	$Music.play()
	$WaterAmbience.play()
	FSM.on_inspect_started.connect(_play_HaborAmbience)
	FSM.on_inspect_ended.connect(_stop_HaborAmbience)

func _play_HaborAmbience() -> void:
	$HarborAmbience.play()

func _stop_HaborAmbience() -> void:
	$HarborAmbience.stop()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.

@warning_ignore("unused_parameter")

var value: float = 0

func _process(delta: float) -> void:
	value += delta
	if (value >= 1.0):
		value -= 1.0
		if (randf() <= 0.05):
			$BoatCreaking.play()

func _on_quit_game_button_button_up() -> void:
	get_tree().quit()


func _on_quit_game_button_2_button_up() -> void:
	get_tree().quit()
