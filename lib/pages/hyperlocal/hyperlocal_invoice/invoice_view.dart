// ignore_for_file: public_member_api_docs, sort_constructors_first
library invoice_view;

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:resize/resize.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:webview_flutter/webview_flutter.dart';

part 'invoice_desktop.dart';
part 'invoice_mobile.dart';
part 'invoice_tablet.dart';

class InvoiceView extends StatelessWidget {
  final String invoiceUrl;
  const InvoiceView({
    Key? key,
    required this.invoiceUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ScreenTypeLayout(
        mobile: _InvoiceMobile(
          invoiceUrl: invoiceUrl,
        ),
        desktop: _InvoiceDesktop(),
        tablet: _InvoiceTablet(),
      );
    });
  }
}
