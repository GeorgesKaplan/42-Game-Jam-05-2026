class_name Deck
extends ScrollContainer

@onready var inventory: Inventory = $Inventory
const Loading: Resource = preload("uid://bsdh43ptepor8")

@export var x:int = 12
@export var y:int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#inventory.theme.set_constant()
	inventory.init_inventory(36, 6)
