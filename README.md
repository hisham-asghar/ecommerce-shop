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


### LICENSE: MIT