class Question {
  final String question;
  final List<String> options;
  final bool reverse;

  Question({
    required this.question,
    required this.options,
    this.reverse = false,
  });

  int mapToScore(int selectedIndex) {
    final n = options.length;
    return reverse ? (selectedIndex + 1) : (n - selectedIndex);
  }
}

final questions = [
  Question(
    question: "How is your appetite?",
    options: [
      "As good as it could be",
      "Quite good",
      "Neither good nor bad",
      "Quite bad",
      "As bad as it could be",
    ],
    reverse: true,
  ),
  Question(
    question: "How much fatigue do you have?",
    options: [
      "None",
      "A little",
      "Moderate",
      "Quite a lot",
      "As much as it could be",
    ],
    reverse: true,
  ),
  Question(
    question: "How much coughing do you have?",
    options: [
      "None",
      "A little",
      "Moderate",
      "Quite a lot",
      "As much as it could be",
    ],
    reverse: true,
  ),
  Question(
    question: "How much shortness of breath do you have?",
    options: [
      "None",
      "A little",
      "Moderate",
      "Quite a lot",
      "As much as it could be",
    ],
    reverse: true,
  ),
  Question(
    question: "How much blood do you see in your sputum?",
    options: [
      "None",
      "A little",
      "Moderate",
      "Quite a lot",
      "As much as it could be",
    ],
    reverse: true,
  ),
  Question(
    question: "How much pain do you have?",
    options: [
      "None",
      "A little",
      "Moderate",
      "Quite a lot",
      "As much as it could be",
    ],
    reverse: true,
  ),
  Question(
    question: "How bad are your symptoms from lung cancer?",
    options: [
      "I have none",
      "Mild",
      "Moderate",
      "Quite severe",
      "As bad as they could be",
    ],
    reverse: true,
  ),
  Question(
    question:
        "How much has your illness affected your ability to carry out normal activities?",
    options: [
      "Not at all",
      "A little",
      "Moderately",
      "Quite a lot",
      "So much that I can do nothing for myself",
    ],
    reverse: true,
  ),
  Question(
    question: "How would you rate the quality of your life today?",
    options: [
      "Very high",
      "High",
      "Moderate",
      "Low",
      "Very low",
    ],
    reverse: true,
  ),
];
