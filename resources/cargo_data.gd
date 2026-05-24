class_name CargoData
extends Resource

@export var content: Array[ItemData]

func get_cargo() -> Array[ItemData]:
	return content
