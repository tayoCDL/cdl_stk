import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';

class GetSavingsDetails extends StatefulWidget {
  final int accountId;

  const GetSavingsDetails({Key? key, required this.accountId}) : super(key: key);

  @override
  State<GetSavingsDetails> createState() => _GetSavingsDetailsState();
}

class _GetSavingsDetailsState extends State<GetSavingsDetails> {
  Map<String, dynamic>? account;
  bool appIsLoading = false;

  @override
  void initState() {
    super.initState();
    fetchSavingsAccountDetails();
  }

  Future<void> fetchSavingsAccountDetails() async {
    setState(() => appIsLoading = true);

    try {
      final response = await RetCodes().getSingleSavingsAccount(widget.accountId);
      setState(() {
        account = response['data'];
        appIsLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() => appIsLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Savings Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
          onPressed: () => MyRouter.popPage(context),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetchSavingsAccountDetails,
        child: LoadingOverlay(
          isLoading: appIsLoading,
          progressIndicator: Lottie.asset('assets/images/newLoader.json', height: 120),
          child: account == null
              ? noDetailsView()
              : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: buildDetailsCard(account!),
          ),
        ),
      ),
    );
  }

  Widget buildDetailsCard(Map<String, dynamic> account) {
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

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.savings, color: Colors.blue, size: 40),
            const SizedBox(height: 10),

            /// Product Name & Account No
            Text(
              ' (${account['savingsProductName']})',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Account No: ${account['accountNo']}',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),

            const SizedBox(height: 20),
            infoRow(Icons.safety_check, 'Deposit Type', account['depositType']['value']),
            infoRow(Icons.currency_exchange, 'Currency', account['currency']['displaySymbol']),
            infoRow(Icons.date_range, 'Submitted On', formattedDate),
            infoRow(Icons.person, 'Submitted By',
                '${account['timeline']['submittedByFirstname']} ${account['timeline']['submittedByLastname']}'),
           // infoRow(Icons.security, 'Account Type', account['accountType']['value']),

            const SizedBox(height: 20),
            /// Status tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline, size: 18, color: statusColor),
                  const SizedBox(width: 6),
                  Text(
                    status,
                    style: TextStyle(color: statusColor, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 10),
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  Widget noDetailsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/images/no_loan.svg", height: 120),
          const SizedBox(height: 20),
          const Text('No Details Found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text(
            'We couldn’t fetch the savings account details at this time.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
