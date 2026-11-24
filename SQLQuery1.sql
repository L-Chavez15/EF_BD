-- CREACION DE LA BASE DE DATOS
CREATE DATABASE TurismoCabrera_DB
GO
-- PONER EN USO LA BASE DE DATOS
USE TurismoCabrera_DB
GO

-- CREACION DE TABLAS PRINCIPALES

-- CREACION DE TABLA CLIENTE
CREATE TABLE CLIENTE
(
    ID_CLIENTE INT IDENTITY PRIMARY KEY NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    Tipo_cliente VARCHAR(30) NOT NULL,
    Direccion VARCHAR(150),
    Correo VARCHAR(100),
    Documento_identidad VARCHAR(20) NOT NULL UNIQUE,
    Telefono INT
)

-- CREACION DE TABLA TARIFA
CREATE TABLE TARIFA
(
    ID_Tarifa INT IDENTITY PRIMARY KEY NOT NULL,
    Nombre_tarifa VARCHAR(100) NOT NULL,
    Tipo VARCHAR(50) NOT NULL,
    Precio_Base DECIMAL(10,2) CHECK (Precio_Base >= 0),
    Estado VARCHAR(30),
    Precio_Por_Dia DECIMAL(10,2) CHECK (Precio_Por_Dia >= 0),
    Precio_Por_Kilometro DECIMAL(10,2) CHECK (Precio_Por_Kilometro >= 0)
)

-- CREACION DE TABLA CIUDAD
CREATE TABLE CIUDAD
(
    ID_CIUDAD INT IDENTITY PRIMARY KEY NOT NULL,
    Nombre VARCHAR(50) NOT NULL
)

-- CREACION DE TABLA PASAJERO
CREATE TABLE PASAJERO
(
    ID_Pasajero INT IDENTITY PRIMARY KEY NOT NULL,
    Nombres VARCHAR(100) NOT NULL,
    Apellidos VARCHAR(60) NOT NULL,
    Fecha_nacimiento DATE,
    Documento_identidad VARCHAR(20) NOT NULL UNIQUE,
    Genero VARCHAR(20),
    Telefono VARCHAR(20),
    Correo VARCHAR(100)
)

-- CREACION DE TABLA CONDUCTOR
CREATE TABLE CONDUCTOR
(
    ID_Conductor INT IDENTITY PRIMARY KEY NOT NULL,
    DNI VARCHAR(20) NOT NULL UNIQUE,
    Nombres VARCHAR(100) NOT NULL,
    Apellidos VARCHAR(60) NOT NULL,
    Disponibilidad BIT NOT NULL,
    Telefono VARCHAR(15),
    Edad INT CHECK (Edad > 0),
    Licencia VARCHAR(30),
    Record VARCHAR(250)
)


-- CREACION DE TABLA UNIDAD
CREATE TABLE UNIDAD
(
    ID_Unidad INT IDENTITY PRIMARY KEY NOT NULL,
    Placa VARCHAR(15) NOT NULL UNIQUE,
    Tipo_Unidad VARCHAR(50),
    Marca VARCHAR(50),
    Anio INT CHECK (Anio > 0),
    Capacidad INT CHECK (Capacidad > 0),
    Kilometraje DECIMAL(10,2) CHECK (Kilometraje >= 0)
)

-- CREACION DE TABLA SERVICIO

CREATE TABLE SERVICIO
(
    ID_servicio INT IDENTITY PRIMARY KEY NOT NULL,
    Tipo_servicio VARCHAR(100) NOT NULL,
    Fecha_inicio DATE NOT NULL,
    Itinerario VARCHAR(100),
    Fecha_final DATE,
    Hora_salida TIME,
    Destino VARCHAR(30),

    CHECK (Fecha_final IS NULL OR Fecha_final >= Fecha_inicio)
)

-- CREACION DE TABLAS DEPENDIENTES
-- CREACION DE TABLA RESERVA
CREATE TABLE RESERVA
(
    ID_reserva INT IDENTITY PRIMARY KEY NOT NULL,
    Estado VARCHAR(30),
    Monto_estimado DECIMAL(10,2) CHECK (Monto_estimado >= 0),
    Fecha_reserva DATE DEFAULT GETDATE(),
    Observaciones VARCHAR(250),
    Id_cliente INT NOT NULL,

    FOREIGN KEY (Id_cliente) REFERENCES CLIENTE(ID_CLIENTE)
)

