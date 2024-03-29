extends Node2D

@onready var CursorSFX = $CursorSFX


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("mouse_left"):
		playsound("res://audio/sfx/ui/click.wav")
	if Input.is_action_just_released("mouse_left"):
		playsound("res://audio/sfx/ui/unclick.wav")


func playsound(sound: String):
	CursorSFX.stream = load(sound)
	CursorSFX.play()
