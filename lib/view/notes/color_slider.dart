import 'package:notester/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ColorSlider extends StatefulWidget {
  final void Function(Color)? callBackColorTapped;
  final Color noteColor;

  const ColorSlider(
      {Key? key, this.callBackColorTapped, required this.noteColor})
      : super(key: key);
  @override
  ColorSliderState createState() => ColorSliderState();
}

class ColorSliderState extends State<ColorSlider> {
  final colors = const [
    Color.fromARGB(255, 255, 255, 255), // classic white
    Color.fromARGB(255, 189, 93, 85),
    Color.fromARGB(255, 202, 157, 7),
    Color.fromARGB(255, 238, 230, 85),
    Color.fromARGB(255, 186, 243, 116),
    Color.fromARGB(255, 126, 235, 211),
    Color.fromARGB(255, 156, 223, 238),
    Color.fromARGB(255, 124, 152, 202),
    Color.fromARGB(255, 185, 137, 228),
    Color.fromARGB(255, 223, 146, 191),
    Color.fromARGB(255, 196, 164, 129),
    Color.fromARGB(255, 190, 191, 194),
    Color.fromARGB(255, 47, 67, 126),
    Color.fromARGB(255, 26, 59, 51),
    Color.fromARGB(255, 103, 50, 202),
    Color.fromARGB(255, 212, 17, 17),
    Color.fromARGB(255, 0, 0, 0),
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
    return ListView(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      children: List.generate(
        colors.length,
        (index) {
          return GestureDetector(
            onTap: () {
              if (widget.callBackColorTapped != null) {
                widget.callBackColorTapped!(colors[index]);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 6, right: 6),
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
            ),
          );
        },
      ),
    );
  }

  Widget? _checkOrNot(int index) {
    if (indexOfCurrentColor == index) {
      return Container(
        decoration: BoxDecoration(
            color: AppColors.cWhite,
            border: Border.all(color: AppColors.cGrey),
            shape: BoxShape.circle),
        padding: const EdgeInsets.all(2),
        child: const Icon(Icons.check, color: AppColors.cDarkBlue, size: 12),
      );
    }
    return null;
  }
}
