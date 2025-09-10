import 'package:calprotectin/app_colors.dart';
import 'package:calprotectin/views/home_page.dart';
import 'package:calprotectin/views/stats_page.dart';
import 'package:flutter/material.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  int index = 1;

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

          if (idx == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (idx == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StatsPage()),
            );
          }
        },
        currentIndex: index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 8, right: 24),
          child: Text(
            "Make Appointment",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Handle action
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Container(
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: AppColors.primaryBlue,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 24, top: 24),
                                child: Row(
                                  children: [
                                    Text(
                                      "Online",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_right,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                              Spacer(),
                              Image.asset(
                                'assets/images/online.png',
                                fit: BoxFit.contain,
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: AppColors.primaryBlue,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 24, top: 24),
                                child: Row(
                                  children: [
                                    Text(
                                      "Offline",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_right,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                              Spacer(),
                              Image.asset(
                                'assets/images/offline.png',
                                fit: BoxFit.contain,
                              ),
                            ],
                          )),
                    ],
                  )),
              Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 24, right: 24, top: 18, bottom: 4),
                        child: Text(
                          "Popular Hospital",
                          style: TextStyle(
                            color: AppColors.textGray,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        child: Row(
                          children: [
                            // first
                            Container(
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.all(16),
                              width: 220,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      'https://media.rs-jih.co.id/media-rsjih/bridge/background/backgroundjih.jpg',
                                      height: 100,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "RS JIH",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "Jl. Ring Road Utara No.160, Perumnas Condong Catur, Condongcatur, Kec. Depok, Kabupaten Sleman, Daerah Istimewa Yogyakarta 55283",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textGray,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.hintBlue,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 8),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.star_border_outlined,
                                              color: AppColors.primaryBlue,
                                              size: 12,
                                            ),
                                            const SizedBox(width: 4),
                                            Text("5.0",
                                                style: TextStyle(
                                                    color:
                                                        AppColors.primaryBlue,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600))
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.hintBlue,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 8),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.pin_drop_outlined,
                                              color: AppColors.primaryBlue,
                                              size: 12,
                                            ),
                                            const SizedBox(width: 4),
                                            Text("1 Km",
                                                style: TextStyle(
                                                    color:
                                                        AppColors.primaryBlue,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryBlue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                      ),
                                      child: Text(
                                        "Contact",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            // 2ND
                            Container(
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.all(16),
                              width: 220,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      'https://lh5.googleusercontent.com/p/AF1QipOevOwNTzumB6VXOEfsdHfjy3pYM_LHVltgTcbG=w408-h544-k-no',
                                      height: 100,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "RS Siloam",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "Jl. Laksda Adisucipto No.32-34, Demangan, Kec. Gondokusuman, Kota Yogyakarta, Daerah Istimewa Yogyakarta 55221",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textGray,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.hintBlue,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 8),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.star_border_outlined,
                                              color: AppColors.primaryBlue,
                                              size: 12,
                                            ),
                                            const SizedBox(width: 4),
                                            Text("5.0",
                                                style: TextStyle(
                                                    color:
                                                        AppColors.primaryBlue,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600))
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.hintBlue,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 8),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.pin_drop_outlined,
                                              color: AppColors.primaryBlue,
                                              size: 12,
                                            ),
                                            const SizedBox(width: 4),
                                            Text("1.2 Km",
                                                style: TextStyle(
                                                    color:
                                                        AppColors.primaryBlue,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryBlue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                      ),
                                      child: Text(
                                        "Contact",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),

                  // appointment history
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 24, left: 24, bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Appointment History",
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
                          height: 12,
                        ),
                        // cards
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          height: 78,
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
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  'https://d1ojs48v3n42tp.cloudfront.net/provider_location_banner/551583_8-11-2023_15-18-54.jpeg',
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "RS JIH",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "10 May 2025 10:00",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textGray),
                                  )
                                ],
                              ),
                              Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.hintRed,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                child: Text("Offline",
                                    style: TextStyle(
                                        color: AppColors.alertRed,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          height: 78,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: AppColors.cardWhite,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  'https://d1ojs48v3n42tp.cloudfront.net/provider_location_banner/551583_8-11-2023_15-18-54.jpeg',
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "RS JIH",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "10 May 2025 10:00",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textGray),
                                  )
                                ],
                              ),
                              Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.hintRed,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                child: Text("Offline",
                                    style: TextStyle(
                                        color: AppColors.alertRed,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                              )
                            ],
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
    );
  }
}
