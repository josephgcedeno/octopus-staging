import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octopus/configs/themes.dart';
import 'package:octopus/infrastructures/models/hr/hr_response.dart';
import 'package:octopus/interfaces/widgets/appbar.dart';
import 'package:octopus/interfaces/widgets/widget_loader.dart';
import 'package:octopus/internal/debug_utils.dart';
import 'package:octopus/internal/screen_resolution_utils.dart';
import 'package:octopus/module/hr_files/interfaces/widgets/download_button.dart';
import 'package:octopus/module/hr_files/services/cubit/hr_cubit.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerScreen extends StatefulWidget {
  const PDFViewerScreen({
    required this.title,
    required this.icon,
    required this.companyFileType,
    Key? key,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final CompanyFileType companyFileType;

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  String? urlPDF;

  @override
  void initState() {
    super.initState();
    context.read<HrCubit>().fetchPDFFile(fileType: widget.companyFileType);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    const int loaderItems = 13;

    return Scaffold(
      appBar: const GlobalAppBar(leading: LeadingButton.back),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.055,
              vertical: height * 0.01,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(widget.icon),
                    Padding(
                      padding: EdgeInsets.only(left: width * 0.03),
                      child: Text(
                        widget.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                if (urlPDF != null)
                  DownloadButton(
                    title: widget.title,
                    url: urlPDF!,
                    documentLoading: false,
                  ),
              ],
            ),
          ),
          Align(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffFAFBFC),
                borderRadius: BorderRadius.circular(6),
              ),
              width: kIsWeb && width > smWebMinWidth ? width * 0.50 : width,
              height: height * 0.80,
              padding: const EdgeInsets.all(10),
              child: BlocConsumer<HrCubit, HrState>(
                listenWhen: (HrState previous, HrState current) =>
                    current is FetchPDFFileFailed ||
                    current is FetchPDFFileSuccess,
                listener: (BuildContext context, HrState state) {
                  if (state is FetchPDFFileSuccess) {
                    setState(() {
                      urlPDF = state.companyFiles[0].fileSource;
                    });
                  } else if (state is FetchPDFFileFailed) {
                    showSnackBar(message: state.message);
                  }
                },
                buildWhen: (HrState previous, HrState current) =>
                    current is FetchPDFFileFailed ||
                    current is FetchPDFFileLoading ||
                    current is FetchPDFFileSuccess,
                builder: (BuildContext context, HrState state) {
                  if (state is FetchPDFFileSuccess) {
                    return SfPdfViewerTheme(
                      data: SfPdfViewerThemeData(
                        progressBarColor: ktransparent,
                      ),
                      child: SfPdfViewer.network(
                        state.companyFiles[0].fileSource,
                        onDocumentLoadFailed: (_) {
                          showSnackBar(
                            message: 'Document failed to load',
                            snackBartState: SnackBartState.error,
                          );
                        },
                      ),
                    );
                  } else if (state is FetchPDFFileFailed) {
                    showSnackBar(message: state.message);
                  }
                  return Container(
                    color: kLightGrey,
                    padding: EdgeInsets.all(width * 0.035),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        for (int i = 0; i < loaderItems; i++)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: height * 0.008,
                              horizontal: width * 0.025,
                            ),
                            child: lineLoader(
                              height: Random().nextInt(15) + 10,
                              width: double.infinity,
                            ),
                          )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
