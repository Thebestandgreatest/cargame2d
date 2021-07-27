extends Area2D

signal lap_finished

func _ready():
	pass

func _on_Area2D_body_entered(_body):
	emit_signal("lap_finished")
 
