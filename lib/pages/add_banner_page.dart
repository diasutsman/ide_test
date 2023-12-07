import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ide_test/services/ide_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';

class AddBannerPage extends StatefulWidget {
  const AddBannerPage({super.key});

  @override
  _AddBannerPageState createState() => _AddBannerPageState();
}

class _AddBannerPageState extends State<AddBannerPage> {
  final TextEditingController _bannerNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
        title: const Text('Add Banner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _bannerNameController,
                decoration: const InputDecoration(
                  labelText: 'Banner Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Banner name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  const Expanded(
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
                    child: const Text('Pick Image'),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Expanded(
                flex: 1,
                child: _bannerImagePath == ''
                    ? const Center(
                        child: Text('Please pick image for the banner.'),
                      )
                    : PhotoView(
                      imageProvider: FileImage(
                        File(_bannerImagePath),
                      ),
                      backgroundDecoration: const BoxDecoration(
                        color: Colors.transparent,
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
                          final bannerName = _bannerNameController.text;
                          final bannerPath = _bannerImagePath;

                          if (_formKey.currentState?.validate() == false) {
                            return;
                          }

                          setState(() {
                            _isLoading = true;
                          });

                          try {
                            if (bannerPath.isEmpty) {
                              throw "Banner image is required.";
                            }

                            await IdeService.addBanner(
                              bannerName: bannerName,
                              bannerPath: bannerPath,
                            );

                            Fluttertoast.showToast(
                              msg: "Banner added.",
                            );

                            Navigator.pop(context);
                          } catch (e, stacktrace) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Failed to add banner!"),
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
      ),
    );
  }
}
