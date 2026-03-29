import 'package:farmers_1/Views/Role_based_login/User/Screen/user_app_main_screen.dart';
import 'package:farmers_1/WeatherUpdates/Service/api_service.dart';
import 'package:farmers_1/WeatherUpdates/weekly_forecast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class Weatherupdatescreen extends ConsumerStatefulWidget {
  const Weatherupdatescreen({super.key});

  @override
  ConsumerState<Weatherupdatescreen> createState() =>
      _WeatherupdatescreenState();
}

class _WeatherupdatescreenState extends ConsumerState<Weatherupdatescreen> {
  final _weatherService = WeatherApiService();
  String city = "Bloemfontein";
  String country = '';
  Map<String, dynamic> currentvalue = {};
  List<dynamic> hourly = [];
  List<dynamic> pastWeek = [];
  List<dynamic> next7days = [];
  bool isLoading = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() => isLoading = true);
    try {
      final forecast = await _weatherService.getHourlyForecast(city);
      final past = await _weatherService.getPastSevenDaysWeather(city);

      setState(() {
        currentvalue = forecast['current'] ?? {};
        List<dynamic> todayHourly =
            forecast['forecast']?['forecastday']?[0]?['hour'] ?? [];
        List<dynamic> tomorrowHourly =
            forecast['forecast']?['forecastday']?[1]?['hour'] ?? [];
        hourly = [...todayHourly, ...tomorrowHourly];
        next7days = forecast['forecast']?['forecastday'] ?? [];
        pastWeek = past;
        city = forecast['location']?['name'] ?? city;
        country = forecast['location']?['country'] ?? '';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "City not found or invalid. Please enter a valid city.",
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  String formatetime(String timeString) {
    DateTime time = DateTime.parse(timeString);
    return DateFormat.j().format(time);
  }

  @override
  Widget build(BuildContext context) {
    String iconPath = currentvalue['condition']?['icon'] ?? '';
    String imageUrl = iconPath.isNotEmpty ? "https:$iconPath" : "";
    Widget imageWidget = imageUrl.isNotEmpty
        ? Image.network(imageUrl, height: 150, width: 150, fit: BoxFit.cover)
        : const SizedBox();

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Container(
          color: const Color(0xFF1C1C1E),
          padding: const EdgeInsets.only(
            top: 35,
            left: 15,
            right: 15,
            bottom: 10,
          ),
          child: Row(
            children: [
              //Back Button
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserAppMainScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Full-width Search Bar
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2E),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    onSubmitted: (value) {
                      if (value.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter a city name."),
                          ),
                        );
                        return;
                      }
                      city = value.trim();
                      _fetchWeather();
                      _controller.clear();
                    },
                    decoration: InputDecoration(
                      hintText: "Search city...",
                      hintStyle: const TextStyle(color: Colors.white54),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.white70,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(color: Colors.blueAccent),
              )
            else if (currentvalue.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "$city${country.isNotEmpty ? ', $country' : ''}",
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${currentvalue['temp_c']}°C",
                    style: const TextStyle(
                      fontSize: 55,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${currentvalue['condition']['text']}",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  imageWidget,
                  const SizedBox(height: 15),

                  // Weather stats container
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      height: 110,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2C2E),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildWeatherStat(
                            "Humidity",
                            "${currentvalue['humidity']}%",
                            "https://cdn-icons-png.flaticon.com/256/4148/4148460.png",
                          ),
                          _buildWeatherStat(
                            "Wind",
                            "${currentvalue['wind_kph']} kph",
                            "https://cdn-icons-png.flaticon.com/512/4238/4238288.png",
                          ),
                          _buildWeatherStat(
                            "Max Temp",
                            "${hourly.isNotEmpty ? hourly.map((h) => h['temp_c']).reduce((a, b) => a > b ? a : b) : "N/A"}°",
                            "https://cdn-icons-png.flaticon.com/512/6281/6281340.png",
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Today Forecast",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WeeklyForecast(
                                  currentvalue: currentvalue,
                                  hourly: hourly,
                                  pastWeek: pastWeek,
                                  next7days: next7days,
                                  city: city,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "Weekly Forecast >",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.white24, thickness: 1),
                  const SizedBox(height: 10),

                  //Hourly Forecast List
                  SizedBox(
                    height: 155,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: hourly.length,
                      itemBuilder: (context, index) {
                        final hour = hourly[index];
                        final now = DateTime.now();
                        final hourTime = DateTime.parse(hour['time']);
                        final isCurrentHour =
                            now.hour == hourTime.hour &&
                            now.day == hourTime.day;

                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            width: 85,
                            decoration: BoxDecoration(
                              color: isCurrentHour
                                  ? Colors.blueAccent
                                  : const Color(0xFF2C2C2E),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  isCurrentHour
                                      ? "Now"
                                      : formatetime(hour['time']),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Image.network(
                                  "https:${hour['condition']?['icon']}",
                                  height: 35,
                                  width: 35,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "${hour["temp_c"]}°C",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherStat(String label, String value, String iconUrl) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(iconUrl, width: 28, height: 28),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.white70),
        ),
      ],
    );
  }
}
