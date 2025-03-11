import 'package:ai_text_extracter_app/services/store_conversions_firestore.dart';
import 'package:ai_text_extracter_app/widgets/image_preview.dart';
import 'package:ai_text_extracter_app/widgets/recognized_text_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ImagePicker imagePicker;
  late TextRecognizer textRecognizer;
  String? pickedImagePath;
  //bool for change the button state
  bool isImagePicked = false;
  bool isProcessing = false;
  String recognizedText = "";
  Future<String?>? recognizedTextFuture;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    textRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );
  }

  //function to pick a image
  void _pickImage({required ImageSource source}) async {
    final pickedImage = await imagePicker.pickImage(source: source);
    if (pickedImage == null) {
      return;
    } else {
      setState(() {
        pickedImagePath = pickedImage.path;
        isImagePicked = true;
      });
    }
  }

  //show bottom sheet
  void _showBottomSheetWidget() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text("Choose from Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(source: ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text("Take a picture"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(source: ImageSource.camera);
              },
            )
          ],
        );
      },
    );
  }

  //function to process image
  Future<String?> _processImage() async {
    if (pickedImagePath == null) {
      return "";
    }

    setState(() {
      isProcessing = true;
      recognizedText = "";
    });

    try {
      //convert my image in to input image
      final inputImage = InputImage.fromFilePath(pickedImagePath!);
      final RecognizedText textReturnFromModel =
          await textRecognizer.processImage(inputImage);

      //stroe textReturnFromModel.text to firestore

      if (textReturnFromModel.text.isNotEmpty) {
        try {
          await StoreConversionsFirestore().storeConversionData(
            conversionData: textReturnFromModel.text,
            conversionDate: DateTime.now(),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Text Stored successfully"),
            ),
          );
        } catch (e) {
          debugPrint("$e");
        }
      }
      debugPrint(textReturnFromModel.text);
      return textReturnFromModel.text;
    } catch (e) {
      debugPrint(e.toString());
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error occured:${e.toString()}"),
          ),
        );
      }

      return "";
    }
  }

  //function to clipboard
  void _copyToClipboard() async {
    if (recognizedTextFuture != null) {
      String? recognizedText = await recognizedTextFuture; // Await to get text

      if (recognizedText != null && recognizedText.isNotEmpty) {
        await Clipboard.setData(
          ClipboardData(text: recognizedText),
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Copied to clipboard"),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ML Text Recognition",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ImagePreview(
              imagePath: pickedImagePath,
            ),
            SizedBox(
              height: 16,
            ),
            if (!isImagePicked)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _showBottomSheetWidget();
                    },
                    child: Text(
                      "Pick an Image",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            if (isImagePicked)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        recognizedTextFuture =
                            _processImage(); // Update Future so FutureBuilder gets notified
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Process Image",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            SizedBox(
              height: 16,
            ),
            if (isProcessing)
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recognized Text",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              _copyToClipboard();
                            },
                            icon: Icon(Icons.copy_all))
                      ],
                    ),
                    FutureBuilder(
                      future: recognizedTextFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Show a loading indicator
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          return RecognizedTextPreview(
                            recognizedText: snapshot.data ?? "No text found",
                          );
                        }
                      },
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
