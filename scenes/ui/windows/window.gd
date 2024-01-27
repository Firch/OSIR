extends Panel

@export var Text: String

@onready var Title = $Title
@onready var DragBorder = $DragBorderMargins/DragBorder
@onready var CloseButton = $CloseButtonMargins/CloseButton
@onready var CloseButtonSprite = $CloseButtonMargins/CloseButton/CloseButtonSprite

var focused: bool = false # Is it in focus?
var mouseover: bool = false # Is the mouse over the window's dragborder?
var moveable: bool = true # Can it be moved?
var moving: bool = false # Does it move currently?


func _ready():
	# Title:
	if Title.text != null:
		Title.text = Text
		
		
	# Connects:
	DragBorder.button_down.connect(_on_start_drag)
	DragBorder.button_up.connect(_on_end_drag)
	
	focus_entered.connect(focus)
	focus_exited.connect(unfocus)
	
	# Very cool loop that adds focusing-unfocusing for every clickable:
	for clickable in get_tree().get_nodes_in_group("Clickables"):
		if is_ancestor_of(clickable):
			clickable.focus_entered.connect(focus)
			clickable.focus_exited.connect(unfocus)
	
	CloseButton.button_down.connect(_on_closebutton_down)
	CloseButton.button_up.connect(_on_closebutton_up)
	CloseButton.pressed.connect(_on_close)
	
	
	# Unfocus:
	if !focused:
		unfocus()


func _on_start_drag():
	if moveable:
		moving = true
		focus()


func _on_end_drag():
	if moveable:
		moving = false


func _on_closebutton_down():
	CloseButtonSprite.animation = "pressed"
	focus()


func _on_closebutton_up():
	CloseButtonSprite.animation = "default"


func _on_close():
	queue_free()


func focus():
	focused = true
	set_theme_type_variation("Focused")
	move_to_front()


func unfocus():
	focused = false
	set_theme_type_variation("Unfocused")

func _input(event):
	if event is InputEventMouseMotion and moving == true:
		position += event.relative / 2
