class_name Cutscene
extends Node3D

signal onCutsceneEnd()

func start():
	$Camera3D3.make_current()
	$AnimationPlayer.play("intro")

func swapToCameraOne():
	$Camera3D.clear_current()
	$Camera3D3.make_current()

func swapToCameraTwo():
	$Camera3D.make_current()
	
func swapToFinalCamera():
	$Camera3D.clear_current()
	
func endCutscene():
	onCutsceneEnd.emit()
