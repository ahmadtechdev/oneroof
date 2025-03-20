import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oneroof/widgets/date_range_slector.dart';

import '../../../../services/api_service_hotel.dart';
import '../../../../widgets/loading_dailog.dart';
import '../../../utility/colors.dart';
import '../../../widgets/hotel_custom_textfield.dart';
import '../search_hotels/search_hotel.dart';
import '../search_hotels/search_hotel_controller.dart';
import 'guests/guests_controller.dart';
import 'hotel_date_controller.dart';
import 'guests/guests_field.dart';

class HotelFormScreen extends StatelessWidget {
  const HotelFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Hotel Search'),
        backgroundColor: TColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[50],
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: HotelForm(),
            ),
          ),
        ),
      ),
    );
  }
}

class HotelForm extends StatelessWidget {
  HotelForm({super.key}) {
    // Initialize both controllers
    Get.find<HotelDateController>();
    Get.find<SearchHotelController>();
  }

  @override
  Widget build(BuildContext context) {
    final cityController = TextEditingController();
    final hotelDateController = Get.find<HotelDateController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // City Input Field
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: CustomTextField(
            hintText: 'Enter City Name',
            icon: Icons.location_on,
            controller: cityController,
          ),
        ),

        const SizedBox(height: 16),

        // Date Range Selector
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Obx(
                () => CustomDateRangeSelector(
              dateRange: hotelDateController.dateRange.value,
              onDateRangeChanged: hotelDateController.updateDateRange,
              nights: hotelDateController.nights.value,
              onNightsChanged: hotelDateController.updateNights,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Guests Field
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const GuestsField(),
        ),

        const SizedBox(height: 24),

        // Search Button
        Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(27),
            boxShadow: [
              BoxShadow(
                color: TColors.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () async {
              // Show loading dialog
              Get.dialog(const LoadingDialog(), barrierDismissible: false);

              final hotelDateController = Get.find<HotelDateController>();
              final guestsController = Get.find<GuestsController>();

              String checkInDate =
              hotelDateController.checkInDate.value.toIso8601String();
              String checkOutDate =
              hotelDateController.checkOutDate.value.toIso8601String();

              // Create rooms array with the new structure
              List<Map<String, dynamic>> rooms = List.generate(
                guestsController.roomCount.value,
                    (index) => {
                  "RoomIdentifier": index + 1,
                  "Adult": guestsController.rooms[index].adults.value,
                  "Children": guestsController.rooms[index].children.value,
                  if (guestsController.rooms[index].children.value > 0)
                    "ChildrenAges":
                    guestsController.rooms[index].childrenAges.toList(),
                },
              );
              print('the rooms is $rooms');

              try {
                var apiService = Get.put(ApiServiceHotel());

                // Call the API
                await apiService.fetchHotel(
                  checkInDate: checkInDate,
                  checkOutDate: checkOutDate,
                  rooms: rooms,
                );

                // Close loading dialog
                Get.back();

                // Navigate to the hotel listing screen
                Get.to(() => const HotelScreen());
              } catch (e) {
                // Close loading dialog
                Get.back();

                // Show error dialog
                Get.dialog(
                  Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Something went wrong',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Please try again later.',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => Get.back(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: TColors.primary,
                              minimumSize: const Size(200, 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                            child: const Text(
                              'OK',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  barrierDismissible: false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(27),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Search Hotels',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}