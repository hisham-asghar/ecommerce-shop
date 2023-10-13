import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/routing/pages.dart';

// Inspired by: https://gist.github.com/johnpryan/5ce79aee5b5f83cfababa97c9cf0a204#gistcomment-3872855

enum AppRoute {
  notFound,
  home,
  productDetails,
  signIn,
  cart,
  checkout,
  pay,
  paymentComplete,
  ordersList,
  account,
  admin,
  adminOrders,
  adminProducts,
  adminProduct,
}

// TODO: Replace with sealed union (Freezed?)
class AppRoutePath {
  AppRoutePath(this.appRoute, {this.userProductId, this.adminProductId});

  final AppRoute appRoute;
  final String? userProductId;
  final String? adminProductId;
}

class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);

    if (uri.pathSegments.isEmpty) {
      return AppRoutePath(AppRoute.home);
    }
    if (uri.pathSegments.length == 1) {
      switch (uri.pathSegments[0]) {
        case 'cart':
          return AppRoutePath(AppRoute.cart);
        case 'checkout':
          return AppRoutePath(AppRoute.checkout);
        case 'signIn':
          return AppRoutePath(AppRoute.signIn);
        case 'pay':
          return AppRoutePath(AppRoute.pay);
        case 'paymentComplete':
          return AppRoutePath(AppRoute.paymentComplete);
        case 'account':
          return AppRoutePath(AppRoute.account);
        case 'admin':
          return AppRoutePath(AppRoute.admin);
        default:
          return AppRoutePath(AppRoute.notFound);
      }
    }
    if (uri.pathSegments.length >= 2) {
      switch (uri.pathSegments[0]) {
        case 'products':
          final productId = uri.pathSegments[1];
          return AppRoutePath(AppRoute.productDetails,
              userProductId: productId);
        case 'admin':
          switch (uri.pathSegments[1]) {
            case 'orders':
              return AppRoutePath(AppRoute.adminOrders);
            case 'products':
              if (uri.pathSegments.length >= 3) {
                final productId = uri.pathSegments[2];
                return AppRoutePath(AppRoute.adminProduct,
                    adminProductId: productId);
              } else {
                return AppRoutePath(AppRoute.adminProducts);
              }
            default:
              return AppRoutePath(AppRoute.notFound);
          }

        default:
          return AppRoutePath(AppRoute.notFound);
      }
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
            location: '/products/${configuration.userProductId!}');
      case AppRoute.signIn:
        return const RouteInformation(location: '/signIn');
      case AppRoute.cart:
        return const RouteInformation(location: '/cart');
      case AppRoute.checkout:
        return const RouteInformation(location: '/checkout');
      case AppRoute.pay:
        return const RouteInformation(location: '/pay');
      case AppRoute.paymentComplete:
        // TODO: append orderId
        return const RouteInformation(location: '/paymentComplete');
      case AppRoute.account:
        return const RouteInformation(location: '/account');
      case AppRoute.admin:
        return const RouteInformation(location: '/admin');
      case AppRoute.adminOrders:
        return const RouteInformation(location: '/admin/orders');
      case AppRoute.adminProducts:
        return const RouteInformation(location: '/admin/products');
      case AppRoute.adminProduct:
        return RouteInformation(
            location: configuration.adminProductId != null
                ? '/admin/products/${configuration.adminProductId}'
                : '/admin/products/new');
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
  void openOrdersList();
  void openAccount();
  void openAdmin();
  void openAdminOrders();
  void openAdminProducts();
  void openAdminProduct(Product? product);
  void openSignIn();
  // nice to call as:
  // context.go(cart)
  // context.go(checkout)
  // ...
  // would be nice to have sealed unions to pass data etc.
  // keep it like this for now
}

