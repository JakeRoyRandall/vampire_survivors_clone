extends CharacterBody2D

@export var kobold_speed := 20.0
@export var hp := 10
@export var knockback_recovery = 3.5
var knockback = Vector2.ZERO

@onready var player := get_tree().get_first_node_in_group("player")
@onready var sprite := $sprite2D
@onready var walk := $walk

signal remove_from_array(object)

func _ready():
	walk.play("walk")

func _physics_process(_delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	var direction := global_position.direction_to(player.global_position)
	velocity = direction * kobold_speed
	velocity += knockback
	move_and_slide()

	if direction.x > 0.1:
		sprite.flip_h = true
	elif direction.x < 0.1:
		sprite.flip_h = false


func _on_hurt_box_hurt(damage, angle, knockback_amount):
	hp -= damage
	knockback = angle * knockback_amount
	if hp <= 0:
		emit_signal("remove_from_array", self)
		queue_free()
