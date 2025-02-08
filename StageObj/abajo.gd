extends Area2D

signal hit  
# Called when the node enters the scene tree for the first time.


func _on_body_entered(body: Node2D) -> void:
	hit.emit()
