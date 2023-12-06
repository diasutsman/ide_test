import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ide_test/pages/dashboard_page.dart';
import 'package:ide_test/services/ide_service.dart';
import 'package:image_picker/image_picker.dart';

class AddBannerPage extends StatefulWidget {
  @override
  _AddBannerPageState createState() => _AddBannerPageState();
}

class _AddBannerPageState extends State<AddBannerPage> {
  TextEditingController _bannerNameController = TextEditingController();
  String _bannerImagePath = '';
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _bannerImagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        title: Text('Add Banner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _bannerNameController,
              decoration: InputDecoration(
                labelText: 'Banner Name',
              ),
            ),
            SizedBox(height: 16.0),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Banner Image:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Pick Image'),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Expanded(
              flex: 1,
              child: _bannerImagePath == ''
                  ? const Center(
                      child:
                          Text('Please pick image for the banner.'),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Image.file(
                            File(_bannerImagePath),
                          ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              height: 55,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        setState(() {
                          _isLoading = true;
                        });

                        final bannerName = _bannerNameController.text;
                        final bannerPath = _bannerImagePath;

                        try {
                          await IdeService.addBanner(
                            bannerName: bannerName,
                            bannerPath: bannerPath,
                          );

                          Fluttertoast.showToast(
                              msg: "Berhasil menambahkan banner");

                          Navigator.pop(context);
                        } catch (e, stacktrace) {
                          print(e.toString());
                          print(stacktrace.toString());
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Gagal menambahkan banner!"),
                                content: Text(e.toString()),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Ok'),
                                  )
                                ],
                              );
                            },
                          );
                        } finally {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Tambah'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
