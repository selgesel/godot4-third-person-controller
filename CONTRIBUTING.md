# Contribution Guide
Thank you for your interest in contributing to this repository!

You can use this guide to figure out how you can contribute, and what type of contributions are most welcome.

## What to Contribute
Although this repository is not in active development and I don't have the capacity to maintain a collective development effort around it, pull requests addressing errors and compatibility issues are welcome!

Please feel free to submit a pull request if it either:
- Fixes a bug
- Adds backwards compatibility with older Godot versions
- Replaces the calls to older Godot APIs with calls that are up-to-date with the latest Godot APIs (e.g. replacing 4 `Input.get_action_strength()` and one `normalize()` call with a single `Input.get_vector()` call)
- Objectively improves the look-and-feel (e.g. lerping blend positions in animations instead of setting fixed values)

Likewise, *please DON'T submit* a pull request if it either:
- Adds new features (e.g. rolling, flying)
- Adds an addon to the project
- Refactors the code
- Restructures the project

## How to Contribute
Now that you're here, I think it to assume that you have a fair grasp on how to use Git, how to use Godot, and how to write GDScript, and more importantly, you already have something that you'd like to work on. In fact, you've already probably written it.

Before you submit your pull request, though, I would kindly ask you to revisit your code to make sure it matches the existing code stylistically. Code style is very subjective and everyone has their own preferences, so I think it's ultimately better to have a specific and rigorously maintained coding style for each project, than to have one that everyone agrees upon, or even let everyone contribute in their own style.

Therefore, I would again kindly ask you to stick to the following stylistic choices:
- Use `4 spaces` instead of tabs
    - When you submit your PR, if it shows a lot more changes than what you thought there would be, this is most likely the cause as your editor might be changing the indentations in changed lines automatically
    - To fix individual files or lines without changing your editor settings, you can simply select the lines with tabs instead of spaces, and hit `Ctrl+i` (`Cmd+i` on Mac) to convert the indetations to spaces
- Don't over-comment the code. Most of the existing code admittedly have a lot of comments but that wasn't a good decision
- Name your variables, classes and files according to the [Naming Conventions](#Naming_Conventions)
- Always add type hints to exported and/or public class/script fields even if it's obvious (e.g. `@export var move_speed: float = 1.0` instead of `@export var move_speed = 1.0`)
- Always represent float default values in decimals even if a type hint is given (e.g. `var zoom_scale: float = 1.0` instead of `var zoom_scale: float = 1`

### Naming Conventions

<table>
<thead>
<tr>
<th>What to Name</th>
<th>Naming Style</th>
<th>Examples</th>
</tr>
</thead>

<tbody>
<tr>
<th>Filenames</th>
<td><code>PascalCase.gd</code></td>
<td>

```
# ✅ Correct
Player.gd
CharacterMovement.gd

# ❌ Incorrect
player.gd
character_movement.gd
Character_Movement.gd
characterMovement.gd
```

</tr>

<tr>
<th>Class names</th>
<td><code>PascalCase</code></td>
<td>

```gdscript
# ✅ Correct
class_name Player
class_name CharacterMovement

# ❌ Incorrect
class_name player
class_name character_movement
class_name Character_Movement
class_name characterMovement
```

</td>
</tr>

<tr>
<th>Method/function names</th>
<td><code>snake_case</code></td>

<td>

```gdscript
# ✅ Correct
func process():
  pass

func get_real_move_speed():
  pass

# ❌ Incorrect
func getRealMoveSpeed():
  pass

func GetRealMoveSpeed():
  pass

func Get_Real_Move_Speed():
  pass
```

</td>
</tr>

<tr>
<th>Scoped variables</th>
<td><code>snake_case</code></td>
<td>

```gdscript
# ✅ Correct
var move_direction = Vector2.ZERO
var zoom_scale = 1.0

# ❌ Incorrect
var MoveDirection = Vector2.ZERO
var zoomScale = 1.0
```

</td>
</tr>

<tr>
<th>Exported or public class/script fields</th>
<td><code>snake_case</code></td>

<td>

```gdscript
# ✅ Correct
@export var move_speed: float = 1.0

# ❌ Incorrect
@export var moveSpeed: float = 1.0
@export var MoveSpeed: float = 1.0
@export var MoveSpeed: float = 1.0
```

</td>
</tr>

<tr>
<th>Private† class/script fields and methods</th>
<td><code>_underscored_snake_case</code></td>
<td>

```gdscript
# ✅ Correct
func _on_zoom_changed():
  pass

var _real_zoom_scale: float = 0.0

# ❌ Incorrect
func on_zoom_changed():
  pass

func _OnZoomChanged():
  pass

var _realZoomScale: float = 0.0
var real_zoom_scale: float = 0.0
```

</td>
</tr>
</tbody>
</table>


_†: Though there's no such thing as a private method or function, some methods or functions are not meant to be accessed or called from the outside. Use an underscore as a prefix to designate such methods and fields_