-- CREACION DE TABLA COTIZACION
CREATE TABLE COTIZACION
(
    ID_Cotizacion INT IDENTITY PRIMARY KEY NOT NULL,
    Id_cliente INT NOT NULL,
    Id_servicio INT NOT NULL,
    ID_Tarifa INT NOT NULL,
    Fecha DATE DEFAULT GETDATE(),
    Observaciones VARCHAR(250),
    Monto DECIMAL(10,2) CHECK (Monto >= 0),
    Estado VARCHAR(30),
    Condiciones VARCHAR(250),

    FOREIGN KEY (Id_cliente) REFERENCES CLIENTE(ID_CLIENTE),
    FOREIGN KEY (Id_servicio) REFERENCES SERVICIO(ID_servicio),
    FOREIGN KEY (ID_Tarifa) REFERENCES TARIFA(ID_Tarifa)
)

-- CREACION DE TABLA PROMOCION
CREATE TABLE PROMOCION
(
    ID_Promocion INT IDENTITY PRIMARY KEY NOT NULL,
    Nombre_Promocion VARCHAR(100) NOT NULL,
    Estado VARCHAR(30),
    Porcentaje DECIMAL(5,2)
        CHECK (Porcentaje >= 0 AND Porcentaje <= 100),
    Descripcion VARCHAR(250),
    Fecha_Inicio DATE,
    Fecha_Fin DATE,
    ID_Tarifa INT NOT NULL,

    FOREIGN KEY (ID_Tarifa) REFERENCES TARIFA(ID_Tarifa),

    CHECK (Fecha_Fin IS NULL OR Fecha_Inicio IS NULL
           OR Fecha_Fin >= Fecha_Inicio)
)

-- CREACION DE TABLA RUTA
CREATE TABLE RUTA
(
    ID_ruta INT IDENTITY PRIMARY KEY NOT NULL,
    Origen VARCHAR(150),
    Destino VARCHAR(150),
    Duracion VARCHAR(50),
    Distancia DECIMAL(10,2) CHECK (Distancia >= 0),
    ID_Ciudad_Origen INT NOT NULL,
    ID_Ciudad_Destino INT NOT NULL,

    FOREIGN KEY (ID_Ciudad_Origen) REFERENCES CIUDAD(ID_CIUDAD),
    FOREIGN KEY (ID_Ciudad_Destino) REFERENCES CIUDAD(ID_CIUDAD)
)

-- CREACION DE TABLAS DE RELACION N:M

-- CREACION DE TABLA SERVICIO_RUTA
CREATE TABLE SERVICIO_RUTA
(
    ID_servicio INT NOT NULL,
    Id_ruta INT NOT NULL,

    PRIMARY KEY (ID_servicio, Id_ruta),

    FOREIGN KEY (ID_servicio) REFERENCES SERVICIO(ID_servicio),
    FOREIGN KEY (Id_ruta) REFERENCES RUTA(ID_ruta)
)


-- CREACION DE TABLA SERVICIO_PASAJERO
CREATE TABLE SERVICIO_PASAJERO
(
    ID_servicio INT NOT NULL,
    ID_Pasajero INT NOT NULL,

    PRIMARY KEY (ID_servicio, ID_Pasajero),

    FOREIGN KEY (ID_servicio) REFERENCES SERVICIO(ID_servicio),
    FOREIGN KEY (ID_Pasajero) REFERENCES PASAJERO(ID_Pasajero)
)


-- CREACION DE TABLA SERVICIO_CONDUCTOR
CREATE TABLE SERVICIO_CONDUCTOR
(
    ID_servicio INT NOT NULL,
    ID_Conductor INT NOT NULL,

    PRIMARY KEY (ID_servicio, ID_Conductor),

    FOREIGN KEY (ID_servicio) REFERENCES SERVICIO(ID_servicio),
    FOREIGN KEY (ID_Conductor) REFERENCES CONDUCTOR(ID_Conductor)
)


