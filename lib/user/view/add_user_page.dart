import 'dart:developer';

import 'package:admin_kdv/constants/app_assets.dart';
import 'package:admin_kdv/constants/app_colors.dart';
import 'package:admin_kdv/constants/app_constants.dart';
import 'package:admin_kdv/constants/app_strings.dart';
import 'package:admin_kdv/cubit/refresh_cubit.dart';
import 'package:admin_kdv/enums/enum_file.dart';
import 'package:admin_kdv/injector/injector.dart';
import 'package:admin_kdv/master/widget/app_asset_image.dart';
import 'package:admin_kdv/master/widget/app_text_form_field.dart';
import 'package:admin_kdv/master/widget/custome_button_gradiant_widget.dart';
import 'package:admin_kdv/user/model/app_file.dart';
import 'package:admin_kdv/user/repository/i_user_repository.dart';
import 'package:admin_kdv/utility/utility.dart';
import 'package:admin_kdv/widget/app_drop_down_widget.dart';
import 'package:admin_kdv/widget/container_widget.dart';
import 'package:admin_kdv/widget/custom_network_image.dart';
import 'package:admin_kdv/widget/navigation_path_widget.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key, this.userId});
  final String? userId;
  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final villaNoController = TextEditingController();
  final passwordVisbility = ValueNotifier<bool>(true);
  final _formKey = GlobalKey<FormState>();
  final pickedImageFile = ValueNotifier<AppFile?>(null);
  final userImage = ValueNotifier<String?>(null);
  final scrollController = ScrollController();

  final isLoading = ValueNotifier<bool>(false);
  final isButtonLoading = ValueNotifier<bool>(false);

  final selectedLine = ValueNotifier<String?>(null);
  final selectedRole = ValueNotifier<String?>(null);

  @override
  void initState() {
    super.initState();
    if (widget.userId != null) {
      getUser();
    }
  }

  Future<void> getUser() async {
    isLoading.value = true;
    final response = await getIt<IUserRepository>().getUser(userId: widget.userId!);
    response.fold(
      (l) {
        isLoading.value = false;
        Utility.toast(message: l.message);
      },
      (r) {
        nameController.text = r.name ?? '';
        emailController.text = r.email ?? '';
        passwordController.text = r.password ?? '';
        mobileNumberController.text = r.mobileNumber ?? '';
        pickedImageFile.value = null;
        userImage.value = r.imagePath;
        selectedRole.value = r.userRoleViewString;
        selectedLine.value = r.userLineViewString;
        villaNoController.text = r.villNumber ?? '';
        isLoading.value = false;
      },
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordVisbility.dispose();
    _formKey.currentState?.dispose();
    pickedImageFile.dispose();
    super.dispose();
  }

  // Future<void> getUserData() async {
  //   nameController.text = userData?.user?.name ?? '';
  //   emailController.text = userData?.user?.email ?? '';
  //   annualVacationController.text = userData?.user?.annualVacationDays.toString() ?? '';
  //   userImage.value = userData?.user?.imagePath ?? '';
  //   if (userData?.user?.userRoleViewString != null) selectedType.value = userData?.user?.userRoleViewString ?? '';
  // }

  @override
  Widget build(BuildContext context) {
    return ContainerWidget(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NavigationPathWidget(
                mainTitle: widget.userId != null ? 'Edit User' : 'Add User',
                firstTitle: 'User',
                secondTitle: widget.userId != null ? 'Edit User' : 'Add User',
                secondTitleColor: AppColors.primary,
              ),
              const Gap(30),
              InkWell(
                onTap: () async {
                  final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (pickedImage != null) {
                    final fileBytes = await pickedImage.readAsBytes();
                    pickedImageFile.value = AppFile(
                      bytes: fileBytes,
                      name: pickedImage.name,
                      mimeType: pickedImage.mimeType ?? '',
                      path: pickedImage.path,
                    );
                    userImage.value = null;
                    // log('${pickedImageFile.value}pickedImageFile');
                  }
                },
                child: ValueListenableBuilder(
                  valueListenable: userImage,
                  builder: (context, userImage, _) {
                    if (userImage != null) {
                      return Container(
                        clipBehavior: Clip.hardEdge,
                        height: 95,
                        width: 95,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: CustomNetworkImage(
                          imageUrl: userImage,
                          height: 24,
                          width: 24,
                        ),
                      );
                    }
                    return ValueListenableBuilder<AppFile?>(
                      valueListenable: pickedImageFile,
                      builder: (context, file, _) {
                        if (file?.bytes != null) {
                          return Container(
                            clipBehavior: Clip.hardEdge,
                            height: 95,
                            width: 95,
                            decoration: const BoxDecoration(shape: BoxShape.circle),
                            child: Image.memory(
                              file!.bytes,
                              fit: BoxFit.cover,
                            ),
                          );
                        }
                        return Container(
                          height: 95,
                          width: 95,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.inputFieldBg,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '+Add',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary,
                                ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const Gap(20),
              AppTextFormField(
                controller: nameController,
                title: 'Name*',
                inputFormatters: [
                  LengthLimitingTextInputFormatter(100),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
              ),
              const Gap(20),
              AppTextFormField(
                controller: emailController,
                title: 'Email*',
                readOnly: widget.userId != null,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter email';
                  } else if (!Utility.isValidEmail(value.trim())) {
                    return 'Please enter valid email';
                  }
                  return null;
                },
              ),
              const Gap(20),
              AppTextFormField(
                controller: villaNoController,
                title: 'Villa No.*',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(100),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter villa number';
                  }
                  return null;
                },
              ),
              const Gap(20),
              ValueListenableBuilder<String?>(
                valueListenable: selectedLine,
                builder: (context, lineNo, _) {
                  return AppDropDown<String>(
                    title: 'Line No.*',
                    hintText: 'Select',
                    selectedValue: lineNo,
                    onSelect: (valueOfCategory) {
                      selectedLine.value = valueOfCategory;
                    },
                    items: AppStrings.lineList
                        .map(
                          (e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(
                              e,
                            ),
                          ),
                        )
                        .toList(),
                    validator: (p0) {
                      if (p0 == null || p0.trim().isEmpty) {
                        return 'Please select line';
                      }
                      return null;
                    },
                  );
                },
              ),
              const Gap(20),
              ValueListenableBuilder<String?>(
                valueListenable: selectedRole,
                builder: (context, type, _) {
                  return AppDropDown<String>(
                    title: 'User Role*',
                    hintText: 'Select',
                    selectedValue: type,
                    onSelect: (valueOfCategory) {
                      selectedRole.value = valueOfCategory;
                    },
                    items: AppStrings.roleList
                        .map(
                          (e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(
                              e,
                            ),
                          ),
                        )
                        .toList(),
                    validator: (p0) {
                      if (p0 == null || p0.trim().isEmpty) {
                        return 'Please select line';
                      }
                      return null;
                    },
                  );
                },
              ),
              const Gap(20),
              AppTextFormField(
                controller: mobileNumberController,
                title: 'Contact number*',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter contact number';
                  }
                  return null;
                },
              ),
              if (widget.userId == null) ...[
                const Gap(20),
                ValueListenableBuilder<bool>(
                  valueListenable: passwordVisbility,
                  builder: (__, visible, _) {
                    return AppTextFormField(
                      title: 'Password*',
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                      obscureText: visible,
                      suffixIcon: IconButton(
                        onPressed: () {
                          passwordVisbility.value = !visible;
                        },
                        icon: AppAssetImage(
                          visible ? AppAssets.eyeOpenIcon : AppAssets.eyeCloseIcon,
                        ),
                      ),
                    );
                  },
                ),
              ],
              const Gap(20),
              ValueListenableBuilder<bool>(
                valueListenable: isButtonLoading,
                builder: (context, loading, _) {
                  return CustomeButtonGradiantWidget(
                    onTap: () {
                      if (!loading) {
                        EasyDebounce.debounce(
                          'edit-create-user',
                          const Duration(milliseconds: 500),
                          () {
                            if (widget.userId != null) {
                              editUser(); // Uncomment this line
                            } else {
                              createUser();
                            }
                          },
                        );
                      }
                    },
                    height: 38,
                    width: 100,
                    isGradient: true,
                    isLoading: loading,
                    child: Text(
                      widget.userId != null ? 'Edit' : 'Create',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 15, color: AppColors.white),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> createUser() async {
    if (_formKey.currentState!.validate()) {
      log('${pickedImageFile.value}image file name');
      isButtonLoading.value = true;
      final response = await getIt<IUserRepository>().addCustomer(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        mobileNumber: mobileNumberController.text.trim(),
        password: passwordController.text.trim(),
        villNumber: villaNoController.text.trim(),
        line: userLineViewString,
        role: userRoleViewString,
      );
      await response.fold(
        (l) {
          isButtonLoading.value = false;
          Utility.toast(message: l.message);
        },
        (r) async {
          isButtonLoading.value = false;
          Utility.toast(message: 'User created successfully');
          context.read<RefreshCubit>().modifyUser(r, UserAction.add);
          context.pop();
        },
      );
    }
  }

  Future<void> editUser() async {
    if (_formKey.currentState!.validate()) {
      isButtonLoading.value = true;
      final response = await getIt<IUserRepository>().updateCustomer(
        userId: widget.userId!,
        name: nameController.text,
        mobileNumber: mobileNumberController.text,
        line: userLineViewString,
        role: userRoleViewString,
        villNumber: villaNoController.text,
      );
      await response.fold(
        (l) {
          isButtonLoading.value = false;
          Utility.toast(message: l.message);
        },
        (r) async {
          isButtonLoading.value = false;
          Utility.toast(message: 'User updated successfully');
          context.read<RefreshCubit>().modifyUser(r, UserAction.edit);
          context.pop();
        },
      );
    }
  }

  String get userRoleViewString {
    switch (selectedRole.value) {
      case 'Admin':
        return AppConstants.admin;
      case 'Line head':
        return AppConstants.lineLead;
      case 'Line member':
        return AppConstants.lineMember;
      default:
        return AppConstants.admin;
    }
  }

  String get userLineViewString {
    switch (selectedLine.value) {
      case 'First line':
        return AppConstants.firstLine;
      case 'Second line':
        return AppConstants.secondLine;
      case 'Third line':
        return AppConstants.thirdLine;
      case 'Fourth line':
        return AppConstants.fourthLine;
      case 'Fifth line':
        return AppConstants.fifthLine;
      default:
        return AppConstants.firstLine;
    }
  }
}
