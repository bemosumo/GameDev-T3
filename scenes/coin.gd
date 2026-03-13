extends Area2D

@onready var sfx = $touchplayer
@onready var sprite = $AnimatedSprite2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		sprite.visible = false

		set_deferred("monitoring", false)

		sfx.play()

		await sfx.finished

		queue_free()
