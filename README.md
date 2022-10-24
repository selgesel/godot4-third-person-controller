# Godot 4 - Third Person Player Controller
A third person player controller with touchscreen support for Godot 4.

> **Note:** This project is for Godot 4 only. For the Godot 3 version please see [selgesel/godot3-third-person-controller](https://github.com/selgesel/godot3-third-person-controller)

This is a complementary code repository for my [YouTube video series](https://www.youtube.com/playlist?list=PLlT0CCZ8Yw0mcxG_D_sSA-Imnc5tiR4tx).

![Preview](./preview.gif?v=1)

## Desktop Controls
### Common Actions
| Keys | Action Name | Description |
|------|-------------|-------------|
| `W` | `move_forward` | Move/swim forward |
| `S` | `move_backwards` | Move/swim backwards |
| `A` | `move_left` | Move/swim to the left |
| `D` | `move_right` | Move/swim to the right |
| `Esc` | `ui_cancel` | (Built-in) Toggle between captured and visible mouse modes |
| `Mouse Wheel Up` | `zoom_in` | Move the camera closer to the player |
| `Mouse Wheel Down` | `zoom_out` | Move the camera further away from the player |

### When Not Swimming
| Keys | Action Name | Description |
|------|-------------|-------------|
| `Q` | `dash` | (Hold) Dash in the current movement direction. Hold to dash periodically |
| `Shift` | `sprint` | (Hold) Run faster |
| `Ctrl` | `crouch` | (Hold) Crouch. While crouching the player moves more slowly and can't jump or dash |
| `Space` | `jump` | Jump. The player can jump multiple times |

### When Swimming
When swimming underwater the movement direction is affected both by the horizontal and vertical angles of the camera. The player can only swim horizontally when on the water surface

| Keys | Action Name | Description |
|------|-------------|-------------|
| `Q` | `surge` | (Hold to charge) After charging for a brief duration, surge in the current movement direction |
| `Ctrl` | `swim_down` | (Hold) Swim downwards. When on surface, this forces the player to dive back in |
| `Space` | `swim_up` | (Hold) Swim upwards |
| `Space` | `jump` | (When on surface) Jump out of the water |

## Touchscreen Controls
In touchscreen devices some actions are performed through gestures, and some are performed simply by pressing the corresponding on-screen button.

Each button displays an icon that (hopefully) explains the action that they perform, and they also appear or disappear based on whether or not they're available.

### Gestures
| Gesture | Context | Description |
|---------|---------|-------------|
| Drag | Thumb Stick (Left) | Move/swim in the current look direction with a speed relative to the drag distance |
| Drag | Screen | Rotate the camera |
| Pinch In (Two Fingers) | Screen | Move the camera further away from the player |
| Pinch Out (Two Fingers) | Screen | Move the camera closer to the player |

## License
MIT
