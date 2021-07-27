extends Node2D

var checkpoint = 0
var laps = 0

func _ready():
	$Level/Start/StaticBody2D/Area2D.connect("lap_finished", self, "endLap")
	$Level/Checkpoint1/Area2D.connect("checkpoint_hit", self, "checkpointHit")
	
func checkpointHit():
	checkpoint = 1

func endLap():
	if checkpoint == 1:
		laps += 1
		checkpoint = 0
		if laps == 3:
			print("race finished")
			get_tree().change_scene("res://finishScreen.tscn")