-- CREACION DE TABLA SERVICIO_UNIDAD
CREATE TABLE SERVICIO_UNIDAD
(
    ID_servicio INT NOT NULL,
    ID_Unidad INT NOT NULL,

    PRIMARY KEY (ID_servicio, ID_Unidad),

    FOREIGN KEY (ID_servicio) REFERENCES SERVICIO(ID_servicio),
    FOREIGN KEY (ID_Unidad) REFERENCES UNIDAD(ID_Unidad)
)

-- CREACION DE TABLA VIAJE
CREATE TABLE VIAJE
(
    ID_Viaje INT IDENTITY PRIMARY KEY NOT NULL,
    Fecha DATE NOT NULL,
    Hora_Salida TIME,
    Hora_Llegada TIME,
    Duracion VARCHAR(50),
    Distancia DECIMAL(10,2) CHECK (Distancia >= 0),
    Estado VARCHAR(30),
    ID_servicio INT NOT NULL,

    FOREIGN KEY (ID_servicio) REFERENCES SERVICIO(ID_servicio)
)

-- CREACION DE TABLA CONTRATO
CREATE TABLE CONTRATO
(
    ID_Contrato INT IDENTITY PRIMARY KEY NOT NULL,
    Estado VARCHAR(100),
    Fecha_Inicio DATE,
    Fecha_Fin DATE,
    Monto DECIMAL(10,2) CHECK (Monto >= 0),
    ID_Servicio INT NOT NULL,

    FOREIGN KEY (ID_Servicio) REFERENCES SERVICIO(ID_servicio),

    CHECK (Fecha_Fin IS NULL OR Fecha_Inicio IS NULL
           OR Fecha_Fin >= Fecha_Inicio)
)

-- CREACION DE TABLA PAGO
CREATE TABLE PAGO
(
    ID_Pago INT IDENTITY PRIMARY KEY NOT NULL,
    Forma_Pago VARCHAR(100) NOT NULL,
    Fecha_Pago DATE DEFAULT GETDATE(),
    Monto DECIMAL(10,2) CHECK (Monto >= 0),
    ID_Contrato INT NOT NULL,

    FOREIGN KEY (ID_Contrato) REFERENCES CONTRATO(ID_Contrato)
)

-- CREACION DE TABLA COMPROBANTE
CREATE TABLE COMPROBANTE
(
    ID_Comprobante INT IDENTITY PRIMARY KEY NOT NULL,
    Tipo VARCHAR(30),
    Nro_serie VARCHAR(30),
    Fecha_Emision DATE,
    Fecha_Vencimiento DATE,
    ID_Pago INT NOT NULL,

    FOREIGN KEY (ID_Pago) REFERENCES PAGO(ID_Pago)
)

-- CREACION DE TABLA MANTENIMIENTO
CREATE TABLE MANTENIMIENTO
(
    ID_Mantenimiento INT IDENTITY PRIMARY KEY NOT NULL,
    Tipo VARCHAR(50),
    Fecha DATE,
    Kilometraje DECIMAL(10,2) CHECK (Kilometraje >= 0),
    Observaciones VARCHAR(250),
    Solucion VARCHAR(250),
    Motivo VARCHAR(250),
    Costo DECIMAL(10,2) CHECK (Costo >= 0),
    Estado VARCHAR(30),
    ID_Unidad INT NOT NULL,

    FOREIGN KEY (ID_Unidad) REFERENCES UNIDAD(ID_Unidad)
)
-- REALIZAMOS REGISTROS
INSERT INTO CIUDAD (Nombre)
VALUES ('Lima'),('Cusco'),('Arequipa'), ('Trujillo'),('Piura')

INSERT INTO CLIENTE (Nombre, Tipo_cliente, Direccion, Correo, Documento_identidad, Telefono) 
VALUES ('Empresa Viajes SAC', 'Corporativo', 'Av. Javier Prado 123, Lima', 'contacto@viajessac.com', '20601234567', 987654321),
('María', 'Natural', 'Calle Los Pinos 456, Cusco', 'mrojas@gmail.com', '45678912', 951234567),
('Global Tours Perú', 'Corporativo', 'Calle Mercaderes 789, Arequipa', 'info@globaltours.pe', '20789456123', 943216789),
('Carlos', 'Natural', 'Urbanización Larrea 321, Trujillo', 'cmendoza@hotmail.com', '12345678', 978456123),
('Agencia de Turismo Norte', 'Corporativo', 'Av. Grau 987, Piura', 'ventas@tursnorte.com', '20543219876', 965432187)

