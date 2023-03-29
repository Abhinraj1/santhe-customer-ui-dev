part of map_text_billing_view;

class _MapTextBillingMobile extends StatefulWidget {
  const _MapTextBillingMobile();

  @override
  State<_MapTextBillingMobile> createState() => _MapTextBillingMobileState();
}

class _MapTextBillingMobileState extends State<_MapTextBillingMobile> {
  final _controller = TextEditingController();
  String query = "";
  PlaceApiProvider apiClient = PlaceApiProvider();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isFetchingLocation = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('MapTextBillingMobile')),
    );
  }
}
