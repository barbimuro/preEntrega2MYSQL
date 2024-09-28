DROP DATABASE IF EXISTS styles_by_bm;
CREATE DATABASE styles_by_bm;
USE styles_by_bm;

CREATE TABLE cliente (
id_cliente INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nombre_cliente VARCHAR(60),
dni_cliente VARCHAR(12),
telefono_cliente VARCHAR(15),
direccion_cliente VARCHAR(100),
email_cliente VARCHAR(80)
) COMMENT 'Datos del cliente';

CREATE TABLE proveedor (
id_proveedor INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nombre_proveedor VARCHAR(60),
cuit_proveedor VARCHAR(12),
telefono_proveedor VARCHAR(15),
direccion_proveedor VARCHAR(100),
email_proveedor VARCHAR(80)
) COMMENT 'Datos del proveedor';

CREATE TABLE categoria_producto (
id_categoria INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nombre_categoria VARCHAR(60),
descripcion_categoria VARCHAR(300)
) COMMENT 'Descripcion categorias de productos';

CREATE TABLE producto (
id_producto INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nombre_producto VARCHAR(60),
precio_producto DECIMAL(8,2),
descripcion_producto VARCHAR(300),
id_categoria INT UNSIGNED, -- fk
id_proveedor INT UNSIGNED -- fk
) COMMENT 'Datos del producto';

CREATE TABLE transaccion (
    id_transaccion INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT UNSIGNED, -- fk
    fecha_transaccion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    monto_transaccion DECIMAL(8,2),
    estado_transaccion ENUM('en preparacion', 'enviado', 'recibido', 'cancelado')
) COMMENT 'Datos de la transaccion';

CREATE TABLE detalle_transaccion (
id_detalle_transaccion INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
id_transaccion INT UNSIGNED, -- fk
id_producto INT UNSIGNED, -- fk
cantidad_producto INT UNSIGNED,
precio_unitario DECIMAL(8,2)
) COMMENT 'Detalle de la transaccion';

ALTER TABLE   styles_by_bm.producto   ADD
FOREIGN KEY  (id_categoria)  REFERENCES styles_by_bm.categoria_producto(id_categoria);

ALTER TABLE   styles_by_bm.producto   ADD
FOREIGN KEY  (id_proveedor)  REFERENCES styles_by_bm.proveedor(id_proveedor);

ALTER TABLE styles_by_bm.transaccion  ADD
FOREIGN KEY  (id_cliente)  REFERENCES styles_by_bm.cliente(id_cliente);

ALTER TABLE   styles_by_bm.detalle_transaccion   ADD
FOREIGN KEY   (id_transaccion) REFERENCES styles_by_bm.transaccion(id_transaccion) ;

ALTER TABLE  styles_by_bm.detalle_transaccion     ADD
FOREIGN KEY   (id_producto)  REFERENCES styles_by_bm.producto(id_producto) ;

-- INSERCIONES:

INSERT INTO cliente (nombre_cliente, dni_cliente, telefono_cliente, direccion_cliente, email_cliente) VALUES
('Juan Perez', '12345678', '555-1234', 'Calle Falsa 123', 'juan.perez@example.com'),
('Maria Lopez', '87654321', '555-5678', 'Avenida Siempreviva 456', 'maria.lopez@example.com'),
('Carlos Martinez', '13579246', '555-1357', 'Calle Luna 789', 'carlos.martinez@example.com'),
('Ana Gutierrez', '24681357', '555-2468', 'Avenida Sol 101', 'ana.gutierrez@example.com'),
('Luis Fernandez', '98765432', '555-9876', 'Calle Estrella 202', 'luis.fernandez@example.com');

INSERT INTO proveedor (nombre_proveedor, cuit_proveedor, telefono_proveedor, direccion_proveedor, email_proveedor) VALUES
('Proveedor Uno', '20123456789', '555-1010', 'Calle Comercio 100', 'contacto1@proveedor.com'),
('Proveedor Dos', '20987654321', '555-2020', 'Avenida Empresa 200', 'contacto2@proveedor.com'),
('Proveedor Tres', '20111222333', '555-3030', 'Calle Industria 300', 'contacto3@proveedor.com'),
('Proveedor Cuatro', '20444555666', '555-4040', 'Avenida Exportacion 400', 'contacto4@proveedor.com'),
('Proveedor Cinco', '20777888999', '555-5050', 'Calle Importacion 500', 'contacto5@proveedor.com');

INSERT INTO categoria_producto (nombre_categoria, descripcion_categoria) VALUES
('Maquillaje', 'Productos para maquillaje facial y corporal.'),
('Cuidado del Cabello', 'Shampoos, acondicionadores y tratamientos capilares.'),
('Cuidado de la Piel', 'Cremas hidratantes, sueros y lociones para la piel.'),
('Perfumes', 'Fragancias para mujeres y hombres.'),
('Uñas', 'Productos para el cuidado y embellecimiento de uñas.');

