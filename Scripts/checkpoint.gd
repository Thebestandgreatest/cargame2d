extends Area2D

signal checkpoint_hit

func _ready():
	pass

func _on_Area2D_body_entered(_body):
	emit_signal("checkpoint_hit")
