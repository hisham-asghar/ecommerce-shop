# Flutter eCommerce Template

This is a reference implementation of a full-stack eCommerce app using Flutter & Firebase.

## Supported Features

- Products List
- Product Page + Add to Cart
- Shopping Cart (update quantity, delete items, show total price)
- Checkout Flow
  - Sign in/register
  - Address details
  - Confirmation
- Purchase flow with Stripe integration (TBC)
- Order History
- User Authentication
- Admin Section
  - Manage products
    - Add / edit products
    - Set stock level
  - Manage orders
    - Set order status (confirmed / shipped / delivered)
- Responsive UI

### Packages

- Riverpod for state management
- Stripe for payments

See `pubspec.yaml` for full list of packages.

### Backend

The backend uses the following Firebase services:

- Authentication
- Cloud Firestore
- Cloud Functions

## Future Roadmap

- Improve test coverage
- Stripe Integration on mobile and web
- Pagination for products list
- Product reviews/ratings

## Architecture

The Flutter client app uses Riverpod for state management and introduces four application layers:

- services
- repositories
- widget state/model classes
- widgets

As a general rule, **each layer can only access the layers above**.

Navigator 2.0 is used for routing. Planning to migrate to `go_router`.

### Project structure

The project folders are organized **by feature**:

- Each feature contains widgets and their state/model classes (if needed)
- Complex features can have sub-folders containing smaller features
- Repositories and services live in the top-level folder (`lib/src`)

## Stripe payment workflow

When the user clicks on the "Pay" button in the app, `CheckoutService.pay()` is called.

In turn, the `createOrderPaymentIntent` cloud function is called, which:

- checks if all items are in stock and calculates the cart total
- finds or creates a Stripe customer for the user `uid` (this also 
- writes a document into `customers/${customerId}` with the `uid` of the user so that later on we can do a reverse-lookup
- creates a payment intent (`createPaymentIntent`), which returns the necessary data to the client

Next, the payment sheet is initialized and presented in two stages:

1. the user address is retrieved and used to initialize the payment sheet (via `StripeRepository.initPaymentSheet()`)
2. `presentPaymentSheet()` is called

At this point, the payment sheet UI is presented and the user can make the payment.

If `payment_intent.succeeded` is received, `fullfillOrder` is called, which in turn:

- retrieves the user `uid` with a reverse-lookup in `customers/${customerId}`
- copies all the cart items into an array and removes them from the cart
- creates an order document with all the details in  `users/${uid}/orders/${orderId}`
- deletes the cart document

As a result, the user can see the new order appear in the list of orders in the app

### TODO

- store the `lastOrderId` in `customers/${customerId}`


### LICENSE: MIT