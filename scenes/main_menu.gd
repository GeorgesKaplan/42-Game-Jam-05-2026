extends MarginContainer

@onready var game: Node2D = $"../../../Game"
@onready var deck: ScrollContainer = $"../Deck"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_game_button_pressed() -> void:
	FSM.set_state(FSM.State.GAME)
	visible = false
	game.visible = true
	deck.visible = true
