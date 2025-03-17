// city_selection_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utility/colors.dart';

class AirportData {
  final String code;
  final String name;
  final String cityName;
  final String countryName;
  final String cityCode;

  AirportData({
    required this.code,
    required this.name,
    required this.cityName,
    required this.countryName,
    required this.cityCode,
  });

  factory AirportData.fromJson(Map<String, dynamic> json) {
    return AirportData(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      cityName: json['city_name'] ?? '',
      countryName: json['country_name'] ?? '',
      cityCode: json['city_code'] ?? '',
    );
  }
}

enum FieldType { departure, destination }

class CitySelectionBottomSheet extends StatefulWidget {
  final Function(AirportData) onCitySelected;
  final FieldType fieldType;

  const CitySelectionBottomSheet({
    Key? key,
    required this.onCitySelected,
    required this.fieldType,
  }) : super(key: key);

  @override
  State<CitySelectionBottomSheet> createState() => _CitySelectionBottomSheetState();
}

class _CitySelectionBottomSheetState extends State<CitySelectionBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<AirportData> _filteredAirports = [];
  final RxBool _isLoading = false.obs;

  // Dummy data for airports
  final List<AirportData> _airports = [
    AirportData(code: 'DEL', name: 'Indira Gandhi International Airport', cityName: 'NEW DELHI', countryName: 'India', cityCode: 'DEL'),
    AirportData(code: 'BOM', name: 'Chhatrapati Shivaji International Airport', cityName: 'MUMBAI', countryName: 'India', cityCode: 'BOM'),
    AirportData(code: 'BLR', name: 'Kempegowda International Airport', cityName: 'BENGALURU', countryName: 'India', cityCode: 'BLR'),
    AirportData(code: 'MAA', name: 'Chennai International Airport', cityName: 'CHENNAI', countryName: 'India', cityCode: 'MAA'),
    AirportData(code: 'HYD', name: 'Rajiv Gandhi International Airport', cityName: 'HYDERABAD', countryName: 'India', cityCode: 'HYD'),
    AirportData(code: 'CCU', name: 'Netaji Subhas Chandra Bose International Airport', cityName: 'KOLKATA', countryName: 'India', cityCode: 'CCU'),
    AirportData(code: 'PNQ', name: 'Pune Airport', cityName: 'PUNE', countryName: 'India', cityCode: 'PNQ'),
    AirportData(code: 'BKK', name: 'Suvarnabhumi Airport', cityName: 'BANGKOK', countryName: 'Thailand', cityCode: 'BKK'),
    AirportData(code: 'DXB', name: 'Dubai International Airport', cityName: 'DUBAI', countryName: 'United Arab Emirates', cityCode: 'DXB'),
    AirportData(code: 'SIN', name: 'Singapore Changi Airport', cityName: 'SINGAPORE', countryName: 'Singapore', cityCode: 'SIN'),
  ];

  @override
  void initState() {
    super.initState();
    _filteredAirports = _airports;
    _searchController.addListener(_filterAirports);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterAirports() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _filteredAirports = _airports;
      });
      return;
    }

    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredAirports = _airports.where((airport) {
        return airport.cityName.toLowerCase().contains(query) ||
            airport.code.toLowerCase().contains(query) ||
            airport.name.toLowerCase().contains(query) ||
            airport.countryName.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 1,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: TColors.secondary,
            ),
            child: Center(
              child: Text(
                widget.fieldType == FieldType.departure ? 'Select Departure City' : 'Select Destination City',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                fillColor: Colors.grey[100],
                filled: true,
                hintText: 'Search for city or airport',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'RECENT SEARCHES',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Divider(color: Colors.grey[300]),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'POPULAR CITIES',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Divider(color: Colors.grey[300]),
          Expanded(
            child: Obx(
                  () => _isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: _filteredAirports.length,
                itemBuilder: (context, index) {
                  final airport = _filteredAirports[index];
                  return ListTile(
                    onTap: () {
                      widget.onCitySelected(airport);
                      Navigator.pop(context);
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${airport.cityName}, ${airport.countryName}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                airport.name,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            airport.code,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}