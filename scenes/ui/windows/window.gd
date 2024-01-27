extends PanelContainer

var focused: bool = true # Is it in focus?
var mouseover: bool = false # Is the
var moveable: bool = true
var moving: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.mouse_entered.connect(_on_mouse_enter)
	$Area2D.mouse_exited.connect(_on_mouse_exit)


func _on_mouse_enter():
	print("Mouse entered object " + name)
	mouseover = true


func _on_mouse_exit():
	print("Mouse exited object " + name)
	if moving == false: # There's gonna be delay, we don't want to lose window accidentially when dragging
		mouseover = false


func _process(delta):
	if mouseover and Input.is_action_just_pressed("mouse_left"):
		moving = true;
	if mouseover and Input.is_action_just_released("mouse_left"):
		moving = false;


func _input(event):
	if event is InputEventMouse and moving == true:
		position = event.position
