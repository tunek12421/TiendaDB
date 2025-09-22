-- Registrar una venta, un detalle de venta y un pago

-- 1. Registrar la venta principal
INSERT INTO TiendaDB.ventas (id_cliente, id_empleado, fecha_venta, total) 
VALUES (1, 2, NOW(), 0);

-- 2. Obtener el ID de la venta recién creada
SET @id_venta = LAST_INSERT_ID();

-- 3. Registrar detalle de venta
INSERT INTO TiendaDB.detalle_ventas (id_venta, id_producto, cantidad, precio_unitario) 
VALUES (@id_venta, 2, 2, 185.00);

-- 4. Actualizar el total de la venta
UPDATE TiendaDB.ventas 
SET total = (
    SELECT SUM(cantidad * precio_unitario) 
    FROM TiendaDB.detalle_ventas 
    WHERE id_venta = @id_venta
) 
WHERE id_venta = @id_venta;

-- 5. Registrar el pago
INSERT INTO TiendaDB.pagos (id_venta, metodo_pago, monto, fecha_pago) 
VALUES (@id_venta, 'Efectivo', 370.00, NOW());