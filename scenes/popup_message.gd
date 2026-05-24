extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_return_game_button_button_up() -> void:
	visible = false

func _on_quitfrom_pause_game_button_button_up() -> void:
	visible = true

func _on_quit_game_button_pressed() -> void:
	get_tree().quit()
