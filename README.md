# Order Tracking

A Flutter application connected to Cloud Firestore for managing orders and
deliveries. It allows users to create records, view real-time changes, update
their status (`Received`, `In transit`, or `Delivered`), and delete them after
confirmation.

Firestore operations are centralized in
[lib/services/firestore_service.dart](lib/services/firestore_service.dart),
and the collection used is `pedidos`.

Firebase configuration is kept local and excluded from Git to avoid publishing
project identifiers or client keys. To run the application, add your own
Firebase configuration files and use:

```powershell
flutter pub get
flutter run
```
