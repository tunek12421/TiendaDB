-- Consultar productos disponibles
SELECT * FROM productos WHERE stock > 0;

-- Consultar productos disponibles con información útil para venta
SELECT 
    id_producto,
    nombre,
    precio,
    stock,
    id_categoria
FROM productos 
WHERE stock > 0
ORDER BY nombre;

-- Consultar productos disponibles con categoría
SELECT 
    p.id_producto,
    p.nombre,
    p.precio,
    p.stock,
    c.nombre_categoria
FROM productos p
JOIN categorias c ON p.id_categoria = c.id_categoria
WHERE p.stock > 0
ORDER BY c.nombre_categoria, p.nombre;