extends ProgressBar

var is_running: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("TestProgressBar"):
		if value == 100:
			value = 0
		is_running = true       

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_running:
		value += delta
		print(value)
	if value == 100:
		is_running = false
