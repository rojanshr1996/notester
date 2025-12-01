import 'package:flutter/material.dart';
import 'package:notester/utils/app_colors.dart';

class ColorSlider extends StatefulWidget {
  final void Function(Color)? callBackColorTapped;
  final Color noteColor;

  const ColorSlider({super.key, this.callBackColorTapped, required this.noteColor});
  @override
  ColorSliderState createState() => ColorSliderState();
}

class ColorSliderState extends State<ColorSlider> {
  final colors = const [
    // Whites and Creams
    Color.fromARGB(255, 255, 255, 255), // classic white
    Color.fromARGB(255, 255, 250, 240), // floral white
    Color.fromARGB(255, 253, 245, 230), // old lace
    Color.fromARGB(255, 255, 248, 220), // cornsilk
    Color.fromARGB(255, 255, 239, 213), // papaya whip
    Color.fromARGB(255, 245, 245, 220), // beige
    Color.fromARGB(255, 250, 235, 215), // antique white
    Color.fromARGB(255, 255, 235, 205), // blanched almond
    Color.fromARGB(255, 245, 222, 179), // wheat
    Color.fromARGB(255, 255, 245, 238), // seashell

    // Reds
    Color.fromARGB(255, 255, 182, 193), // light pink
    Color.fromARGB(255, 255, 192, 203), // pink
    Color.fromARGB(255, 255, 105, 180), // hot pink
    Color.fromARGB(255, 255, 20, 147), // deep pink
    Color.fromARGB(255, 219, 112, 147), // pale violet red
    Color.fromARGB(255, 220, 20, 60), // crimson
    Color.fromARGB(255, 255, 0, 0), // red
    Color.fromARGB(255, 178, 34, 34), // firebrick
    Color.fromARGB(255, 139, 0, 0), // dark red
    Color.fromARGB(255, 212, 17, 17), // custom red
    Color.fromARGB(255, 189, 93, 85), // custom red-brown
    Color.fromARGB(255, 205, 92, 92), // indian red
    Color.fromARGB(255, 240, 128, 128), // light coral
    Color.fromARGB(255, 233, 150, 122), // dark salmon
    Color.fromARGB(255, 250, 128, 114), // salmon
    Color.fromARGB(255, 255, 160, 122), // light salmon

    // Oranges
    Color.fromARGB(255, 255, 127, 80), // coral
    Color.fromARGB(255, 255, 99, 71), // tomato
    Color.fromARGB(255, 255, 69, 0), // orange red
    Color.fromARGB(255, 255, 140, 0), // dark orange
    Color.fromARGB(255, 255, 165, 0), // orange
    Color.fromARGB(255, 255, 215, 0), // gold
    Color.fromARGB(255, 255, 200, 124), // peach
    Color.fromARGB(255, 255, 185, 15), // dark gold
    Color.fromARGB(255, 255, 195, 77), // light orange
    Color.fromARGB(255, 255, 153, 51), // bright orange

    // Yellows
    Color.fromARGB(255, 255, 255, 224), // light yellow
    Color.fromARGB(255, 255, 255, 0), // yellow
    Color.fromARGB(255, 255, 250, 205), // lemon chiffon
    Color.fromARGB(255, 250, 250, 210), // light goldenrod
    Color.fromARGB(255, 238, 232, 170), // pale goldenrod
    Color.fromARGB(255, 240, 230, 140), // khaki
    Color.fromARGB(255, 238, 230, 85), // custom yellow
    Color.fromARGB(255, 202, 157, 7), // custom dark yellow
    Color.fromARGB(255, 189, 183, 107), // dark khaki
    Color.fromARGB(255, 184, 134, 11), // dark goldenrod
    Color.fromARGB(255, 255, 236, 139), // light goldenrod
    Color.fromARGB(255, 255, 228, 181), // moccasin
    Color.fromARGB(255, 255, 253, 208), // cream
    Color.fromARGB(255, 255, 247, 153), // pastel yellow

    // Greens
    Color.fromARGB(255, 240, 255, 240), // honeydew
    Color.fromARGB(255, 144, 238, 144), // light green
    Color.fromARGB(255, 152, 251, 152), // pale green
    Color.fromARGB(255, 186, 243, 116), // custom light green
    Color.fromARGB(255, 124, 252, 0), // lawn green
    Color.fromARGB(255, 127, 255, 0), // chartreuse
    Color.fromARGB(255, 173, 255, 47), // green yellow
    Color.fromARGB(255, 154, 205, 50), // yellow green
    Color.fromARGB(255, 50, 205, 50), // lime green
    Color.fromARGB(255, 0, 255, 0), // lime
    Color.fromARGB(255, 34, 139, 34), // forest green
    Color.fromARGB(255, 0, 128, 0), // green
    Color.fromARGB(255, 0, 100, 0), // dark green
    Color.fromARGB(255, 46, 139, 87), // sea green
    Color.fromARGB(255, 60, 179, 113), // medium sea green
    Color.fromARGB(255, 32, 178, 170), // light sea green
    Color.fromARGB(255, 143, 188, 143), // dark sea green
    Color.fromARGB(255, 26, 59, 51), // custom dark green
    Color.fromARGB(255, 85, 107, 47), // dark olive green
    Color.fromARGB(255, 107, 142, 35), // olive drab
    Color.fromARGB(255, 128, 128, 0), // olive
    Color.fromARGB(255, 102, 205, 170), // medium aquamarine
    Color.fromARGB(255, 127, 255, 212), // aquamarine
    Color.fromARGB(255, 0, 250, 154), // medium spring green
    Color.fromARGB(255, 0, 255, 127), // spring green

    // Cyans and Teals
    Color.fromARGB(255, 224, 255, 255), // light cyan
    Color.fromARGB(255, 175, 238, 238), // pale turquoise
    Color.fromARGB(255, 126, 235, 211), // custom teal
    Color.fromARGB(255, 64, 224, 208), // turquoise
    Color.fromARGB(255, 72, 209, 204), // medium turquoise
    Color.fromARGB(255, 0, 206, 209), // dark turquoise
    Color.fromARGB(255, 0, 255, 255), // cyan
    Color.fromARGB(255, 0, 139, 139), // dark cyan
    Color.fromARGB(255, 0, 128, 128), // teal
    Color.fromARGB(255, 95, 158, 160), // cadet blue
    Color.fromARGB(255, 102, 205, 170), // medium aqua
    Color.fromARGB(255, 175, 238, 238), // powder turquoise
    Color.fromARGB(255, 32, 178, 170), // teal green

    // Blues
    Color.fromARGB(255, 240, 248, 255), // alice blue
    Color.fromARGB(255, 230, 230, 250), // lavender
    Color.fromARGB(255, 176, 224, 230), // powder blue
    Color.fromARGB(255, 173, 216, 230), // light blue
    Color.fromARGB(255, 156, 223, 238), // custom light blue
    Color.fromARGB(255, 135, 206, 250), // light sky blue
    Color.fromARGB(255, 135, 206, 235), // sky blue
    Color.fromARGB(255, 0, 191, 255), // deep sky blue
    Color.fromARGB(255, 100, 149, 237), // cornflower blue
    Color.fromARGB(255, 124, 152, 202), // custom blue
    Color.fromARGB(255, 65, 105, 225), // royal blue
    Color.fromARGB(255, 0, 0, 255), // blue
    Color.fromARGB(255, 0, 0, 205), // medium blue
    Color.fromARGB(255, 0, 0, 139), // dark blue
    Color.fromARGB(255, 25, 25, 112), // midnight blue
    Color.fromARGB(255, 47, 67, 126), // custom dark blue
    Color.fromARGB(255, 0, 0, 128), // navy
    Color.fromARGB(255, 70, 130, 180), // steel blue
    Color.fromARGB(255, 30, 144, 255), // dodger blue
    Color.fromARGB(255, 176, 196, 222), // light steel blue
    Color.fromARGB(255, 123, 104, 238), // medium slate blue
    Color.fromARGB(255, 106, 90, 205), // slate blue
    Color.fromARGB(255, 72, 61, 139), // dark slate blue

    // Purples and Violets
    Color.fromARGB(255, 216, 191, 216), // thistle
    Color.fromARGB(255, 221, 160, 221), // plum
    Color.fromARGB(255, 238, 130, 238), // violet
    Color.fromARGB(255, 218, 112, 214), // orchid
    Color.fromARGB(255, 186, 85, 211), // medium orchid
    Color.fromARGB(255, 147, 112, 219), // medium purple
    Color.fromARGB(255, 138, 43, 226), // blue violet
    Color.fromARGB(255, 185, 137, 228), // custom purple
    Color.fromARGB(255, 148, 0, 211), // dark violet
    Color.fromARGB(255, 153, 50, 204), // dark orchid
    Color.fromARGB(255, 103, 50, 202), // custom dark purple
    Color.fromARGB(255, 139, 0, 139), // dark magenta
    Color.fromARGB(255, 128, 0, 128), // purple
    Color.fromARGB(255, 75, 0, 130), // indigo
    Color.fromARGB(255, 230, 130, 255), // light purple
    Color.fromARGB(255, 200, 162, 200), // pastel purple
    Color.fromARGB(255, 191, 148, 228), // lavender purple
    Color.fromARGB(255, 155, 89, 182), // amethyst
    Color.fromARGB(255, 102, 51, 153), // royal purple
    Color.fromARGB(255, 170, 102, 204), // violet purple

    // Magentas and Pinks
    Color.fromARGB(255, 255, 0, 255), // magenta
    Color.fromARGB(255, 199, 21, 133), // medium violet red
    Color.fromARGB(255, 223, 146, 191), // custom pink
    Color.fromARGB(255, 255, 192, 203), // light pink
    Color.fromARGB(255, 255, 182, 193), // baby pink
    Color.fromARGB(255, 219, 112, 147), // rosy pink
    Color.fromARGB(255, 255, 174, 201), // carnation pink
    Color.fromARGB(255, 255, 105, 180), // bright pink
    Color.fromARGB(255, 231, 84, 128), // medium pink
    Color.fromARGB(255, 255, 20, 147), // vibrant pink
    Color.fromARGB(255, 204, 0, 153), // deep magenta
    Color.fromARGB(255, 255, 0, 127), // rose
    Color.fromARGB(255, 255, 102, 204), // bubble gum
    Color.fromARGB(255, 255, 153, 204), // cotton candy

    // Browns and Tans
    Color.fromARGB(255, 255, 228, 196), // bisque
    Color.fromARGB(255, 255, 218, 185), // peach puff
    Color.fromARGB(255, 244, 164, 96), // sandy brown
    Color.fromARGB(255, 210, 180, 140), // tan
    Color.fromARGB(255, 222, 184, 135), // burlywood
    Color.fromARGB(255, 196, 164, 129), // custom brown
    Color.fromARGB(255, 188, 143, 143), // rosy brown
    Color.fromARGB(255, 205, 133, 63), // peru
    Color.fromARGB(255, 210, 105, 30), // chocolate
    Color.fromARGB(255, 139, 69, 19), // saddle brown
    Color.fromARGB(255, 160, 82, 45), // sienna
    Color.fromARGB(255, 165, 42, 42), // brown
    Color.fromARGB(255, 128, 0, 0), // maroon
    Color.fromARGB(255, 101, 67, 33), // dark brown
    Color.fromARGB(255, 133, 94, 66), // coffee
    Color.fromARGB(255, 150, 75, 0), // rust
    Color.fromARGB(255, 121, 85, 72), // mocha
    Color.fromARGB(255, 141, 110, 99), // taupe
    Color.fromARGB(255, 92, 64, 51), // chestnut
    Color.fromARGB(255, 118, 85, 43), // bronze

    // Grays and Neutrals
    Color.fromARGB(255, 245, 245, 245), // white smoke
    Color.fromARGB(255, 220, 220, 220), // gainsboro
    Color.fromARGB(255, 211, 211, 211), // light gray
    Color.fromARGB(255, 192, 192, 192), // silver
    Color.fromARGB(255, 190, 191, 194), // custom gray
    Color.fromARGB(255, 169, 169, 169), // dark gray
    Color.fromARGB(255, 128, 128, 128), // gray
    Color.fromARGB(255, 105, 105, 105), // dim gray
    Color.fromARGB(255, 119, 136, 153), // light slate gray
    Color.fromARGB(255, 112, 128, 144), // slate gray
    Color.fromARGB(255, 47, 79, 79), // dark slate gray
    Color.fromARGB(255, 54, 69, 79), // blue gray
    Color.fromARGB(255, 96, 96, 96), // granite
    Color.fromARGB(255, 158, 158, 158), // ash gray
    Color.fromARGB(255, 183, 183, 183), // light silver
    Color.fromARGB(255, 85, 85, 85), // charcoal
    Color.fromARGB(255, 64, 64, 64), // dark charcoal
    Color.fromARGB(255, 32, 32, 32), // jet black
    Color.fromARGB(255, 16, 16, 16), // near black
    Color.fromARGB(255, 0, 0, 0), // black
    Color.fromARGB(255, 255, 215, 180), // apricot
  ];