INSERT INTO COMPROBANTE (Tipo, Nro_serie, Fecha_Emision, Fecha_Vencimiento, ID_Pago)
VALUES ('Factura', 'F001-000123', '2026-05-11', '2026-06-11', 1),
('Boleta', 'B001-000456', '2026-05-13', '2026-06-13', 2),
('Factura', 'F001-000124', '2026-05-16', '2026-06-16', 3),
('Boleta', 'B001-000457', '2026-05-20', '2026-06-20', 4),
('Factura', 'F001-000125', '2026-05-21', '2026-06-21', 5)

INSERT INTO CONDUCTOR (DNI, Nombres, Apellidos, Disponibilidad, Telefono, Edad, Licencia, Record) 
VALUES 
('40567890', 'Pedro','Jiménez', 1, '989111222', 42, 'A-III-c', 'Sin papeletas ni antecedentes'),
('41234567', 'Roberto','Mejía', 1, '989333444', 38, 'A-II-b', 'Una infracción leve registrada'),
('42345678', 'Manuel','Paredes', 0, '989555666', 45, 'A-III-c', 'Historial limpio'),
('43456789', 'Segundo','Cabrera', 1, '989777888', 39, 'A-II-b', 'Sin observaciones'),
('44567890', 'Erick','Silva', 1, '989999000', 33, 'A-III-c', 'Excelente récord de conducción')

INSERT INTO CONTRATO (Estado, Fecha_Inicio, Fecha_Fin, Monto, ID_Servicio) VALUES 
('Vigente', '2026-06-01', '2026-06-01', 1200.00, 1),
('Vigente', '2026-06-05', '2026-06-05', 450.00, 2),
('Vigente', '2026-06-10', '2026-06-12', 2500.00, 3),
('Borrador', '2026-06-15', '2026-06-16', 850.00, 4),
('Vigente', '2026-06-20', '2026-06-22', 1800.00, 5);

INSERT INTO COTIZACION (Id_cliente, Id_servicio, ID_Tarifa, Fecha, Observaciones, Monto, Estado, Condiciones) VALUES 
(1, 1, 1, '2026-05-11', 'Cotización para grupo corporativo', 1200.00, 'Aceptada', 'Pago a 30 días'),
(2, 2, 4, '2026-05-13', 'Cotización traslado aeropuerto', 450.00, 'Aceptada', 'Pago al contado'),
(3, 3, 3, '2026-05-16', 'Paquete completo Colca', 2500.00, 'Aceptada', '50% adelanto, 50% al iniciar'),
(4, 4, 2, '2026-05-19', 'Servicio ejecutivo Trujillo', 850.00, 'Pendiente', 'Sujeto a disponibilidad'),
(5, 5, 5, '2026-05-21', 'VIP Máncora', 1800.00, 'Aceptada', 'Todo incluido')

INSERT INTO MANTENIMIENTO (Tipo, Fecha, Kilometraje, Observaciones, Solucion, Motivo, Costo, Estado, ID_Unidad) VALUES 
('Preventivo', '2026-04-10', 44000.00, 'Cambio de aceite y filtros', 'Reemplazo completado con éxito', 'Mantenimiento por kilometraje', 350.00, 'Completado', 1),
('Correctivo', '2026-04-15', 118000.00, 'Revisión del sistema de frenos', 'Cambio de pastillas de freno', 'Desgaste normal', 850.00, 'Completado', 2),
('Preventivo', '2026-04-20', 18000.00, 'Alineación y balanceo', 'Ajustes en suspensión', 'Mantenimiento preventivo', 200.00, 'Completado', 3),
('Preventivo', '2026-04-25', 50000.00, 'Revisión general del motor', 'Cambio de bujías y líquido refrigerante', 'Kilometraje cumplido', 450.00, 'Completado', 4),
('Correctivo', '2026-05-02', 158000.00, 'Falla en el sistema eléctrico', 'Reparación de alternador', 'Vehículo no encendía', 1200.00, 'Completado', 5)

