import 'package:calprotectin/views/questionnaire_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calprotectin/app_colors.dart';

class TestDetectedModal extends StatelessWidget {
  final VoidCallback onButtonPressed;
  final VoidCallback? onClose;

  const TestDetectedModal({
    Key? key,
    required this.onButtonPressed,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Image.asset(
                  'assets/images/test.png',
                  height: 170,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 8),
              // Title
              const Text(
                'New Test Detected',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              // Description
              const Text(
                'Fill the LCSS questionnaire to get advice on your diagnosis',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),
              // btn go
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // tutup modal dulu
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const QuestionnairePage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Let\'s Go',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Close btn
        Positioned(
          right: 16,
          top: 16,
          child: InkWell(
            onTap: () =>
                onClose != null ? onClose!() : Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(4),
              child: const Icon(
                Icons.close,
                size: 22,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Extension to show the modal
extension TestDetectedModalExtension on BuildContext {
  Future<void> showTestDetectedModal({
    required VoidCallback onButtonPressed,
    VoidCallback? onClose,
  }) {
    return showGeneralDialog(
      context: this,
      barrierDismissible: true,
      barrierLabel: "Test Detected Modal",
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => Container(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutQuint,
        );

        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(curvedAnimation),
          child: FadeTransition(
            opacity:
                Tween<double>(begin: 0.5, end: 1.0).animate(curvedAnimation),
            child: TestDetectedModal(
              onButtonPressed: onButtonPressed,
              onClose: onClose,
            ),
          ),
        );
      },
    );
  }
}
