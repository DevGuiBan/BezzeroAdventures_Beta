extends CharacterBody2D
class_name skeleton

var _is_dead: bool = false
var _player_ref = null
var _last_direction := Vector2.DOWN

@export_category("Objects")
@export var _animation: AnimationPlayer = null

func _on_detection_area_body_entered(_body) -> void:
	if _body.is_in_group("character"):
		_player_ref = _body

func _on_detection_area_body_exited(_body) -> void:
	if _body.is_in_group("character"):
		_player_ref = null

func _physics_process(_delta: float) -> void:
	if _is_dead:
		return

	if _player_ref != null:
		if _player_ref.is_dead:
			velocity = Vector2.ZERO
		else:
			var _direction: Vector2 = global_position.direction_to(_player_ref.global_position)
			var _distance: float = global_position.distance_to(_player_ref.global_position)
			
			if _distance < 20:
				_player_ref.die()
			
			velocity = _direction * 35
	else:
		# PLAYER SAIU DO RANGE → PARA
		velocity = Vector2.ZERO

	move_and_slide()
	_animate()

func _animate() -> void:
	if _is_dead:
		_animation.play("idle_dead")
		return

	# guarda última direção se estiver andando
	if velocity.length() > 1:
		_last_direction = velocity.normalized()

	var dir := _last_direction

	if velocity.length() < 1:
		if abs(dir.y) > abs(dir.x):
			if dir.y < 0:
				_animation.play("idle_back")
			else:
				_animation.play("idle_front")
		else:
			if dir.x < 0:
				_animation.play("idle_left")
			else:
				_animation.play("idle_right")
		return

	if abs(dir.y) > abs(dir.x):
		if dir.y < 0:
			_animation.play("walk_back")
		else:
			_animation.play("walk_front")
	else:
		if dir.x < 0:
			_animation.play("walk_left")
		else:
			_animation.play("walk_right")
	
func update_health() -> void:
	_is_dead = true
	_animation.play("idle_dead")


func _on_animation_finished(_anim_name: String) -> void:
	queue_free()
