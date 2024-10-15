extends Status_effects
class_name Speed

func _init(time = 3) -> void:
  super._init(time)

  effect_name = "Speed"
  count_max = 3
  effect_attributes.values = {
    'ATK':1000,
    'SPEED':60,
    'COUNT':count
  }
  effect_attributes['name'] = effect_name

func apply(target):
  super.apply(target)
  target.status_bonus.push_back(effect_attributes)

func remove(target):
  super.remove(target)
 
