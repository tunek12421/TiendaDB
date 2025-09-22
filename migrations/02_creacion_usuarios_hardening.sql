
START TRANSACTION;



CREATE USER IF NOT EXISTS 'cajero'@'localhost' IDENTIFIED BY 'cajero123';

CREATE USER IF NOT EXISTS 'gerente'@'localhost' IDENTIFIED BY 'gerente123';

CREATE USER IF NOT EXISTS 'admin_tecnico'@'localhost' IDENTIFIED BY 'admintecnico123';



FLUSH PRIVILEGES;



COMMIT;



SELECT 'Usuario creados exitosamente: cajero, gerente, admin_tecnico' as status;

