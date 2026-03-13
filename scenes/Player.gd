extends CharacterBody2D

@export var speed := 200.0
@export var jump_speed := -400.0
@export var gravity := 1200.0
@export var max_jumps: int = 2
@export var crouch_speed: float = 80.0
@export var dash_multiplier: float = 2.0

var jump_count: int = 0
var is_crouching: bool = false
var is_dashing: bool = false
var was_on_wall: bool = false

@onready var animplayer = $Sprite2D
@onready var jump_sfx = $jump
@onready var land_sfx = $land
@onready var wall_sfx = $bump


func _get_input():
	if Input.is_action_just_pressed("ui_up") and jump_count < max_jumps:
		velocity.y = jump_speed
		jump_count += 1
		is_crouching = false
		land_sfx.stop()
		jump_sfx.play()

	if Input.is_action_just_released("ui_up"):
		land_sfx.play()

	is_crouching = is_on_floor() and Input.is_action_pressed("ui_down")
	is_dashing = Input.is_action_pressed("ui_accept")

	var current_speed = speed
	if is_crouching:
		current_speed = crouch_speed
	elif is_dashing:
		current_speed = speed * dash_multiplier

	var direction := Input.get_axis("ui_left", "ui_right")
	var animation = "idle"

	if direction:
		velocity.x = direction * current_speed

		if not is_crouching and not is_dashing:
			animation = "walk right"

		if direction > 0:
			animplayer.flip_h = false
		else:
			animplayer.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)

	if not is_on_floor():
		if velocity.y < 0:
			animation = "jump"
		else:
			animation = "fall"
	else:
		if is_dashing:
			animation = "dash"
			if direction < 0:
				animplayer.flip_h = false
			elif direction > 0:
				animplayer.flip_h = true
		elif is_crouching:
			animation = "duck"

	if animplayer.sprite_frames.has_animation(animation):
		if animplayer.animation != animation:
			animplayer.play(animation)
	else:
		if animplayer.sprite_frames.has_animation("idle") and animplayer.animation != "idle":
			animplayer.play("idle")


func _physics_process(delta: float) -> void:
	velocity.y += delta * gravity
	_get_input()

	move_and_slide()

	if is_on_floor():
		jump_count = 0

	if is_on_wall() and not was_on_wall:
		wall_sfx.play()

	was_on_wall = is_on_wall()
