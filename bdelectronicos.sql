-- ============================================================
--  BASE DE DATOS: Tienda de Electrónicos
--  Archivo   : bdelectronicos.sql
--  Motor     : MySQL 8.0+
--  Encoding  : UTF-8
--  Creado    : 2026-05-11
-- ============================================================

CREATE DATABASE IF NOT EXISTS bdelectronicos
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE bdelectronicos;

-- ------------------------------------------------------------
-- Desactivar verificación de claves foráneas durante la carga
-- ------------------------------------------------------------
SET FOREIGN_KEY_CHECKS = 0;


-- ============================================================
--  DOMINIO: Recursos Humanos
-- ============================================================

CREATE TABLE empleado (
    id_empleado   INT            NOT NULL AUTO_INCREMENT,
    nombre        VARCHAR(100)   NOT NULL,
    apellido      VARCHAR(100)   NOT NULL,
    email         VARCHAR(150)   NOT NULL,
    telefono      VARCHAR(20)    NULL,
    rol           ENUM('admin','vendedor','almacenista','gerente') NOT NULL DEFAULT 'vendedor',
    salario       DECIMAL(10,2)  NULL,
    fecha_ingreso DATE           NOT NULL,
    activo        BOOLEAN        NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_empleado PRIMARY KEY (id_empleado),
    CONSTRAINT uq_empleado_email UNIQUE (email)
) ENGINE=InnoDB COMMENT='Personal de la tienda';


-- ============================================================
--  DOMINIO: Proveedores y Compras
-- ============================================================

CREATE TABLE proveedor (
    id_proveedor  INT            NOT NULL AUTO_INCREMENT,
    nombre        VARCHAR(120)   NOT NULL,
    contacto      VARCHAR(100)   NULL,
    email         VARCHAR(150)   NOT NULL,
    telefono      VARCHAR(20)    NULL,
    pais          VARCHAR(60)    NOT NULL,
    ciudad        VARCHAR(80)    NULL,
    rfc           VARCHAR(20)    NULL,
    activo        BOOLEAN        NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_proveedor PRIMARY KEY (id_proveedor)
) ENGINE=InnoDB COMMENT='Empresas proveedoras de mercancía';


-- ============================================================
--  DOMINIO: Catálogo de Productos
-- ============================================================

