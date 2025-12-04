import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:intl/intl.dart';
import 'package:notester/provider/dark_theme_provider.dart';
import 'package:notester/utils/app_colors.dart';
import 'package:notester/view/notes/color_slider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:scribble/scribble.dart';

class ScratchpadScreen extends StatefulWidget {
  const ScratchpadScreen({super.key});

  @override
  State<ScratchpadScreen> createState() => _ScratchpadScreenState();
}

class _ScratchpadScreenState extends State<ScratchpadScreen> {
  late ScribbleNotifier notifier;
  late ValueNotifier<Color> selectedColorNotifier;
  late ValueNotifier<double> strokeWidthNotifier;
  late ValueNotifier<bool> isEraserNotifier;
  late ValueNotifier<bool> isSavingNotifier;
  late ScreenshotController screenshotController;

  @override
  void initState() {
    super.initState();
    final themeChange = Provider.of<DarkThemeProvider>(context, listen: false);
    final isDarkMode = themeChange.darkTheme;
    final defaultColor = isDarkMode ? AppColors.cWhite : AppColors.cBlack;

    selectedColorNotifier = ValueNotifier<Color>(defaultColor);
    strokeWidthNotifier = ValueNotifier<double>(3.0);
    isEraserNotifier = ValueNotifier<bool>(false);
    isSavingNotifier = ValueNotifier<bool>(false);
    screenshotController = ScreenshotController();

    notifier = ScribbleNotifier();
  }

  @override
  void dispose() {
    notifier.dispose();
    selectedColorNotifier.dispose();
    strokeWidthNotifier.dispose();
    isEraserNotifier.dispose();
    isSavingNotifier.dispose();
    super.dispose();
  }

  Future<void> _saveToGallery() async {
    if (isSavingNotifier.value) return;

    isSavingNotifier.value = true;

    try {
      // Request appropriate permission based on Android version
      PermissionStatus status;

      if (await Permission.photos.isGranted ||
          await Permission.storage.isGranted) {
        status = PermissionStatus.granted;
      } else {
        status = await Permission.photos.request();

        if (status.isDenied || status.isPermanentlyDenied) {
          status = await Permission.storage.request();
        }
      }

      final canProceed = status.isGranted || status.isLimited;

      if (!canProceed && status.isPermanentlyDenied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                  'Storage permission is required. Please enable it in settings.'),
              backgroundColor: Colors.orange,
              action: SnackBarAction(
                label: 'Settings',
                onPressed: () => openAppSettings(),
                textColor: AppColors.cWhite,
              ),
            ),
          );
        }
        isSavingNotifier.value = false;
        return;
      }

      // Capture screenshot
      final Uint8List? imageBytes =
          await screenshotController.capture(pixelRatio: 3.0);

      if (imageBytes == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to capture screenshot'),
              backgroundColor: Colors.red,
            ),
          );
        }
        isSavingNotifier.value = false;
        return;
      }

      // Generate filename with timestamp
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final fileName = 'scratchpad_$timestamp';

      // Save to gallery
      final result = await ImageGallerySaverPlus.saveImage(
        imageBytes,
        quality: 100,
        name: fileName,
      );

      if (mounted) {
        if (result['isSuccess'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Saved to gallery: $fileName.png'),
              backgroundColor: AppColors.cGreen,
              duration: const Duration(seconds: 3),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to save image'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        isSavingNotifier.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final isDarkMode = themeChange.darkTheme;

    // Set default colors based on theme
    final backgroundColor = isDarkMode ? AppColors.cBlack : AppColors.cWhite;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Scratch Pad'),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 4,
        shadowColor: Theme.of(context).colorScheme.shadow,
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            tooltip: 'Undo',
            onPressed: notifier.canUndo ? notifier.undo : null,
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            tooltip: 'Redo',
            onPressed: notifier.canRedo ? notifier.redo : null,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear',
            onPressed: notifier.clear,
          ),
          ValueListenableBuilder<bool>(
            valueListenable: isSavingNotifier,
            builder: (context, isSaving, _) {
              return IconButton(
                icon: isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.cWhite),
                        ),
                      )
                    : const Icon(Icons.save),
                tooltip: 'Save to Gallery',
                onPressed: isSaving ? null : _saveToGallery,
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Screenshot(
            controller: screenshotController,
            child: Container(
              color: backgroundColor,
              child: Scribble(
                notifier: notifier,
                drawPen: true,
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Card(
              color: Theme.of(context).scaffoldBackgroundColor,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Color Palette
                    ValueListenableBuilder<Color>(
                      valueListenable: selectedColorNotifier,
                      builder: (context, selectedColor, _) {
                        return ColorSlider(
                          noteColor: selectedColor,
                          callBackColorTapped: (color) {
                            selectedColorNotifier.value = color;
                            isEraserNotifier.value = false;
                            notifier.setColor(color);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    // Stroke Width Slider
                    ValueListenableBuilder<double>(
                      valueListenable: strokeWidthNotifier,
                      builder: (context, strokeWidth, _) {
                        return Row(
                          children: [
                            Icon(
                              Icons.brush,
                              size: 16,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            Expanded(
                              child: Slider(
                                value: strokeWidth,
                                min: 1,
                                max: 15,
                                onChanged: (value) {
                                  strokeWidthNotifier.value = value;
                                  notifier.setStrokeWidth(value);
                                },
                                activeColor:
                                    Theme.of(context).colorScheme.surface,
                              ),
                            ),
                            Icon(
                              Icons.brush,
                              size: 24,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    // Tool Buttons
                    ValueListenableBuilder<bool>(
                      valueListenable: isEraserNotifier,
                      builder: (context, isEraser, _) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildToolButton(
                              icon: Icons.edit,
                              label: 'Pen',
                              isSelected: !isEraser,
                              onTap: () {
                                isEraserNotifier.value = false;
                                notifier.setColor(selectedColorNotifier.value);
                              },
                            ),
                            _buildToolButton(
                              icon: Icons.cleaning_services,
                              label: 'Eraser',
                              isSelected: isEraser,
                              onTap: () {
                                isEraserNotifier.value = true;
                                notifier.setEraser();
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.surface.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.surface
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? Theme.of(context).colorScheme.surface
                  : Theme.of(context).iconTheme.color,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).textTheme.bodyMedium?.color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
