extends CanvasLayer


signal TroopPurchased()

func _on_Button_pressed():
	emit_signal("TroopPurchased")
