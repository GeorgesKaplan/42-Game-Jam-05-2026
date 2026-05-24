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
## Item's selling value
@export var value: int = 1

enum Shape {
	SINGLE,	## 1x1
	TALL,	## 1x2
	LONG,	## 2x1
	SQUARE,	## 2x2
	VTALL,	## 1x3
	VLONG,	## 3x1
	LVTALL,	## 2x3
	LOWU, ## 3x2-1-2
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

const SHAPE_DATA: Dictionary[Shape, Dictionary] = {
	Shape.SINGLE: {
		"shape_data": [	[0, 0, 0],
						[0, 0, 0],
						[1, 0, 0]],
		"span": Vector2(64, 64),
	},

	Shape.TALL: {
		"shape_data": [	[0, 0, 0],
						[1, 0, 0],
						[1, 0, 0]],
		"span": Vector2(64, 0),
	},

	Shape.LONG: {
		"shape_data": [	[0, 0, 0],
						[0, 0, 0],
						[1, 1, 0]],
		"span": Vector2(2, 1),
	},

	Shape.SQUARE: {
		"shape_data": [	[0, 0, 0],
						[1, 1, 0],
						[1, 1, 0]],
		"span": Vector2(128, 0),
	},

	Shape.VTALL: {
		"shape_data": [	[1, 0, 0],
						[1, 0, 0],
						[1, 0, 0]],
		"span": Vector2(64, -64),
	},

	Shape.VLONG: {
		"shape_data": [	[0, 0, 0],
						[0, 0, 0],
						[1, 1, 1]],
		"span": Vector2(3, 1),
	},

	Shape.LVTALL: {
		"shape_data": [	[1, 1, 0],
						[1, 1, 0],
						[1, 1, 0]],
		"span": Vector2(2, 3),
	},

	Shape.LOWU: {
		"shape_data": [	[0, 0, 0],
						[1, 0, 1],
						[1, 1, 1]],
		"span": Vector2(196, 0),
	},

	Shape.WIDE: {
		"shape_data": [	[0, 0, 0],
						[1, 1, 1],
						[1, 1, 1]],
		"span": Vector2(3, 2),
	},

	Shape.LARGE: {
		"shape_data": [	[1, 1, 1],
						[1, 1, 1],
						[1, 1, 1]],
		"span": Vector2(3, 3),
	},
}

const GRAB_DATA: Dictionary[GrabAnchor, Array] = {
	GrabAnchor.TOP_LEFT: 	[0.25,	0.25],
	GrabAnchor.TOP_MID: 	[0.5,	0.25],
	GrabAnchor.TOP_RIGHT: 	[0.75,	0.25],
	GrabAnchor.MID_LEFT: 	[0.25,	0.5],
	GrabAnchor.MID_MID: 	[0.5,	0.5],
	GrabAnchor.MID_RIGHT: 	[0.75,	0.5],
	GrabAnchor.BOT_LEFT: 	[0.25,	0.75],
	GrabAnchor.BOT_MID: 	[0.5,	0.75],
	GrabAnchor.BOT_RIGHT: 	[0.75,	0.75],
}

func get_shape_data() -> Array:
	return SHAPE_DATA[shape]["shape_data"]

func get_shape_span() -> Vector2:
	return SHAPE_DATA[shape]["span"]

func get_grab_data() -> Array:
	return GRAB_DATA[origin]
