import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:spark_app/provider/internet_provider.dart';
import 'package:spark_app/provider/sign_in_provider.dart';
import 'package:spark_app/utils/config.dart';
import 'package:spark_app/utils/snackbar.dart';
import 'package:spark_app/view/pages/home_page.dart';

import '../../utils/app_theme.dart';
import '../../utils/next_screen.dart';
import '../widgets/custom_text.dart';
import '../widgets/rounded_loading_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  final RoundedLoadingButtonController googleController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController facebookController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 40, bottom: 30, top: 90, right: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Flexible(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(
                      image: AssetImage(Config.appIcon),
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextWidget(
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                      text: "Social Media Integration Task",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextWidget(
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: AppTheme.greyColor),
                      text: "Wafa Mohamed - (The Spark Foundation)",
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundedLoadingButtonWidget(
                    color: AppTheme.redColor,
                    successColor: AppTheme.redColor,
                    text: "Sign In With Google",
                    controller: googleController,
                    iconData: FontAwesomeIcons.google,
                    onPressed: () {
                      handleGoogleSignIn();
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RoundedLoadingButtonWidget(
                    color: AppTheme.blueColor,
                    successColor: AppTheme.blueColor,
                    text: "Sign In With Facebook",
                    controller: facebookController,
                    iconData: FontAwesomeIcons.facebook,
                    onPressed: () {
                      handleFacebookAuth();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// handling google sign in
  Future handleGoogleSignIn() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    print('Internet available: ${ip.hasInternet}');

    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackbar(
        context,
        "Check your Internet connection",
        AppTheme.redColor,
      );
      googleController.reset();
    } else {
      await sp.signInWithGoogle().then(
        (value) {
          if (sp.hasError == true) {
            openSnackbar(
              context,
              sp.errorCode.toString(),
              AppTheme.redColor,
            );
            googleController.reset();
          } else {
            /// checking whether user exists or not
            sp.checkUserExists().then(
              (value) async {
                if (value == true) {
                  /// user exists
                  await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
                      .saveDataToSharedPreferences()
                      .then((value) => sp.setSignIn().then((value) {
                            googleController.success();
                            handleAfterSignIn();
                          })));
                } else {
                  /// user does not exist
                  sp.saveDataToFirestore().then(
                        (value) => sp.saveDataToSharedPreferences().then(
                              (value) => sp.setSignIn().then(
                                (value) {
                                  googleController.success();
                                  handleAfterSignIn();
                                },
                              ),
                            ),
                      );
                }
              },
            );
          }
        },
      );
    }
  }

  /// handling facebook auth
  Future handleFacebookAuth() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackbar(context, "Check your Internet connection", Colors.red);
      facebookController.reset();
    } else {
      await sp.signInWithFacebook().then(
        (value) {
          if (sp.hasError == true) {
            openSnackbar(context, sp.errorCode.toString(), Colors.red);
            facebookController.reset();
          } else {
            // checking whether user exists or not
            sp.checkUserExists().then(
              (value) async {
                if (value == true) {
                  // user exists
                  await sp.getUserDataFromFirestore(sp.uid).then(
                        (value) => sp.saveDataToSharedPreferences().then(
                              (value) => sp.setSignIn().then(
                                (value) {
                                  facebookController.success();
                                  handleAfterSignIn();
                                },
                              ),
                            ),
                      );
                } else {
                  // user does not exist
                  sp.saveDataToFirestore().then(
                        (value) => sp.saveDataToSharedPreferences().then(
                              (value) => sp.setSignIn().then(
                                (value) {
                                  facebookController.success();
                                  handleAfterSignIn();
                                },
                              ),
                            ),
                      );
                }
              },
            );
          }
        },
      );
    }
  }

  /// handle after signing (Navigate)
  handleAfterSignIn() {
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      nextScreenReplace(context, const HomePage());
    });
  }
}
