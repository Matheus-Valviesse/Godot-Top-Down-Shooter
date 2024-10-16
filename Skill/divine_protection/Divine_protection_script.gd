extends Skill
class_name Divine_protection

func _init() -> void:
  super._init('Divine_protection',300 ,2.50)

func apply_skill(player, dmg) -> void:

  var skill = preload('res://Skill/divine_protection/skill_divine_protection.tscn')
  var skill_spaw =  skill.instantiate()
  skill_spaw.damage = dmg 
  skill_spaw.damage_multiplier = damage_multiplier
  player.get_parent().add_child(skill_spaw)
  skill_spaw.position = player.position
  
