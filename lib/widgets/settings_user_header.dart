import 'package:cached_network_image/cached_network_image.dart';
import 'package:notester/utils/app_colors.dart';
import 'package:notester/widgets/simple_circular_loader.dart';
import 'package:flutter/material.dart';

class SettingsUserHeader extends StatelessWidget {
  final double size;
  final VoidCallback? onPressed;
  final String profilePic;
  final String userName;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onImageTap;

  const SettingsUserHeader(
      {Key? key,
      this.size = 70.0,
      this.onPressed,
      this.profilePic = "",
      this.userName = "",
      this.onSettingsTap,
      this.onImageTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(15),
      color: Theme.of(context).primaryColor,
      shadowColor: Theme.of(context).colorScheme.shadow,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              InkWell(
                onTap: onImageTap,
                child: Container(
                  height: size,
                  width: size,
                  decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor),
                      color: AppColors.cDarkBlueAccent,
                      shape: BoxShape.circle),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      memCacheHeight: 200,
                      imageUrl: profilePic,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Center(child: SimpleCircularLoader(color: Theme.of(context).colorScheme.outline)),
                      errorWidget: (context, url, error) => const Icon(Icons.image, color: AppColors.cLight, size: 36),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(userName, style: Theme.of(context).textTheme.displaySmall),
                    const SizedBox(height: 2),
                    Text("View your profile",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor)),
                  ],
                ),
              ),
              IconButton(
                onPressed: onSettingsTap,
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
