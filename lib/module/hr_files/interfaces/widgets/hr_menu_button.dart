import 'package:flutter/material.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/module/hr_files/interfaces/screens/pdf_viewer_screen.dart';

class HrMenuButton extends StatefulWidget {
  const HrMenuButton({
    required this.title,
    required this.icon,
    this.isDropdown = true,
    Key? key,
    this.functionCall,
  }) : super(key: key);

  final String title;
  final bool isDropdown;
  final IconData icon;
  final VoidCallback? functionCall;

  @override
  State<HrMenuButton> createState() => _HrMenuButtonState();
}

class _HrMenuButtonState extends State<HrMenuButton> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return SizedBox(
      height: isClicked ? (isPortrait ? height * 0.15 : height * 0.20) : null,
      child: Stack(
        children: <Widget>[
          if (widget.isDropdown)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              top: isClicked ? (isPortrait ? height * 0.07 : height * 0.10) : 0,
              child: AnimatedOpacity(
                opacity: isClicked ? 1 : 0,
                duration: const Duration(milliseconds: 250),
                child: GestureDetector(
                  onTap: () async {
                    Navigator.of(context).push(
                      MaterialPageRoute<dynamic>(
                        builder: (_) => PDFViewerScreen(
                          title: widget.title,
                          icon: widget.icon,
                        ),
                      ),
                    );
                    setState(() {
                      isClicked = false;
                    });
                  },
                  child: Container(
                    width: isPortrait ? width * 0.887 : width * 0.880,
                    margin: isPortrait
                        ? EdgeInsets.symmetric(horizontal: width * 0.015)
                        : EdgeInsets.symmetric(horizontal: width * 0.02),
                    padding: EdgeInsets.symmetric(
                      vertical: height * 0.025,
                      horizontal: width * 0.053,
                    ),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.06),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        const Text('PDF File'),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: theme.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          GestureDetector(
            onTap: () {
              setState(() {
                isClicked = !isClicked;
                if (!widget.isDropdown) {
                  Future<void>.delayed(const Duration(milliseconds: 500), () {
                    setState(() {
                    isClicked = false;
                    });
                    widget.functionCall?.call();
                  });
                }
              });
            },
            child: Container(
              padding:
                  EdgeInsets.all(isPortrait ? width * 0.03 : height * 0.03),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: isClicked
                    ? <BoxShadow>[
                        BoxShadow(
                          color: kBlue.withOpacity(0.17),
                          spreadRadius: 3,
                          blurRadius: 5,
                        ),
                      ]
                    : null,
              ),
              margin: isPortrait
                  ? EdgeInsets.symmetric(
                      vertical: height * 0.017,
                      horizontal: width * 0.020,
                    )
                  : EdgeInsets.symmetric(
                      vertical: height * 0.01,
                      horizontal: width * 0.008,
                    ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Icon(
                      widget.icon,
                      color: isClicked ? theme.primaryColor : kBlack,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.018),
                      child: Text(
                        widget.title,
                        style: isClicked
                            ? theme.textTheme.displayMedium
                                ?.copyWith(color: theme.primaryColor)
                            : theme.textTheme.displayMedium,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Icon(
                      widget.isDropdown
                          ? Icons.expand_more_outlined
                          : Icons.keyboard_arrow_right,
                      color: isClicked
                          ? theme.primaryColor
                          : kDarkGrey.withOpacity(0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
