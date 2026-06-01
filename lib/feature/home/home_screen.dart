import 'package:flutter/material.dart';
import 'package:flutter_challenge/feature/home/home_screen_controller.dart';
import 'package:flutter_challenge/feature/shared_widget/main_shell.dart';
import 'package:flutter_challenge/feature/shared_widget/offer_card.dart';
import 'package:flutter_challenge/util/constants/app_colors.dart';
import 'package:flutter_challenge/util/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView<HomeScreenController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainShell(
      currentIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text('home_title'.tr, style: Styles.boldText18()),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              _buildSearchBar(),
              SizedBox(height: 12.h),
              _buildFilterChips(),
              SizedBox(height: 12.h),
              Expanded(child: _buildOfferList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'search_hint'.tr,
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        filled: true,
        fillColor: Colors.white,
      ),
      // Fixed (Task A1): onChanged  connected to controller.setSearchQuery.
      onChanged: (value) => controller.setSearchQuery(value),
    );
  }

  Widget _buildFilterChips() {
    return Obx(() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _filterChip('filter_all'.tr, OfferFilter.all),
            _filterChip('filter_bakery'.tr, OfferFilter.bakery),
            _filterChip('filter_cafe'.tr, OfferFilter.cafe),
            _filterChip('filter_market'.tr, OfferFilter.market),
          ],
        ),
      );
    });
  }

  Widget _filterChip(String label, OfferFilter filter) {
    final isSelected = controller.activeFilter == filter;
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => controller.setFilter(filter),
        selectedColor: AppColors.primary.withValues(alpha: 0.2),
        checkmarkColor: AppColors.primary,
      ),
    );
  }

  Widget _buildOfferList() {
    return Obx(() {
      if (controller.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.hasError) {
        return Center(
          child: Text('error_generic'.tr, style: Styles.regularText14()),
        );
      }

      final offers = controller.visibleOffers;
      // FIXED (Task A4): Friendly empty state widget when offers list is empty
      if (offers.isEmpty) {
        return RefreshIndicator(
          onRefresh: () => controller.onRefresh(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: 100.h),
              Center(
                child: Text(
                  'empty_offers'.tr,
                  style: Styles.regularText14()?.copyWith(
                      color: Colors.grey[600]) ??
                      Styles.regularText14(),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      }

      // FIXED (Task A3): Wrapped with RefreshIndicator for pull-to-refresh functionality
      return RefreshIndicator(
        onRefresh: () => controller.onRefresh(),
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: offers.length,
          itemBuilder: (context, index) {
            final offer = offers[index];
            return OfferCard(
              offer: offer,
              onFavoriteTap: () => controller.toggleFavorite(offer.id),
            );
          },
        ),
      );
    });
  }
}
