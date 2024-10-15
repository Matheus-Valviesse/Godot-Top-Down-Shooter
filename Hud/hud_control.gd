extends CanvasLayer

func _hp_change(player)->void:
	var HpBar  = $HpBar/Bar
	HpBar.size.x = 246 * player.HP/ player.HPMax

func _mp_change(player)->void:
	var MpBar  = $MpBar/Bar
	MpBar.size.x = 246 * player.MP/ player.MPMax
