@Timeout(Duration(seconds: 600))
import 'package:dcli/dcli.dart' hide equals;
import 'package:test/test.dart';

import '../util/test_file_system.dart';

String baseURl =
    'https://raw.githubusercontent.com/bsutton/dcli/master/test/src/functions/fetch_downloads';
String testFile;
void main() {
  group('Fetch Single', () {
    // Don't know how to test this as it writes directly to stdout.
    // Need some way to hook Stdout
    test('Fetch One', () {
      TestFileSystem().withinZone((fs) {
        var sampleAac = fs.tempFile();
        fetch(url: '$baseURl/sample.aac', saveToPath: sampleAac);
        expect(FileSync(sampleAac).length, equals(14951));
        delete(sampleAac);

        var sampleWav = fs.tempFile();
        fetch(url: '$baseURl/sample.wav', saveToPath: sampleWav);
        expect(FileSync(sampleWav).length, equals(212948));
        delete(sampleWav);
      });
    });

    test('Fetch One with Progress', () {
      TestFileSystem().withinZone((fs) {
        var sampleAac = fs.tempFile();
        fetch(
            url: '$baseURl/sample.aac',
            saveToPath: sampleAac,
            onProgress: (progress) {
              print(progress);
            });
        expect(FileSync(sampleAac).length, equals(14951));
        delete(sampleAac);

        var sampleWav = fs.tempFile();
        fetch(
            url: '$baseURl/sample.wav',
            saveToPath: sampleWav,
            onProgress: (progress) {
              print(progress);
              return true;
            });
        expect(FileSync(sampleWav).length, equals(212948));
        delete(sampleWav);
      });
    });
  });

  group('Fetch Multi', () {
    test('Fetch  ', () {
      TestFileSystem().withinZone((fs) {
        var sampleAac = fs.tempFile();
        var sampleWav = fs.tempFile();

        fetchMultiple(urls: [
          FetchUrl(
              url: '$baseURl/sample.aac',
              saveToPath: sampleAac,
              onProgress: showProgress),
          FetchUrl(url: '$baseURl/sample.wav', saveToPath: sampleWav)
        ]);
        expect(FileSync(sampleAac).length, equals(14951));
        expect(FileSync(sampleWav).length, equals(212948));

        delete(sampleAac);
        delete(sampleWav);
      });
    });

    test('Fetch With Progress ', () {
      TestFileSystem().withinZone((fs) {
        var sampleAac = fs.tempFile();
        var sampleWav = fs.tempFile();

        fetchMultiple(urls: [
          FetchUrl(
              url: '$baseURl/sample.aac',
              saveToPath: sampleAac,
              onProgress: showProgress),
          FetchUrl(
              url: '$baseURl/sample.wav',
              saveToPath: sampleWav,
              onProgress: showProgress)
        ]);
        expect(FileSync(sampleAac).length, equals(14951));
        expect(FileSync(sampleWav).length, equals(212948));

        delete(sampleAac);
        delete(sampleWav);
      });
    });
  });
}

void showProgress(FetchProgress progress) {
  print(progress);
}
