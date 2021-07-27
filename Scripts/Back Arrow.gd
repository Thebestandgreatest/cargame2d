extends TextureButton


func _ready():
	pass


func _on_Back_Arrow_pressed():
	get_tree().change_scene("res://main.tscn")
