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
	get_parent().HORSE_CAMERA.make_current()
	
func endCutscene():
	playGunshot()
	onCutsceneEnd.emit()
	
func playGunshot():
	$AudioStreamPlayer.play()

func playHorn():
	$Horn.play()

func playAnnouncer():
	$Announcer.play()
	
func playMicOwie():
	$MicOwie.play()
