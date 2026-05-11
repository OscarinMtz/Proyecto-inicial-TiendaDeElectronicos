actua como administrador de base de datos  de proyecto tienda de electronicos , que entidade se necesitan para su gestion

<img width="513" height="389" alt="image" src="https://github.com/user-attachments/assets/74ce554b-096d-40aa-a4c7-70b40949e639" />

Como administrador de base de datos para una tienda de electrónicos, aquí están las entidades esenciales para una gestión completa:El modelo se organiza en 5 dominios funcionales:

**Catálogo de productos**
`CATEGORIA` → `PRODUCTO` → `VARIANTE_PRODUCTO`: un producto como "iPhone 16" puede tener variantes de color y almacenamiento, cada una con su propio precio y código de barras.

**Inventario y logística interna**
`INVENTARIO` relaciona cada variante con un `ALMACEN`. Permite stock por ubicación, alertas de stock mínimo y trazabilidad por sucursal o bodega.

**Ventas y clientes**
`CLIENTE` → `PEDIDO` → `DETALLE_PEDIDO` → `VARIANTE_PRODUCTO`. El detalle guarda precio y descuento al momento de la compra (histórico inmutable).

**Pagos y envíos**
`PAGO` y `ENVIO` se asocian 1-a-1 con el pedido, separados para soportar pagos diferidos, múltiples métodos y tracking de transportistas.

**Compras a proveedores**
`PROVEEDOR` → `ORDEN_COMPRA` → `DETALLE_COMPRA`: permite gestionar reabastecimiento, historial de precios de compra y relaciones con múltiples proveedores por producto.

**Entidad de soporte operativo**
`EMPLEADO` se enlaza a los pedidos para auditoría de ventas, comisiones y control de acceso por rol.

¿Quieres que desarrolle los scripts DDL en SQL, agregue entidades adicionales como garantías, devoluciones o reseñas, o diseñe los índices recomendados para este modelo?


las entidades con sus atributos y tipo en forma de tabla  para cada una de las entidades

<img width="533" height="545" alt="image" src="https://github.com/user-attachments/assets/2050270b-50de-4f52-bad4-b2d42029da3e" />
<img width="558" height="579" alt="image" src="https://github.com/user-attachments/assets/0d7ae9a5-d70e-4bff-8831-058d81962b2d" />
<img width="542" height="538" alt="image" src="https://github.com/user-attachments/assets/25b19fad-a6b5-47f5-9ea9-450d9558f0ee" />
<img width="523" height="471" alt="image" src="https://github.com/user-attachments/assets/0b7c1e4b-7c8b-4c8f-9578-43444e5fccf9" />
<img width="514" height="513" alt="image" src="https://github.com/user-attachments/assets/9020cf8c-9a02-4f22-834b-d5b27bf2a015" />

de acuerdo con tu respuesta anterior puedes generar un script en sql para descargar con el nombre de bdelectronicos.sql para las entidades con sus relaciones

El script está listo para descargar. Incluye todo lo siguiente:

**Estructura (DDL)**
- `CREATE DATABASE` con charset `utf8mb4`
- 11 tablas con sus tipos de datos, restricciones `NOT NULL`, `UNIQUE`, `CHECK` y valores `DEFAULT`
- 13 claves foráneas con sus reglas `ON UPDATE CASCADE` y `ON DELETE` correspondientes
- 10 índices en columnas de búsqueda frecuente (marca, fecha, estado, cliente, etc.)

**Datos de prueba (seed)**
- 4 empleados, 3 proveedores, 5 categorías con jerarquía
- 3 almacenes, 4 productos, 7 variantes, 9 registros de inventario
- 3 clientes de ejemplo

**Para ejecutarlo** en MySQL:
```bash
mysql -u root -p < bdelectronicos.sql
```
o desde MySQL Workbench con `File → Open SQL Script`.


¿Quieres que agregue también datos de pedidos de prueba, vistas, procedimientos almacenados o triggers (por ejemplo, para actualizar el stock automáticamente al confirmar un pedido)?
