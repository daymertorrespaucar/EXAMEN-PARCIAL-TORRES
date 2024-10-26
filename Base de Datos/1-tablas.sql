
-- USE Ventas2023
-- DROP DATABASE TRAVEL_EASY

CREATE DATABASE TRAVEL_EASY;
GO
USE TRAVEL_EASY;
GO

CREATE TABLE empresa_hotelera (
    id_empresa_hotel INT PRIMARY KEY IDENTITY(1, 1),
    razon_social VARCHAR(255),
    ruc VARCHAR(255),
    direccion VARCHAR(255),
    telefono_central VARCHAR(255)
);

CREATE TABLE sucursal (
    id_empresa_hotel INT DEFAULT 1, --SOLO SE PERMITIRÁ UN HOTEL
    id_sucursal INT PRIMARY KEY IDENTITY(1, 1),
    nombre VARCHAR(255),
    ciudad VARCHAR(255),
    distrito VARCHAR(255),
    direccion VARCHAR(255),
    telefono_sucursal VARCHAR(255),

    FOREIGN KEY (id_empresa_hotel) REFERENCES empresa_hotelera (id_empresa_hotel)
);
--añadiendo a sucursal la columna estado de tipo bit y not null y default 1
ALTER TABLE sucursal
ADD estado bit NOT NULL DEFAULT 1;

CREATE TABLE tipo_habitacion (
    id_tipo_habitacion INT PRIMARY KEY IDENTITY(1, 1),
    tipo VARCHAR(255),
    capacidad INT,
    descripcion VARCHAR(255),
    precio DECIMAL(10, 2)
);
--añaadiendo a tipo_habitacion la columna estado de tipo bit y not null y default 1
ALTER TABLE tipo_habitacion
ADD estado bit NOT NULL DEFAULT 1;

CREATE TABLE habitaciones (
    id_sucursal INT,
    id_habitacion INT IDENTITY(1, 1),
    piso INT,
    puerta INT,
    id_tipo_habitacion INT,
    PRIMARY KEY (id_habitacion),
    FOREIGN KEY (id_sucursal) REFERENCES sucursal (id_sucursal),
    FOREIGN KEY (id_tipo_habitacion) REFERENCES tipo_habitacion (id_tipo_habitacion)
);
--añadiendo a habitaciones la columna estado de tipo bit y not null y default 1
ALTER TABLE habitaciones
ADD estado bit NOT NULL DEFAULT 1;

--añadiendo constrains a id_sucursal delete restrict y update cascade
ALTER TABLE habitaciones
ADD CONSTRAINT fk_id_sucursal
FOREIGN KEY (id_sucursal) REFERENCES sucursal (id_sucursal)
ON UPDATE CASCADE;

-- no se puede repetir en una sucursal habitaciones con el mismo piso y puerta
ALTER TABLE habitaciones
ADD CONSTRAINT UQ_sucursal_piso_puerta 
UNIQUE (id_sucursal, piso, puerta);



CREATE TABLE cargos (
    id_cargo INT PRIMARY KEY IDENTITY(1, 1),
    nombre VARCHAR(255),
    descripcion VARCHAR(255)
);

CREATE TABLE empleados (
    id_empleado INT PRIMARY KEY IDENTITY(1, 1),
    id_sucursal INT,
    id_cargo INT,
    dni_empleado INT NOT NULL UNIQUE,
    nombre VARCHAR(255),
    apellido VARCHAR(255),
    celular VARCHAR(255),
    contrasena VARCHAR(255),

    FOREIGN KEY (id_sucursal) REFERENCES sucursal (id_sucursal),
    FOREIGN KEY (id_cargo) REFERENCES cargos (id_cargo)
)
--añaadiendo constrains a id_sucursal delete set null y update cascade 
ALTER TABLE empleados
ADD CONSTRAINT fk_id_sucursal_empleados
FOREIGN KEY (id_sucursal) REFERENCES sucursal (id_sucursal)
ON UPDATE CASCADE
ON DELETE SET NULL;

CREATE TABLE clientes (
    dni_cliente INT PRIMARY KEY,
    nombre VARCHAR(255),
    apellido VARCHAR(255),
    celular VARCHAR(255)
);

CREATE TABLE reserva (
    id_reserva INT PRIMARY KEY IDENTITY(1, 1),
    
    id_habitacion INT,

    id_empleado INT,
    dni_cliente INT,
    fecha_inicio DATE,
    fecha_fin DATE,
    estado VARCHAR(255) DEFAULT 'Pendiente',

    FOREIGN KEY (id_habitacion) REFERENCES habitaciones (id_habitacion),
    FOREIGN KEY (id_empleado) REFERENCES empleados (id_empleado),
    FOREIGN KEY (dni_cliente) REFERENCES clientes (dni_cliente)
);
--añadiendo constrains a id_empleado update cascade
ALTER TABLE reserva
ADD CONSTRAINT fk_id_empleado
FOREIGN KEY (id_empleado) REFERENCES empleados (id_empleado)
ON UPDATE CASCADE;

--añadiendo constrains a dni_cliente delete set null y update cascade
ALTER TABLE reserva
ADD CONSTRAINT fk_dni_cliente
FOREIGN KEY (dni_cliente) REFERENCES clientes (dni_cliente)
ON UPDATE CASCADE
ON DELETE SET NULL;

CREATE TABLE boleta (
    id_boleta INT PRIMARY KEY IDENTITY(1, 1),
    id_reserva INT,
    fecha_emision DATE,
    concepto VARCHAR(255),
    cantidad_dias INT,
    cupon DECIMAL(10, 2),
    monto_total DECIMAL(10, 2),
    FOREIGN KEY (id_reserva) REFERENCES reserva (id_reserva)
);




------------------------ IDEAS: --------------------------------

/* Declarar como regla de empresa que el cliente debe pagar la reserva como plazo maximo el mismo dia que comienza su estadia en el hotel. IMPORTANTE
 * hacer un trigger que se dispare para eliminar las reservas que no se pagaron en el plazo maximo (se puede disparar todos los dias a las 11am por ejemplo)
 * Poder buscar habitaciones disponibles por tipo de habitacion (ej: simple, doble, triple, etc) Solo variar un poco la funcion ya existente
 * Registras la fecha de registro del cliente en el hotel (POR TRIGGERS AL INGRESAR UN NUEVO CLIENTE)
 * Borrar reservas que usuario comunica quiere cancelar / o simplemente colocarlas como "Cancelada". No sé si esto sea conveniente en el proyecto, nos 
        daría mas trabajo ya que estas se cancelan solas si no las ocupan.
 * (Supuesto) Alquien busca una habitacion, se muestran 2 habitaciones del mismo 
        tipo pero una de ellas tiene una reserva no pagada y la otra esta completamente 
        libre, hambas habitaciones se mostraran para que se puedan reservar; la 
        pregunta es: ¿Se deberia ocultar la habitacion para esperar a la persona que aun no ha pagado?
*/



