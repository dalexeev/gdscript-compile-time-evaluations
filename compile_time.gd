@tool
extends Resource

func _get(property: StringName) -> Variant:
	var method: String = property.get_slice(",", 0)
	if method == "val":
		return str_to_var(property.substr(4))
	if has_method(method):
		var args: String = "[" + property.substr(method.length() + 1) + "]"
		return var_to_str(callv(method, str_to_var(args)))
	return null

func inc(a: Variant) -> Variant:
	return a + 1

func sum(a: Variant, b: Variant) -> Variant:
	return a + b
