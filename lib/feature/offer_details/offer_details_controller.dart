import 'package:flutter_challenge/model/offer_model.dart';
import 'package:flutter_challenge/repository/offer_repo.dart';
import 'package:flutter_challenge/repository/cart_repo.dart';
import 'package:get/get.dart';

import '../../model/cart_item_model.dart';

class OfferDetailsController extends GetxController {
  final OfferRepo _offerRepo = Get.find<OfferRepo>();
  final CartRepo _cartRepo = Get.find<CartRepo>();

  final RxBool _isLoading = true.obs;
  final RxBool _hasError = false.obs;
  final Rxn<OfferModel> _offer = Rxn<OfferModel>();
  final RxInt _quantity = 1.obs;

  bool get isLoading => _isLoading.value;
  bool get hasError => _hasError.value;
  OfferModel? get offer => _offer.value;
  int get quantity => _quantity.value;

  // Add a reactive tracking list for cart items
  final RxList<CartItemModel> _cartItems = <CartItemModel>[].obs;

  // Calculate dynamic quantity left: raw quantity minus what's already in the basket
  num get adjustedQuantityLeft {
    if (_offer.value == null) return 0;

    final cartItem = _cartItems.firstWhereOrNull((item) => item.offer.id == _offer.value!.id);
    final quantityInCart = cartItem?.quantity ?? 0;

    return _offer.value!.quantityLeft - quantityInCart;
  }

  @override
  void onInit() {
    super.onInit();
    _loadOfferDetails();
    _updateCartItems();
  }

  Future<void> _loadOfferDetails() async {
    final String? offerId = Get.parameters['id'];
    if (offerId == null || offerId.isEmpty) {
      _hasError.value = true;
      _isLoading.value = false;
      return;
    }

    _isLoading.value = true;
    _hasError.value = false;
    try {
      final allOffers = await _offerRepo.fetchOffers();
      final foundOffer = allOffers.firstWhereOrNull((item) => item.id == offerId);

      if (foundOffer != null) {
        _offer.value = foundOffer;
      } else {
        _hasError.value = true;
      }
    } catch (e) {
      _hasError.value = true;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _updateCartItems() async {
    final items = await _cartRepo.loadCart();
    _cartItems.assignAll(items);
  }

  void incrementQuantity() {
    if (_offer.value != null && _quantity.value < adjustedQuantityLeft) {
      _quantity.value++;
    }
  }

  void decrementQuantity() {
    if (_quantity.value > 1) {
      _quantity.value--;
    }
  }

  // FIXED (Task A2): Wired up adding items to the actual persistent local cart storage
  Future<void> addToBag() async {
    if (_offer.value == null || adjustedQuantityLeft <= 0) return;

    try {
      await _cartRepo.addOffer(_offer.value!, quantity: _quantity.value);
      await _updateCartItems(); // Refresh our cart inventory list instantly

      // Reset stepper count back to 1 or max available
      _quantity.value = adjustedQuantityLeft > 0 ? 1 : 0;

      Get.snackbar(
        'success_generic'.tr,
        'Added items to bag!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'error_generic'.tr,
        'Could not add item to bag.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}