CREATE TABLE categoria (
    id_categoria  INT            NOT NULL AUTO_INCREMENT,
    nombre        VARCHAR(80)    NOT NULL,
    descripcion   TEXT           NULL,
    id_padre      INT            NULL,
    activa        BOOLEAN        NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_categoria  PRIMARY KEY (id_categoria),
    CONSTRAINT fk_cat_padre  FOREIGN KEY (id_padre)
        REFERENCES categoria (id_categoria)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='Jerarquía de categorías (auto-referencia para subcategorías)';


CREATE TABLE producto (
    id_producto   INT            NOT NULL AUTO_INCREMENT,
    sku           VARCHAR(50)    NOT NULL,
    nombre        VARCHAR(150)   NOT NULL,
    descripcion   TEXT           NULL,
    marca         VARCHAR(80)    NOT NULL,
    modelo        VARCHAR(80)    NULL,
    precio_base   DECIMAL(10,2)  NOT NULL,
    id_categoria  INT            NOT NULL,
    id_proveedor  INT            NULL,
    activo        BOOLEAN        NOT NULL DEFAULT TRUE,
    fecha_alta    DATE           NOT NULL,
    CONSTRAINT pk_producto       PRIMARY KEY (id_producto),
    CONSTRAINT uq_producto_sku   UNIQUE (sku),
    CONSTRAINT fk_prod_categoria FOREIGN KEY (id_categoria)
        REFERENCES categoria (id_categoria)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_prod_proveedor FOREIGN KEY (id_proveedor)
        REFERENCES proveedor (id_proveedor)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='Productos del catálogo general';


CREATE TABLE variante_producto (
    id_variante   INT            NOT NULL AUTO_INCREMENT,
    id_producto   INT            NOT NULL,
    color         VARCHAR(40)    NULL,
    almacenamiento VARCHAR(20)   NULL,
    ram           VARCHAR(20)    NULL,
    precio        DECIMAL(10,2)  NOT NULL,
    codigo_barras VARCHAR(50)    NULL,
    imagen_url    VARCHAR(255)   NULL,
    activa        BOOLEAN        NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_variante        PRIMARY KEY (id_variante),
    CONSTRAINT uq_variante_barras UNIQUE (codigo_barras),
    CONSTRAINT fk_var_producto    FOREIGN KEY (id_producto)
        REFERENCES producto (id_producto)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='Variantes específicas de cada producto (color, capacidad, etc.)';


-- ============================================================
--  DOMINIO: Inventario y Almacén
-- ============================================================

CREATE TABLE almacen (
    id_almacen  INT            NOT NULL AUTO_INCREMENT,
    nombre      VARCHAR(100)   NOT NULL,
    direccion   VARCHAR(200)   NOT NULL,
    ciudad      VARCHAR(80)    NOT NULL,
    estado      VARCHAR(80)    NULL,
    telefono    VARCHAR(20)    NULL,
    activo      BOOLEAN        NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_almacen PRIMARY KEY (id_almacen)
) ENGINE=InnoDB COMMENT='Sucursales o bodegas de almacenamiento';


CREATE TABLE inventario (
    id_inventario        INT      NOT NULL AUTO_INCREMENT,
    id_variante          INT      NOT NULL,
    id_almacen           INT      NOT NULL,
    stock_actual         INT      NOT NULL DEFAULT 0,
    stock_minimo         INT      NOT NULL DEFAULT 5,
    stock_maximo         INT      NULL,
    ultima_actualizacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
                                           ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_inventario       PRIMARY KEY (id_inventario),
    CONSTRAINT uq_inv_variante_alm UNIQUE (id_variante, id_almacen),
    CONSTRAINT chk_stock_actual    CHECK (stock_actual >= 0),
    CONSTRAINT fk_inv_variante     FOREIGN KEY (id_variante)
        REFERENCES variante_producto (id_variante)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_inv_almacen      FOREIGN KEY (id_almacen)
        REFERENCES almacen (id_almacen)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='Stock por variante y por almacén';


-- ============================================================
--  DOMINIO: Clientes y Ventas
-- ============================================================

CREATE TABLE cliente (
    id_cliente    INT            NOT NULL AUTO_INCREMENT,
    nombre        VARCHAR(100)   NOT NULL,
    apellido      VARCHAR(100)   NOT NULL,
    email         VARCHAR(150)   NOT NULL,
    telefono      VARCHAR(20)    NULL,
    direccion     VARCHAR(200)   NULL,
    ciudad        VARCHAR(80)    NULL,
    rfc           VARCHAR(20)    NULL,
    fecha_registro DATE          NOT NULL DEFAULT (CURRENT_DATE),
    activo        BOOLEAN        NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_cliente       PRIMARY KEY (id_cliente),
    CONSTRAINT uq_cliente_email UNIQUE (email)
) ENGINE=InnoDB COMMENT='Clientes registrados en la tienda';


CREATE TABLE pedido (
    id_pedido    INT            NOT NULL AUTO_INCREMENT,
    id_cliente   INT            NOT NULL,
    id_empleado  INT            NULL,
    fecha_pedido DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado       ENUM('pendiente','confirmado','enviado','entregado','cancelado')
                               NOT NULL DEFAULT 'pendiente',
    subtotal     DECIMAL(10,2)  NOT NULL,
    descuento    DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
    impuesto     DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
    total        DECIMAL(10,2)  NOT NULL,
    notas        TEXT           NULL,
    CONSTRAINT pk_pedido       PRIMARY KEY (id_pedido),
    CONSTRAINT fk_ped_cliente  FOREIGN KEY (id_cliente)
        REFERENCES cliente (id_cliente)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_ped_empleado FOREIGN KEY (id_empleado)
        REFERENCES empleado (id_empleado)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='Cabecera de cada orden de venta';


CREATE TABLE detalle_pedido (
    id_detalle     INT            NOT NULL AUTO_INCREMENT,
    id_pedido      INT            NOT NULL,
    id_variante    INT            NOT NULL,
    cantidad       INT            NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    descuento      DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
    subtotal       DECIMAL(10,2)  NOT NULL,
    CONSTRAINT pk_detalle_pedido  PRIMARY KEY (id_detalle),
    CONSTRAINT chk_det_cantidad   CHECK (cantidad > 0),
    CONSTRAINT fk_det_pedido      FOREIGN KEY (id_pedido)
        REFERENCES pedido (id_pedido)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_det_variante    FOREIGN KEY (id_variante)
        REFERENCES variante_producto (id_variante)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='Líneas de productos de cada pedido (snapshot de precio)';


-- ============================================================
--  DOMINIO: Pagos y Envíos
-- ============================================================

CREATE TABLE pago (
    id_pago    INT            NOT NULL AUTO_INCREMENT,
    id_pedido  INT            NOT NULL,
    metodo     ENUM('efectivo','tarjeta_credito','tarjeta_debito',
                    'transferencia','oxxo','paypal') NOT NULL,
    monto      DECIMAL(10,2)  NOT NULL,
    referencia VARCHAR(100)   NULL,
    estado     ENUM('pendiente','aprobado','rechazado','reembolsado')
                              NOT NULL DEFAULT 'pendiente',
    fecha_pago DATETIME       NULL,
    CONSTRAINT pk_pago        PRIMARY KEY (id_pago),
    CONSTRAINT uq_pago_pedido UNIQUE (id_pedido),
    CONSTRAINT fk_pago_pedido FOREIGN KEY (id_pedido)
        REFERENCES pedido (id_pedido)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='Registro de pago asociado a un pedido';


CREATE TABLE envio (
    id_envio          INT            NOT NULL AUTO_INCREMENT,
    id_pedido         INT            NOT NULL,
    direccion_destino VARCHAR(200)   NOT NULL,
    ciudad_destino    VARCHAR(80)    NOT NULL,
    transportista     VARCHAR(80)    NULL,
    numero_tracking   VARCHAR(100)   NULL,
    costo_envio       DECIMAL(8,2)   NOT NULL DEFAULT 0.00,
    estado            ENUM('preparando','en_camino','entregado','devuelto')
                                     NOT NULL DEFAULT 'preparando',
    fecha_estimada    DATE           NULL,
    fecha_entrega     DATE           NULL,
    CONSTRAINT pk_envio        PRIMARY KEY (id_envio),
    CONSTRAINT fk_envio_pedido FOREIGN KEY (id_pedido)
        REFERENCES pedido (id_pedido)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='Seguimiento de envío por pedido';


-- ============================================================
--  DOMINIO: Órdenes de Compra a Proveedores
-- ============================================================

CREATE TABLE orden_compra (
    id_orden         INT            NOT NULL AUTO_INCREMENT,
    id_proveedor     INT            NOT NULL,
    id_empleado      INT            NULL,
    fecha_orden      DATE           NOT NULL,
    fecha_esperada   DATE           NULL,
    fecha_recepcion  DATE           NULL,
    estado           ENUM('borrador','enviada','recibida','cancelada')
                                    NOT NULL DEFAULT 'borrador',
    total            DECIMAL(12,2)  NOT NULL DEFAULT 0.00,
    notas            TEXT           NULL,
    CONSTRAINT pk_orden_compra   PRIMARY KEY (id_orden),
    CONSTRAINT fk_oc_proveedor   FOREIGN KEY (id_proveedor)
        REFERENCES proveedor (id_proveedor)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_oc_empleado    FOREIGN KEY (id_empleado)
        REFERENCES empleado (id_empleado)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='Cabecera de orden de compra a proveedor';


CREATE TABLE detalle_compra (
    id_detalle      INT            NOT NULL AUTO_INCREMENT,
    id_orden        INT            NOT NULL,
    id_producto     INT            NOT NULL,
    cantidad        INT            NOT NULL,
    precio_unitario DECIMAL(10,2)  NOT NULL,
    subtotal        DECIMAL(10,2)  NOT NULL,
    CONSTRAINT pk_detalle_compra PRIMARY KEY (id_detalle),
    CONSTRAINT chk_dc_cantidad   CHECK (cantidad > 0),
    CONSTRAINT fk_dc_orden       FOREIGN KEY (id_orden)
        REFERENCES orden_compra (id_orden)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_dc_producto    FOREIGN KEY (id_producto)
        REFERENCES producto (id_producto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='Líneas de productos de cada orden de compra';


-- ============================================================
--  ÍNDICES RECOMENDADOS
-- ============================================================

-- Búsquedas frecuentes de productos
CREATE INDEX idx_producto_marca     ON producto (marca);
CREATE INDEX idx_producto_categoria ON producto (id_categoria);
CREATE INDEX idx_variante_producto  ON variante_producto (id_producto);

-- Consultas de inventario
CREATE INDEX idx_inventario_almacen ON inventario (id_almacen);

-- Historial de pedidos por cliente
CREATE INDEX idx_pedido_cliente     ON pedido (id_cliente);
CREATE INDEX idx_pedido_fecha       ON pedido (fecha_pedido);
CREATE INDEX idx_pedido_estado      ON pedido (estado);

-- Detalle de pedidos
CREATE INDEX idx_detped_pedido      ON detalle_pedido (id_pedido);
CREATE INDEX idx_detped_variante    ON detalle_pedido (id_variante);

-- Órdenes de compra
CREATE INDEX idx_oc_proveedor       ON orden_compra (id_proveedor);
CREATE INDEX idx_oc_estado          ON orden_compra (estado);


-- ============================================================
--  DATOS DE PRUEBA (seed mínimo)
-- ============================================================

INSERT INTO empleado (nombre, apellido, email, rol, fecha_ingreso) VALUES
('Administrador', 'Sistema', 'admin@bdelectronicos.com', 'admin', CURDATE()),
('María', 'López',  'maria.lopez@bdelectronicos.com',  'gerente',     '2024-01-15'),
('Carlos', 'Reyes', 'carlos.reyes@bdelectronicos.com', 'vendedor',    '2024-03-01'),
('Ana', 'Martínez', 'ana.martinez@bdelectronicos.com', 'almacenista', '2024-03-01');

INSERT INTO proveedor (nombre, contacto, email, pais, ciudad) VALUES
('Apple Distribuciones MX', 'Luis Fernández', 'ventas@appledist.mx', 'México', 'Ciudad de México'),
('Samsung Wholesale',       'Jin Park',        'sales@samsungwh.com', 'Corea del Sur', 'Seúl'),
('Importaciones Tech S.A.', 'Roberto Díaz',    'rdiaz@importech.mx',  'México', 'Monterrey');

INSERT INTO categoria (nombre, descripcion, id_padre) VALUES
('Electrónica',       'Todos los productos electrónicos', NULL),
('Smartphones',       'Teléfonos inteligentes',           1),
('Laptops',           'Computadoras portátiles',          1),
('Accesorios',        'Accesorios y periféricos',         1),
('Audio',             'Audífonos y bocinas',              4);

INSERT INTO almacen (nombre, direccion, ciudad, estado) VALUES
('Bodega Central',    'Av. Industria 100', 'Ciudad Juárez', 'Chihuahua'),
('Sucursal Norte',    'Blvd. Tecnológico 45', 'Chihuahua', 'Chihuahua'),
('Sucursal Sur',      'Calle Reforma 210',    'Ciudad Juárez', 'Chihuahua');

INSERT INTO producto (sku, nombre, marca, modelo, precio_base, id_categoria, id_proveedor, fecha_alta) VALUES
('APL-IP15-001', 'iPhone 15',       'Apple',   'A3090',       19999.00, 2, 1, CURDATE()),
('SAM-S24-001',  'Galaxy S24',      'Samsung', 'SM-S921B',    17499.00, 2, 2, CURDATE()),
('APL-MBA-001',  'MacBook Air M3',  'Apple',   'MRXN3E/A',    29999.00, 3, 1, CURDATE()),
('SAM-APN-001',  'Galaxy Buds 2',   'Samsung', 'SM-R177NZ',    2499.00, 5, 2, CURDATE());

INSERT INTO variante_producto (id_producto, color, almacenamiento, precio, codigo_barras) VALUES
(1, 'Negro',  '128GB', 19999.00, '0194253728947'),
(1, 'Blanco', '128GB', 19999.00, '0194253728954'),
(1, 'Negro',  '256GB', 22999.00, '0194253728961'),
(2, 'Gris',   '256GB', 17499.00, '8806095073842'),
(2, 'Crema',  '256GB', 17499.00, '8806095073859'),
(3, 'Plata',  '256GB', 29999.00, '0194253757503'),
(4, 'Grafito','  N/A', 2499.00,  '8806094854923');

INSERT INTO inventario (id_variante, id_almacen, stock_actual, stock_minimo) VALUES
(1, 1, 25, 5), (2, 1, 18, 5), (3, 1, 10, 3),
(4, 1, 30, 8), (5, 1, 22, 5),
(6, 1, 12, 3),
(7, 1, 40, 10),
(1, 2, 8,  3), (4, 2, 10, 5);

INSERT INTO cliente (nombre, apellido, email, telefono, ciudad, fecha_registro) VALUES
('Juan',    'Pérez',    'juan.perez@email.com',    '6561234567', 'Ciudad Juárez', CURDATE()),
('Sofía',   'Ramírez',  'sofia.ramirez@email.com', '6569876543', 'Juárez',        CURDATE()),
('Miguel',  'Torres',   'miguel.torres@email.com', '6561112233', 'Chihuahua',     CURDATE());


-- ------------------------------------------------------------
-- Restaurar verificación de claves foráneas
-- ------------------------------------------------------------
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
--  FIN DEL SCRIPT
-- ============================================================
