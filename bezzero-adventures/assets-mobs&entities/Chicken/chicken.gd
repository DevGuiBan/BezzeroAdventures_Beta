extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

@export var move_speed := 30.0
@export var move_distance := 20.0

@export var min_wait := 1.5
@export var max_wait := 4.0

var start_position: Vector2


func _ready():
	randomize()
	start_position = global_position
	play_random_cycle()


func play_random_cycle():
	await idle_time()

	var direction = 1 if randf() < 0.5 else -1
	
	await move_to(start_position + Vector2(move_distance * direction, 0))
	await idle_time()
	await move_to(start_position)

	play_random_cycle()


func idle_time():
	# animation_player.play("idle_chiken")
	await get_tree().create_timer(randf_range(min_wait, max_wait)).timeout


func move_to(target: Vector2):
	# PARA a animação enquanto anda
	animation_player.pause()

	while global_position.distance_to(target) > 2:
		var dir = (target - global_position).normalized()
		velocity = dir * move_speed
		
		if dir.x != 0:
			sprite.flip_h = dir.x > 0
		
		move_and_slide()
		await get_tree().process_frame
	
	velocity = Vector2.ZERO
	
	# quando chega volta a animar
	animation_player.play("idle_chiken")
