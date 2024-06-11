extends Node

const CT = preload("./compile_time.tres")

const _TWO = CT["inc,1"]
const _THREE = CT["sum,1,2"]
const _FIVE = CT["sum," + _TWO + "," + _THREE]
const _TWELVE = CT['sum,"1","2"']

const TWO = CT["val," + _TWO]
const THREE = CT["val," + _THREE]
const FIVE = CT["val," + _FIVE]
const TWELVE = CT["val," + _TWELVE]

func _ready() -> void:
	print(var_to_str(_TWO)) # "2"
	print(var_to_str(_THREE)) # "3"
	print(var_to_str(_FIVE)) # "5"
	print(var_to_str(_TWELVE)) # "\"12\""

	print(var_to_str(TWO)) # 2
	print(var_to_str(THREE)) # 3
	print(var_to_str(FIVE)) # 5
	print(var_to_str(TWELVE)) # "12"
