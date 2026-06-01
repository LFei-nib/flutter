import 'package:flutter/material.dart';
import 'package:flutter_challenge/feature/offer_details/offer_details_controller.dart';
import 'package:flutter_challenge/util/constants/app_colors.dart';
import 'package:flutter_challenge/util/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OfferDetailsScreen extends GetView<OfferDetailsController> {
  const OfferDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('offer_details'.tr, style: Styles.boldText18()),
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.hasError || controller.offer == null) {
          return Center(
            child: Text('error_generic'.tr, style: Styles.regularText14()),
          );
        }

        final offer = controller.offer!;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Offer Image
                    Image.network(
                      offer.imageUrl,
                      width: double.infinity,
                      height: 240.h,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 240.h,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, size: 48),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Store Name
                          Text(
                            offer.storeName,
                            style: Styles.regularText14().copyWith(color: Colors.grey[600]),
                          ),
                          SizedBox(height: 4.h),

                          // Offer Title
                          Text(offer.title, style: Styles.boldText18()),
                          SizedBox(height: 12.h),

                          // Prices & Discount Row
                          Row(
                            children: [
                              Text(
                                '\$${offer.discountedPrice}',
                                style: Styles.boldText18().copyWith(color: AppColors.primary),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                '\$${offer.originalPrice}',
                                style: Styles.regularText14().copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: Colors.red[500],
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  '-${offer.discountPercent}%',
                                  style: Styles.boldText18().copyWith(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          const Divider(),
                          SizedBox(height: 12.h),

                          // Pickup Window
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 20, color: Colors.grey),
                              SizedBox(width: 8.w),
                              Text('Pickup: ${offer.pickupWindow}', style: Styles.regularText14()),
                            ],
                          ),
                          SizedBox(height: 8.h),

                          // Quantity Left
                          Row(
                            children: [
                              const Icon(Icons.shopping_bag_outlined, size: 20, color: Colors.grey),
                              SizedBox(width: 8.w),
                              Text('${controller.adjustedQuantityLeft} left', style: Styles.regularText14()),
                            ],
                          ),
                          SizedBox(height: 16.h),

                          // CO2 Badge (Task A2 Requirement / Fix B1 dynamic tracking)
                          Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: Colors.green[200]!),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.eco, color: Colors.green),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    'You save ${offer.co2Kg} kg of CO₂ with this meal!',
                                    style: Styles.mediumText16().copyWith(color: Colors.green[800]),
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
              ),
            ),

            // Bottom Quantity Selector & Action Button
            _buildBottomActionBar(),
          ],
        );
      }),
    );
  }

  Widget _buildBottomActionBar() {
    final offer = controller.offer!;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Quantity Stepper (1 to quantityLeft)
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: controller.decrementQuantity,
                  ),
                  Obx(() => Text('${controller.quantity}', style: Styles.boldText18())),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: controller.incrementQuantity,
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),

            // Add To Bag Button
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                onPressed: controller.adjustedQuantityLeft > 0 ? controller.addToBag : null,
                child: Text(
                  'Add to bag',
                  style: Styles.boldText18().copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}