import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:oneroof/utility/colors.dart';
import 'package:oneroof/views/group_ticket/passenger_detail.dart';

class slectpkg extends StatefulWidget {
  const slectpkg({Key? key}) : super(key: key);

  @override
  State<slectpkg> createState() => _slectpkgState();
}

class _slectpkgState extends State<slectpkg> {
  // Default filter values
  String _selectedSector = 'lahore-dammam';
  String _selectedAirline = 'fly-jinnah';
  String _selectedDate = 'all'; // Changed default to 'all' to show all dates

  // Formatting
  final DateFormat _dateFormatter = DateFormat('dd-MM-yyyy');

  // Dummy data for flights
  final List<Map<String, dynamic>> _flights = [
    {
      'airline': 'Fly Jinnah',
      'shortName': 'FJ',
      'departure': DateTime(2025, 4, 5),
      'departureTime': '07:00 AM',
      'arrivalTime': '08:20 AM',
      'origin': 'LAHORE',
      'destination': 'DAMMAM',
      'flightNumber': '9F 570',
      'price': 93000,
      'hasLayover': false,
      'baggage': '20+7 KG',
    },
    {
      'airline': 'Fly Jinnah',
      'shortName': 'FJ',
      'departure': DateTime(2025, 4, 8),
      'departureTime': '07:00 AM',
      'arrivalTime': '08:20 AM',
      'origin': 'LAHORE',
      'destination': 'DAMMAM',
      'flightNumber': '9F 570',
      'price': 95500,
      'hasLayover': false,
      'baggage': '20+7 KG',
    },
    {
      'airline': 'Fly Jinnah',
      'shortName': 'FJ',
      'departure': DateTime(2025, 4, 10),
      'departureTime': '07:00 AM',
      'arrivalTime': '08:20 AM',
      'origin': 'LAHORE',
      'destination': 'DAMMAM',
      'flightNumber': '9F 570',
      'price': 95500,
      'hasLayover': false,
      'baggage': '20+7 KG',
    },
    {
      'airline': 'Air Sial',
      'shortName': 'AS',
      'departure': DateTime(2025, 4, 4),
      'departureTime': '09:00 AM',
      'arrivalTime': '10:30 AM',
      'origin': 'LAHORE',
      'destination': 'DAMMAM',
      'flightNumber': 'AS 201',
      'price': 97000,
      'hasLayover': false,
      'baggage': '30+7 KG',
    },
    {
      'airline': 'Saudi Airline',
      'shortName': 'SA',
      'departure': DateTime(2025, 4, 9),
      'departureTime': '11:30 AM',
      'arrivalTime': '01:20 PM',
      'origin': 'LAHORE',
      'destination': 'DAMMAM',
      'flightNumber': 'SV 735',
      'price': 105000,
      'hasLayover': false,
      'baggage': '35+7 KG',
    },
  ];

  // Sector options
  final List<Map<String, String>> _sectorOptions = [
    {'label': 'Lahore-Dammam', 'value': 'lahore-dammam'},
    {'label': 'Islamabad-Riyadh', 'value': 'islamabad-riyadh'},
    {'label': 'Islamabad-Dammam', 'value': 'islamabad-dammam'},
    {'label': 'Lahore-Riyadh', 'value': 'lahore-riyadh'},
    {'label': 'Lahore-Jeddah', 'value': 'lahore-jeddah'},
    {'label': 'Faisalabad-Sharjah', 'value': 'faisalabad-sharjah'},
    {'label': 'Peshawar-Riyadh', 'value': 'peshawar-riyadh'},
  ];

  // Airline options
  final List<Map<String, String>> _airlineOptions = [
    {'label': 'Fly Nas', 'value': 'fly-nas'},
    {'label': 'Air Sial', 'value': 'air-sial'},
    {'label': 'Fly Jinnah', 'value': 'fly-jinnah'},
    {'label': 'Saudi Airline', 'value': 'saudi-airline'},
    {'label': 'Serene Air', 'value': 'serene-air'},
    {'label': 'Air Arabia', 'value': 'air-arabia'},
  ];

  // Date options - Added "All Dates" option
  final List<Map<String, String>> _dateOptions = [
    {'label': 'All Dates', 'value': 'all'},
    {'label': '04 Apr 2025', 'value': '04-04-2025'},
    {'label': '05 Apr 2025', 'value': '05-04-2025'},
    {
      'label': '08 Apr 2025',
      'value': '08-04-2025',
    }, // Added to match Fly Jinnah flight
    {'label': '09 Apr 2025', 'value': '09-04-2025'},
    {
      'label': '10 Apr 2025',
      'value': '10-04-2025',
    }, // Added to match Fly Jinnah flight
    {'label': '12 Apr 2025', 'value': '12-04-2025'},
    {'label': '17 Apr 2025', 'value': '17-04-2025'},
  ];

