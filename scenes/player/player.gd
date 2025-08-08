extends CharacterBody2D

##################################################
const MOVING_SPEED = 100.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite = $AnimatedSprite2D

var blink_on: bool = false
var blink_timer: float = 0.0
var blink_interval: float = 0.3

##################################################
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		animated_sprite.play("jump")

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var x_direction := Input.get_axis("ui_left", "ui_right")
	if x_direction:
		velocity.x = x_direction * MOVING_SPEED
		if x_direction > 0:
			animated_sprite.flip_h = false
		elif x_direction < 0:
			animated_sprite.flip_h = true
		
		if is_on_floor():
			animated_sprite.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, MOVING_SPEED)
		if is_on_floor():
			animated_sprite.play("idle")

	move_and_slide()

##################################################
func _process(delta: float) -> void:
	blink_timer += delta
	if blink_timer >= blink_interval:
		blink_timer = 0.0
		blink_on = not blink_on
		
		var alpha: float = 0.0
		if blink_on:
			alpha = 1.0
		else:
			alpha = 0.0
		
		var current_color = \
			animated_sprite.material.get_shader_parameter("outline_color")
		current_color.w = alpha
		animated_sprite.material.set_shader_parameter("outline_color", \
														current_color)
