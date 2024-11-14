// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:provider/provider.dart';
// import 'package:sales_toolkit/util/enum/color_utils.dart';
//
//
//
// class RepaymentViewRepaymentScheduleDialog extends StatelessWidget {
//   const RepaymentViewRepaymentScheduleDialog(
//       {Key key,})
//       : super(key: key);
//
//   final void Function(String) onChanged;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height - 200,
//       decoration: BoxDecoration(
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.black.withOpacity(0.02),
//                 spreadRadius: MediaQuery.of(context).size.height,
//                 blurRadius: 1)
//           ],
//           color: ColorUtils.CHANGE_LOG_APP_COLOR,
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
//       child: Padding(
//         padding: horizontalPadding(size: 10),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//            SizedBox(height: 15,)
//             Container(
//               width: MediaQuery.of(context).size.width / 3,
//               height: 5,
//               decoration: BoxDecoration(
//                   color: Colors.black, borderRadius: BorderRadius.circular(10)),
//             ),
//             verticalSpacing(spacing: 20),
//             Align(
//               alignment: Alignment.topLeft,
//               child: Text(
//                 'Repayment Schedule',
//                 textAlign: TextAlign.left,
//                 style: baseTextStyle(context,
//                     color: Colors.black,
//                     fontSize: 28,
//                     fontWeight: FontWeight.w600),
//               ),
//             ),
//             verticalSpacing(spacing: 7),
//             Align(
//               alignment: Alignment.topLeft,
//               child: Text(
//                 'Breakdown of loan repayment below;',
//                 textAlign: TextAlign.left,
//                 style: baseTextStyle(context,
//                     color: Colors.black.withOpacity(0.7),
//                     fontSize: 16,
//                     fontWeight: FontWeight.normal),
//               ),
//             ),
//             verticalSpacing(spacing: 30),
//             RepaymentAnalysis(showBackGroung: true),
//             verticalSpacing(spacing: 20),
//             Expanded(
//               child: ListView.builder(
//                   physics: const BouncingScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount: context
//                       .read<PayBackController>()
//                       .repaymentScheduleRespond
//                       ?.repaymentSchedule
//                       ?.periods
//                       ?.length ??
//                       0,
//                   itemBuilder: (context, index) {
//                     if (index == 0) {
//                       return const SizedBox.shrink();
//                     }
//                     final currentPeriod = context
//                         .read<PayBackController>()
//                         .repaymentScheduleRespond
//                         ?.repaymentSchedule
//                         ?.periods![index];
//
//                     final dueDate = currentPeriod!.dueDate;
//
//                     final amount = currentPeriod.totalOriginalDueForPeriod;
//
//                     var isLoanComplete = currentPeriod.complete;
//
//                     final repaymentModel = ViewRepaymentScheduleModel(
//                         (index).toString(),
//                         locator
//                             .get<DateConverter>()
//                             .convertUserDateOfBirth(dueDate),
//                         moneyConverter(amount.toString()));
//
//                     return RepaymentAnalysis(
//                       viewRepaymentScheduleModel: repaymentModel,
//                       isLoanComplete: isLoanComplete,
//                     );
//                   }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class RepaymentAnalysis extends StatelessWidget {
//   final ViewRepaymentScheduleModel? viewRepaymentScheduleModel;
//   final bool? isLoanComplete;
//
//   RepaymentAnalysis(
//       {Key? key,
//         this.viewRepaymentScheduleModel,
//         this.showBackGroung = false,
//         this.isLoanComplete = false})
//       : super(key: key);
//
//   final bool showBackGroung;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 50,
//       decoration: BoxDecoration(
//           color: showBackGroung
//               ? ColorUtils.PRIMARY_COLOR.withOpacity(0.15)
//               : Colors.transparent,
//           borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               children: [
//                 Text(
//                   viewRepaymentScheduleModel?.month ?? 'Month',
//                   textAlign: TextAlign.left,
//                   style: baseTextStyle(context,
//                       color: ColorUtils.PRIMARY_COLOR,
//                       fontSize: 14,
//                       fontWeight: FontWeight.normal),
//                 ),
//                 horizontalSpacing(spacing: 5),
//                 isLoanComplete!
//                     ? Icon(
//                   Icons.done_rounded,
//                   color: Colors.green[400],
//                   size: 24,
//                 )
//                     : const SizedBox.shrink()
//               ],
//             ),
//             const Spacer(),
//             Text(
//               viewRepaymentScheduleModel?.dueDate ?? 'DueDate',
//               textAlign: TextAlign.left,
//               style: baseTextStyle(context,
//                   color: showBackGroung
//                       ? ColorUtils.PRIMARY_COLOR
//                       : isLoanComplete!
//                       ? Colors.black.withOpacity(0.5)
//                       : Colors.black.withOpacity(0.8),
//                   fontSize: 16,
//                   fontWeight: FontWeight.w400),
//             ),
//             const Spacer(),
//             Text(
//               viewRepaymentScheduleModel?.amount ?? 'Amount',
//               textAlign: TextAlign.start,
//               style: baseTextStyle(context,
//                   color: showBackGroung
//                       ? ColorUtils.PRIMARY_COLOR
//                       : isLoanComplete!
//                       ? Colors.black.withOpacity(0.5)
//                       : Colors.black.withOpacity(0.8),
//                   fontSize: 16,
//                   fontWeight: FontWeight.w400),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
