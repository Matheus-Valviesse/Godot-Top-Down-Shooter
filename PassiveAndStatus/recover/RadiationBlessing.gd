extends Status_effects_recovery
class_name Radiation_blessing

func _init(time = 9) -> void:
  value = 0.09
  recovery = 'all'
  super._init(time)
  effect_name = "Radiation Blessing"

func apply(target):
  super.apply(target)

func remove(target):
  super.remove(target)
