📦 Plan de Implementación: Aplicación "ElectroAdmin" (Gestión Multiplataforma para Tienda de Electrónicos)

🛠️ 1. Preparación del Entorno y Configuración Inicial
Instalación de SDK y Herramientas
• Instalar Flutter SDK estable y verificar compatibilidad con canales Android, iOS, Web y Windows.
• Configurar variables de entorno y rutas de compilación.
• Instalar VS Code con extensiones oficiales: Flutter, Dart, Firebase, GitLens, Pubspec Assist, Error Lens.
• Configurar Firebase Console y crear el proyecto `BDcrudElectronicos`.
• Habilitar Firebase Authentication (Email/Password) y Cloud Firestore (modo prueba inicial, con reglas escalables).
• Instalar Firebase CLI y FlutterFire CLI; ejecutar vinculación al proyecto `BDcrudElectronicos` para generar configuraciones por plataforma.
Control de Versiones
• Inicializar repositorio Git con `.gitignore` oficial para Flutter.
• Definir ramas: `main`, `develop`, `feature/*`.
• Excluir credenciales locales y archivos sensibles.

📦 2. Gestión de Dependencias (pubspec.yaml)
Se organizarán las librerías por categoría funcional. Se priorizará la compatibilidad con el canal estable de Flutter.

| Categoría | Paquetes Requeridos | Función |
|---|---|---|
| Núcleo Firebase | firebase_core, firebase_auth, cloud_firestore | Conexión, autenticación y base de datos |
| Estado Global | provider | Gestión reactiva de UI y lógica de negocio |
| Enrutamiento | go_router | Navegación declarativa, protección de rutas, deep links |
| UI/Componentes | cached_network_image, flutter_staggered_grid_view, shimmer, google_fonts, intl | Carga de imágenes, layouts dinámicos, estados de carga, tipografía, formatos de fecha/moneda |
| Utilidades | uuid, equatable, logger, flutter_form_builder | Generación de IDs, comparación de objetos, logs, validación de formularios |
| Plataforma/Build | flutter_launcher_icons, flutter_native_splash, lints, flutter_secure_storage | Iconos, splash, análisis estático, almacenamiento seguro |

✅ Procedimiento: Declarar dependencias, ejecutar actualización, validar compatibilidad cruzada y aplicar formateo automático.

🎨 3. Sistema de Diseño UI/UX (Gris y Azul Profesional)

