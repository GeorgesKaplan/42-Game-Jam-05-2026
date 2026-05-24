extends MarginContainer

@onready var game: Node2D = null
@onready var deck: ScrollContainer = $"../Deck"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Ensure we reliably resolve the Game node (may not be available
	# via the original relative path during instancing order).
	if (game == null):
		var root_scene: Node = get_tree().get_current_scene()
		if (root_scene and root_scene.has_node("Game")):
			game = root_scene.get_node("Game")
		else:
			game = $"../../../Game"


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass


func _on_start_game_button_pressed() -> void:
	FSM.set_state(FSM.State.GAME)
	visible = false
	game.visible = true
	deck.visible = true
