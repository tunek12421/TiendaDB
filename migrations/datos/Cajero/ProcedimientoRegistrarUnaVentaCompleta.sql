-- Crear procedimiento almacenado para registrar venta completa
DELIMITER //

CREATE PROCEDURE RegistrarVentaCompleta(
    IN p_id_cliente INT,
    IN p_id_empleado INT,
    IN p_id_producto INT,
    IN p_cantidad INT,
    IN p_precio_unitario DECIMAL(10,2),
    IN p_metodo_pago ENUM('Efectivo', 'Tarjeta', 'Transferencia')
)
BEGIN
    DECLARE v_id_venta INT;
    DECLARE v_total DECIMAL(10,2);
    
    -- Iniciar transacción
    START TRANSACTION;
    
    -- 1. Registrar la venta principal
    INSERT INTO ventas (id_cliente, id_empleado, fecha_venta, total) 
    VALUES (p_id_cliente, p_id_empleado, NOW(), 0);
    
    -- 2. Obtener el ID de la venta recién creada
    SET v_id_venta = LAST_INSERT_ID();
    
    -- 3. Registrar detalle de venta
    INSERT INTO detalle_ventas (id_venta, id_producto, cantidad, precio_unitario) 
    VALUES (v_id_venta, p_id_producto, p_cantidad, p_precio_unitario);
    
    -- 4. Calcular total
    SET v_total = p_cantidad * p_precio_unitario;
    
    -- 5. Actualizar el total de la venta
    UPDATE ventas SET total = v_total WHERE id_venta = v_id_venta;
    
    -- 6. Registrar el pago
    INSERT INTO pagos (id_venta, metodo_pago, monto, fecha_pago) 
    VALUES (v_id_venta, p_metodo_pago, v_total, NOW());
    
    -- Confirmar transacción
    COMMIT;
    
    -- Retornar el ID de la venta creada
    SELECT v_id_venta AS id_venta_creada, v_total AS total_venta;
    
END //

DELIMITER ;