INSERT INTO producto (nombre_producto, precio_producto, descripcion_producto, id_categoria, id_proveedor) VALUES
('Base de Maquillaje', 25.00, 'Base líquida de larga duración.', 1, 1),
('Shampoo Nutritivo', 15.00, 'Shampoo para cabello seco y maltratado.', 2, 2),
('Crema Hidratante', 30.00, 'Crema hidratante para piel seca.', 3, 3),
('Perfume Floral', 50.00, 'Fragancia con notas florales.', 4, 4),
('Esmalte de Uñas', 10.00, 'Esmalte de uñas en color rojo intenso.', 5, 5);

INSERT INTO transaccion (id_cliente, fecha_transaccion, monto_transaccion, estado_transaccion) VALUES
(1, '2024-09-01 10:00:00', 25.00, 2),
(2, '2024-09-02 12:00:00', 45.00, 3),
(3, '2024-09-03 14:00:00', 30.00, 1),
(4, '2024-09-04 16:00:00', 50.00, 2),
(5, '2024-09-05 18:00:00', 10.00, 4);

INSERT INTO detalle_transaccion (id_transaccion, id_producto, cantidad_producto, precio_unitario) VALUES
(1, 1, 1, 25.00),
(2, 2, 3, 15.00),
(3, 3, 1, 30.00),
(4, 4, 1, 50.00),
(5, 5, 1, 10.00);

-- VIEWS:

CREATE VIEW vista_productos_mas_vendidos AS
SELECT p.nombre_producto, SUM(dt.cantidad_producto) AS cantidad_vendida, SUM(dt.precio_unitario * dt.cantidad_producto) AS ingreso_total
FROM producto AS p
JOIN detalle_transaccion AS dt ON p.id_producto = dt.id_producto
GROUP BY p.id_producto
ORDER BY cantidad_vendida DESC;

CREATE VIEW vista_envios_cancelados AS 
SELECT t.id_transaccion, c.nombre_cliente,c.telefono_cliente, t.monto_transaccion, t.fecha_transaccion
FROM transaccion AS t
JOIN cliente AS c ON t.id_cliente = c.id_cliente
WHERE t.estado_transaccion ='cancelado';

-- FUNCTIONS:
DROP FUNCTION IF EXISTS fn_total_transacciones;
DROP FUNCTION IF EXISTS fn_dias_desde_ultima_transaccion;
DELIMITER //

CREATE FUNCTION fn_total_transacciones(cid INT)
RETURNS INT
COMMENT 'Cantidad de transacciones por cliente'
DETERMINISTIC
READS SQL DATA
	BEGIN 
		DECLARE existe BOOL;
        DECLARE total_transacciones INT;
        SET existe =(SELECT 
						IF(
							COUNT(id_cliente)=0, FALSE, TRUE)
                            FROM styles_by_bm.cliente
                            WHERE id_cliente = cid);
		IF existe THEN 
			SELECT COUNT(t.id_transaccion) INTO total_transacciones
            FROM transaccion AS t
			WHERE t.id_cliente = cid;
            RETURN total_transacciones;
				ELSE
					SIGNAL SQLSTATE '45000' 
					SET MESSAGE_TEXT = 'No existe el cliente', MYSQL_ERRNO = 1000;
		    END IF;
           
            
	END //


CREATE FUNCTION fn_dias_desde_ultima_transaccion(cid INT)
RETURNS INT
COMMENT 'Cantidad de días desde la última transacción del cliente'
DETERMINISTIC
READS SQL DATA
BEGIN 
    DECLARE dias INT;

    SELECT DATEDIFF(NOW(), MAX(t.fecha_transaccion)) INTO dias
    FROM transaccion t
    WHERE t.id_cliente = cid;

    IF dias IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'No existe el cliente o no tiene transacciones', MYSQL_ERRNO = 1000;
    END IF;

    RETURN dias;
END //

DELIMITER ;

-- PROCEEDURES:

DROP PROCEDURE IF EXISTS reportar_info_cliente;
DROP PROCEDURE IF EXISTS chequeo_transaccion_envio;
DELIMITER //
CREATE PROCEDURE reportar_info_cliente(
    IN cid INT
)
BEGIN
    SELECT 
		c.nombre_cliente,
        fn_total_transacciones(c.id_cliente),
        fn_dias_desde_ultima_transaccion(c.id_cliente)
        FROM cliente AS c
        WHERE cid = c.id_cliente;
END //

CREATE PROCEDURE chequeo_transaccion_envio(
    IN cid INT
)
BEGIN
	SELECT c.nombre_cliente,
    t.estado_transaccion,
	fn_dias_desde_ultima_transaccion(c.id_cliente)
    FROM cliente AS c
    JOIN transaccion AS t
		USING(id_cliente)
    WHERE cid = c.id_cliente;
END //

DELIMITER ;

-- TRIGGERS:
DELIMITER //

CREATE TRIGGER evitar_monto_cero
BEFORE INSERT ON transaccion
FOR EACH ROW
BEGIN
    IF NEW.monto_transaccion <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El monto de la transacción debe ser mayor que cero.';
    END IF;
END //
DELIMITER //
CREATE TRIGGER actualizar_stock_producto
AFTER INSERT ON detalle_transaccion
FOR EACH ROW
BEGIN
    UPDATE producto
    SET stock = stock - NEW.cantidad_producto
    WHERE id_producto = NEW.id_producto;
END //

DELIMITER ;






