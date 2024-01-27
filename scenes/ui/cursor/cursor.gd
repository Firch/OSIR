extends RigidBody2D

var normalsens: float = 2
var fastsens: float = 4

var sens: float = normalsens

var opacity: float = 1
var stopped: bool = false


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	gravity_scale = 0
	linear_damp = 100;


func _process(delta):
	$AnimatedSprite2D.modulate.a = opacity;


func _unhandled_input(event):
	if (event is InputEventMouseMotion) and !(stopped):
		apply_central_force(event.relative * sens * 1000)


func _integrate_forces(state):
	rotation_degrees = 0
	position = position.clamp(Vector2.ZERO, get_viewport_rect().size / 2 - $CollisionShape2D.shape.size)
