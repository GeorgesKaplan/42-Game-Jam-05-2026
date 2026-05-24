extends ProgressBar

var is_running: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	@warning_ignore("unsafe_property_access", "unsafe_method_access")
	FSM.on_game_started.connect(_start)
	FSM.on_game_paused.connect(_pause)
	FSM.on_game_unpaused.connect(_unpause)

func _start() -> void:
	if value == 100:
		value = 0
	is_running = true

func _pause() -> void:
	is_running = false

func _unpause() -> void:
	is_running = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_running:
		value += delta
		print(value)
	if value == 100:
		is_running = false
		FSM.set_state(FSM.State.INSPECT)
