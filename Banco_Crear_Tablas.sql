/*
 * Base de datos Banco TechCamp
 * Descripción
 * Esquema de la base de datos relacional para el modelo de negocio de 
 * un banco. 
 * Autor: Daniel Dávila Lesmes
 * Contacto: daniel.davila@segurosbolivar.com 
 * Cel: 322 777 48 28
 * 
 */

-- Ejecute los comandos de forma descendente y en el mismo orden para
-- poder crear las tablas adecuadamente.
--Sección 1. Creación de Tablas
----------------------------------------------------------------------------------------

--1. Crear la tabla usuario 
--(Contiene los datos asociados a la cuenta de usuario para login como id y contraseña)

CREATE TABLE USUARIO(
	usu_usuario VARCHAR(50),
	usu_contrasenia VARCHAR(100) NOT NULL,
	usu_activo NUMBER(1,0) DEFAULT 1,
	usu_fecha_creacion DATE NOT NULL,
	PRIMARY KEY (usu_usuario)
);

--2. Crear la tabla sucursal 
-- (Contiene los datos básicos de contacto asociados a la sucursal bancaria) 

CREATE TABLE SUCURSAL(
	suc_id NUMBER generated as identity,
	suc_nombre VARCHAR(100),
	suc_direccion VARCHAR(100),
	suc_telefono NUMBER(10),
	PRIMARY KEY (suc_id)
);
INSERT INTO SUCURSAL(suc_nombre,suc_direccion,suc_telefono) VALUES ('Bogota Venecia','Cra 1 no 30-160',3007006060);

--3. Crear la tabla Persona
-- (Contiene los datos básicos de una persona)
-- Importante: Los datos asociados a esta tabla pueden ser considerados datos
-- sensibles de acuerdo a la ley de Habeas Data.

CREATE TABLE PERSONA (
	per_id NUMBER GENERATED AS IDENTITY,
	per_documento NUMBER UNIQUE NOT NULL,
	per_nombres VARCHAR(100) NOT NULL,
	per_primer_apellido VARCHAR(50) NOT NULL,
	per_segundo_apellido VARCHAR(50) NOT NULL,
	per_direccion VARCHAR(100),
	per_celular NUMBER(10),
	per_correo VARCHAR(100),
	per_usu_usuario VARCHAR(100) UNIQUE NOT NULL,
	per_suc_id NUMBER,
	
	PRIMARY KEY (per_id,per_suc_id,per_documento),
	FOREIGN KEY (per_usu_usuario) REFERENCES USUARIO(usu_usuario),
	FOREIGN KEY (per_suc_id) REFERENCES SUCURSAL(suc_id)
);

-- 4. Crear la tabla tipo de cuenta
-- Contiene los tipos de cuenta asociados al banco y su descripción.

CREATE TABLE TIPO_CUENTA(
	tipcue_id NUMBER generated as identity,
	tipcue_abreviado VARCHAR(10),
	tipcue_nombre VARCHAR(30),
	tipcue_descripcion VARCHAR(300),
	PRIMARY KEY (tipcue_id)
);

-- 5. Crear la tabla cuenta bancaria
-- Contiene lso datos básicos asociados a la cuenta para poder realizar transacciones

CREATE TABLE CUENTA_BANCARIA(
	cue_id NUMBER NOT NULL,
	cue_tipcue_id NUMBER,
	cue_per_documento NUMBER,
	cue_fecha_apertura DATE NOT NULL,
	cue_contrasenia VARCHAR(100) NOT NULL,
	cue_activa NUMBER(1,0) NOT NULL,
	cue_saldo NUMBER,
	cue_tasa_interes NUMBER NOT NULL,
	cue_fecha_cierre DATE,
	
	PRIMARY KEY (cue_id),
	FOREIGN KEY (cue_tipcue_id) REFERENCES TIPO_CUENTA(tipcue_id),
	FOREIGN KEY (cue_per_documento) REFERENCES PERSONA(per_documento)
);
-- 6. Crear la tabla tipo de transaccion
-- Servicios que se pueden realizar con las cuentas
CREATE TABLE TIPO_TRANSACCION(
	tiptr_id NUMBER generated as identity,
	tiptr_nombre VARCHAR(20),
	tiptr_descripción VARCHAR(300),
	
	PRIMARY KEY (tiptr_id)
);

-- 7. Crear la tabla Transacciones
-- Movimientos que se realizan como consignaciones, retiros entre otros.

CREATE TABLE TRANSACCION (
	tra_id VARCHAR(100),
	tra_fecha TIMESTAMP NOT NULL,
	tra_tiptr_id NUMBER NOT NULL,
	tra_valor NUMBER NOT NULL,
	tra_origen_cue_id NUMBER NOT NULL,
	tra_destino_cue_id NUMBER,
	tra_estado NUMBER(1,0) NOT NULL,
	tra_suc_id NUMBER, 
	PRIMARY KEY (tra_id),
	FOREIGN KEY (tra_tiptr_id) REFERENCES TIPO_TRANSACCION(tiptr_id),
	FOREIGN KEY (tra_origen_cue_id) REFERENCES CUENTA_BANCARIA(cue_id),
	FOREIGN KEY (tra_destino_cue_id) REFERENCES CUENTA_BANCARIA(cue_id),
	FOREIGN KEY (tra_suc_id) REFERENCES SUCURSAL(suc_id)
	
);