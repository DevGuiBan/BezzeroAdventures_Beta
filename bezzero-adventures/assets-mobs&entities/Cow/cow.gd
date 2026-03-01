extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

@export var move_speed := 40.0
@export var move_distance := 40.0

@export var min_wait := 1.5
@export var max_wait := 4.0

var start_position: Vector2


func _ready():
	randomize()
	start_position = global_position
	sprite.flip_h = false
	cycle()

func cycle():
	while true:
		# ANDA PARA ESQUERDA
		sprite.flip_h = false
		await move_to(start_position + Vector2(-move_distance, 0))
		
		await wait_time()
		
		# ANDA PARA DIREITA
		sprite.flip_h = true
		await move_to(start_position)
		
		await wait_time()


func wait_time():
	velocity = Vector2.ZERO
	# animation_player.play("idle_cow")
	
	await get_tree().create_timer(randf_range(min_wait, max_wait)).timeout


func move_to(target: Vector2):
	animation_player.play("walk_cow_left")
	
	while global_position.distance_to(target) > 2:
		var dir = (target - global_position).normalized()
		velocity = dir * move_speed
		
		move_and_slide()
		await get_tree().process_frame
	
	velocity = Vector2.ZERO
