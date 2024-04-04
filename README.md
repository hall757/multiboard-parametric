# Parametric multiboard stacks

Refer for more info:
https://www.multiboard.io/

Or at thangs.com
https://thangs.com/designer/Keep%20Making/3d-model/8x8%20Multiboard%20Core%20Tile-974214

Usage:
```
// Create a common (core) tile 3 cells width, and 2 cells in height
multiboard_common(3, 2);

// Create a side tile tile 3 cells width, and 2 cells in height. Tooth are on
// the right side
multiboard_side(3, 2);

// Create a corner 3 by 2 tile
multiboard_side(3, 2);
```

If you use it, you'll please me if you let me know.

Additions by Randy Hall:

![examples](/Users/randy/Documents/src/multiboard-parametric/examples.png)

```
// For a 3x3 panel set...
// Set grid type to one of the below
// 
//   For flat sides: (nine unique panels)
//     "top left"    "top"    "top right"
//     "left"        "core"   "right"
//     "bottom left" "bottom" "bottom right"
// 
//   For classic sides: 
//     (three unique panels)
//     (four unique panels if width and height differ)
//     "side"  "side"  "corner"
//     "core"  "core"  "side"
//     "core"  "core"  "side"
//
//   For a horizontal config
//      "left end" "horizontal" "right end"
//
//   For a vertical config
//       "top end"
//       "vert"
//       "bottom end"
```
