extends Skill
class_name Divine_protection


func _init() -> void:
  super._init('Divine_protection',300)

func apply_skill(player) -> void:

  var skill = preload('res://Skill/divine_protection/skill_divine_protection.tscn')
  var skill_spaw =  skill.instantiate()
  player.get_parent().add_child(skill_spaw)
  skill_spaw.position = player.position
  
