extends ScrollContainer

@onready var inventory: Inventory = $Inventory

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#inventory.theme.set_constant()
	inventory.init_inventory(3, 12)
