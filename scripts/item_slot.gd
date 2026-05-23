extends Panel

@onready var item_icon: TextureRect = $ItemIcon
## Defines if the slot is available or not.
## Must be set to false when slot is filled and true when emptied.
var is_empty: bool = true

#func _ready() -> void:
	#print_debug("Node ", self, " holds texture ", item_icon.texture)

func _get_drag_data(_at_position: Vector2) -> Variant:
	if item_icon.texture == null:
		print_debug("Item slot ", self, " is empty") 
		return
	print_debug("Node ", self, " holds texture ", item_icon.texture)
	var item_preview: Panel = self.duplicate()
	var drag_preview: Control = Control.new()
	drag_preview.add_child(item_preview)
	item_preview.position -= Vector2(self.size.x / 2, self.size.y / 2)
	item_preview.self_modulate = Color.TRANSPARENT
	drag_preview.scale = Vector2(0.75, 0.75)
	drag_preview.modulate = Color(drag_preview.modulate, 0.75)
	
	set_drag_preview(drag_preview)
	item_icon.hide()
	return item_icon

func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return is_empty

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	print_debug("Item slot ", self, " received ", data)
	var tmp: Texture = item_icon.texture
	item_icon.texture = data.texture
	data.texture = tmp
	item_icon.show()
	data.show()
