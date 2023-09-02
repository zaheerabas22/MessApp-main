import 'package:flutter/material.dart';

import 'package:messapp/mainscreens/constants.dart';
import 'package:messapp/auth/login.dart';
import 'package:messapp/mainscreens/SignUpSelectionScreem.dart';

class LoginAndSignupBtn extends StatelessWidget {
  const LoginAndSignupBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: "login_btn",
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const LoginScreen();
                    },
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        30), // Adjust the radius value as needed
                  ),
                  primary: kPrimaryColor,
                  elevation: 0),
              child: Text(
                "Login".toUpperCase(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 22),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 40,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignUpSelectionScreen();
                  },
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      30), // Adjust the radius value as needed
                ),
                primary: kPrimaryLightColor,
                elevation: 0),
            child: Text(
              "Sign Up".toUpperCase(),
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
