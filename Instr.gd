extends Panel

var isPanelShown = false
	
func show_panel():
	self.visible = true
	#isPanelShown = true
	#Player.set_movement_enabled(false)

func hide_panel():
	self.visible = false


func _on_ok_bttn_pressed():
	hide_panel()
