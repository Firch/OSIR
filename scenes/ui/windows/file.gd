extends Control

#
# This is JANK (I think). Please rewrite this.
#

@export var File: Script

@onready var FileButton = $Button
@onready var Selection = $Selection
@onready var ClickTimer = $Button/ClickTimer

var enabled: bool = true # Can be interacted with? Change that when dragging
var ghost: bool = false # Is it attached to cursor?

var prepared: bool = false # Will be true when it is just pressed, but will return false after Doubleclick timer finishes

func _ready():
	# Connects:
	FileButton.pressed.connect(_on_click)
	FileButton.focus_entered.connect(_on_focus)
	FileButton.focus_exited.connect(_on_unfocus)
	ClickTimer.timeout.connect(_on_click_timeout)


func _process(delta):
	pass


func _on_focus():
	Selection.visible = true


func _on_unfocus():
	Selection.visible = false
	# Selection.visible = false


func _on_click():
	if enabled:
		
		if prepared == true:
			run()
		
		prepared = true
		ClickTimer.start()


func _on_click_timeout(): # Resets double click
	prepared = false


func run(): # Open the file
	print("Run")
