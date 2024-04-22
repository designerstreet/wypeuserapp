import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wype_user/constants.dart';

class FileViewPage extends StatefulWidget {
  String assetPath;
  FileViewPage({super.key, required this.assetPath});

  @override
  State<FileViewPage> createState() => _FileViewPageState();
}

class _FileViewPageState extends State<FileViewPage> {
  String pathPDF = "";

  @override
  void initState() {
    super.initState();
    fromAsset(widget.assetPath, widget.assetPath.split('/').last).then((f) {
      setState(() {
        pathPDF = f.path;
      });
    });
  }

  Future<File> fromAsset(String asset, String filename) async {
    // To open from assets, you can copy them to the app storage folder, and the access them "locally"
    Completer<File> completer = Completer();

    try {
      if (Platform.isAndroid) {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          await Permission.storage.request();
        }
      }
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: pathPDF.isEmpty
          ? Container(child: Center(child: CircularProgressIndicator(  color: darkGradient,)))
          : PDFView(
              filePath: pathPDF,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: false,
              fitPolicy: FitPolicy.BOTH,
              pageFling: false,
              onRender: (pages) {
                setState(() {});
              },
              onError: (error) {
               Container(child: Center(child: CircularProgressIndicator(  color: darkGradient,)));
              },
              onPageError: (page, error) {
                Container(child: Center(child: CircularProgressIndicator(  color: darkGradient,)));
              },
              onViewCreated: (PDFViewController pdfViewController) {},
            ),
    );
  }
}
