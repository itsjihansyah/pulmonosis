import 'package:flutter/material.dart';
import 'package:calprotectin/models/questions.dart';
import 'package:calprotectin/services/firestore_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuestionnairePage extends StatefulWidget {
  const QuestionnairePage({super.key});

  @override
  State<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  int currentIndex = 0;
  String? selectedAnswer;
  final List<int> answers = [];
  bool isLoading = false; // Add loading state

  /// Hitung score rata-rata dari semua jawaban
  double calculateScore(List<int> answers) {
    if (answers.isEmpty) return 0;
    final sum = answers.reduce((a, b) => a + b);
    return sum / answers.length;
  }

  /// Call FastAPI → prediksi hospital (0 = tidak perlu, 1 = perlu)
  Future<int> _predictHospital(List<int> answers) async {
    try {
      final url = Uri.parse(
          "http://192.168.0.113:8000/predict"); // emulator Android pakai 10.0.2.2
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"answers": answers}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result["prediction"] ?? 0; // default 0
      } else {
        return 0;
      }
    } catch (e) {
      debugPrint("Error calling API: $e");
      return 0;
    }
  }

  /// Show loading modal
  void _showLoadingModal() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // Prevent back button dismiss
          child: Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Processing your answers...",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Please wait while we analyze your responses",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Hide loading modal
  void _hideLoadingModal() {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _saveAnswer() async {
    if (selectedAnswer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an answer.")),
      );
      return;
    }

    final question = questions[currentIndex];
    final selectedIndex = question.options.indexOf(selectedAnswer!);
    final score = question.mapToScore(selectedIndex);

    // simpan jawaban sementara
    if (answers.length > currentIndex) {
      answers[currentIndex] = score;
    } else {
      answers.add(score);
    }

    // kalau masih ada pertanyaan berikutnya
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        selectedAnswer = null;
      });
    } else {
      // kalau sudah selesai semua pertanyaan
      setState(() {
        isLoading = true;
      });

      // Show loading modal
      _showLoadingModal();

      try {
        final avgScore = calculateScore(answers);
        final hospital = await _predictHospital(answers); // 🔥 int (0/1)

        // simpan via FirestoreService
        await FirestoreService.saveLcssResult(
          answers: answers,
          score: avgScore,
          hospital: hospital,
        );

        // Hide loading modal
        _hideLoadingModal();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Survey completed & saved!")),
        );
        Navigator.pop(context);
      } catch (e) {
        // Hide loading modal
        _hideLoadingModal();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving survey: $e")),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _goBack() {
    if (currentIndex == 0) return;
    setState(() {
      currentIndex--;
      if (answers.length > currentIndex) {
        final prevScore = answers[currentIndex];
        final q = questions[currentIndex];
        final idx = q.reverse ? (5 - prevScore) : (prevScore - 1);
        selectedAnswer = q.options[idx];
      } else {
        selectedAnswer = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Progress bar
              Column(
                children: [
                  const SizedBox(height: 24),
                  Text(
                    "QUESTION ${currentIndex + 1}/${questions.length}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: (currentIndex + 1) / questions.length,
                        backgroundColor: Colors.grey[200],
                        color: Colors.blue,
                        minHeight: 8,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 40),

              // Question text
              Text(
                question.question,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Options
              Expanded(
                child: ListView.separated(
                  itemCount: question.options.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final opt = question.options[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedAnswer == opt
                              ? Colors.blue
                              : Colors.grey.shade300,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: RadioListTile<String>(
                        title: Text(opt),
                        value: opt,
                        groupValue: selectedAnswer,
                        activeColor: Colors.blue,
                        onChanged: (val) {
                          setState(() => selectedAnswer = val);
                        },
                      ),
                    );
                  },
                ),
              ),

              // Buttons
              Row(
                children: [
                  if (currentIndex > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed:
                            isLoading ? null : _goBack, // Disable when loading
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text("Back"),
                      ),
                    ),
                  if (currentIndex > 0) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : _saveAnswer, // Disable when loading
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        foregroundColor: Colors.white,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              currentIndex == questions.length - 1
                                  ? "Finish"
                                  : "Next",
                            ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
