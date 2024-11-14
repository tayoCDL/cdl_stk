//import 'package:flutter_pdfview/flutter_pdfview.dart';

// class PdfPreview extends StatefulWidget {
//   const PdfPreview({Key key}) : super(key: key);
//
//   @override
//   _PdfPreviewState createState() => _PdfPreviewState();
// }
//
// class _PdfPreviewState extends State<PdfPreview> {
//   String pathPDF = "";
//   String landscapePathPdf = "";
//   String remotePDFpath = "";
//
//
//   @override
//   void initState() {
//     super.initState();
//
//     createFileOfPdfUrl().then((f) {
//       setState(() {
//         remotePDFpath = f.path;
//       });
//     });
//   }
//
//
// Future<File> createFileOfPdfUrl() async {
//   Completer<File> completer = Completer();
//   print("Start download file from internet!");
//   try {
//
//     final url = "http://www.pdf995.com/samples/pdf.pdf";
//
//     final filename = url.substring(url.lastIndexOf("/") + 1);
//
//     var request = await HttpClient().getUrl(Uri.parse(url));
//     var response = await request.close();
//     var bytes = await consolidateHttpClientResponseBytes(response);
//     var dir = await getApplicationDocumentsDirectory();
//     print("Download files");
//     print("${dir.path}/$filename");
//     File file = File("${dir.path}/$filename");
//
//     await file.writeAsBytes(bytes, flush: true);
//     completer.complete(file);
//   } catch (e) {
//     throw Exception('Error parsing asset file!');
//   }
//
//   return completer.future;
// }
//
//   Widget build(BuildContext context) {
//     return Container(
//       child:    TextButton(
//         child: Text("Remote PDF"),
//         onPressed: () {
//           if (remotePDFpath.isNotEmpty) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => PDFScreen(path: remotePDFpath),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
//
//
// class PDFScreen extends StatefulWidget {
//   final String path;
//
//   PDFScreen({Key key, this.path}) : super(key: key);
//
//   _PDFScreenState createState() => _PDFScreenState();
// }
//
// class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
//   final Completer<PDFViewController> _controller =
//   Completer<PDFViewController>();
//   int pages = 0;
//   int currentPage = 0;
//   bool isReady = false;
//   String errorMessage = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Document"),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.share),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Stack(
//         children: <Widget>[
//           PDFView(
//             filePath: widget.path,
//             enableSwipe: true,
//             swipeHorizontal: true,
//             autoSpacing: false,
//             pageFling: true,
//             pageSnap: true,
//             defaultPage: currentPage,
//             fitPolicy: FitPolicy.BOTH,
//             preventLinkNavigation:
//             false, // if set to true the link is handled in flutter
//             onRender: (_pages) {
//               setState(() {
//                 pages = _pages;
//                 isReady = true;
//               });
//             },
//             onError: (error) {
//               setState(() {
//                 errorMessage = error.toString();
//               });
//               print(error.toString());
//             },
//             onPageError: (page, error) {
//               setState(() {
//                 errorMessage = '$page: ${error.toString()}';
//               });
//               print('$page: ${error.toString()}');
//             },
//             onViewCreated: (PDFViewController pdfViewController) {
//               _controller.complete(pdfViewController);
//             },
//             onLinkHandler: (String uri) {
//               print('goto uri: $uri');
//             },
//             onPageChanged: (int page, int total) {
//               print('page change: $page/$total');
//               setState(() {
//                 currentPage = page;
//               });
//             },
//           ),
//           errorMessage.isEmpty
//               ? !isReady
//               ? Center(
//             child: CircularProgressIndicator(),
//           )
//               : Container()
//               : Center(
//             child: Text(errorMessage),
//           )
//         ],
//       ),
//       floatingActionButton: FutureBuilder<PDFViewController>(
//         future: _controller.future,
//         builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
//           if (snapshot.hasData) {
//             return FloatingActionButton.extended(
//               label: Text("Go to ${pages ~/ 2}"),
//               onPressed: () async {
//                 await snapshot.data.setPage(pages ~/ 2);
//               },
//             );
//           }
//
//           return Container();
//         },
//       ),
//     );
//   }
// }