import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_widgets/custom_widgets.dart';
import 'package:notester/model/model.dart';
import 'package:notester/utils/app_colors.dart';
import 'package:notester/widgets/simple_circular_loader.dart';
import 'package:flutter/material.dart';

class EnlargeImage extends StatelessWidget {
  final ImageArgs imageArgs;

  const EnlargeImage({Key? key, required this.imageArgs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transformationController = TransformationController();
    TapDownDetails? doubleTapDetails;

    void handleDoubleTapDown(TapDownDetails details) {
      doubleTapDetails = details;
    }

    void handleDoubleTap() {
      if (transformationController.value != Matrix4.identity()) {
        transformationController.value = Matrix4.identity();
      } else {
        final position = doubleTapDetails?.localPosition;
        transformationController.value = Matrix4.identity()
          ..translate(-position!.dx * 2, -position.dy * 2)
          ..scale(3.0);
      }
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.cBlack,
        body: Stack(
          children: [
            Hero(
              tag: imageArgs.imageUrl,
              child: GestureDetector(
                onDoubleTap: handleDoubleTap,
                onDoubleTapDown: handleDoubleTapDown,
                child: InteractiveViewer(
                  transformationController: transformationController,
                  panEnabled: true, // Set it to false to prevent panning.
                  minScale: 1,
                  maxScale: 3,
                  child: SizedBox(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    child: CachedNetworkImage(
                      memCacheHeight: 1500,
                      filterQuality: FilterQuality.none,
                      imageUrl: imageArgs.imageUrl,
                      placeholder: (context, url) =>
                          const Center(child: SimpleCircularLoader()),
                      fit: BoxFit.contain,
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(Icons.broken_image,
                            color: AppColors.cBlueAccent, size: 100),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 15,
              top: 15,
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                      color: AppColors.cGrey.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(25)),
                  child: Center(
                    child: BackButton(
                      onPressed: () {
                        Utilities.closeActivity(context);
                      },
                      color: AppColors.cBlack,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
