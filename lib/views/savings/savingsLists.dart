import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_toolkit/util/helper_class.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/views/savings/viewsinglesavings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavingsLists extends StatefulWidget {
  final int?  clientID;

  const SavingsLists({Key? key, this.clientID}) : super(key: key);

  @override
  _SavingsListsState createState() =>
      _SavingsListsState(clientID: this.clientID);
}

class _SavingsListsState extends State<SavingsLists> {
  List<dynamic> savings_lists = [];
  final int?  clientID;
  String?  staffId = '';
  bool appIsLoading = false;
  _SavingsListsState({this.clientID});

  @override
  void initState() {
    getSavingsLists();
    super.initState();
  }



  getSavingsLists() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      appIsLoading = true;
    });
    final Future<Map<String, dynamic>> response =
    RetCodes().getSavingsListsForAClient(clientID);
    response.then((response) {
      setState(() {
        appIsLoading = false;
      });
      print('this is app data ${response['data']}');
      setState(() {
        staffId =   prefs.getString('loanOfficerId');
        savings_lists = response['data']['savingsAccounts'];
        print('savings lists >> ${savings_lists}');
      });
    });



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'View Savings',
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
        onRefresh: () => getSavingsLists(),
        child:  LoadingOverlay(
          isLoading: appIsLoading,
          //  isLoading: false,
          progressIndicator: Container(
            height: 120,
            width: 120,
            child:  Lottie.asset('assets/images/newLoader.json'),
          ),
          child:
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:
            savings_lists.isEmpty
                ? noSavingsView()
                :
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  savingsAccountsList(savings_lists),
                  const SizedBox(height: 20),

                  // redeemInstructions(),
                ],
              ),
            ),
          ),
        ),
      ),



    );
  }


  Widget savingsAccountsList(List<dynamic> savingsAccounts) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: savingsAccounts.length,
      itemBuilder: (context, index) {
        final account = savingsAccounts[index];

        final status = account['status']['value'];

        final isPending = account['status']['submittedAndPendingApproval'];
        final isActive = account['status']['active'];
        final statusColor = isPending
            ? Colors.orange
            : isActive
            ? Colors.green
            : Colors.grey;

        final submittedDate = account['timeline']['submittedOnDate'];
        final formattedDate =
            '${submittedDate[2].toString().padLeft(2, '0')}-${submittedDate[1].toString().padLeft(2, '0')}-${submittedDate[0]}';

        return GestureDetector(
          onTap: () {
            MyRouter.pushPage(context, GetSavingsDetails(accountId: account['id']));
          },
          child: Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Top Row: Product and Account No
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.account_balance_wallet, color: Colors.blueGrey),
                          const SizedBox(width: 8),
                          Text(
                            '${account['productName']} (${account['shortProductName']})',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '#${account['accountNo']}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  /// Deposit Type & Currency
                  Row(
                    children: [
                      Icon(Icons.savings, color: Colors.green.shade600),
                      const SizedBox(width: 6),
                      Text(
                        account['depositType']['value'],
                        style: const TextStyle(fontSize: 14),
                      ),
                      const Spacer(),
                      Text(
                        account['currency']['displaySymbol'],
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  /// Status and Submitted Date
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, size: 16, color: statusColor),
                            const SizedBox(width: 6),
                            Text(
                              status,
                              style: TextStyle(
                                fontSize: 13,
                                color: statusColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(Icons.date_range, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            formattedDate,
                            style: const TextStyle(fontSize: 13, color: Colors.black54),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  Widget noSavingsView() {
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
            'No Savings Found',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 10),
          const Text(
            'Sorry, no active savings are available for the client.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
