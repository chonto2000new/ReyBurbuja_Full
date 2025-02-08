extends Area2D

signal scored 



func _on_body_entered(body: Node2D) -> void:
	scored.emit()
	queue_free()
