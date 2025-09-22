-- =============================================
-- MIGRACIÓN: Inserción de Datos - TiendaDB
-- 5 registros por tabla
-- =============================================

USE TiendaDB;

-- Iniciar transacción para garantizar consistencia
START TRANSACTION;

-- =============================================
-- TABLA: categorias (5 registros)
-- =============================================
INSERT INTO categorias (nombre_categoria, descripcion) VALUES
('Electrónicos', 'Dispositivos electrónicos y tecnología'),
('Ropa', 'Vestimenta para hombres, mujeres y niños'),
('Hogar', 'Artículos para el hogar y decoración'),
('Deportes', 'Equipamiento y ropa deportiva'),
('Libros', 'Literatura, educativos y entretenimiento');

-- =============================================
-- TABLA: proveedores (5 registros)
-- =============================================
INSERT INTO proveedores (nombre, telefono, direccion, email) VALUES
('TechDistribuidor SA', '4-4567890', 'Av. América 1234, Cochabamba', 'ventas@techdist.com'),
('Moda Global Ltda', '4-4567891', 'Calle España 567, Cochabamba', 'contacto@modaglobal.com'),
('Hogar y Estilo', '4-4567892', 'Av. Heroínas 890, Cochabamba', 'info@hogarestilo.com'),
('Deportes Pro', '4-4567893', 'Calle Bolívar 345, Cochabamba', 'pedidos@deportespro.com'),
('Editorial Andina', '4-4567894', 'Av. Ayacucho 678, Cochabamba', 'distribución@editorialandina.com');

-- =============================================
-- TABLA: clientes (5 registros)
-- =============================================
INSERT INTO clientes (nombre, email, telefono, direccion, fecha_registro) VALUES
('María González López', 'maria.gonzalez@email.com', '70012345', 'Zona Norte, Calle 1 #123', '2024-01-15'),
('Carlos Rodríguez Pérez', 'carlos.rodriguez@email.com', '70012346', 'Zona Sur, Av. Principal 456', '2024-01-20'),
('Ana Martínez Silva', 'ana.martinez@email.com', '70012347', 'Centro, Plaza Colón 789', '2024-02-01'),
('José Fernández Torres', 'jose.fernandez@email.com', '70012348', 'Zona Este, Calle Comercio 321', '2024-02-10'),
('Laura Sánchez Morales', 'laura.sanchez@email.com', '70012349', 'Zona Oeste, Av. Libertad 654', '2024-02-15');

-- =============================================
-- TABLA: empleados (5 registros)
-- =============================================
INSERT INTO empleados (nombre, cargo, salario, fecha_contratacion) VALUES
('Pedro Jiménez Vargas', 'Gerente', 8500.00, '2023-01-15'),
('Sofía Herrera Castro', 'Cajera', 3200.00, '2023-03-01'),
('Miguel Torres Ramírez', 'Vendedor', 3500.00, '2023-06-10'),
('Elena Morales Gutiérrez', 'Cajera', 3200.00, '2023-08-20'),
('Roberto Paredes Luna', 'Almacenero', 3000.00, '2023-10-05');

-- =============================================
-- TABLA: productos (5 registros)
-- =============================================
INSERT INTO productos (nombre, precio, stock, id_categoria) VALUES
('Smartphone Samsung Galaxy A54', 2450.00, 25, 1),
('Camiseta Deportiva Nike', 185.00, 50, 2),
('Juego de Sábanas Queen', 320.00, 30, 3),
('Pelota de Fútbol Adidas', 125.00, 40, 4),
('Libro: "Cien Años de Soledad"', 75.00, 20, 5);

-- =============================================
-- TABLA: ventas (5 registros)
-- =============================================
INSERT INTO ventas (id_cliente, id_empleado, fecha_venta, total) VALUES
(1, 2, '2024-02-20 10:30:00', 2450.00),
(2, 3, '2024-02-20 14:15:00', 370.00),
(3, 2, '2024-02-21 09:45:00', 320.00),
(4, 4, '2024-02-21 16:20:00', 250.00),
(5, 3, '2024-02-22 11:10:00', 75.00);

-- =============================================
-- TABLA: pedidos (5 registros)
-- =============================================
INSERT INTO pedidos (id_proveedor, fecha_pedido, estado) VALUES
(1, '2024-02-15', 'Completado'),
(2, '2024-02-16', 'Completado'),
(3, '2024-02-17', 'Pendiente'),
(4, '2024-02-18', 'Completado'),
(5, '2024-02-19', 'Pendiente');

-- =============================================
-- TABLA: detalles_ventas (5 registros)
-- =============================================
INSERT INTO detalles_ventas (id_venta, id_producto, cantidad, precio_unitario) VALUES
(1, 1, 1, 2450.00),  -- Smartphone
(2, 2, 2, 185.00),   -- 2 Camisetas
(3, 3, 1, 320.00),   -- Juego de sábanas
(4, 4, 2, 125.00),   -- 2 Pelotas
(5, 5, 1, 75.00);    -- Libro

-- =============================================
-- TABLA: pagos (5 registros)
-- =============================================
INSERT INTO pagos (id_venta, metodo_pago, monto, fecha_pago) VALUES
(1, 'Tarjeta', 2450.00, '2024-02-20 10:35:00'),
(2, 'Efectivo', 370.00, '2024-02-20 14:20:00'),
(3, 'Transferencia', 320.00, '2024-02-21 09:50:00'),
(4, 'Efectivo', 250.00, '2024-02-21 16:25:00'),
(5, 'Tarjeta', 75.00, '2024-02-22 11:15:00');

-- =============================================
-- TABLA: detalles_pedidos (5 registros)
-- =============================================
INSERT INTO detalles_pedidos (id_pedido, id_producto, cantidad, precio_unitario) VALUES
(1, 1, 10, 2200.00),  -- Pedido smartphones (precio mayorista)
(2, 2, 30, 150.00),   -- Pedido camisetas
(3, 3, 20, 280.00),   -- Pedido sábanas
(4, 4, 25, 100.00),   -- Pedido pelotas
(5, 5, 15, 60.00);    -- Pedido libros

-- =============================================
-- ACTUALIZAR TOTALES DE VENTAS
-- =============================================
-- Actualizar el campo total en ventas basado en detalles_ventas
UPDATE ventas v 
SET total = (
    SELECT SUM(dv.cantidad * dv.precio_unitario) 
    FROM detalles_ventas dv 
    WHERE dv.id_venta = v.id_venta
);

-- =============================================
-- VERIFICACIÓN DE DATOS INSERTADOS
-- =============================================

-- Mostrar resumen de registros por tabla
SELECT 'categorias' AS tabla, COUNT(*) AS registros FROM categorias
UNION ALL
SELECT 'proveedores', COUNT(*) FROM proveedores
UNION ALL
SELECT 'clientes', COUNT(*) FROM clientes
UNION ALL
SELECT 'empleados', COUNT(*) FROM empleados
UNION ALL
SELECT 'productos', COUNT(*) FROM productos
UNION ALL
SELECT 'ventas', COUNT(*) FROM ventas
UNION ALL
SELECT 'pedidos', COUNT(*) FROM pedidos
UNION ALL
SELECT 'detalles_ventas', COUNT(*) FROM detalles_ventas
UNION ALL
SELECT 'pagos', COUNT(*) FROM pagos
UNION ALL
SELECT 'detalles_pedidos', COUNT(*) FROM detalles_pedidos;

-- Confirmar transacción
COMMIT;

-- Mensaje de confirmación
SELECT 'Datos de TiendaDB insertados exitosamente: 5 registros por tabla' AS Mensaje;