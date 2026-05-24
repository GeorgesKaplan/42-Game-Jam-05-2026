extends CanvasLayer

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var sprite_2d_2: Sprite2D = $Sprite2D2

var frames:bool = false
var slidin:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if sprite_2d.position.x >= 4766:
		sprite_2d.position.x = sprite_2d_2.position.x - 5692
	elif sprite_2d_2.position.x >= 4766:
		sprite_2d_2.position.x = sprite_2d.position.x - 5692
