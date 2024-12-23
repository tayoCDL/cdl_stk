import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_toolkit/util/helper_class.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfferScreenSubMenu extends StatefulWidget {
  final int clientID;

  const OfferScreenSubMenu({Key key, this.clientID}) : super(key: key);

  @override
  _OfferScreenSubMenuState createState() =>
      _OfferScreenSubMenuState(clientID: this.clientID);
}

class _OfferScreenSubMenuState extends State<OfferScreenSubMenu> {
  List<dynamic> offers_lists = [];
  final int clientID;
  String staffId = '';
  bool appIsLoading = false;
  _OfferScreenSubMenuState({this.clientID});

  @override
  void initState() {
    getClientOffersLists();
    super.initState();
  }

  Future<void> shareOffer(String offerDetails) async {
    await FlutterShare.share(
      title: 'Loan Offer',
      text: offerDetails,
    //  linkUrl: 'https://ussdcp.creditdirect.ng/',
      chooserTitle: 'Share Offer',
    );
  }

  getClientOffersLists() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        appIsLoading = true;
      });
    final Future<Map<String, dynamic>> response =
    RetCodes().getLoanOfferForClient(clientID);
    response.then((response) {
      setState(() {
       appIsLoading = false;
      });
      print('this is app data ${response['data']}');
      setState(() {
        staffId =   prefs.getString('loanOfficerId');
        offers_lists = response['data']['data'];
      });
    });



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'View Offer',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            MyRouter.popPage(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.blue,
          ),
        ),
      ),
      body:
            RefreshIndicator(
              onRefresh: () => getClientOffersLists(),
              child:  LoadingOverlay(
                isLoading: appIsLoading,
                progressIndicator: Container(
                  height: 120,
                  width: 120,
                  child:  Lottie.asset('assets/images/newLoader.json'),
                ),
                child:
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: offers_lists.isEmpty
                      ? noOffersView()
                      : SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        offersLists(),
                        const SizedBox(height: 20),
                        shareOfferButton(),
                        const SizedBox(height: 20),
                        const Text(
                          "Ways To Redeem Your Loan Offer",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        redeemInstructions(),
                      ],
                    ),
                  ),
                ),
              ),
            ),



    );
  }

  Widget offersLists() {
    return Column(
      children: offers_lists.map((offer) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.only(bottom: 15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Offer ${offer['loanId']}: ₦${AppHelper().formatCurrency(offer['amount'].toStringAsFixed(2))}',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${offer['tenure']} months',
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // Widget shareOfferButton() {
  //   final String allOffersDetails = offers_lists.map((offer) {
  //  //   return 'Offer ${offer['loanId']}: ₦${AppHelper().formatCurrency(offer['amount'].toStringAsFixed(2))} - ${offer['tenure']} months';
  //     return 'Offer ${offer['loanId']}: ₦${AppHelper().formatCurrency(offer['amount'].toStringAsFixed(2))} - ${offer['tenure']} months';
  //   }).join('\n');
  //
  //   return ElevatedButton.icon(
  //     onPressed: () => shareOffer(allOffersDetails),
  //     icon: const Icon(Icons.share, color: Colors.white),
  //     label: const Text("Share Offers"),
  //     style: ElevatedButton.styleFrom(
  //       primary: Colors.blue,
  //       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
  //       textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //     ),
  //   );
  // }
  Widget shareOfferButton() {
    // Redeem instructions content
    final String redeemInstructionsDetails = """

Good news! You're eligible for a loan offer with Credit Direct! Follow the prompts below to redeem your offer:
1. Dial *5120*${staffId}#
2. Chat with 09070309430 on WhatsApp, or 3. Visit https://ussdcp.creditdirect.ng
Use my referral code: referral code.

Please feel free to reach out to me for any further clarifications.
  """;

    return ElevatedButton.icon(
      onPressed: () => shareOffer(redeemInstructionsDetails),
      icon: const Icon(Icons.share, color: Colors.white),
      label: const Text("Share Redeem Instructions"),
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }


  Widget redeemInstructions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "1. Dial *5120*refId# to redeem your loan offer via our USSD Code.",
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
        SizedBox(height: 6),
        Text(
          "2. Chat with our BOT on WhatsApp via the below number : 08060798415.",
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
        SizedBox(height: 6),
        Text(
          "3. Visit our webpage on https://ussdcp.creditdirect.ng/",
          style: TextStyle(fontSize: 14, color: Colors.blue),
        ),
      ],
    );
  }

  Widget noOffersView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/images/no_loan.svg",
            height: 120,
            width: 120,
          ),
          const SizedBox(height: 20),
          const Text(
            'No Offer Found',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 10),
          const Text(
            'Sorry, no active offers are available for the client.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
