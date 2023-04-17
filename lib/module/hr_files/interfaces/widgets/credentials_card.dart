import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/internal/debug_utils.dart';

class CredentialsCard extends StatefulWidget {
  const CredentialsCard({
    required this.appTitle,
    required this.email,
    required this.password,
    Key? key,
  }) : super(key: key);

  final String appTitle;
  final String email;
  final String password;

  @override
  State<CredentialsCard> createState() => _CredentialsCardState();
}

class _CredentialsCardState extends State<CredentialsCard> {
  bool isClicked = false;
  bool showPassword = false;
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(() {
      if (emailFocusNode.hasFocus) {
        isClicked = true;
      }
    });

    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        isClicked = true;
      } else if (!passwordFocusNode.hasFocus) {
        isClicked = false;
        showPassword = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    final TextEditingController emailController =
        TextEditingController(text: widget.email);
    final TextEditingController passwordController =
        TextEditingController(text: widget.password);

    return Container(
      padding: EdgeInsets.all(width * 0.04),
      margin: EdgeInsets.only(
        left: width * 0.03,
        right: width * 0.03,
        bottom: height * 0.02,
        top: height * 0.035,
      ),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color:
                isClicked ? kBlue.withOpacity(0.17) : kBlack.withOpacity(0.06),
            spreadRadius: 5,
            blurRadius: 7,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(
            child: Text(
              widget.appTitle,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Text('Email'),
          ),
          TextField(
            readOnly: true,
            controller: emailController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: const Color(0xFFf5f7f9),
              suffixIcon: InkWell(
                focusNode: emailFocusNode,
                onFocusChange: (bool hasFocus) {
                  setState(() {
                    if (hasFocus) {
                      isClicked = true;
                    } else {
                      isClicked = false;
                    }
                  });
                },
                onTap: () {
                  FocusScope.of(context).requestFocus(emailFocusNode);
                  Clipboard.setData(ClipboardData(text: emailController.text));
                  showSnackBar(
                    message: 'Copied to clipboard',
                  );
                },
                child: const Icon(
                  Icons.content_copy_outlined,
                  color: kDarkGrey,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0), //responsiveness
            child: Text('Password'),
          ),
          TextField(
            readOnly: true,
            controller: passwordController,
            obscureText: !showPassword,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: const Color(0xFFf5f7f9),
              suffixIcon: InkWell(
                focusNode: passwordFocusNode,
                onFocusChange: (bool hasFocus) {
                  setState(() {
                    if (hasFocus) {
                      isClicked = true;
                    } else {
                      isClicked = false;
                    }
                  });
                },
                onTap: () {
                  FocusScope.of(context).requestFocus(passwordFocusNode);
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
                child: Icon(
                  Icons.remove_red_eye_outlined,
                  color: showPassword ? theme.primaryColor : kDarkGrey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
