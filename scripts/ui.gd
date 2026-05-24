extends Control


@onready var deck: Deck = $Deck
var inventory: Inventory
var items: Array = [preload("uid://dhai7dnhmy1dr"),
					preload("uid://dqmkssb3t0r0h"),
					preload("uid://kqjii3uku47r"),
					preload("uid://kxh7nqacsek4"),
					preload("uid://bvsdd1kejxb37")]

func _ready() -> void:
	self.inventory = deck.inventory
	var item_slots: Array = inventory.get_node("GridContainer").get_children()
	
	for slot: ItemSlot in item_slots:
		slot.item = items.pick_random()
		
		# TODO: Fill this inventory with random items from `items` array while respecting their `Shape`, i.e, they can't overlap
