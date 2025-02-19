extends Status_effects
class_name Status_effects_recovery

var apply_in_seconds = 1
var time_past = 0
 
var value : float
var recovery: String

func apply_in_time(time:float, target):

	time_past += time

	if time_past >= apply_in_seconds:
		time_past -= 1
		var recover_text = preload('res://PopUptext/Recover/Recover.tscn')
		var recover_spaw = recover_text.instantiate()
		recover_spaw.position = target.position
	
		if recovery == 'all':
			recover_spaw.find_child('Hp').text ='HP '+"%.2f" %  recover_hp(value,target)
			recover_spaw.find_child('Mp').text ='MP '+"%.2f" %  recover_mp(value,target)

		elif recovery == 'hp':
			recover_spaw._set_text_values(recovery,{'hp':recover_hp(value,target)})

		elif recovery == 'mp':
			recover_spaw._set_text_values(recovery,{'mp':recover_mp(value,target)})
	
		recover_spaw.find_child('Anim').play('recover')
		target.get_parent().add_child(recover_spaw)

		target.hud_edit()
	
func recover_hp(percent, target) -> float:
	var recover_value = target.HPMax * percent
	var r_hp = min(target.HP + (recover_value), target.HPMax)
	target.HP = r_hp
	return recover_value
	
func recover_mp(percent, target) -> float:
	var recover_value = target.MPMax * percent
	var r_mp = min(target.MP + (target.MPMax * percent), target.MPMax)
	target.MP = r_mp
	return recover_value
