extends Label

var offset: Vector2 = Vector2(3, 16)


func  _ready():
	set_z_index(2)


func _input(event):
	if event is InputEventMouseMotion:
		position = event.global_position / 2 + offset