  // Reset filters to default
  void _resetFilters() {
    setState(() {
      _selectedSector = 'lahore-dammam';
      _selectedAirline = 'fly-jinnah';
      _selectedDate = 'all'; // Changed to 'all'
    });
  }

  // Improved filtered flights getter
  List<Map<String, dynamic>> get _filteredFlights {
    return _flights.where((flight) {
      // Match airline
      bool airlineMatch = true;
      if (_selectedAirline.isNotEmpty) {
        final airlineName = flight['airline']
            .toString()
            .toLowerCase()
            .replaceAll(' ', '-');
        airlineMatch = airlineName == _selectedAirline;
      }

      // Match sector
      bool sectorMatch = true;
      if (_selectedSector.isNotEmpty) {
        final origin = flight['origin'].toString().toLowerCase();
        final destination = flight['destination'].toString().toLowerCase();
        final sector = '$origin-$destination';
        sectorMatch = sector == _selectedSector;
      }

      // Match date - Now handles 'all' option
      bool dateMatch = true;
      if (_selectedDate.isNotEmpty && _selectedDate != 'all') {
        final flightDate = _dateFormatter.format(flight['departure']);
        dateMatch = flightDate == _selectedDate;
      }

      return airlineMatch && sectorMatch && dateMatch;
    }).toList();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            // Create temporary filter variables for the bottom sheet
            String tempSector = _selectedSector;
            String tempAirline = _selectedAirline;
            String tempDate = _selectedDate;

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filters',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: TColors.primary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              // Reset temporary filters in bottom sheet
                              tempSector = 'lahore-dammam';
                              tempAirline = 'fly-jinnah';
                              tempDate = 'all'; // Changed to 'all'
                            });
                          },
                          child: const Text(
                            'Clear All',
                            style: TextStyle(
                              fontSize: 14,
                              color: TColors.third,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // Filter content in scrollable area
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Sector Filter
                          const Text(
                            'Sector',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: TColors.text,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children:
                                _sectorOptions.map((option) {
                                  final bool isSelected =
                                      tempSector == option['value'];
                                  return GestureDetector(
                                    onTap: () {
                                      setModalState(() {
                                        tempSector = option['value']!;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            isSelected
                                                ? TColors.third
                                                : Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        option['label']!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              isSelected
                                                  ? Colors.white
                                                  : TColors.text,
                                          fontWeight:
                                              isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),

                          const SizedBox(height: 25),

                          // Airlines Filter
                          const Text(
                            'Airlines',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: TColors.text,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children:
                                _airlineOptions.map((option) {
                                  final bool isSelected =
                                      tempAirline == option['value'];
                                  return GestureDetector(
                                    onTap: () {
                                      setModalState(() {
                                        tempAirline = option['value']!;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            isSelected
                                                ? TColors.third
                                                : Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        option['label']!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              isSelected
                                                  ? Colors.white
                                                  : TColors.text,
                                          fontWeight:
                                              isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),

                          const SizedBox(height: 25),

                          // Departure Dates Filter
                          const Text(
                            'Departure Dates',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: TColors.text,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children:
                                _dateOptions.map((option) {
                                  final bool isSelected =
                                      tempDate == option['value'];
                                  return GestureDetector(
                                    onTap: () {
                                      setModalState(() {
                                        tempDate = option['value']!;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            isSelected
                                                ? TColors.third
                                                : Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        option['label']!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              isSelected
                                                  ? Colors.white
                                                  : TColors.text,
                                          fontWeight:
                                              isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Apply button
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // Apply the selected filters from temp variables
                          _selectedSector = tempSector;
                          _selectedAirline = tempAirline;
                          _selectedDate = tempDate;
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.secondary,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Apply Filters',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: TColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Handle back navigation
          },
        ),
        title: const Text(
          'Flight Search Results',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.print, color: Colors.white),
            onPressed: () {
              // Handle print functionality
            },
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filters and Route Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: TColors.text,
                      ),
                    ),
                    TextButton(
                      onPressed: _resetFilters, // Use the reset function
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Clear All',
                        style: TextStyle(fontSize: 14, color: TColors.third),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Text(
                      'LAHORE-DAMMAM',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: TColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: TColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.flight,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Filter toggle button
          InkWell(
            onTap: _showFilterBottomSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Show All Filters',
                    style: TextStyle(
                      color: TColors.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down, color: TColors.secondary),
                ],
              ),
            ),
          ),

          // Applied filters chips
          if (_selectedSector != 'lahore-dammam' ||
              _selectedAirline != 'fly-jinnah' ||
              _selectedDate != 'all') // Changed condition
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (_selectedSector != 'lahore-dammam')
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Chip(
                          label: Text(
                            _sectorOptions.firstWhere(
                              (option) => option['value'] == _selectedSector,
                              orElse:
                                  () => {
                                    'label': 'Unknown',
                                    'value': _selectedSector,
                                  },
                            )['label']!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: TColors.third,
                          deleteIconColor: Colors.white,
                          onDeleted: () {
                            setState(() {
                              _selectedSector = 'lahore-dammam';
                            });
                          },
                        ),
                      ),
                    if (_selectedAirline != 'fly-jinnah')
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Chip(
                          label: Text(
                            _airlineOptions.firstWhere(
                              (option) => option['value'] == _selectedAirline,
                              orElse:
                                  () => {
                                    'label': 'Unknown',
                                    'value': _selectedAirline,
                                  },
                            )['label']!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: TColors.third,
                          deleteIconColor: Colors.white,
                          onDeleted: () {
                            setState(() {
                              _selectedAirline = 'fly-jinnah';
                            });
                          },
                        ),
                      ),
                    if (_selectedDate != 'all') // Changed condition
                      Chip(
                        label: Text(
                          _dateOptions.firstWhere(
                            (option) => option['value'] == _selectedDate,
                            orElse:
                                () => {
                                  'label': _selectedDate,
                                  'value': _selectedDate,
                                },
                          )['label']!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: TColors.third,
                        deleteIconColor: Colors.white,
                        onDeleted: () {
                          setState(() {
                            _selectedDate = 'all'; // Changed to 'all'
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),

          // Flight cards list
          Expanded(
            child:
                _filteredFlights.isEmpty
                    ? const Center(
                      child: Text(
                        'No flights match your filter criteria',
                        style: TextStyle(
                          fontSize: 16,
                          color: TColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _filteredFlights.length,
                      itemBuilder: (context, index) {
                        final flight = _filteredFlights[index];
                        final formatter = DateFormat('dd MMM yyyy');

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Header with airline and date - more compact
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  12,
                                  12,
                                  12,
                                  6,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: TColors.third.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        flight['shortName'],
                                        style: TextStyle(
                                          color: TColors.third,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          flight['airline'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: TColors.primary,
                                          ),
                                        ),
                                        Text(
                                          'Departure',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Text(
                                      '${formatter.format(flight['departure'])}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: TColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Route info - more compact
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            flight['departureTime'],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: TColors.primary,
                                            ),
                                          ),
                                          Text(
                                            flight['origin'],
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 6,
                                            height: 6,
                                            decoration: const BoxDecoration(
                                              color: TColors.primary,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 1,
                                              color: Colors.grey[300],
                                            ),
                                          ),
                                          const Icon(
                                            Icons.flight,
                                            color: TColors.primary,
                                            size: 16,
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 1,
                                              color: Colors.grey[300],
                                            ),
                                          ),
                                          Container(
                                            width: 6,
                                            height: 6,
                                            decoration: const BoxDecoration(
                                              color: TColors.primary,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            flight['arrivalTime'],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: TColors.primary,
                                            ),
                                          ),
                                          Text(
                                            flight['destination'],
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Flight number and info row combined - more compact
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      flight['flightNumber'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: TColors.primary,
                                      ),
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.info_outline,
                                          size: 14,
                                          color: TColors.secondary,
                                        ),
                                        const SizedBox(width: 2),
                                        const Text(
                                          'NO',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: TColors.secondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 16),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.luggage,
                                          size: 14,
                                          color: TColors.primary,
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          flight['baggage'],
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: TColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Price and booking - more compact
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  12,
                                  6,
                                  12,
                                  12,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'PKR ${flight['price']}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: TColors.primary,
                                      ),
                                    ),
                                    const Spacer(),
                                    ElevatedButton(
                                      onPressed: () {
                                        Get.to(() => BookingSummaryScreen());
                                        // Handle booking
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: TColors.secondary,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Book Now',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
