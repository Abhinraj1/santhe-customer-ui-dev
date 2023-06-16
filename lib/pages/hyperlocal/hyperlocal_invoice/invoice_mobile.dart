// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors_in_immutables

part of invoice_view;

class _InvoiceMobile extends StatefulWidget {
  final String invoiceUrl;
  const _InvoiceMobile({
    Key? key,
    required this.invoiceUrl,
  }) : super(key: key);

  @override
  State<_InvoiceMobile> createState() => _InvoiceMobileState();
}

class _InvoiceMobileState extends State<_InvoiceMobile> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height / 100;
    log(widget.invoiceUrl,
        time: DateTime.now(), name: 'Invoice_mobile.dart', sequenceNumber: 1);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        toolbarHeight: screenHeight * 5.5,
        leading: IconButton(
          splashRadius: 0.1,
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 13.sp,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Invoice',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18.sp),
        ),
      ),
      body: SfPdfViewer.network(
        widget.invoiceUrl,
        canShowHyperlinkDialog: false,
        canShowPaginationDialog: false,
        canShowScrollHead: false,
        canShowScrollStatus: false,
        enableDocumentLinkAnnotation: false,
        enableTextSelection: false,
        enableDoubleTapZooming: false,
        enableHyperlinkNavigation: false,
        canShowPasswordDialog: false,
        key: _pdfViewerKey,
      ),
    );
  }
}
