import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';
import 'package:my_shop_ecommerce_flutter/src/routing/pages.dart';

// Inspired by: https://gist.github.com/johnpryan/5ce79aee5b5f83cfababa97c9cf0a204#gistcomment-3872855

enum AppRoute {
  notFound,
  home,
  productDetails,
  cart,
  checkout,
  pay,
  paymentComplete
}

// TODO: Replace with sealed union (Freezed?)
class AppRoutePath {
  AppRoutePath({required this.appRoute, required this.productId});
  AppRoutePath.notFound()
      : appRoute = AppRoute.notFound,
        productId = null;
  AppRoutePath.home()
      : appRoute = AppRoute.home,
        productId = null;
  AppRoutePath.details(this.productId) : appRoute = AppRoute.productDetails;
  AppRoutePath.cart()
      : appRoute = AppRoute.cart,
        productId = null;
  AppRoutePath.checkout()
      : appRoute = AppRoute.checkout,
        productId = null;
  AppRoutePath.pay()
      : appRoute = AppRoute.pay,
        productId = null;
  AppRoutePath.paymentComplete()
      : appRoute = AppRoute.paymentComplete,
        productId = null;

  final AppRoute appRoute;
  final String? productId;
}

class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);

    if (uri.pathSegments.isEmpty) {
      return AppRoutePath.home();
    }
    if (uri.pathSegments.length == 1) {
      switch (uri.pathSegments[0]) {
        case 'cart':
          return AppRoutePath.cart();
        case 'checkout':
          return AppRoutePath.checkout();
        case 'pay':
          return AppRoutePath.pay();
        case 'paymentComplete':
          return AppRoutePath.paymentComplete();
        default:
          return AppRoutePath.notFound();
      }
    }
    if (uri.pathSegments.length >= 2) {
      final productId = uri.pathSegments[1];
      return AppRoutePath.details(productId);
    }
    throw UnimplementedError();
  }

  @override
  RouteInformation? restoreRouteInformation(AppRoutePath configuration) {
    switch (configuration.appRoute) {
      case AppRoute.home:
        return const RouteInformation(location: '/');
      case AppRoute.productDetails:
        return RouteInformation(
            location: '/product/${configuration.productId!}');
      case AppRoute.cart:
        return const RouteInformation(location: '/cart');
      case AppRoute.checkout:
        return const RouteInformation(location: '/checkout');
      case AppRoute.pay:
        return const RouteInformation(location: '/pay');
      case AppRoute.paymentComplete:
        // TODO: append orderId
        return const RouteInformation(location: '/paymentComplete');
      default:
        return const RouteInformation(location: '/404');
    }
  }
}

abstract class BaseRouterDelegate extends RouterDelegate<AppRoutePath> {
  void openHome();
  void selectProduct(Product product);
  void openCart();
  void openCheckout();
  void openPay();
  void openPaymentComplete(Order order);
  // nice to call as:
  // context.go(cart)
  // context.go(checkout)
  // ...
  // would be nice to have sealed unions to pass data etc.
  // keep it like this for now
}

class AppRouterDelegate extends BaseRouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  AppRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  // These variables keep track of all the state needed to handle navigation
  AppRoute _appRoute = AppRoute.home;
  Product? _selectedProduct;
  Order? _latestOrder;

  // method handlers to update the navigation state
  @override
  void openHome() {
    _appRoute = AppRoute.home;
    _selectedProduct = null;
    _latestOrder = null;
    notifyListeners();
  }

  @override
  void selectProduct(Product product) {
    _appRoute = AppRoute.productDetails;
    _selectedProduct = product;
    notifyListeners();
  }

  @override
  void openCart() {
    _appRoute = AppRoute.cart;
    notifyListeners();
  }

  @override
  void openCheckout() {
    _appRoute = AppRoute.checkout;
    notifyListeners();
  }

  @override
  void openPay() {
    _appRoute = AppRoute.pay;
    notifyListeners();
  }

  @override
  void openPaymentComplete(Order order) {
    _appRoute = AppRoute.paymentComplete;
    _latestOrder = order;
    notifyListeners();
  }

  // given the state variables, return the current configuration
  @override
  AppRoutePath get currentConfiguration =>
      AppRoutePath(appRoute: _appRoute, productId: _selectedProduct?.id);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (_appRoute == AppRoute.notFound)
          const NotFoundPage()
        else
          const ProductListPage(),
        if (_selectedProduct != null)
          ProductDetailsPage(product: _selectedProduct!),
        if (_appRoute == AppRoute.cart) const ShoppingCartPage(),
        if (_appRoute == AppRoute.checkout) ...[
          const ShoppingCartPage(),
          const CheckoutPage(),
        ],
        if (_appRoute == AppRoute.pay) ...[
          const ShoppingCartPage(),
          const CheckoutPage(),
          const CardPaymentPage(),
        ],
        // note: payment complete removes the previous pages from the stack
        if (_appRoute == AppRoute.paymentComplete)
          PaymentCompletePage(order: _latestOrder!),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        switch (_appRoute) {
          case AppRoute.home:
            // cannot pop from home - do nothing
            break;
          case AppRoute.productDetails:
            _appRoute = AppRoute.home;
            _selectedProduct = null;
            notifyListeners();
            break;
          case AppRoute.cart:
            _appRoute = _selectedProduct != null
                ? AppRoute.productDetails
                : AppRoute.home;
            notifyListeners();
            break;
          case AppRoute.checkout:
            _appRoute = AppRoute.cart;
            notifyListeners();
            break;
          case AppRoute.pay:
            _appRoute = AppRoute.checkout;
            notifyListeners();
            break;
          case AppRoute.paymentComplete:
            _appRoute = AppRoute.home;
            _selectedProduct = null;
            _latestOrder = null;
            notifyListeners();
            break;
          case AppRoute.notFound:
            _appRoute = AppRoute.notFound;
            notifyListeners();
            break;
        }
        return true;
      },
    );
  }

  // given a configuration, update all the state variables
  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    _appRoute = configuration.appRoute;
    if (configuration.appRoute == AppRoute.productDetails) {
      _selectedProduct = findProduct(configuration.productId!);
    } else {
      _selectedProduct = null;
    }
    // TODO: Handle payment complete
  }
}

final routerDelegateProvider = Provider<BaseRouterDelegate>((ref) {
  return AppRouterDelegate();
});
