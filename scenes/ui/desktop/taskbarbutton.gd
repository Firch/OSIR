extends Control

var IconImage: CompressedTexture2D

var App: Node

@onready var Icon = $ButtonSprite/Icon

@onready var AppButton = self
@onready var ButtonSprite = $ButtonSprite


func _ready():
	Icon.texture = App.IconImage
	
	AppButton.button_down.connect(_on_button_down)
	AppButton.button_up.connect(_on_button_up)
	
	AppButton.pressed.connect(_on_button_pressed)


func _on_button_down():
	ButtonSprite.theme_type_variation = "ButtonPressed"


func _on_button_up():
	ButtonSprite.theme_type_variation = "ButtonIdle"


func _on_button_pressed():
	if !App.enabled:
		App._on_maximize()
	App.focus()
