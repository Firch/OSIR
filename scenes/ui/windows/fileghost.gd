extends Control

var Text: String
var IconImage: CompressedTexture2D

@onready var Title = $Title
@onready var Icon = $CenterContainer/Icon

func _ready():
	Title.text = Text
	Icon.texture = IconImage
	
	set_z_index(2)

func _input(event):
	if event is InputEventMouseMotion:
		position += event.relative / 2 # Dragging

func _process(delta):
	if not Input.is_action_pressed("mouse_left"):
		queue_free()
