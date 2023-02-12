import 'dart:io';

mixin ConvertToMp3 {
  Future<String> convertToMp3(
      {required String inputFilePath, required String outputFilePath}) async {
    var result = await Process.run('ffmpeg', [
      '-hide_banner',
      '-loglevel',
      'error',
      '-n',
      '-i',
      inputFilePath,
      '-map',
      '0:a:m:language:jpn?',
      '${outputFilePath.isEmpty ? inputFilePath.split('.')[0] : outputFilePath}.mp3'
    ]);

    if (result.exitCode != 0) {
      return result.stderr.trim();
    } else {
      return 'Video converted to mp3.';
    }
  }
}
