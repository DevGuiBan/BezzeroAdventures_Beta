extends Area2D
class_name DoorComponent2

var _player_ref: Character = null

@export_category("Variables")
@export var _teleport_position: Vector2

#1600 1280

@export_category("Objects")

func _on_body_entered(_body) -> void:
	if _body is Character:
		_player_ref = _body
		_player_ref.global_position = _teleport_position
		print("A")