INSERT INTO PAGO (Forma_Pago, Fecha_Pago, Monto, ID_Contrato) 
VALUES ('Transferencia Bancaria', '2026-05-11', 1200.00, 1),
('Tarjeta de Crédito', '2026-05-13', 450.00, 2),
('Depósito BCP', '2026-05-16', 1250.00, 3),
('Yape', '2026-05-20', 850.00, 4),
('Transferencia BCP', '2026-05-21', 1800.00, 5)

INSERT INTO PASAJERO (Nombres, Apellidos, Fecha_nacimiento, Documento_identidad, Genero, Telefono, Correo) 
VALUES ('Juan', 'Pérez', '1985-04-12', '40123456', 'Masculino', '987123456', 'jperez@gmail.com'),
('Ana', 'Torres', '1992-09-25', '45678901', 'Femenino', '952345678', 'atorres@hotmail.com'),
('Luis', 'Castro', '1988-11-03', '42345678', 'Masculino', '943456789', 'lcastro@yahoo.com'),
('Carmen', 'Vargas ', '1995-02-19', '47890123', 'Femenino', '974567891', 'cvargas@gmail.com'),
('Jorge', 'Huamán', '1980-07-30', '23456789', 'Masculino', '965678912', 'jhuaman@outlook.com')

INSERT INTO PROMOCION (Nombre_Promocion, Estado, Porcentaje, Descripcion, Fecha_Inicio, Fecha_Fin, ID_Tarifa) 
VALUES ('Descuento Verano Cusco', 'Activo', 15.00, '15% de descuento en tarifa básica de turismo', '2026-06-01', '2026-06-30', 1),
('Promo Corporativa Aniversario', 'Activo', 10.00, 'Descuento especial para clientes corporativos', '2026-06-01', '2026-12-31', 2),
('Aventura de Finde', 'Inactivo', 20.00, '20% off en rutas de aventura', '2026-01-01', '2026-03-31', 3),
('Campaña Local', 'Activo', 5.00, 'Descuento para residentes locales', '2026-06-01', '2026-07-01', 4),
('VIP Early Bird', 'Activo', 25.00, 'Reserva anticipada VIP', '2026-05-01', '2026-08-31', 5)

INSERT INTO RESERVA (Estado, Monto_estimado, Fecha_reserva, Observaciones, Id_cliente) 
VALUES ('Confirmada', 1200.00, '2026-05-10', 'Cliente solicita guía bilingüe', 1),
('Pendiente', 450.00, '2026-05-12', 'Requiere factura electrónica', 2),
('Confirmada', 2500.00, '2026-05-15', 'Pago adelantado recibido del 50%', 3),
('Cancelada', 300.00, '2026-05-18', 'Cancelado por motivos de fuerza mayor', 4),
('Confirmada', 900.00, '2026-05-20', 'Incluye refrigerios a bordo', 5)

INSERT INTO RUTA (Origen, Destino, Duracion, Distancia, ID_Ciudad_Origen, ID_Ciudad_Destino) 
VALUES 
('Aeropuerto Velasco Astete', 'Centro de Cusco', '00:30 hrs', 8.50, 2, 2),
('Lima Aeropuerto', 'San Isidro Lima', '00:45 hrs', 16.20, 1, 1),
('Arequipa Centro', 'Chivay Colca', '03:30 hrs', 160.00, 3, 3),
('Trujillo Centro', 'Ruinas de Chan Chan', '00:25 hrs', 12.00, 4, 4),
('Piura Terminal', 'Máncora Playa', '02:45 hrs', 185.50, 5, 5)

