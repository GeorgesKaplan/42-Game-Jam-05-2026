extends Control

@onready var inventory: Inventory = $Inventory

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory.init_inventory(14, 4)
	
	var actual_container: GridContainer = inventory.get_node("GridContainer")
	print_debug("actual container child count: ", actual_container.get_child_count())
	#var slot1: ItemSlot = actual_container.get_child(41)
	##slot1.visible = false
	#slot1.hide()
	
	var fake_container: GridContainer = inventory.get_node("GridContainer")
	#var panel1: Panel = fake_container.get_child(41)
	##panel1.visible = false
	#panel1.hide()
