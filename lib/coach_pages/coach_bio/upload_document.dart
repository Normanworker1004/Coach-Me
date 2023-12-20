// import 'package:file_picker/file_picker.dart';
// import 'dart:io';

import 'package:cme/app.dart';
import 'package:cme/auth_scope_model/user_model.dart';
import 'package:cme/model/fetch_certificate_response.dart';
import 'package:cme/network/coach/bio.dart';
import 'package:cme/ui_widgets/button.dart';
import 'package:cme/ui_widgets/texts.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// import 'package:gx_file_picker/gx_file_picker.dart';

class UploadCertificate extends StatefulWidget {
  final UserModel? userModel;

  const UploadCertificate({Key? key, required this.userModel})
      : super(key: key);

  @override
  _UploadCertificateState createState() => _UploadCertificateState();
}

class _UploadCertificateState extends State<UploadCertificate> {
  UserModel? userModel;
  bool isUploading = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    userModel = widget.userModel;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            // verticalSpace(height: 16),
            Center(
              child: Container(
                width: 72,
                height: 4,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Color.fromRGBO(
                        238, 238, 238, 1) //rgba(238, 238, 238, 1)
                    ),
              ),
            ),
            verticalSpace(height: 23),
            boldText(
              "Upload Certificate",
              size: 28,
            ),
            verticalSpace(height: 18),
            InkWell(
              onTap: () async {
                try {
                  var isGranted = await Permission.storage.isGranted;

                  if (!isGranted) {
                    var status = await Permission.storage.request();
                    if (status == PermissionStatus.granted) {
                      isGranted = true;
                    }
                  }

                  if (!isGranted) {
                    return;
                  }

                  FilePickerResult? files =
                      await FilePicker.platform.pickFiles();

                  // getFiles(
                  //   type: FileType.custom,
                  //   allowedExtensions: ['pdf'],
                  // );

                  if (files != null) {
                    setState(() {
                      isUploading = true;
                    });
                     dynamic test = await uploadCoachCertificates(userModel!.getAuthToken(),
                            filePath: files.files.first.path! //.path + ".pdf",
                            )
                        .whenComplete(() {
                      print("upload completed.......˝");
                      setState(() {
                        isUploading = false;
                      });
                    }).then((value) async {
                       //print("upload then.......${value.stream.bytesToString()}");
                      var responseString = await value!.stream.bytesToString();
                   print("${value.statusCode} $responseString");
                      setState(() {
                        isUploading = false;
                      });
                    }).catchError((e) {
                      print("errorr.......$e");
                    });

                    print("JEREMYYYY::$test");

                  } else {
                    // User canceled the picker
                  }

                } catch (e) {
                  print("error....$e");
                }
              },
              child: DottedBorder(
                color: Colors.grey,
                strokeWidth: 1,
                dashPattern: [16, 4],
                borderType: BorderType.RRect,
                radius: Radius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 24, 16, 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/stats_share.png",
                        color: normalBlue,
                        width: 16,
                      ),
                      horizontalSpace(),
                      RichText(
                        text: TextSpan(
                            style: TextStyle(
                              fontFamily: App.font_name,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: "Attach ",
                                style: TextStyle(
                                  color: normalBlue,
                                ),
                              ),
                              TextSpan(text: "your relevant document"),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            verticalSpace(height: 16),
            FutureBuilder<FetchCertificateResponse>(
                future: fetchCoachCertificates(widget.userModel!.getAuthToken()),
                builder: (context, snapshot) {
                  if (snapshot == null) {
                    return Center(
                      child: Row(
                        children: [
                          mediumText("Unable to fetch certificates"),
                        ],
                      ),
                    );
                  }
                  if (snapshot.data == null) {
                    return Center(
                      child: Row(
                        children: [
                          CircularProgressIndicator(),
                          horizontalSpace(),
                          mediumText("Unable to fetch certificates")
                        ],
                      ),
                    );
                  }
                  var r = snapshot.data!;

                  List<CertificateDetails>? certs = [];
                  if (r.status!) {
                    certs = r.details;
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      certs!.length,
                      (index) {
                        CertificateDetails c = certs![index];
                        return Column(
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  "assets/file-text.png",
                                  // color: deepRed,
                                  height: 15,
                                ),
                                horizontalSpace(),
                                Expanded(
                                  child: Text(
                                    "${c.name}",
                                    textAlign: TextAlign.left,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: App.font_name,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    await deleteCoachCertificate(
                                        widget.userModel!.getAuthToken(),
                                        certificateid: c.id);
                                    setState(() {isLoading = false;});
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      "assets/trash.png",
                                      color: deepRed,
                                      height: 15,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            verticalSpace(),
                          ],
                        );
                      },
                    ),
                  );
                }),
            Spacer(),
            proceedButton(
              text: "Done",
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: Visibility(
            visible: isLoading || isUploading,
            child: Container(
              color: white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  mediumText(isLoading
                      ? "    Deleting certificate..."
                      : "    Uploading certificate...")
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
