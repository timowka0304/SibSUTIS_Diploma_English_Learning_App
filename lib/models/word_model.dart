class Word {
  final String wordEn;
  final String wordRu;
  final String transcription;
  final String audioFile;
  final String example;

  Word({
    required this.wordEn,
    required this.wordRu,
    required this.transcription,
    required this.audioFile,
    required this.example,
  });

  factory Word.fromJson(List<dynamic> json) {
    return Word(
        wordEn: json[0]['heading'] ?? '',
        wordRu: json[0]['translations'] ?? '',
        transcription: json[0]['transcription'] ?? '',
        example: json[0]['examples'].split('\r').first ?? '',
        audioFile: json[0]['soundFileName'] ?? '');
  }

  Future<Word> fetch() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return this;
  }
}
