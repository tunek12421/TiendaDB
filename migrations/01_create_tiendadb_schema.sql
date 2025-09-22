-- =============================================
-- Script de Creación de Base de Datos: TiendaDB
-- =============================================

-- Eliminar la base de datos si existe y crear una nueva
DROP DATABASE IF EXISTS TiendaDB;
CREATE DATABASE TiendaDB;
USE TiendaDB;

-- =============================================
-- TABLA: categorias
-- =============================================
CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    nombre_categoria VARCHAR(50) NOT NULL,
    descripcion TEXT
);

-- =============================================
-- TABLA: proveedores
-- =============================================
CREATE TABLE proveedores (
    id_proveedor INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    direccion VARCHAR(150),
    email VARCHAR(100)
);

-- =============================================
-- TABLA: productos
-- =============================================
CREATE TABLE productos (
    id_producto INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    id_categoria INT,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

-- =============================================
-- TABLA: clientes
-- =============================================
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefono VARCHAR(20),
    direccion VARCHAR(150),
    fecha_registro DATE DEFAULT CURRENT_DATE
);

-- =============================================
-- TABLA: empleados
-- =============================================
CREATE TABLE empleados (
    id_empleado INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    cargo VARCHAR(50),
    salario DECIMAL(10,2),
    fecha_contratacion DATE DEFAULT CURRENT_DATE
);

