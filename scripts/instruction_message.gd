extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


func _on_return_button_pressed() -> void:
	visible = false


func _on_instruction_button_pressed() -> void:
	visible = true
