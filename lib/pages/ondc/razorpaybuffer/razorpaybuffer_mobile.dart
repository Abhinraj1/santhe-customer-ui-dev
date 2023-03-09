part of razorpaybuffer_view;

class _RazorpaybufferMobile extends StatefulWidget {
  const _RazorpaybufferMobile();

  @override
  State<_RazorpaybufferMobile> createState() => _RazorpaybufferMobileState();
}

class _RazorpaybufferMobileState extends State<_RazorpaybufferMobile>
    with LogMixin {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutBloc, CheckoutState>(
      listener: (context, state) {
        warningLog('$state');
      },
      builder: (context, state) {
        return Material(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/circularProgress.png'),
                    const SizedBox(
                      height: 60,
                    ),
                    Text(
                      'Initiating Payment',
                      style: TextStyle(
                        color: AppColors().brandDark,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Connecting to razorPay',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
