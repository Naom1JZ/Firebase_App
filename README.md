# Registro conectado: seguimiento de pedidos

## Datos del estudiante

La información personal del estudiante se mantiene fuera de este repositorio.

## Contexto

La aplicación administra el seguimiento de pedidos o entregas. Permite registrar pedidos, consultar su estado en tiempo real, actualizar el avance de una entrega y eliminar pedidos después de confirmar la acción.

## Colección y campos

La colección utilizada en Cloud Firestore es **`pedidos`**. Los documentos contienen:

| Campo | Tipo | Uso |
|---|---|---|
| `titulo` | `String` | Nombre visible del pedido; es obligatorio. |
| `descripcion` | `String` | Detalle del pedido o de la entrega; es obligatorio. |
| `estado` | `String` | Estado actual: `Recibido`, `En camino` o `Entregado`. |
| `fechaCreacion` | `Timestamp` | Fecha asignada con `FieldValue.serverTimestamp()`. |
| `autor` | `String` | Valor anónimo `2026`; no representa una identidad real. |
| `tipoEntrega` | `String` | Campo personal: `Domicilio`, `Punto de retiro` o `Envio express`. |

Los pedidos se consultan ordenados por `fechaCreacion` de forma descendente.

## Métodos del servicio

Las operaciones de Firestore están centralizadas en [lib/services/firestore_service.dart](lib/services/firestore_service.dart):

- `streamRegistros()`: escucha la colección `pedidos` en tiempo real.
- `crearRegistro(...)`: crea un pedido con estado inicial `Recibido` y fecha del servidor.
- `actualizarEstado(id, estado)`: actualiza el estado de una entrega.
- `eliminarRegistro(id)`: elimina un pedido confirmado por el usuario.

La aplicación muestra estados de carga, error, colección vacía y datos disponibles. El formulario valida los campos obligatorios y la pantalla principal reacciona automáticamente a los cambios de Firestore.

## Decisión personal

Se eligió `tipoEntrega` como campo personal porque influye directamente en la interfaz: cada tarjeta muestra si el pedido es a domicilio, para recoger en un punto o de envío express. Esta información ayuda a distinguir rápidamente la logística de cada pedido sin almacenar direcciones, teléfonos u otros datos personales.

## Firebase y ejecución

- Proyecto Firebase: se configura de forma local y no se publica en este repositorio.
- Configuración Android: `android/app/google-services.json`.
- Configuración FlutterFire: `lib/firebase_options.dart`.
- Dependencias adicionales permitidas: `firebase_core` y `cloud_firestore`.

Los archivos de configuración de Firebase están excluidos por `.gitignore` porque
contienen identificadores del proyecto y claves de cliente. Para ejecutar la
aplicación después de clonar el repositorio, agrega tus propios archivos locales
con FlutterFire CLI y configura el proyecto Firebase correspondiente.

Para ejecutar la aplicación en el emulador Android:

```powershell
flutter pub get
flutter run -d emulator-5554
```

Para la demostración, crea al menos cinco pedidos desde la aplicación, cambia el estado de uno, elimina otro con confirmación y verifica la colección `pedidos` en Firebase Console.

## Declaración de uso de IA

Se utilizó GitHub Copilot como herramienta de apoyo durante el desarrollo para proponer la estructura inicial del proyecto, generar ejemplos de código Flutter/Dart, revisar errores de configuración Firebase/Gradle y sugerir pruebas. La selección del contexto, los nombres de la colección y campos, la configuración del proyecto, la revisión de resultados y las pruebas finales fueron realizadas y verificadas por la estudiante.

No se almacenan contraseñas, identidades, teléfonos ni datos personales reales en Firestore.