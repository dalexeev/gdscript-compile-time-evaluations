# gdscript-compile-time-evaluations

This project demonstrates some GDScript "support" for user-defined functions that are evaluated at compile time.

## Prerequisites

1. GDScript supports constants, their initializers must be _constant expressions_. User-defined functions do not support compile-time evaluations.
2. Constant expressions include pass-by-value built-in types[^1], arrays and dictionaries in a _constant context_, as well as some objects (resources loaded using `preload()`). Also types are constant expressions: classes (represented by a `GDScript` resource or an internal wrapper `GDScriptNativeClass`) and enumerations (user-defined named enums represented by a dictionary). Objects are not generally constant expressions.
3. GDScript performs _constant folding_ during the static analysis. Some expressions are considered compile-time evaluated[^2], i.e. they can be replaced by a value if all their arguments/elements/operands are also constant expressions. Many operators (`+`, `-`, `*`, etc.), attribute/index access, pass-by-value built-in type constructors[^1], `@GlobalScope` math functions and some `@GDScript` functions are compile-time evaluated.

## Explanation

1. Since only objects can have user-defined functions and we need a constant base, we use `preload()` to load a custom resource. We also load a resource rather than a script in order to use non-static class members.
2. To make the code executable in the editor, we added `@tool` to `compile_time.gd`. This is an optional step if you do not need to execute a code in the editor, see [How to use](#how-to-use) section.
3. A method call is not considered compile-time evaluated, `const_base.some_method()` is not a constant expression. We could use a property with a getter, but it does not allow us to pass parameters. Therefore, we used index access and the `_get()` virtual method.
4. Since we cannot overload the `[]` operator, and `_get()` requires exactly one string argument, we use a string to encode function name and call arguments. For example, the notation `sum,1,2` is equivalent to `sum(1, 2)`, and the notation `sum,"1","2"` is equivalent to `sum("1", "2")`. Arguments are written as if they were encoded using `var_to_str()`.[^3]
5. To call a function at compile time, we use `CT["func,args"]`. Before calling the function, the passed arguments are decoded using `str_to_var()`, after evaluation the result is encoded back to a string using `var_to_str()`. For example, `CT["sum,1,2"]` will return `"3"`, not `3`. This is done because `var_to_str()` is not compile-time evaluated.
6. Since `str_to_var()` is also not compile-time evaluated, there is an exception function `val` that returns the decoded result of `str_to_var()`. For example, `CT["val,1"]` will return `1`, and `CT['val,"1"']` will return `"1"`.
7. If you made an error in `CT["..."]`, it will be detected at compile time. Note that this may clutter the Output with errors while editing the script.

## How to use?

Of course, in general this use of GDScript is unintended and can only be used as a joke. However, some of this may be useful in practice. For example, you can create a `constants.gd` script with export variables and edit their values ​​in the `constants.tres` resource using the Inspector. At the same time, you can use these values ​​as constants in other scripts.

```gdscript
# constants.gd
extends Resource

@export var my_value: int
```

```gdscript
# other.gd
extends Node

const MY_VALUE = preload("./constants.tres").my_value # It's valid!
```

[^1]: Note that `Callable` and `Signal` are not constant expressions if they explicitly or implicitly use `self` or another non-constant object as base.
[^2]: Typically, constant expressions should be _pure_, i.e. _deterministic_ and _have no side effects_. However, in GDScript this is not always true, or at least not always checked.
[^3]: Note that strings can only be enclosed in double quotes, otherwise `str_to_var()` will not parse the expression.
