extends CharacterBody2D

@export var gravity: float = 800.0 
@export var walk_speed: float = 200.0
@export var jump_speed: float = -400.0

@export var tex_stand: Texture2D
@export var tex_jump: Texture2D
@export var tex_fall: Texture2D
@export var tex_duck: Texture2D
@export var tex_dash: Texture2D

@export var max_jumps: int = 2
var jump_count: int = 0

@export var crouch_speed: float = 80.0
var is_crouching: bool = false

@export var dash_multiplier: float = 2.0
var is_dashing: bool = false

@onready var sprite = $Sprite2D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		jump_count = 0

	if Input.is_action_just_pressed("ui_up") and jump_count < max_jumps:
		velocity.y = jump_speed
		jump_count += 1
		is_crouching = false

	if is_on_floor() and Input.is_action_pressed("ui_down"):
		is_crouching = true
	else:
		is_crouching = false

	is_dashing = Input.is_action_pressed("ui_accept")

	var current_speed = walk_speed
	if is_crouching:
		current_speed = crouch_speed
	elif is_dashing:
		current_speed = walk_speed * dash_multiplier

	var direction = 0
	if Input.is_action_pressed("ui_left"):
		direction = -1
		sprite.flip_h = true
	elif Input.is_action_pressed("ui_right"):
		direction = 1
		sprite.flip_h = false

	velocity.x = direction * current_speed
	
	if not is_on_floor():
		if velocity.y < 0:
			sprite.texture = tex_jump
		else:
			sprite.texture = tex_fall
	else:
		if is_dashing:
			sprite.texture = tex_dash
			
			if direction == -1:
				sprite.flip_h = false
			elif direction == 1:
				sprite.flip_h = true
				
		elif is_crouching:
			sprite.texture = tex_duck
		else:
			sprite.texture = tex_stand

	move_and_slide()
