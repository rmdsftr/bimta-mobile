import 'package:bimta/layouts/custom_topbar.dart';
import 'package:bimta/models/lihat_jadwal_dosen.dart';
import 'package:bimta/services/jadwal/lihat_jadwal_dosen.dart';
import 'package:bimta/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LihatJadwalDosenScreen extends StatefulWidget {
  const LihatJadwalDosenScreen({Key? key}) : super(key: key);

  @override
  State<LihatJadwalDosenScreen> createState() => _LihatJadwalDosenScreenState();
}

class _LihatJadwalDosenScreenState extends State<LihatJadwalDosenScreen> {
  DateTime selectedDate = DateTime.now();
  Map<DateTime, List<KegiatanModel>> events = {};
  bool isLoading = false;
  String? errorMessage;

  final KegiatanService _kegiatanService = KegiatanService();

  List<String> dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    _loadKegiatanForMonth();
  }

  Future<void> _loadKegiatanForMonth() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final kegiatanList = await _kegiatanService.getKegiatanByBulan(
        year: selectedDate.year,
        month: selectedDate.month,
      );

      setState(() {
        events = _kegiatanService.convertToCalendarMap(kegiatanList);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceAll('Exception: ', '');
        isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage ?? 'Terjadi kesalahan'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _selectDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  void _changeMonth(int monthDelta) {
    setState(() {
      selectedDate = DateTime(
        selectedDate.year,
        selectedDate.month + monthDelta,
        1,
      );
    });
    _loadKegiatanForMonth();
  }

  List<DateTime> _getDaysInMonth(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    final lastDay = DateTime(date.year, date.month + 1, 0);
    final days = <DateTime>[];

    for (int i = 1; i <= lastDay.day; i++) {
      days.add(DateTime(date.year, date.month, i));
    }

    return days;
  }

  int _getStartingWeekday(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    return firstDay.weekday % 7;
  }

  bool _hasEvents(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return events.containsKey(normalizedDate) && events[normalizedDate]!.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = _getDaysInMonth(selectedDate);
    final startingWeekday = _getStartingWeekday(selectedDate);

    final normalizedSelectedDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    final selectedEvents = events[normalizedSelectedDate] ?? [];

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          BackgroundWidget(),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomTopbar(
              leading: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Jadwal Dosen",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 75, right: 16, left: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(15),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat('MMMM yyyy').format(selectedDate),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.chevron_left, size: 24),
                                    onPressed: isLoading ? null : () => _changeMonth(-1),
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                  ),
                                  SizedBox(width: 8),
                                  IconButton(
                                    icon: Icon(Icons.chevron_right, size: 24),
                                    onPressed: isLoading ? null : () => _changeMonth(1),
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: dayNames
                                .map((day) => SizedBox(
                              width: 32,
                              child: Center(
                                child: Text(
                                  day,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ))
                                .toList(),
                          ),
                          SizedBox(height: 12),
                          Expanded(
                            flex: 1,
                            child: isLoading
                                ? Center(
                              child: CircularProgressIndicator(),
                            )
                                : GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 7,
                                childAspectRatio: 1,
                              ),
                              itemCount: daysInMonth.length + startingWeekday,
                              itemBuilder: (context, index) {
                                if (index < startingWeekday) {
                                  return SizedBox();
                                }

                                final dayIndex = index - startingWeekday;
                                final date = daysInMonth[dayIndex];
                                final isSelected = date.day == selectedDate.day &&
                                    date.month == selectedDate.month &&
                                    date.year == selectedDate.year;
                                final hasEvents = _hasEvents(date);

                                return GestureDetector(
                                  onTap: () => _selectDate(date),
                                  child: Container(
                                    margin: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.transparent,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Text(
                                            '${date.day.toString().padLeft(2, '0')}',
                                            style: TextStyle(
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.black87,
                                              fontWeight: isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ),
                                        if (hasEvents && !isSelected)
                                          Positioned(
                                            bottom: 4,
                                            left: 0,
                                            right: 0,
                                            child: Center(
                                              child: Container(
                                                width: 4,
                                                height: 4,
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Upcoming events',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 12),
                          Expanded(
                            flex: 1,
                            child: selectedEvents.isEmpty
                                ? Center(
                              child: Text(
                                'Tidak ada kegiatan',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            )
                                : ListView.builder(
                              itemCount: selectedEvents.length,
                              itemBuilder: (context, index) {
                                final kegiatan = selectedEvents[index];
                                return Container(
                                  margin: EdgeInsets.only(bottom: 12),
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.blue.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        kegiatan.namaKegiatan,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        kegiatan.formattedTime,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      if (kegiatan.deskripsi != null &&
                                          kegiatan.deskripsi!.isNotEmpty) ...[
                                        SizedBox(height: 4),
                                        Text(
                                          kegiatan.deskripsi!,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontFamily: 'Poppins',
                                            color: Colors.grey[500],
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}