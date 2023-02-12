import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:vid2mp3/convert_to_mp3.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with ConvertToMp3 {
  final TextEditingController _inputFieldController = TextEditingController();
  final TextEditingController _outputFieldController = TextEditingController();

  String inputPath = '';
  String inputFileName = '';

  String outputPath = '';

  bool _isConverting = false;

  String outputFieldLabelText = 'Output path';

  void setOutputFieldLabelText() {
    // int i = inputFile.lastIndexOf('.');
    // var newInputPath =  {inputFile.substring(0, i), inputFile.substring(i)};

    outputFieldLabelText = inputPath.isNotEmpty && outputPath.isEmpty
        ? '${inputPath.split('.')[0]}.mp3'
        : 'Output path';
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.video, lockParentWindow: true);

    if (result != null) {
      File file = File(result.files.single.path!);

      // print(file.parent); // file directory
      // print(file.uri.pathSegments.last); // file name

      setState(() {
        inputPath = file.path;
        inputFileName = file.uri.pathSegments.last;
        _inputFieldController.text = inputPath;
        setOutputFieldLabelText();
      });
    } else {
      // User canceled the picker
    }
  }

  void selectOutputPath() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory == null) {
      // User canceled the picker
      return;
    }

    setState(() {
      outputPath =
          '$selectedDirectory${Platform.pathSeparator}${inputFileName.split('.')[0]}';
      _outputFieldController.text = outputPath;
    });
  }

  void startConvertion() async {
    setState(() => _isConverting = true);

    await convertToMp3(
      inputFilePath: inputPath,
      outputFilePath: outputPath,
    ).then((message) {
      SnackBar snackBar = SnackBar(
        content: Text(message),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });

    setState(() => _isConverting = false);
  }

  MaterialColor getMaterialColor(Color color) =>
      Colors.primaries.firstWhere((element) => element.value == color.value);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vid2Mp3'),
      ),
      backgroundColor: getMaterialColor(Theme.of(context).primaryColor)[50],
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 760),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Input path',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    enabled: !_isConverting,
                    controller: _inputFieldController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      // labelText: 'Input path',
                      hintText: 'Input path',
                      suffixIconColor: _isConverting
                          ? Colors.black38
                          : Theme.of(context).primaryColor,
                      suffixIcon: Container(
                        margin: const EdgeInsets.only(right: 6),
                        child: ClipOval(
                          child: Material(
                            color: Colors.transparent,
                            child: IconButton(
                              icon: const Icon(Icons.folder_open),
                              onPressed: () {
                                pickFile();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    onChanged: (value) => setState(() {
                      inputPath = value;
                      setOutputFieldLabelText();
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Focus(
                onFocusChange: (isFocused) {
                  if (_inputFieldController.text.isNotEmpty) {
                    setState(() {
                      outputFieldLabelText = 'Output path';

                      if (!isFocused) {
                        setOutputFieldLabelText();
                      }
                    });
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Output path',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      enabled: !_isConverting,
                      controller: _outputFieldController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: outputFieldLabelText,
                        suffixText: '.mp3',
                        suffixIconColor: _isConverting
                            ? Colors.black38
                            : Theme.of(context).primaryColor,
                        suffixIcon: Container(
                          margin: const EdgeInsets.only(right: 6),
                          child: ClipOval(
                            child: Material(
                              color: Colors.transparent,
                              child: IconButton(
                                icon: const Icon(Icons.folder_open),
                                onPressed: () {
                                  selectOutputPath();
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      onChanged: (value) => setState(() => outputPath = value),
                    ),
                    const SizedBox(height: 48),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                      ),
                      onPressed:
                          _isConverting || _inputFieldController.text.isEmpty
                              ? null
                              : () => startConvertion(),
                      child: _isConverting
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Convert'),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