-- =============================================
-- TABLA: ventas
-- =============================================
CREATE TABLE ventas (
    id_venta INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_empleado INT,
    fecha_venta DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

-- =============================================
-- TABLA: detalles_ventas
-- =============================================
CREATE TABLE detalles_ventas (
    id_detalle_venta INT PRIMARY KEY AUTO_INCREMENT,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_venta) REFERENCES ventas(id_venta)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- =============================================
-- TABLA: pagos
-- =============================================
CREATE TABLE pagos (
    id_pago INT PRIMARY KEY AUTO_INCREMENT,
    id_venta INT NOT NULL,
    metodo_pago VARCHAR(50) NOT NULL,
    -- Puede ser: 'Efectivo', 'Tarjeta', 'Transferencia', etc.
    monto DECIMAL(10,2) NOT NULL,
    fecha_pago DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_venta) REFERENCES ventas(id_venta)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- =============================================
-- TABLA: pedidos
-- =============================================
CREATE TABLE pedidos (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_proveedor INT NOT NULL,
    fecha_pedido DATE DEFAULT CURRENT_DATE,
    estado ENUM('Pendiente', 'Completado', 'Cancelado') DEFAULT 'Pendiente',
    FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- =============================================
-- TABLA: detalles_pedidos
-- =============================================
CREATE TABLE detalles_pedidos (
    id_detalle_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- =============================================
-- ÍNDICES ADICIONALES PARA OPTIMIZACIÓN
-- =============================================

-- Índices para búsquedas frecuentes
CREATE INDEX idx_productos_categoria ON productos(id_categoria);
CREATE INDEX idx_ventas_cliente ON ventas(id_cliente);
CREATE INDEX idx_ventas_empleado ON ventas(id_empleado);
CREATE INDEX idx_ventas_fecha ON ventas(fecha_venta);
CREATE INDEX idx_detalles_venta ON detalles_ventas(id_venta);
CREATE INDEX idx_detalles_producto ON detalles_ventas(id_producto);
CREATE INDEX idx_pedidos_proveedor ON pedidos(id_proveedor);
CREATE INDEX idx_pedidos_estado ON pedidos(estado);
CREATE INDEX idx_pagos_venta ON pagos(id_venta);

-- =============================================
-- INSERCIÓN DE DATOS DE PRUEBA
-- =============================================

-- Insertar categorías
INSERT INTO categorias (nombre_categoria, descripcion) VALUES
('Electrónica', 'Productos electrónicos y tecnología'),
('Ropa', 'Prendas de vestir para todas las edades'),
('Alimentos', 'Productos alimenticios y bebidas'),
('Hogar', 'Artículos para el hogar y decoración'),
('Deportes', 'Equipamiento y accesorios deportivos');

-- Insertar proveedores
INSERT INTO proveedores (nombre, telefono, direccion, email) VALUES
('Tech Supplies S.A.', '555-0001', 'Av. Industrial 123', 'ventas@techsupplies.com'),
('Fashion World', '555-0002', 'Calle Moda 456', 'contacto@fashionworld.com'),
('Food Distribution Co.', '555-0003', 'Zona Comercial 789', 'pedidos@fooddist.com');

-- Insertar empleados
INSERT INTO empleados (nombre, cargo, salario) VALUES
('Juan Pérez', 'Vendedor', 1500.00),
('María García', 'Gerente', 2500.00),
('Carlos López', 'Cajero', 1200.00),
('Ana Martínez', 'Supervisor', 1800.00);

-- Insertar clientes
INSERT INTO clientes (nombre, email, telefono, direccion) VALUES
('Cliente General', 'cliente@email.com', '555-1001', 'Calle Principal 100'),
('Roberto Díaz', 'roberto@email.com', '555-1002', 'Av. Central 200'),
('Laura Sánchez', 'laura@email.com', '555-1003', 'Plaza Mayor 300'),
('Pedro Rodríguez', 'pedro@email.com', '555-1004', 'Barrio Norte 400');

-- Insertar productos
INSERT INTO productos (nombre, precio, stock, id_categoria) VALUES
('Laptop HP', 850.00, 15, 1),
('Mouse Inalámbrico', 25.00, 50, 1),
('Camiseta Polo', 35.00, 100, 2),
('Pantalón Jeans', 45.00, 80, 2),
('Arroz 5kg', 12.00, 200, 3),
('Aceite 1L', 8.00, 150, 3),
('Lámpara LED', 30.00, 40, 4),
('Almohada Memory Foam', 25.00, 60, 4),
('Pelota de Fútbol', 40.00, 30, 5),
('Raqueta de Tenis', 120.00, 20, 5);

-- =============================================
-- VISTAS ÚTILES
-- =============================================

-- Vista de ventas detalladas
CREATE VIEW vista_ventas_detalladas AS
SELECT 
    v.id_venta,
    v.fecha_venta,
    c.nombre AS cliente,
    e.nombre AS empleado,
    dv.id_producto,
    p.nombre AS producto,
    dv.cantidad,
    dv.precio_unitario,
    (dv.cantidad * dv.precio_unitario) AS subtotal,
    v.total
FROM ventas v
JOIN clientes c ON v.id_cliente = c.id_cliente
LEFT JOIN empleados e ON v.id_empleado = e.id_empleado
JOIN detalles_ventas dv ON v.id_venta = dv.id_venta
JOIN productos p ON dv.id_producto = p.id_producto;

-- Vista de inventario
CREATE VIEW vista_inventario AS
SELECT 
    p.id_producto,
    p.nombre,
    c.nombre_categoria,
    p.precio,
    p.stock,
    (p.precio * p.stock) AS valor_inventario
FROM productos p
LEFT JOIN categorias c ON p.id_categoria = c.id_categoria;

-- =============================================
-- PROCEDIMIENTOS ALMACENADOS
-- =============================================

DELIMITER //

-- Procedimiento para registrar una venta
CREATE PROCEDURE registrar_venta(
    IN p_id_cliente INT,
    IN p_id_empleado INT,
    OUT p_id_venta INT
)
BEGIN
    INSERT INTO ventas (id_cliente, id_empleado, total) 
    VALUES (p_id_cliente, p_id_empleado, 0);
    
    SET p_id_venta = LAST_INSERT_ID();
END //

-- Procedimiento para agregar detalle de venta y actualizar stock
CREATE PROCEDURE agregar_detalle_venta(
    IN p_id_venta INT,
    IN p_id_producto INT,
    IN p_cantidad INT
)
BEGIN
    DECLARE v_precio DECIMAL(10,2);
    DECLARE v_stock_actual INT;
    
    -- Obtener precio y stock actual
    SELECT precio, stock INTO v_precio, v_stock_actual
    FROM productos 
    WHERE id_producto = p_id_producto;
    
    -- Verificar stock disponible
    IF v_stock_actual >= p_cantidad THEN
        -- Insertar detalle
        INSERT INTO detalles_ventas (id_venta, id_producto, cantidad, precio_unitario)
        VALUES (p_id_venta, p_id_producto, p_cantidad, v_precio);
        
        -- Actualizar stock
        UPDATE productos 
        SET stock = stock - p_cantidad 
        WHERE id_producto = p_id_producto;
        
        -- Actualizar total de la venta
        UPDATE ventas 
        SET total = (
            SELECT SUM(cantidad * precio_unitario) 
            FROM detalles_ventas 
            WHERE id_venta = p_id_venta
        )
        WHERE id_venta = p_id_venta;
    ELSE
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Stock insuficiente';
    END IF;
END //

DELIMITER ;

-- =============================================
-- TRIGGERS
-- =============================================

DELIMITER //

-- Trigger para actualizar stock cuando se recibe un pedido
CREATE TRIGGER actualizar_stock_pedido
AFTER UPDATE ON pedidos
FOR EACH ROW
BEGIN
    IF NEW.estado = 'Completado' AND OLD.estado != 'Completado' THEN
        UPDATE productos p
        INNER JOIN detalles_pedidos dp ON p.id_producto = dp.id_producto
        SET p.stock = p.stock + dp.cantidad
        WHERE dp.id_pedido = NEW.id_pedido;
    END IF;
END //

DELIMITER ;

-- =============================================
-- FIN DEL SCRIPT
-- =============================================

-- Mostrar las tablas creadas
SHOW TABLES;

-- Mensaje de confirmación
SELECT 'Base de datos TiendaDB creada exitosamente' AS Mensaje;
