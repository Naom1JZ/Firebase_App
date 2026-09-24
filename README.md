# Seguimiento de pedidos

Aplicación Flutter conectada a Cloud Firestore para administrar pedidos o
entregas. Permite crear registros, consultar cambios en tiempo real, actualizar
su estado (`Recibido`, `En camino` o `Entregado`) y eliminarlos después de una
confirmación.

Las operaciones de Firestore están centralizadas en
[lib/services/firestore_service.dart](lib/services/firestore_service.dart), y
la colección utilizada es `pedidos`.

La configuración de Firebase se mantiene local y está excluida de Git para no
publicar identificadores del proyecto ni claves de cliente. Para ejecutar la
aplicación, agrega tus propios archivos de configuración de Firebase y usa:

```powershell
flutter pub get
flutter run
```