part of hyperlocal_shophome_view;

class _HyperlocalShophomeMobile extends StatefulWidget {
  const _HyperlocalShophomeMobile();

  @override
  State<_HyperlocalShophomeMobile> createState() =>
      _HyperlocalShophomeMobileState();
}

class _HyperlocalShophomeMobileState extends State<_HyperlocalShophomeMobile> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HyperlocalShopBloc, HyperlocalShopState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Text('HyperlocalShophomeMobile'),
          ),
        );
      },
    );
  }
}
