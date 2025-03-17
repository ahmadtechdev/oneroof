// flight_booking_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/city_selection_bottom_sheet.dart';

enum TripType { oneWay, roundTrip, multiCity }

class CityPair {
  final RxString fromCity;
  final RxString fromCityName;
  final RxString toCity;
  final RxString toCityName;
  final RxString departureDate;

  CityPair({
    String? fromCity,
    String? fromCityName,
    String? toCity,
    String? toCityName,
    String? departureDate,
  })  : fromCity = (fromCity ?? 'DEL').obs,
        fromCityName = (fromCityName ?? 'NEW DELHI').obs,
        toCity = (toCity ?? 'BOM').obs,
        toCityName = (toCityName ?? 'MUMBAI').obs,
        departureDate = (departureDate ?? '03/11/2025').obs;

  void swap() {
    final tempCity = fromCity.value;
    final tempCityName = fromCityName.value;

    fromCity.value = toCity.value;
    fromCityName.value = toCityName.value;

    toCity.value = tempCity;
    toCityName.value = tempCityName;
  }
}

class FlightBookingController extends GetxController {
  // Trip type
  final Rx<TripType> tripType = TripType.roundTrip.obs;

  // City pairs for multicity
  final RxList<CityPair> cityPairs = <CityPair>[].obs;

  // City selection for one-way and round trip
  final RxString fromCity = 'DEL'.obs;
  final RxString fromCityName = 'NEW DELHI'.obs;
  final RxString toCity = 'BOM'.obs;
  final RxString toCityName = 'MUMBAI'.obs;

  // Date selection
  final RxString departureDate = '03/11/2025'.obs;
  final RxString returnDate = '10/11/2025'.obs;

  // Traveller and class selection
  final RxInt travellersCount = 1.obs;
  final RxString travelClass = 'Economy'.obs;

  // Passenger types
  final List<RxBool> passengerTypes = [
    false.obs, // Defence Forces
    false.obs, // Students
    false.obs, // Senior Citizens
  ];

  // Additional checkbox for Doctors & Nurses
  final RxBool doctorsAndNurses = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with round trip selected as shown in the screenshot
    setTripType(TripType.roundTrip);

    // Initialize first city pair for multicity
    cityPairs.add(CityPair(
      fromCity: 'DEL',
      fromCityName: 'NEW DELHI',
      toCity: 'BOM',
      toCityName: 'MUMBAI',
      departureDate: '03/11/2025',
    ));

    // Add a second city pair for multicity
    cityPairs.add(CityPair(
      fromCity: 'BOM',
      fromCityName: 'MUMBAI',
      toCity: 'BLR',
      toCityName: 'BENGALURU',
      departureDate: '05/11/2025',
    ));
  }

  void setTripType(TripType type) {
    tripType.value = type;

    // If switching to multicity and there's only one city pair, add another
    if (type == TripType.multiCity && cityPairs.length < 2) {
      cityPairs.add(CityPair(
        fromCity: toCity.value,
        fromCityName: toCityName.value,
        toCity: 'BLR',
        toCityName: 'BENGALURU',
        departureDate: _getDefaultDepartureDate(1),
      ));
    }
  }

  String _getDefaultDepartureDate(int daysToAdd) {
    final DateTime date = DateTime.now().add(Duration(days: daysToAdd));
    return _formatDate(date);
  }

  void swapCities() {
    if (tripType.value == TripType.multiCity) {
      // Do nothing for multicity as each leg has its own swap button
      return;
    }

    final tempCity = fromCity.value;
    final tempCityName = fromCityName.value;

    fromCity.value = toCity.value;
    fromCityName.value = toCityName.value;

    toCity.value = tempCity;
    toCityName.value = tempCityName;
  }

  void swapCitiesForPair(int index) {
    if (index < cityPairs.length) {
      cityPairs[index].swap();
    }
  }

  void addCityPair() {
    if (cityPairs.length < 5) { // Limit to 5 city pairs
      final lastPair = cityPairs.last;
      cityPairs.add(CityPair(
        fromCity: lastPair.toCity.value,
        fromCityName: lastPair.toCityName.value,
        toCity: 'BLR', // Default to Bangalore
        toCityName: 'BENGALURU',
        departureDate: _getDefaultDepartureDate(cityPairs.length + 1),
      ));
    }
  }

  void removeCityPair() {
    if (cityPairs.length > 2) {
      cityPairs.removeLast();
    }
  }

  void setDepartureDate(String date) {
    departureDate.value = date;
  }

  void setReturnDate(String date) {
    returnDate.value = date;
  }

  void setDepartureDateForPair(int index, String date) {
    if (index < cityPairs.length) {
      cityPairs[index].departureDate.value = date;
    }
  }

  void incrementTravellers() {
    if (travellersCount.value < 9) {
      travellersCount.value++;
    }
  }

  void decrementTravellers() {
    if (travellersCount.value > 1) {
      travellersCount.value--;
    }
  }

  void setTravelClass(String classType) {
    travelClass.value = classType;
  }

  void togglePassengerType(int index) {
    passengerTypes[index].value = !passengerTypes[index].value;
  }

  void toggleDoctorsAndNurses() {
    doctorsAndNurses.value = !doctorsAndNurses.value;
  }

  void searchFlights() {
    // Implement search functionality
    Get.snackbar(
      'Search',
      'Searching for flights...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // Here you would typically navigate to a results page or call an API
  }

  // Methods for opening date pickers
  void openDepartureDatePicker(BuildContext context) {
    _showDatePicker(context, (date) {
      setDepartureDate(_formatDate(date));
    });
  }

  void openReturnDatePicker(BuildContext context) {
    if (tripType.value != TripType.oneWay) {
      _showDatePicker(context, (date) {
        setReturnDate(_formatDate(date));
      });
    }
  }

  void openDatePickerForPair(BuildContext context, int index) {
    _showDatePicker(context, (date) {
      setDepartureDateForPair(index, _formatDate(date));
    });
  }

  void _showDatePicker(BuildContext context, Function(DateTime) onDateSelected) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ).then((date) {
      if (date != null) {
        onDateSelected(date);
      }
    });
  }

  // flight_booking_controller.dart - Add these methods

  void showCitySelectionBottomSheet(BuildContext context, FieldType fieldType, {int? multiCityIndex}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CitySelectionBottomSheet(
        fieldType: fieldType,
        onCitySelected: (AirportData airport) {
          if (tripType.value == TripType.multiCity && multiCityIndex != null) {
            // For multicity
            if (fieldType == FieldType.departure) {
              cityPairs[multiCityIndex].fromCity.value = airport.code;
              cityPairs[multiCityIndex].fromCityName.value = airport.cityName;
            } else {
              cityPairs[multiCityIndex].toCity.value = airport.code;
              cityPairs[multiCityIndex].toCityName.value = airport.cityName;
            }
          } else {
            // For one-way and round-trip
            if (fieldType == FieldType.departure) {
              fromCity.value = airport.code;
              fromCityName.value = airport.cityName;
            } else {
              toCity.value = airport.code;
              toCityName.value = airport.cityName;
            }
          }
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}