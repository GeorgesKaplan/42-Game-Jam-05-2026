class_name ItemData
extends Resource

@export var name: String
@export var sprite: Texture2D
@export var illegal: bool
@export var shape: Shape = Shape.SINGLE
## The point of origin where an object is grabbed, in a 3x3 matrix.
## Starts from the bottom left corner.
@export var origin: Array = [1,1]

# TODO: link shape and origin

enum Shape {
	SINGLE,	## 1x1
	TALL,	## 1x2
	LONG,	## 2x1
	SQUARE,	## 2x2
	VTALL,	## 1x3
	VLONG,	## 3x1
	WIDE,	## 3x2
	LARGE,	## 3x3
}

const SHAPE_DATA: Dictionary[Shape, Array] = {
	Shape.SINGLE: [	[0, 0, 0],
					[0, 0, 0],
					[1, 0, 0]],

	Shape.TALL: [	[0, 0, 0],
					[1, 0, 0],
					[1, 0, 0]],

	Shape.LONG: [	[0, 0, 0],
					[0, 0, 0],
					[1, 1, 0]],

	Shape.SQUARE: [	[0, 0, 0],
					[1, 1, 0],
					[1, 1, 0]],

	Shape.VTALL: [	[1, 0, 0],
					[1, 0, 0],
					[1, 0, 0]],

	Shape.VLONG: [	[0, 0, 0],
					[0, 0, 0],
					[1, 1, 1]],

	Shape.WIDE: [	[0, 0, 0],
					[1, 1, 1],
					[1, 1, 1]],

	Shape.LARGE: [	[1, 1, 1],
					[1, 1, 1],
					[1, 1, 1]],
}

func get_shape_data() -> Array:
	return SHAPE_DATA[shape]