  late Color borderColor;
  late Color foregroundColor;
  late int indexOfCurrentColor;
  late Color noteColor;

  @override
  void initState() {
    super.initState();
    noteColor = widget.noteColor;
  }

  @override
  Widget build(BuildContext context) {
    indexOfCurrentColor = colors.indexOf(widget.noteColor);
    foregroundColor = Theme.of(context).primaryColor;
    borderColor = Theme.of(context).primaryColor;

    // Calculate how many columns we need for two rows
    final totalColors = colors.length;
    final columnsNeeded = (totalColors / 2).ceil();

    return SizedBox(
      height: 92, // Height for 2 rows (38 + 38 + padding)
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: columnsNeeded,
        itemBuilder: (context, columnIndex) {
          final topIndex = columnIndex * 2;
          final bottomIndex = columnIndex * 2 + 1;

          return Padding(
            padding: const EdgeInsets.only(left: 6, right: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildColorCircle(topIndex),
                const SizedBox(height: 8),
                if (bottomIndex < colors.length) _buildColorCircle(bottomIndex),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildColorCircle(int index) {
    return GestureDetector(
      onTap: () {
        if (widget.callBackColorTapped != null) {
          widget.callBackColorTapped!(colors[index]);
        }
      },
      child: Container(
        width: 38.0,
        height: 38.0,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              foregroundColor: foregroundColor,
              backgroundColor: colors[index],
            ),
            Positioned(
              right: -5,
              child: _checkOrNot(index) ?? const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _checkOrNot(int index) {
    if (indexOfCurrentColor == index) {
      return Container(
        decoration:
            BoxDecoration(color: AppColors.cWhite, border: Border.all(color: AppColors.cGrey), shape: BoxShape.circle),
        padding: const EdgeInsets.all(2),
        child: const Icon(Icons.check, color: AppColors.cDarkBlue, size: 12),
      );
    }
    return null;
  }
}
