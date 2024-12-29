String limitTextTo300Words(String text) {
  // Split the input text into words
  List<String> words = text.split(' ');

  // Limit to 300 words
  if (words.length > 40) {
    words = words.sublist(0, 40);
  }

  // Join the words back into a string
  return words.join(' ') + (words.length == 40 ? '...' : '');
}