**Paleta de Colores**
• Fondo principal: gris muy claro casi blanco (#F8F9FA) para reducir fatiga visual en sesiones largas de administración.
• Color primario: azul corporativo sólido (#2563EB) para botones de acción principal, enlaces y elementos interactivos clave.
• Color secundario: gris medio-azulado (#64748B) para bordes, íconos secundarios, textos de apoyo y selecciones neutras.
• Estados: azul verdoso suave (éxito/stock disponible), rojo grisáceo (alertas/stock bajo), gris neutro (deshabilitado/inactivo).
• Acentos: azul claro (#DBEAFE) para fondos de tarjetas seleccionadas o filas destacadas en tablas.
• Garantizar contraste WCAG AA para textos sobre fondos grises y azules, especialmente en pantallas de inventario y reportes financieros.

**Tipografía y Espaciado**
• Fuente: familia sans-serif moderna y legible (ej. Inter, Roboto o Segoe UI) con pesos ligero (300), regular (400) y semibold (600) para jerarquía visual clara.
• Escala tipográfica consistente: títulos de módulo (24px), subtítulos de sección (18px), cuerpo de tablas y formularios (14-16px), etiquetas técnicas y SKU (12-13px).
• Sistema de espaciado base en múltiplos de 8px para coherencia en grillas de productos, tablas de datos y formularios de pedido.

**Componentes de Interfaz**
• Tarjetas de producto/variante con bordes redondeados (8-12px), sombras sutiles en gris azulado y efecto hover con elevación suave (web/desktop).
• Campos de entrada con etiquetas flotantes en azul, bordes que cambian de gris a azul al enfocar, y validación visual en tiempo real (SKU, formato telefónico, DNIs).
• Tablas responsivas con encabezados fijos en azul oscuro, filas con hover en gris claro, ordenamiento por columna y filtros avanzados desplegables.
• Diálogos modales con borde superior azul para confirmación de movimientos de stock, aplicación de descuentos y registro de envíos.
• Indicadores shimmer en gris azulado y barras de progreso circulares en azul para sincronización de inventario y carga de catálogos.
• Badges de estado con fondo azul claro y texto azul oscuro para estados de pedido (Pendiente, Pagado, Enviado, Cancelado).

**Layout Administrativo**
• Barra lateral colapsable en gris oscuro con íconos en azul claro y texto blanco; acceso rápido a: Categorías, Productos, Variantes, Inventario/Almacenes, Empleados, Clientes, Pedidos, Pagos, Envíos, Proveedores y Órdenes de Compra.
• Barra superior en blanco con borde inferior gris suave, conteniendo búsqueda global (por SKU, nombre, cliente o pedido), notificaciones de stock mínimo en azul/rojo, y perfil de usuario con avatar.
• Área central dinámica con fondo gris muy claro que alterna entre vistas de lista (móvil) y paneles tipo grid/tabla (escritorio), con contenedores blancos para contenido principal.
• Breadcrumbs en gris medio para navegación jerárquica dentro de módulos complejos (ej. Producto > Variante > Inventario por almacén).

🗄️ 4. Arquitectura de Base de Datos (Esquema Relacional Adaptado)
Modelo de Colecciones/Tablas
Se estructurarán los datos siguiendo estrictamente el esquema proporcionado, mapeado a documentos Firestore con referencias cruzadas para mantener integridad relacional:
• `CATEGORIA`: id_categoria, nombre, descripcion
• `PRODUCTO`: id_producto, id_categoria, nombre, marca, descripcion_general
• `VARIANTE_PRODUCTO`: id_variante, id_producto, sku, color, almacenamiento, precio_base
• `ALMACEN`: id_almacen, nombre_sucursal, ubicacion
• `INVENTARIO`: id_inventario, id_variante, id_almacen, stock_actual, stock_minimo, ultima_actualizacion
• `EMPLEADO`: id_empleado, nombre, rol (Admin/Vendedor/Almacenista), email, comision_pct
• `CLIENTE`: id_cliente, nombre_completo, dni_tax_id, telefono
• `PEDIDO`: id_pedido, id_cliente, id_empleado, fecha_pedido, estado_pedido, total_neto
• `DETALLE_PEDIDO`: id_detalle, id_pedido, id_variante, cantidad, precio_unitario_historico, descuento_aplicado
• `PAGO`: id_pago, id_pedido, metodo_pago, monto_pagado, fecha_pago
• `ENVIO`: id_envio, id_pedido, transportista, numero_seguimiento, fecha_estimada
• `PROVEEDOR`: id_proveedor, nombre_empresa, contacto_nombre, email
• `ORDEN_COMPRA`: id_orden_compra, id_proveedor, fecha_emision, total_costo
• `DETALLE_COMPRA`: id_detalle_compra, id_orden_compra, id_variante, cantidad, costo_unitario

Relaciones y Referencias
• Se utilizarán `DocumentReference` o IDs explícitos para mantener vínculos (ej. `id_categoria` en PRODUCTO, `id_variante` en DETALLE_PEDIDO).
• Los joins se resolverán en el cliente mediante streams o consultas anidadas para optimizar lecturas.
• `INVENTARIO` se normalizará por combinación `id_variante + id_almacen` para evitar duplicados y permitir stock multi-sucursal.

Índices y Consultas
• Índices compuestos para: (estado_pedido + fecha_pedido), (id_almacen + stock_actual < stock_minimo), (id_proveedor + fecha_emision).
• Paginación por cursor en listados extensos (catálogos, historial de pedidos, órdenes de compra).

Reglas de Seguridad
• Restricción por rol: Almacenista solo lectura/edición en INVENTARIO; Vendedor acceso a CLIENTE, PEDIDO, PAGO; Admin acceso total.
• Validación de tipos: precios como `Decimal`, cantidades como `Integer >= 0`, fechas en formato ISO.
• Acceso público deshabilitado en producción; auditoría de cambios opcional mediante campos `updatedAt` y `updatedBy`.

Persistencia Offline
• Caché nativo de Firestore habilitado para operar sin conexión en registro de ventas y consultas de stock, con sincronización automática al recuperar red.

🔐 5. Flujo de Autenticación
Pantallas Iniciales
• Inicio de sesión: email y contraseña, validación en tiempo real, enlace a recuperación.
• Registro: datos básicos de empleado, selección de rol, confirmación de credenciales.
• Recuperación: flujo de verificación por email, redirección segura al login.
Gestión de Sesión
• Listener de estado de auth para redirección automática.
• Persistencia de sesión entre reinicios; cierre seguro con limpieza de caché local.
Validación y Seguridad
• Bloqueo de UI durante peticiones.
• Límite de intentos y mensajes de error accionables.

🏗️ 6. Estructura de Archivos y Organización
• `lib/core/` → Tema global, constantes, enrutador, configuraciones Firebase.
• `lib/data/models/` → Clases mapeadas a cada entidad (Categoria, Producto, VarianteProducto, Almacen, Inventario, Empleado, Cliente, Pedido, DetallePedido, Pago, Envio, Proveedor, OrdenCompra, DetalleCompra).
• `lib/data/repositories/` → Acceso a Firestore con métodos CRUD aislados por módulo.
• `lib/data/services/` → Lógica de negocio: cálculo de totales, validación de stock, formateo de precios/fechas, aplicación de descuentos.
• `lib/presentation/providers/` → Gestores de estado por módulo.
• `lib/presentation/screens/` → Vistas organizadas por funcionalidad.
• `lib/presentation/widgets/` → Componentes reutilizables (tablas de inventario, selectores de variante, formularios de pedido, diálogos de confirmación).
• `assets/` → Imágenes, iconos, tipografías, configuraciones de splash.
• `test/` → Pruebas unitarias y de integración por módulo.

🔄 7. Estrategia CRUD por Módulo
| Módulo | Funcionalidades Clave | Consideraciones Específicas |
|---|---|---|
| Categorías | Listado, alta, edición, baja lógica | Catálogo maestro, validación de nombre único |
| Productos | Listado con filtros por categoría/marca, alta/edición | Relación con CATEGORIA, descripción técnica estructurada |
| Variantes | Gestión por SKU, color, almacenamiento, precio base | Validación de SKU único, cálculo automático de variantes por producto |
| Almacenes e Inventario | Registro de sucursales, control de stock actual/mínimo | Actualización en tiempo real, alertas automáticas al cruzar stock mínimo |
| Empleados | Alta, edición, asignación de rol y comisión | Restricción de permisos según `rol`, vinculación a pedidos |
| Clientes | Registro, búsqueda por nombre o DNI, historial | Validación de `dni_tax_id` único, contacto estructurado |
| Pedidos | Creación, cambio de estado, historial inmutable | Cálculo de `total_neto`, asignación de cliente y vendedor, validación de disponibilidad |
| Detalle Pedido | Integrado en flujo de venta | Congelamiento de `precio_unitario_historico`, aplicación de `descuento_aplicado`, validación de stock al agregar |
| Pagos | Registro vinculado a pedido, listado por método/fecha | Validación `monto_pagado` vs `total_neto`, métodos predefinidos, fecha automática |
| Envíos | Asignación de transportista, seguimiento, fecha estimada | Relación 1:1 con pedido, actualización de estado de envío |
| Proveedores | Registro de empresa y contacto, historial de órdenes | Validación de email empresarial, vinculación a compras |
| Órdenes de Compra | Emisión, cálculo de `total_costo`, recepción | Integración con DETALLE_COMPRA para actualizar inventario al recibir mercancía |
| Detalle Compra | Listado de ítems por orden de compra | Registro de `costo_unitario` para análisis de margen, vinculación a variante |

Patrón de Flujo: Repositorio → Proveedor → Pantalla Lista → Pantalla Formulario → Confirmación → Actualización de Estado.
Transacciones: Uso de lotes/transacciones para movimientos de stock y creación de pedidos+detalles+pagos, garantizando atomicidad.
Paginación y Búsqueda: Carga progresiva y filtros combinados (texto, fecha, estado, categoría, SKU, almacén).

📱 8. Adaptación Multiplataforma (Android / iOS / Web / Windows)
Android e iOS
• Navegación por drawer o pestañas inferiores.
• Gestos táctiles optimizados, áreas de toque estándar para escaneo visual de SKU y selección de variantes.
Web
• Layout tipo panel administrativo con sidebar fijo y tablas expandibles.
• Soporte completo de teclado (tabulación, atajos para guardar/búsqueda).
• Tooltips informativos en campos técnicos (SKU, márgenes, comisiones).
Windows
• Ventana redimensionable con paneles anclables.
• Exportación de reportes de inventario, ventas y órdenes de compra (PDF/CSV).
• Menú contextual y teclas de acceso rápido para flujo ágil de caja.
Estrategia de Responsividad
• Detección en tiempo de ejecución de plataforma y tamaño.
• Alternancia automática entre listas verticales (móvil) y grids/tablas (escritorio).
• Ajuste de densidad de información sin comprometer legibilidad en pantallas de punto de venta.

🚀 9. Fases de Desarrollo (Paso a Paso)
| Fase | Objetivo | Entregables |
|---|---|---|
| 1. Cimientos | Configuración proyecto, Firebase `BDcrudElectronicos`, dependencias, tema base | Repo inicial, vinculación Firebase, `pubspec.yaml` validado, paleta aplicada |
| 2. Autenticación y Routing | Login, registro, recuperación, protección de rutas | Flujo auth completo, redirección por rol, manejo de errores |
| 3. Módulos Maestros | CRUD Categorías, Productos, Variantes, Proveedores, Almacenes | Pantallas lista/formulario, repositorios, validaciones de SKU y stock mínimo |
| 4. Gestión de Personas | CRUD Empleados y Clientes, roles y permisos | Dropdowns vinculados, filtros avanzados, persistencia de sesiones |
| 5. Flujo Comercial | Pedidos, Detalles, Pagos, Envíos, Transacciones atómicas | Cálculo de totales, congelamiento de precios históricos, registro de pagos y seguimientos |
| 6. Abastecimiento | Órdenes de Compra y Detalle de Compra | Control de costos, vinculación a proveedores, actualización de inventario post-recepción |
| 7. UX y Multiplataforma | Adaptación de layouts, estados de carga/error, accesibilidad | Sidebar responsive, contrastes WCAG, atajos de escritorio, optimización web |
| 8. Pruebas y Seguridad | Validación de reglas Firestore, pruebas unitarias, profiling offline | Reglas en modo estricto, cobertura de flujos críticos, builds estables |
| 9. Empaquetado y Release | Generación de builds por plataforma, documentación | .aab, .ipa, ejecutable Windows, build Web estático, guía de despliegue |

✅ 10. Checklist de Validación Final
• Autenticación funcional con persistencia, recuperación de contraseña y asignación de rol
• CRUD completo y estable para las 14 entidades del esquema de electrónicos
• Relaciones operativas: Producto-Categoría, Variante-Inventario, Pedido-Detalle-Pago-Envio, OrdenCompra-DetalleCompra-Proveedor
• UI coherente con paleta lila y rosa pastel, accesible y adaptada a entornos técnicos/comerciales
• Layout responsivo y nativo para Android, iOS, Web y Windows
• Reglas de Firestore aplicadas y validadas contra accesos no autorizados por rol
• Estados de carga, error y vacío implementados en todas las vistas de stock y ventas
• Paginación y búsqueda optimizadas para catálogos grandes y historiales extensos
• Builds generados sin warnings críticos y con análisis estático aprobado
• Documentación de arquitectura, flujo de datos de inventario/ventas y despliegue actualizada

📝 Notas Técnicas Importantes
• Estructura `lib/` vs `bin/`: Flutter compila exclusivamente `lib/`. Se recomienda mantener toda la lógica Dart dentro de esta carpeta siguiendo la arquitectura propuesta para garantizar compilación multiplataforma sin errores.
• Escalabilidad: El plan utiliza arquitectura por características (feature-based), permitiendo añadir módulos como reportes de margen, integración con lectores de códigos de barras o facturación electrónica sin reestructurar el núcleo.
• Integridad de Datos: Los campos históricos (`precio_unitario_historico`, `ultima_actualizacion`, `fecha_estimada`) se manejarán como inmutables tras su creación para garantizar auditoría precisa de ventas y movimientos de stock.
• Mantenimiento: Se sugiere implementar logs de auditoría (quién modificó stock, aprobó descuentos o cambió estados de pedido) como capa opcional posterior, almacenando metadatos en cada documento/registro.


## prompt 

Genera un plan de implementación técnico y estructurado para una aplicación de administración multiplataforma (Android, iOS, Web, Windows) desarrollada en Flutter con Dart, enfocada en una tienda de electrónicos. El proyecto se conectará a Firebase (Authentication y Cloud Firestore) y utilizará un esquema de datos basado en las siguientes tablas relacionales: CATEGORIA, PRODUCTO, VARIANTE_PRODUCTO, ALMACEN, INVENTARIO, EMPLEADO, CLIENTE, PEDIDO, DETALLE_PEDIDO, PAGO, ENVIO, PROVEEDOR, ORDEN_COMPRA y DETALLE_COMPRA (con sus respectivos campos e relaciones). La aplicación debe iniciar con un flujo de autenticación completo (login, registro, recuperación) y luego dar acceso a un CRUD moderno para cada entidad. La interfaz debe usar una paleta de colores lilas y rosas pasteles, con componentes atractivos, responsivos y adaptables a cada plataforma. Organiza la respuesta en secciones claras: preparación, dependencias, diseño UI/UX, arquitectura de datos (mapeando las tablas proporcionadas), autenticación, estructura de archivos, estrategia CRUD por módulo, adaptación multiplataforma, fases de desarrollo y checklist final. NO incluyas código fuente en la respuesta. Mantén un formato profesional, con tablas y listas donde sea necesario, y asegura que todo el contenido esté alineado exclusivamente con la gestión de una tienda de electrónicos según el esquema indicado.