class AppRouterDelegate extends BaseRouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  AppRouterDelegate({required this.productsRepository})
      : navigatorKey = GlobalKey<NavigatorState>();

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final ProductsRepository productsRepository;

  // These variables keep track of all the state needed to handle navigation
  AppRoute _appRoute = AppRoute.home;
  String? _selectedUserProductId;
  String? _selectedAdminProductId;
  Order? _latestOrder;

  // method handlers to update the navigation state
  @override
  void openHome() {
    _appRoute = AppRoute.home;
    _selectedUserProductId = null;
    _selectedAdminProductId = null;
    _latestOrder = null;
    notifyListeners();
  }

  @override
  void selectProduct(Product product) {
    _appRoute = AppRoute.productDetails;
    _selectedUserProductId = product.id;
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

  @override
  void openOrdersList() {
    _appRoute = AppRoute.ordersList;
    notifyListeners();
  }

  @override
  void openAccount() {
    _appRoute = AppRoute.account;
    notifyListeners();
  }

  @override
  void openAdmin() {
    _appRoute = AppRoute.admin;
    _selectedAdminProductId = null;
    notifyListeners();
  }

  @override
  void openAdminOrders() {
    _appRoute = AppRoute.adminOrders;
    notifyListeners();
  }

  @override
  void openAdminProducts() {
    _appRoute = AppRoute.adminProducts;
    notifyListeners();
  }

  @override
  void openAdminProduct(Product? product) {
    _appRoute = AppRoute.adminProduct;
    _selectedAdminProductId = product?.id;
    notifyListeners();
  }

  @override
  void openSignIn() {
    _appRoute = AppRoute.signIn;
    notifyListeners();
  }

  // given the state variables, return the current configuration
  @override
  AppRoutePath get currentConfiguration => AppRoutePath(
        _appRoute,
        userProductId: _selectedUserProductId,
        adminProductId: _selectedAdminProductId,
      );

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (_appRoute == AppRoute.notFound)
          const NotFoundPage()
        else
          const ProductListPage(),
        if (_selectedUserProductId != null)
          ProductDetailsPage(productId: _selectedUserProductId!),
        if (_appRoute == AppRoute.signIn) const EmailPasswordSignInPage(),
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
        if (_appRoute == AppRoute.ordersList) const OrdersListPage(),
        if (_appRoute == AppRoute.account) const AccountPage(),
        if (_appRoute == AppRoute.admin) const AdminPage(),
        if (_appRoute == AppRoute.adminOrders) ...[
          const AdminPage(),
          const AdminOrdersPage(),
        ],
        if (_appRoute == AppRoute.adminProducts) ...[
          const AdminPage(),
          const AdminProductsPage(),
        ],
        if (_appRoute == AppRoute.adminProduct) ...[
          const AdminPage(),
          const AdminProductsPage(),
          AdminProductDetailsPage(productId: _selectedAdminProductId),
        ],
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
            _selectedUserProductId = null;
            notifyListeners();
            break;
          case AppRoute.signIn:
          case AppRoute.cart:
          case AppRoute.ordersList:
          case AppRoute.account:
          case AppRoute.admin:
            _appRoute = _selectedUserProductId != null
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
            _selectedUserProductId = null;
            _latestOrder = null;
            notifyListeners();
            break;
          case AppRoute.adminOrders:
          case AppRoute.adminProducts:
            _appRoute = AppRoute.admin;
            _selectedAdminProductId = null;
            notifyListeners();
            break;
          case AppRoute.adminProduct:
            _appRoute = AppRoute.adminProducts;
            _selectedAdminProductId = null;
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
    // TODO: Defensive code to prevent navigation to pages that require certain objects to be set
    _appRoute = configuration.appRoute;
    if (configuration.appRoute == AppRoute.productDetails) {
      _selectedUserProductId = configuration.userProductId;
    } else {
      _selectedUserProductId = null;
    }
    if (configuration.appRoute == AppRoute.adminProduct) {
      _selectedAdminProductId = configuration.adminProductId;
    } else {
      _selectedAdminProductId = null;
    }
    // TODO: Handle payment complete
  }
}

final routerDelegateProvider = Provider<BaseRouterDelegate>((ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return AppRouterDelegate(productsRepository: productsRepository);
});
