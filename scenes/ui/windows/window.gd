extends PanelContainer

var focused: bool = true # Is it in focus?
var mouseover: bool = false # Is the mouse over the window's dragborder?
var moveable: bool = true # Can it be moved?
var moving: bool = false # Does it move currently?


func _ready():
	$DragBorder.mouse_entered.connect(_on_mouse_enter)
	$DragBorder.mouse_exited.connect(_on_mouse_exit)


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
	if event is InputEventMouseMotion and moving == true:
		position += event.relative / 2
