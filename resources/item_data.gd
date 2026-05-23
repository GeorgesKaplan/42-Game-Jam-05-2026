class_name ItemData
extends Resource

@export var name: String
@export var sprite: Texture2D
## Defines if the object 
@export var illegal: bool
@export var shape: Shape = Shape.SINGLE
## The point of origin where an object is grabbed, in a 3x3 matrix.
## Starts from the bottom left corner.
@export var origin: GrabAnchor = GrabAnchor.MID_MID

enum Shape {
	SINGLE,	## 1x1
	TALL,	## 1x2
	LONG,	## 2x1
	SQUARE,	## 2x2
	VTALL,	## 1x3
	VLONG,	## 3x1
	LVTALL,	## 2x3
	WIDE,	## 3x2
	LARGE,	## 3x3
}

enum GrabAnchor {
	TOP_LEFT,
	TOP_MID,
	TOP_RIGHT,
	MID_LEFT,
	MID_MID,
	MID_RIGHT,
	BOT_LEFT,
	BOT_MID,
	BOT_RIGHT,
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

	Shape.LVTALL: [	[1, 1, 0],
					[1, 1, 0],
					[1, 1, 0]],

	Shape.WIDE: [	[0, 0, 0],
					[1, 1, 1],
					[1, 1, 1]],

	Shape.LARGE: [	[1, 1, 1],
					[1, 1, 1],
					[1, 1, 1]],
}

const GRAB_DATA: Dictionary[GrabAnchor, Array] = {
	GrabAnchor.TOP_LEFT: 	[0,		0],
	GrabAnchor.TOP_MID: 	[0.5,	0],
	GrabAnchor.TOP_RIGHT: 	[1,		0],
	GrabAnchor.MID_LEFT: 	[0,		0.5],
	GrabAnchor.MID_MID: 	[0.5,	0.5],
	GrabAnchor.MID_RIGHT: 	[1,		0.5],
	GrabAnchor.BOT_LEFT: 	[0,		1],
	GrabAnchor.BOT_MID: 	[0.5,	1],
	GrabAnchor.BOT_RIGHT: 	[1,		1],
}

func get_shape_data() -> Array:
	return SHAPE_DATA[shape]

func get_grab_data() -> Array:
	return GRAB_DATA[origin]
