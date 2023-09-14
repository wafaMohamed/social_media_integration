import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spark_app/view/pages/home_page.dart';
import 'package:spark_app/view/pages/login_page.dart';
import 'package:spark_app/view/widgets/custom_text.dart';
import '../../provider/internet_provider.dart';
import '../../provider/sign_in_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/config.dart';
import '../../utils/next_screen.dart';
import '../../utils/snackbar.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({Key? key}) : super(key: key);

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final formKey = GlobalKey<FormState>();

  // controller -> phone, email, name, otp code
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController otpCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppTheme.blackColor,
          ),
          onPressed: () {
            nextScreenReplace(context, const LoginPage());
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Image(
                    image: AssetImage(Config.appIcon), height: 50, width: 50),
                const SizedBox(
                  height: 10,
                ),
                const CustomTextWidget(
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  text: "Phone Login",
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Name cannot be empty";
                    }
                    return null;
                  },
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.account_circle),
                    hintText: "Wafa Mohamed",
                    hintStyle: const TextStyle(color: AppTheme.grey600Color),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppTheme.redColor)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: AppTheme.greyColor)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppTheme.greyColor),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Email address cannot be empty";
                    }
                    return null;
                  },
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email),
                    hintText: "abc@gmail.com",
                    hintStyle: const TextStyle(color: AppTheme.grey600Color),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppTheme.redColor)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: AppTheme.greyColor)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppTheme.greyColor),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Phone Number cannot be empty";
                    }
                    return null;
                  },
                  controller: phoneController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.phone),
                      hintText: "+20-01153545019",
                      hintStyle: const TextStyle(color: AppTheme.grey600Color),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: AppTheme.redColor)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: AppTheme.greyColor)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: AppTheme.greyColor))),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      login(context, phoneController.text.trim());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.whiteColor,
                    ),
                    child: const CustomTextWidget(
                      text: 'Register',

                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future login(BuildContext context, String mobile) async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackbar(
          context, "Check your internet connection", AppTheme.redColor);
    } else {
      if (formKey.currentState!.validate()) {
        FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: mobile,
            verificationCompleted: (AuthCredential credential) async {
              await FirebaseAuth.instance.signInWithCredential(credential);
            },
            verificationFailed: (FirebaseAuthException e) {
              openSnackbar(context, e.toString(), AppTheme.redColor);
            },
            codeSent: (String verificationId, int? forceResendingToken) {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const CustomTextWidget(
                      text: "Enter Code",
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: otpCodeController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.code),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  const BorderSide(color: AppTheme.redColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  const BorderSide(color: AppTheme.greyColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  const BorderSide(color: AppTheme.greyColor),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final code = otpCodeController.text.trim();
                            AuthCredential authCredential =
                                PhoneAuthProvider.credential(
                                    verificationId: verificationId,
                                    smsCode: code);
                            User user = (await FirebaseAuth.instance
                                    .signInWithCredential(authCredential))
                                .user!;
                            // save the values
                            sp.phoneNumberUser(user, emailController.text,
                                nameController.text);
                            // checking whether user exists,
                            sp.checkUserExists().then(
                              (value) async {
                                if (value == true) {
                                  // user exists
                                  await sp
                                      .getUserDataFromFirestore(sp.uid)
                                      .then(
                                        (value) => sp
                                            .saveDataToSharedPreferences()
                                            .then(
                                              (value) => sp.setSignIn().then(
                                                (value) {
                                                  nextScreenReplace(context,
                                                      const HomePage());
                                                },
                                              ),
                                            ),
                                      );
                                } else {
                                  // user does not exist
                                  await sp.saveDataToFirestore().then(
                                        (value) => sp
                                            .saveDataToSharedPreferences()
                                            .then(
                                              (value) => sp.setSignIn().then(
                                                (value) {
                                                  nextScreenReplace(context,
                                                      const HomePage());
                                                },
                                              ),
                                            ),
                                      );
                                }
                              },
                            );
                          },
                          child: const CustomTextWidget(
                            text: "Confirm",
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            },
            codeAutoRetrievalTimeout: (String verification) {});
      }
    }
  }
}
