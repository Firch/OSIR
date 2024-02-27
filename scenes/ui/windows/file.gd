# Please rewrite that so it uses actual doubleclick

extends Control

@export var Text: String
@export var IconImage: CompressedTexture2D
@export var File: Script

@onready var Title = $Title
@onready var Icon = $Button/CenterContainer/Icon

@onready var FileButton = $Button
@onready var Selection = $Selection
@onready var ClickTimer = $Button/ClickTimer

@onready var Fileghost = preload("res://scenes/ui/windows/fileghost.tscn")

var enabled: bool = true # Can be interacted with? Change that when dragging
var prepared: bool = false # Will be true when it is just pressed, but will return false after Doubleclick timer finishes

func _ready():
	# Title:
	if Text != '':
		Title.text = Text
	
	
	# Icons:
	if IconImage != null:
		Icon.texture = IconImage
	
	
	# Connects:
	FileButton.pressed.connect(_on_click)
	ClickTimer.timeout.connect(_on_click_timeout)


func _process(delta):
	pass


func _input(event):
	if Input.is_action_just_pressed("mouse_left") and FileButton.is_hovered():
		var FileghostInstance = Fileghost.instantiate()
		FileghostInstance.Text = Title.text
		FileghostInstance.IconImage = Icon.texture
		add_child(FileghostInstance)


func _on_click():
	if enabled:
		Selection.visible = true
		
		if prepared == true:
			run()
		
		prepared = true
		ClickTimer.start()


func _on_click_timeout(): # Resets double click
	prepared = false


func run(): # Open the file
	print("Run")
