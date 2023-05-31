import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/infrastructures/models/hr/hr_response.dart';
import 'package:octopus/internal/screen_resolution_utils.dart';
import 'package:octopus/module/hr_files/interfaces/screens/pdf_viewer_screen.dart';

class HrMenuButton extends StatefulWidget {
  const HrMenuButton({
    required this.title,
    required this.icon,
    this.companyFileType,
    this.isDropdown = true,
    Key? key,
    this.functionCall,
  }) : super(key: key);

  final String title;
  final bool isDropdown;
  final IconData icon;
  final VoidCallback? functionCall;
  final CompanyFileType? companyFileType;

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
    return SizedBox(
      width: kIsWeb && width > smWebMinWidth ? width * 0.25 : width,
      height: isClicked
          ? kIsWeb && width > smWebMinWidth
              ? height * 0.17
              : height * 0.20
          : null,
      child: Stack(
        children: <Widget>[
          if (widget.isDropdown)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              top: isClicked ? height * 0.08 : 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: isClicked ? 1 : 0,
                duration: const Duration(milliseconds: 250),
                child: GestureDetector(
                  onTap: widget.companyFileType != null
                      ? () async {
                          Navigator.of(context).push(
                            MaterialPageRoute<dynamic>(
                              builder: (_) => PDFViewerScreen(
                                title: widget.title,
                                icon: widget.icon,
                                companyFileType: widget.companyFileType!,
                              ),
                            ),
                          );
                          setState(() {
                            isClicked = false;
                          });
                        }
                      : null,
                  child: Container(
                    width:
                        kIsWeb && width > smWebMinWidth ? width * 0.25 : width,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 18.5,
                    ),
                    margin: EdgeInsets.only(
                      top: kIsWeb && width > smWebMinWidth ? 5 : 20,
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
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18.5,
              ),
              margin: EdgeInsets.only(
                top: kIsWeb && width > smWebMinWidth ? 5 : 20,
              ),
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