INSERT INTO SERVICIO (Tipo_servicio, Fecha_inicio, Itinerario, Fecha_final, Hora_salida, Destino) 
VALUES ('City Tour Cusco', '2026-06-01', 'Centro Histórico - Sacsayhuamán', '2026-06-01', '08:00:00', 'Cusco'),
('Traslado Ejecutivo Lima', '2026-06-05', 'Aeropuerto - Hotel Marriott', '2026-06-05', '14:30:00', 'Lima'),
('Tour Arequipa y Cañón del Colca', '2026-06-10', 'Arequipa - Chivay - Colca', '2026-06-12', '06:00:00', 'Colca'),
('Viaje Corporativo Trujillo', '2026-06-15', 'Trujillo - Huanchaco - Ruinas', '2026-06-16', '09:00:00', 'Trujillo'),
('Excursión Playas Piura', '2026-06-20', 'Piura - Máncora', '2026-06-22', '07:30:00', 'Máncora')

INSERT INTO SERVICIO_CONDUCTOR (ID_servicio, ID_Conductor) 
VALUES (1, 1),
(2, 2),
(3, 4),
(4, 5),
(5, 1)

INSERT INTO SERVICIO_PASAJERO (ID_servicio, ID_Pasajero) 
VALUES (1, 1),
(1, 2),
(2, 3),
(3, 4),
(5, 1)

INSERT INTO SERVICIO_RUTA (ID_servicio, Id_ruta) 
VALUES (1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5)

INSERT INTO SERVICIO_UNIDAD (ID_servicio, ID_Unidad) 
VALUES (1, 1),
(2, 4),
(3, 2),
(4, 3),
(5, 5)

INSERT INTO TARIFA (Nombre_tarifa, Tipo, Precio_Base, Estado, Precio_Por_Dia, Precio_Por_Kilometro) 
VALUES ('Tarifa Turística Básica', 'Turismo', 150.00, 'Activo', 50.00, 2.50),
('Tarifa Corporativa Ejecutiva', 'Corporativo', 300.00, 'Activo', 80.00, 3.50),
('Tarifa Aventura Extrema', 'Aventura', 200.00, 'Activo', 60.00, 3.00),
('Tarifa Económica Local', 'Local', 80.00, 'Activo', 30.00, 1.50),
('Tarifa VIP Todo Incluido', 'VIP', 500.00, 'Activo', 150.00, 5.00)

INSERT INTO UNIDAD (Placa, Tipo_Unidad, Marca, Anio, Capacidad, Kilometraje) 
VALUES ('ABC-123', 'Minivan', 'Mercedes-Benz', 2022, 15, 45000.50),
('XYZ-789', 'Bus', 'Volvo', 2021, 45, 120000.00),
('MNO-456', 'Camioneta 4x4', 'Toyota', 2023, 5, 18500.25),
('DEF-321', 'Minivan', 'Hyundai', 2022, 12, 52000.00),
('GHI-654', 'Bus', 'Scania', 2020, 50, 160000.80)

INSERT INTO VIAJE (Fecha, Hora_Salida, Hora_Llegada, Duracion, Distancia, Estado, ID_servicio) 
VALUES ('2026-06-01', '08:00:00', '12:00:00', '04:00 hrs', 8.50, 'Programado', 1),
('2026-06-05', '14:30:00', '15:15:00', '00:45 hrs', 16.20, 'Programado', 2),
('2026-06-10', '06:00:00', '09:30:00', '03:30 hrs', 160.00, 'Programado', 3),
('2026-06-15', '09:00:00', '09:25:00', '00:25 hrs', 12.00, 'Programado', 4),
('2026-06-20', '07:30:00', '10:15:00', '02:45 hrs', 185.50, 'Programado', 5)

-- MOSTRAMOS LAS TABLAS CREADAS

SELECT * FROM CIUDAD
SELECT * FROM CLIENTE
SELECT * FROM RESERVA
SELECT * FROM COTIZACION
SELECT * FROM TARIFA
SELECT * FROM PROMOCION
SELECT * FROM CONTRATO
SELECT * FROM PAGO
SELECT * FROM COMPROBANTE
SELECT * FROM SERVICIO
SELECT * FROM RUTA
SELECT * FROM SERVICIO_RUTA
SELECT * FROM VIAJE
SELECT * FROM PASAJERO
SELECT * FROM SERVICIO_PASAJERO
SELECT * FROM CONDUCTOR
SELECT * FROM SERVICIO_CONDUCTOR
SELECT * FROM UNIDAD
SELECT * FROM SERVICIO_UNIDAD
SELECT * FROM MANTENIMIENTO