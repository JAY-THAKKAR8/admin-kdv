// ignore_for_file: use_build_context_synchronously

import 'package:admin_kdv/app/routes/app_route.dart';
import 'package:admin_kdv/auth/repository/i_auth_repository.dart';
import 'package:admin_kdv/constants/app_assets.dart';
import 'package:admin_kdv/constants/app_colors.dart';
import 'package:admin_kdv/injector/injector.dart';
import 'package:admin_kdv/master/widget/app_asset_image.dart';
import 'package:admin_kdv/master/widget/app_text_form_field.dart';
import 'package:admin_kdv/master/widget/custome_button_gradiant_widget.dart';
import 'package:admin_kdv/utility/extentions/string_extentions.dart';
import 'package:admin_kdv/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController(text: 'admin@gmail.com'.isDebugging);
  final passwordController = TextEditingController(text: 'password'.isDebugging);
  final passwordVisbility = ValueNotifier<bool>(true);

  final isLoading = ValueNotifier<bool>(false);

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    isLoading.dispose();
    passwordVisbility.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.background,
      body: Stack(
        alignment: getValueForScreenType(
          context: context,
          mobile: Alignment.center,
          tablet: Alignment.center,
          desktop: Alignment.bottomRight,
        ),
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            child: Image.asset(
              AppAssets.loginbg,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            constraints: BoxConstraints(
              maxWidth: getValueForScreenType(context: context, mobile: 450, tablet: 450, desktop: 500),
            ),
            decoration: getValueForScreenType(
              context: context,
              mobile: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              tablet: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              desktop: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  bottomLeft: Radius.circular(60),
                ),
              ),
            ),
            padding: getValueForScreenType(
              context: context,
              mobile: const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
              tablet: const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
              desktop: const EdgeInsets.symmetric(vertical: 16, horizontal: 90),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: getValueForScreenType(
                  context: context,
                  mobile: MainAxisSize.min,
                  tablet: MainAxisSize.min,
                  desktop: MainAxisSize.max,
                ),
                children: [
                  Row(
                    children: [
                      const AppAssetImage(
                        AppAssets.logo,
                        height: 42,
                        width: 42,
                      ),
                      const Gap(10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'KDV',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          Text(
                            'Management',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Gap(20),
                  Text(
                    'Login',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const Gap(20),
                  AppTextFormField(
                    hintText: 'Email',
                    title: 'Email',
                    textInputAction: TextInputAction.next,
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty || !Utility.isValidEmail(value.trim())) {
                        return 'Please enter valid email';
                      }
                      return null;
                    },
                  ),
                  const Gap(20),
                  ValueListenableBuilder<bool>(
                    valueListenable: passwordVisbility,
                    builder: (__, visible, _) {
                      return AppTextFormField(
                        hintText: 'Password',
                        title: 'Password',
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                        onFieldSubmitted: (p0) {},
                        obscureText: visible,
                        suffixIcon: IconButton(
                          onPressed: () {
                            passwordVisbility.value = !visible;
                          },
                          icon: AppAssetImage(
                            visible ? AppAssets.eyeCloseIcon : AppAssets.eyeOpenIcon,
                          ),
                        ),
                      );
                    },
                  ),
                  const Gap(20),
                  ValueListenableBuilder<bool>(
                    valueListenable: isLoading,
                    builder: (_, value, __) {
                      return CustomeButtonGradiantWidget(
                        buttonText: 'Login',
                        isLoading: value,
                        isGradient: true,
                        onTap: () {
                          login();
                        },
                      );
                    },
                  ),
                  const Gap(10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;
    isLoading.value = true;

    final failOrSuccess = await getIt<IAuthRepository>()
        .signInWithEmail(email: emailController.text.trim(), password: passwordController.text.trim());

    failOrSuccess.fold(
      (l) {
        isLoading.value = false;
        Utility.toast(message: l.message);
      },
      (r) {
        isLoading.value = false;
        Utility.toast(message: 'Welcome to home');
        context.go(AppRoutes.home.route);
      },
    );
  }
}
