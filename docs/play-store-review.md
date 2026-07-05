# Play Store review notes

Use these notes to complete the Play Console review fields. Do not commit the
reviewer password or private API keys to this repository.

## App access

The app can be browsed as guest, but checkout, favorites, profile and order
history require login. Provide the reviewer account in Play Console > App
content > App access.

- Login screen: choose "Iniciar sesion".
- Email: reviewer account created in Firebase Auth.
- Password: store only in Play Console App access notes.

Suggested review steps:

1. Sign in with the reviewer account.
2. Open Inicio or Buscar and inspect the product catalog.
3. Add a product to favorites.
4. Open a product detail, choose size/color and add it to cart.
5. Go to Carrito, enter a delivery address and confirm the demo checkout.
6. Confirm the order appears in Historial de pedidos.
7. Open Casona AI and ask for an outfit recommendation.

## Payments

La Casona uses Stripe in test mode for an educational/demo ecommerce flow. No
real money is charged. Payment-related private keys are stored in Firebase
Functions secrets, not in the Flutter app bundle.

## User data

The app uses Firebase Authentication and Firestore for account, cart, favorites
and order data. SendGrid sends purchase confirmation emails. Gemini powers the
fashion assistant through Firebase Functions.

## Permissions

Camera access is used only for visual product search. Biometric authentication
is optional and stores login preference locally on the device.
