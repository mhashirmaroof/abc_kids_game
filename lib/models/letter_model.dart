class LetterModel {
  final String letter;
  final String word;
  final String image;
  final String soundLetter;
  final String soundWord;

  const LetterModel({
    required this.letter,
    required this.word,
    required this.image,
    required this.soundLetter,
    required this.soundWord,
  });

  factory LetterModel.fromJson(Map<String, dynamic> json) {
    return LetterModel(
      letter:      json['letter']       as String,
      word:        json['word']         as String,
      image:       json['image']        as String,
      soundLetter: json['sound_letter'] as String,
      soundWord:   json['sound_word']   as String,
    );
  }
}
