import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spark_app/view/pages/login_page.dart';
import '../../provider/sign_in_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/next_screen.dart';
import '../widgets/custom_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future getData() async {
    final sp = context.read<SignInProvider>();
    sp.getDataFromSharedPreferences();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    // change read to watch
    final sp = context.watch<SignInProvider>();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundColor:AppTheme.blackColor,
              backgroundImage: NetworkImage("${sp.imageUrl}"),
              radius: 70,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomTextWidget(
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.red800Color),
                  text: "Welcome ",
                ),
                CustomTextWidget(
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                  text: "${sp.name}",
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextWidget(
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              text: "${sp.email}",
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextWidget(
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              text: "${sp.uid}",
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomTextWidget(
                  text: "PROVIDER:",
                ),
                const SizedBox(
                  width: 5,
                ),
                CustomTextWidget(
                  text: "${sp.provider}".toUpperCase(),
                  style: const TextStyle(color:AppTheme.greenColor),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(AppTheme.greyColor),
              ),
              onPressed: () {
                sp.userSignOut();
                nextScreenReplace(context, const LoginPage());
              },
              child: const CustomTextWidget(
                style: TextStyle(
                  color: AppTheme.whiteColor,
                ),
                text: "SIGN OUT",
              ),
            )
          ],
        ),
      ),
    );
  }
}
