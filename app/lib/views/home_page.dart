import 'package:calprotectin/services/firestore_service.dart';
import 'package:calprotectin/views/appointment_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:calprotectin/app_colors.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'test_detected_modal.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

double calculateLcssScore(List<dynamic> answers) {
  if (answers.isEmpty) return 0;
  final total = answers.fold<int>(0, (sum, e) => sum + (e as int));
  return total / answers.length;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedOption = '10 May';
  final List<String> options = ['10 May', '9 May', '8 May'];
  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);
  bool _isRecommendationVisible = false;
  int index = 0;

  @override
  void initState() {
    super.initState();
    // Initialize the value notifier for the circular progress bar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _valueNotifier.value = 7;
    });
  }

  // Method to show the test detected modal
  void _showTestDetectedModal() {
    context.showTestDetectedModal(
      onButtonPressed: () {
        Navigator.of(context).pop(); // Close the modal
        // Navigate to LCSS questionnaire or take appropriate action
        // For example: Navigator.of(context).push(MaterialPageRoute(builder: (_) => LcssQuestionnairePage()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (idx) {
          setState(() {
            index = idx;
          });

          if (idx == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AppointmentPage()),
            );
          }
        },
        currentIndex: index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital_outlined),
            label: 'Appointment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.textGray,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Morning, Jihan! 🌤️',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        CustomDropdown(
                          options: options,
                          selectedOption: selectedOption,
                          onChanged: (newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedOption = newValue;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: _showTestDetectedModal,
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.black,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage('assets/images/avatar.png'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Calprotectin Test
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirestoreService.getLatestCalprotectin(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.data!.docs.isEmpty) {
                      return const Text("No Calprotectin test yet");
                    }

                    final doc = snapshot.data!.docs.first;
                    final value = double.tryParse(doc['value'].toString()) ?? 0;
                    final date = (doc['createdAt'] as Timestamp).toDate();

                    // Tentukan status
                    String status;
                    if (value >= 1 && value <= 6) {
                      status = "Normal";
                    } else if (value >= 7) {
                      status = "Abnormal";
                    } else {
                      status = "Invalid";
                    }

                    // Update progress bar
                    _valueNotifier.value = value;

                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Column(
                          children: [
                            // Main Card Content
                            Container(
                              decoration: const BoxDecoration(
                                  color: AppColors.primaryBlue),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding: const EdgeInsets.all(24),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Left Column (Text & Details)
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 26,
                                                height: 26,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  color: AppColors.hintBlue,
                                                ),
                                                child: const Icon(
                                                  Icons.description_outlined,
                                                  color: AppColors.primaryBlue,
                                                  size: 16,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                "Calprotectin Test",
                                                style: TextStyle(
                                                    color: AppColors.textGray),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            status,
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Last updated ${DateFormat('d MMM yyyy').format(date)}",
                                            style: TextStyle(
                                                color: AppColors.textGray),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.hintBlue,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 4,
                                              horizontal: 8,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.trending_down_outlined,
                                                  color: AppColors.primaryBlue,
                                                  size: 12,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  "0.8%",
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.primaryBlue,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    DashedCircularProgressBar(
                                      width: 125,
                                      height: 125,
                                      valueNotifier: _valueNotifier,
                                      progress: value,
                                      maxProgress: 7,
                                      corners: StrokeCap.round,
                                      foregroundColor: AppColors.primaryBlue,
                                      backgroundColor: AppColors.background,
                                      foregroundStrokeWidth: 20,
                                      backgroundStrokeWidth: 20,
                                      animation: true,
                                      child: Center(
                                        child: ValueListenableBuilder(
                                          valueListenable: _valueNotifier,
                                          builder: (_, double v, __) => Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(height: 4),
                                              Text(
                                                '${v.toInt()}',
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24,
                                                ),
                                              ),
                                              Transform.translate(
                                                offset: const Offset(0, -6),
                                                child: const Text(
                                                  'mg/L',
                                                  style: TextStyle(
                                                    color: AppColors.textGray,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // --- Recommendation Section (ambil dari surveys) ---
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isRecommendationVisible =
                                      !_isRecommendationVisible;
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                height: 48,
                                color: AppColors.primaryBlue,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "See recommendation",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      _isRecommendationVisible
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (_isRecommendationVisible)
                              StreamBuilder<
                                  QuerySnapshot<Map<String, dynamic>>>(
                                stream:
                                    FirestoreService.getLatestLcss(), // surveys
                                builder: (context, surveySnapshot) {
                                  if (!surveySnapshot.hasData)
                                    return Container();
                                  if (surveySnapshot.data!.docs.isEmpty) {
                                    return Container(
                                      padding: const EdgeInsets.all(24),
                                      color: AppColors.primaryBlue,
                                      child: const Text(
                                        "No recommendation yet",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    );
                                  }

                                  final doc = snapshot.data!.docs.first;
                                  final value = double.tryParse(
                                          doc['value'].toString()) ??
                                      0;

// 🔥 Hitung hospital langsung dari CLP
                                  final hospital = value > 6 ? 1 : 0;

                                  final recommendation = hospital == 1
                                      ? "We recommend you to visit a hospital for further check."
                                      : "No hospital visit required for now. Keep monitoring your condition.";

                                  return Container(
                                    width: double.infinity,
                                    color: AppColors.primaryBlue,
                                    padding: const EdgeInsets.only(
                                      top: 0,
                                      left: 24,
                                      right: 24,
                                      bottom: 24,
                                    ),
                                    child: Text(
                                      recommendation,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // LCSS Score Section
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirestoreService.getLatestLcss(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Text("No LCSS test yet");
                    }

                    final doc = snapshot.data!.docs.first;
                    final lcssScore = (doc['score'] ?? 0).toDouble();
                    final surveyDate = (doc['createdAt'] as Timestamp).toDate();

                    // ✅ Fix untuk hospital (handle boolean & int)
                    dynamic rawHospital = doc['hospital'];
                    int hospital;
                    if (rawHospital is bool) {
                      hospital = rawHospital ? 1 : 0;
                    } else if (rawHospital is int) {
                      hospital = rawHospital;
                    } else {
                      hospital = 0;
                    }

                    return Row(
                      children: [
                        // === Card LCSS ===
                        Container(
                          height: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 24,
                                          height: 26,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: AppColors.hintBlue,
                                          ),
                                          child: const Icon(
                                            Icons.leaderboard_outlined,
                                            color: AppColors.primaryBlue,
                                            size: 16,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "LCSS Score",
                                          style: TextStyle(
                                              color: AppColors.textGray),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Text(
                                      lcssScore.toStringAsFixed(1),
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Filled on ${DateFormat('d MMM yy').format(surveyDate)}",
                                      style: const TextStyle(
                                          color: AppColors.textGray),
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.hintBlue,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                        horizontal: 8,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.trending_up_outlined,
                                            color: AppColors.primaryBlue,
                                            size: 12,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            lcssScore >= 3 ? "Severe" : "Mild",
                                            style: TextStyle(
                                              color: AppColors.primaryBlue,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        const Spacer(),

                        // === Card Device === (unchanged)
                        Container(
                          height: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 24,
                                          height: 26,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: AppColors.hintRed,
                                          ),
                                          child: const Icon(
                                            Icons.memory_outlined,
                                            color: AppColors.alertRed,
                                            size: 16,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "Device",
                                          style: TextStyle(
                                              color: AppColors.textGray),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    const Text(
                                      "A01",
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      "Last seen at 10:00",
                                      style:
                                          TextStyle(color: AppColors.textGray),
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.hintRed,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                        horizontal: 8,
                                      ),
                                      child: const Text(
                                        "Offline",
                                        style: TextStyle(
                                          color: AppColors.alertRed,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                // Latest activity list
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Latest Activity",
                          style: TextStyle(
                              color: AppColors.textGray, fontSize: 16),
                        ),
                        Spacer(),
                        Text(
                          "See all",
                          style: TextStyle(
                              color: AppColors.primaryBlue, fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.cardWhite,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.notes_outlined,
                            color: AppColors.primaryBlue,
                            size: 24,
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "LCSS Questionnaire Filled",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "10 May 2025 10:00",
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.textGray),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.cardWhite,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.science_outlined,
                            color: AppColors.primaryBlue,
                            size: 24,
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "New Test Detected",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "10 May 2025 09:00",
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.textGray),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.cardWhite,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.notes_outlined,
                            color: AppColors.primaryBlue,
                            size: 24,
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "LCSS Questionnaire Filled",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "03 May 2025 10:00",
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.textGray),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.cardWhite,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.science_outlined,
                            color: AppColors.primaryBlue,
                            size: 24,
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "New Test Detected",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "03 May 2025 08:00",
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.textGray),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom dropdown widget
class CustomDropdown extends StatefulWidget {
  final List<String> options;
  final String selectedOption;
  final Function(String?) onChanged;

  const CustomDropdown({
    Key? key,
    required this.options,
    required this.selectedOption,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  final MenuController _menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      controller: _menuController,
      menuChildren: widget.options.map((String value) {
        return MenuItemButton(
          onPressed: () {
            widget.onChanged(value);
            _menuController.close();
          },
          child: SizedBox(
            width: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                value,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        );
      }).toList(),
      alignmentOffset: const Offset(0, 4),
      style: MenuStyle(
        backgroundColor: MaterialStateProperty.all(AppColors.primaryBlue),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      builder: (context, controller, child) {
        return Container(
          width: 124,
          height: 30,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.date_range_outlined,
                      color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    widget.selectedOption,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
