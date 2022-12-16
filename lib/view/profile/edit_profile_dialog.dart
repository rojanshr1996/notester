import 'package:custom_widgets/custom_widgets.dart';
import 'package:notester/utils/app_colors.dart';
import 'package:notester/utils/custom_text_style.dart';
import 'package:notester/widgets/custom_text_enter_field.dart';
import 'package:flutter/material.dart';

class EditProfileDialog extends StatelessWidget {
  final TextEditingController? nameController;
  final TextEditingController? phoneController;
  final TextEditingController? addressController;
  final GlobalKey<FormState>? formKey;
  final VoidCallback? onUpdate;

  const EditProfileDialog(
      {Key? key, this.nameController, this.phoneController, this.addressController, this.formKey, this.onUpdate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Stack(
                    children: [
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context).colorScheme.shadow, blurRadius: 8, offset: const Offset(0, 3)),
                          ],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      CustomTextEnterField(
                        textEditingController: nameController,
                        label: Text("Full Name", style: Theme.of(context).textTheme.bodyText2),
                        textInputType: TextInputType.text,
                        style: Theme.of(context).textTheme.bodyMedium,
                        hintStyle: CustomTextStyle.hintTextLight,
                        validator: (value) => validateField(context: context, value: value!, fieldName: "Name"),
                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.cBlueShade)),
                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
                        focusedErrorBorder:
                            const OutlineInputBorder(borderSide: BorderSide(color: AppColors.cRedAccent)),
                        errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.cRedAccent)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Stack(
                    children: [
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context).colorScheme.shadow, blurRadius: 8, offset: const Offset(0, 3)),
                          ],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      CustomTextEnterField(
                        textEditingController: phoneController,
                        label: Text("Phone Number", style: Theme.of(context).textTheme.bodyText2),
                        textInputType: TextInputType.phone,
                        style: Theme.of(context).textTheme.bodyMedium,
                        hintStyle: CustomTextStyle.hintTextLight,
                        validator: (value) => validateField(context: context, value: value!, fieldName: "Name"),
                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.cBlueShade)),
                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
                        focusedErrorBorder:
                            const OutlineInputBorder(borderSide: BorderSide(color: AppColors.cRedAccent)),
                        errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.cRedAccent)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Stack(
                    children: [
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context).colorScheme.shadow, blurRadius: 8, offset: const Offset(0, 3)),
                          ],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      CustomTextEnterField(
                        textEditingController: addressController,
                        label: Text("Address", style: Theme.of(context).textTheme.bodyText2),
                        textInputType: TextInputType.text,
                        style: Theme.of(context).textTheme.bodyMedium,
                        hintStyle: CustomTextStyle.hintTextLight,
                        validator: (value) => validateField(context: context, value: value!, fieldName: "Address"),
                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.cBlueShade)),
                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
                        focusedErrorBorder:
                            const OutlineInputBorder(borderSide: BorderSide(color: AppColors.cRedAccent)),
                        errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.cRedAccent)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: CustomButton(
                    title: "UPDATE",
                    borderRadius: BorderRadius.circular(5),
                    splashBorderRadius: BorderRadius.circular(5),
                    buttonColor: Theme.of(context).buttonTheme.colorScheme?.primary,
                    onPressed: onUpdate,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
