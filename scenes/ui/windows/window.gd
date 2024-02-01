extends Panel

@export var Text: String
@export var IconImage: CompressedTexture2D

@export var Minimizeable: bool = true # Is minimize button here?
@export var Closeable: bool = true # Is close button here?
@export var Moveable: bool = true # Can it be moved?

@onready var Title = $Title
@onready var Icon = $Icon

@onready var DragBorder = $DragBorderMargins/DragBorder
@onready var CloseButton = $CloseButtonMargins/CloseButton
@onready var CloseButtonSprite = $CloseButtonMargins/CloseButton/CloseButtonSprite
@onready var MinimizeButton = $MinimizeButtonMargins/MinimizeButton
@onready var MinimizeButtonSprite = $MinimizeButtonMargins/MinimizeButton/MinimizeButtonSprite

@onready var AppearingTimer = $AppearingTimer
@onready var DisappearingTimer = $DisappearingTimer

@onready var Audio = $AudioStreamPlayer

@onready var Taskbar = get_parent().get_node("Taskbar/HBoxContainer")
@onready var TaskbarButton = preload("res://scenes/ui/desktop/taskbarbutton.tscn")
@onready var ButtonInstance = TaskbarButton.instantiate()


var focused: bool = false # Is it in focus?
var mouseover: bool = false # Is the mouse over the window's dragborder?
var moving: bool = false # Does it move currently?

var enabled: bool = true # Can be interacted with? Change that when calling enable() and disable()

var opening: bool = true # Is currently opening? That's for animations
var closing: bool = false # Is currently closing? That's for animations
var minimizing: bool = false # Is currently minimizing? That's for animations

var minimized: bool = false # Is currently inchang MINIMIZED state?

func _ready():
	# Title:
	if Title.text != null:
		Title.text = Text
	
	
	# Icons:
	if IconImage != null:
		Icon.texture = IconImage
	else:
		Icon.queue_free()
		Title.position.x -= 19
	
	
	# Settings:
	if opening:
		modulate.a = 0.0
	if not Minimizeable:
		MinimizeButton.queue_free()
	if not Closeable:
		CloseButton.queue_free()
	if not Moveable:
		DragBorder.queue_free()
		set_theme_type_variation("Nonmoveable")
	
	
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
	
	MinimizeButton.button_down.connect(_on_minimizebutton_down)
	MinimizeButton.button_up.connect(_on_minimizebutton_up)
	MinimizeButton.pressed.connect(_on_minimize)
	
	AppearingTimer.timeout.connect(appeared)
	DisappearingTimer.timeout.connect(disappeared)
	
	
	# Unfocus:
	if !focused:
		unfocus()
	
	
	# Taskbar:
	if Moveable:
		ButtonInstance.App = self
		Taskbar.add_child(ButtonInstance)


func appeared(): # Called when OpeningTimer ended. That means appearing transition is ended.
	opening = false
	modulate.a = 1
	print("Window '" + name + "' opened!")


func disappeared(): # Called when ClosingTimer ended. That means disappearing transition is ended.
	if closing == true:
		print("Window '" + name + "' closed!")
		queue_free()
	if minimizing == true:
		modulate.a = 0
		minimizing = false;
		minimized = true;
		print("Window '" + name + "' minimized!")


func _process(delta):
	# Closing & Opening animations
	if opening:
		modulate.a = 0.5
	if closing:
		modulate.a = 0.5
	if minimizing:
		modulate.a = 0.5
		# position.y += 10
		# scale /= 1.2
	
	
	# Debug open window
	#if Input.is_action_just_pressed("ui_accept"):
	#	if minimized:
	#		_on_maximize()


func _on_start_drag():
	if Moveable:
		moving = true
		focus()


func _on_end_drag():
	if Moveable:
		moving = false


func _on_closebutton_down(): # Called when close button is down - only for animations!
	CloseButtonSprite.animation = "pressed"
	focus()


func _on_closebutton_up(): # Called when close button is up - only for animations!
	CloseButtonSprite.animation = "default"


func _on_close(): # Called when close button is pressed, closing the window.
	closing = true
	unfocus()
	DisappearingTimer.start()
	playsound("res://audio/sfx/ui/remove.wav")
	ButtonInstance.queue_free()
	disable()


func _on_minimizebutton_down(): # Called when minimize button is down - only for animations!
	MinimizeButtonSprite.animation = "pressed"
	focus()


func _on_minimizebutton_up(): # Called when minimize button is up - only for animations!
	MinimizeButtonSprite.animation = "default"


func _on_minimize(): # Called when minimize button is pressed, minimizing the window.
	opening = false
	minimizing = true
	unfocus()
	DisappearingTimer.start()
	
	playsound("res://audio/sfx/ui/remove.wav")
	disable()


func _on_maximize(): 
	# Called by taskbar to maximize
	minimizing = false
	minimized = false;
	opening = true
	AppearingTimer.start()
	playsound("res://audio/sfx/ui/appear.wav")
	enable()


func focus():
	grab_focus()
	if focused == false:
		if Moveable:
			set_theme_type_variation("Focused")
		move_to_front()
		
		focused = true
		
		print("Focus on window '" + name + "'!")


func unfocus():
	focused = false
	if Moveable:
		set_theme_type_variation("Unfocused")


func enable(): # Reverts disable().
	enabled = true
	
	set_z_index(0); # Ordering magic - used for disappearance animation
	get_parent().move_child(self, get_parent().get_child_count())
	
	focus_entered.connect(focus)
	focus_exited.connect(unfocus)
	
	for clickable in get_tree().get_nodes_in_group("Clickables"):
		if is_ancestor_of(clickable):
			clickable.disabled = false
			
			clickable.focus_entered.connect(focus)
			clickable.focus_exited.connect(unfocus)
	mouse_filter = Control.MOUSE_FILTER_PASS


func disable(): # Disables window's functionality.
	enabled = false
	
	set_z_index(1); # Ordering magic - used for disappearance animation
	get_parent().move_child(self, 0)
	
	focus_entered.disconnect(focus)
	focus_exited.disconnect(unfocus)
	
	for clickable in get_tree().get_nodes_in_group("Clickables"):
		if is_ancestor_of(clickable):
			clickable.disabled = true
			
			clickable.focus_entered.disconnect(focus)
			clickable.focus_exited.disconnect(unfocus)
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func change_font(font: FontFile):
	Title.label_settings.set_font(font)
	print("Applied '" + str(font) + "' font to window '" + name + "'!")


func playsound(sound: String):
	Audio.stream = load(sound)
	Audio.play()


func _input(event):
	if event is InputEventMouseMotion and moving == true:
		position += event.relative / 2 # Dragging
