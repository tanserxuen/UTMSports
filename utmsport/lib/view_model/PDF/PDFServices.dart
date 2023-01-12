import 'dart:io';
import 'dart:typed_data';

// import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file_plus/open_file_plus.dart';

// import 'package:pdf/widgets.dart' as pw;
import 'package:utmsport/utils.dart';

class PDFService {
  requestPermission() async {
    PermissionStatus permissionResult;
    permissionResult = await Permission.storage.request();
    if (permissionResult.isGranted) {
      print("granted");
      return true;
    }
    return false;
  }

  /*generatePDF(data, img, reportName, columnNames) {
    final pdf = pw.Document();
    Uint8List image = img.buffer.asUint8List(); //you could use async as well

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: pw.EdgeInsets.all(31),
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Table(
              children: [
                pw.TableRow(
                  children: [
                    pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "$reportName Report",
                          style: pw.TextStyle(
                              fontSize: 28, color: PdfColors.deepOrange400),
                        ),
                        pw.Text(
                          'Live Healthier Lifestyle',
                          textAlign: pw.TextAlign.right,
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        //TODO: insert UTM logo
                        pw.Image(pw.MemoryImage(image),
                            fit: pw.BoxFit.contain, width: 10, height: 10),
                        pw.Text(
                          'UtmSports',
                          style: pw.TextStyle(
                            fontSize: 8,
                            color: PdfColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            pw.Divider(color: PdfColors.white, thickness: 20),

            pw.Paragraph(
                text: "Total Count: ${data.length}",
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),

            //Section Header: Advanced Booking List
            pw.Header(text: '$reportName List'),

            // Stocked Items Table
            pw.Table(children: [
              //header
              pw.TableRow(children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text("Index",
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    pw.Divider(thickness: 1)
                  ],
                ),
                for (var i = 0; i < columnNames.length; i++)
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text(columnNames[i]['label'],
                          style: pw.TextStyle(
                              fontSize: 12, fontWeight: pw.FontWeight.bold)),
                      pw.Divider(thickness: 1)
                    ],
                  ),
              ]),
              //datarow
              for (var i = 0; i < data.length; i++)
                pw.TableRow(
                  children: [
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text((i + 1).toString(),
                              style: pw.TextStyle(fontSize: 12)),
                          pw.Divider(thickness: 1)
                        ]),
                    for (var j = 0; j < columnNames.length; j++)
                      pw.Column(
                        mainAxisSize: pw.MainAxisSize.max,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            convertData(data[i][columnNames[j]['varName']],
                                columnNames[j]['type']),
                            pw.Divider(thickness: 1)
                          ]),
                  ],
                ),
            ])
          ];
        },
      ),
    );
    return pdf;
  }

  convertData(value, type) {
    String convertedValue;
    switch (type) {
      case "Timestamp":
        convertedValue =
            Utils.parseTimestampToFormatDate(value, format: "y-MM-dd HH:mm:ss")
                .toString();
        break;
      case "Bool":
        convertedValue = (value == true ? 1 : 0) as String;
        break;
        //TODO: handle array value in pdf
      // case "Array":
      // case "List<int>":
      // case "List<bool>":
      // case "List<Timestamp>":
      //   List<pw.Container> a = [];
      //   print(value[0][0].runtimeType);
      //   value.forEach((e) => a.add(pw.Container(child: pw.Text(convertData(e, e[0].runtimeType)))));
      //   return pw.Column(children: a);
      default:
        convertedValue = value.toString();
        break;
    }
    return pw.Text(convertedValue, style: pw.TextStyle(fontSize: 12));
  }*/

  saveAndOpenPDF(pdf) async {
    final output = await getTemporaryDirectory();
    String filePath = "${output.path}/example.pdf";
    final file = File(filePath);
    print("${output.path}/example.pdf");
    await file
        .writeAsBytes(await pdf.save())
        .then((_) => OpenFile.open(filePath));
    // document.dispose();
  }
}
