extends Resource
class_name Status_effects

var effect_name: String
var effect_attributes: Dictionary = {
  'values': {}
}
var duration: float

var stakeable: bool

var count: float = 1
var count_max: float = 1

var statu_type: String

var t

func _init(time = 3) -> void:

  duration = time

func apply(target):
  pass
  # print("Efeito aplciado:" + target.name)


func remove(target):

  for i in range(target.status_bonus.size()):
    if target.status_bonus[i].name == effect_name:
      target.status_bonus.remove_at(i)


func get_effect_name() -> String:
  return effect_name