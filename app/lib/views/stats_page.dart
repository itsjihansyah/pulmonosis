import 'package:calprotectin/app_colors.dart';
import 'package:calprotectin/views/appointment_page.dart';
import 'package:calprotectin/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CalprotectinData {
  final String month;
  final double value;

  CalprotectinData(this.month, this.value);
}

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage>
    with SingleTickerProviderStateMixin {
  int index = 2;
  String selectedPeriod = 'Monthly';
  late AnimationController _animationController;
  late Animation<double> _animation;
  DraggableScrollableController _scrollController =
      DraggableScrollableController();

  final List<CalprotectinData> monthlyData = [
    CalprotectinData('Sep', 20.0),
    CalprotectinData('Oct', 28.0),
    CalprotectinData('Nov', 30.0),
    CalprotectinData('Dec', 32.0),
    CalprotectinData('Jan', 35.0),
    CalprotectinData('Feb', 28.0),
    CalprotectinData('Mar', 39.0),
    CalprotectinData('Apr', 30.0),
    CalprotectinData('May', 40.0),
  ];

  final List<Map<String, String>> latestActivities = [
    {
      "title": "Calprotectin Test",
      "date": "11 May 2025 08:00 AM",
      "value": "50.00 mg/l"
    },
    {
      "title": "Calprotectin Test",
      "date": "03 May 2025 08:00 AM",
      "value": "47.00 mg/l"
    },
    {
      "title": "Calprotectin Test",
      "date": "28 April 2025 09:00 AM",
      "value": "40.00 mg/l"
    },
    {
      "title": "Calprotectin Test",
      "date": "21 April 2025 09:00 AM",
      "value": "34.00 mg/l"
    },
    {
      "title": "Calprotectin Test",
      "date": "16 April 2025 08:00 AM",
      "value": "30.00 mg/l"
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
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
          } else if (idx == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
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
            icon: Icon(Icons.analytics),
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
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 40, left: 24, right: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Calprotectin Level Average",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.hintBlue.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.trending_up_outlined,
                                    color: AppColors.cardWhite,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 4),
                                  Text("0.4%",
                                      style: TextStyle(
                                          color: AppColors.cardWhite,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600))
                                ],
                              ),
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("40.0",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 68,
                                    fontWeight: FontWeight.bold)),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Text(" mg/L",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal)),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            _periodButton('Daily', selectedPeriod == 'Daily'),
                            SizedBox(width: 8),
                            _periodButton(
                                'Monthly', selectedPeriod == 'Monthly'),
                            SizedBox(width: 8),
                            _periodButton('Yearly', selectedPeriod == 'Yearly'),
                          ],
                        ),
                        _buildCalprotectinChart(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          DraggableScrollableSheet(
            controller: _scrollController,
            initialChildSize: 0.4,
            minChildSize: 0.4,
            maxChildSize: 1.0,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        height: 40,
                        alignment: Alignment.center,
                        child: Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2.5),
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(24),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Latest Activity",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 16),
                            ...latestActivities
                                .map((activity) => _buildActivityItem(
                                    activity['title']!,
                                    activity['date']!,
                                    activity['value']!))
                                .toList(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _periodButton(String period, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPeriod = period;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.hintBlue : Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Text(
          period,
          style: TextStyle(
            color: isSelected ? AppColors.primaryBlue : AppColors.cardWhite,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCalprotectinChart() {
    return SizedBox(
      height: 230,
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: CategoryAxis(
          majorGridLines: MajorGridLines(width: 0),
          axisLine: AxisLine(width: 0),
          labelStyle: TextStyle(color: Colors.white),
        ),
        primaryYAxis: NumericAxis(
          isVisible: false,
        ),
        series: <ColumnSeries<CalprotectinData, String>>[
          ColumnSeries<CalprotectinData, String>(
            dataSource: monthlyData,
            xValueMapper: (CalprotectinData data, _) => data.month,
            yValueMapper: (CalprotectinData data, _) => data.value,
            color: Color(0xffE6EEF5),
            width: 0.7,
            borderRadius: BorderRadius.circular(8),
            selectionBehavior: SelectionBehavior(
              enable: true,
              selectedColor: Colors.white,
              unselectedColor: Color(0xffE6EEF5),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String date, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.description_outlined, color: Colors.black54, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
