CREATE TABLE estados(
id_estado INT PRIMARY KEY,
descripcion VARCHAR(50),
tipo VARCHAR(50)
);

CREATE TABLE empleados(
id_empleado SERIAL PRIMARY KEY,
nombre VARCHAR(100),
centro_trabajo VARCHAR(40),
puesto VARCHAR(50),
estado INT REFERENCES estados(id_estado)
);

CREATE TABLE tipo_usuarios(
id_tipo_usuario SERIAL PRIMARY KEY,
descripcion VARCHAR(50)
);

CREATE TABLE usuarios(
id_usuario SERIAL PRIMARY KEY,
id_empleado INT REFERENCES empleados(id_empleado),
correo VARCHAR(100) UNIQUE,
password_hash VARCHAR(255),
id_tipo_usuario INT REFERENCES tipo_usuarios(id_tipo_usuario)
);

CREATE TABLE zonas(
id_zona SERIAL PRIMARY KEY,
acronimo VARCHAR(10),
zona VARCHAR(30)
);

CREATE TABLE fincas(
id_finca SERIAL PRIMARY KEY,
finca VARCHAR(40),
finca_inv VARCHAR(40),
productor VARCHAR(40),
id_zona INT REFERENCES zonas(id_zona),
municipio VARCHAR(40),
propietario VARCHAR(60),
proveedor VARCHAR(40),
estado INT REFERENCES estados(id_estado)
);

CREATE TABLE tipo_persona(
id_tipo_persona SERIAL PRIMARY KEY,
descripcion VARCHAR(40),
longitud_rfc INT
);

CREATE TABLE clientes(
id_cliente SERIAL PRIMARY KEY,
razon_social VARCHAR(60),
rfc VARCHAR(13),
id_tipo_persona INT REFERENCES tipo_persona(id_tipo_persona),
acronimo VARCHAR(10),
cedis VARCHAR(40),
estado INT REFERENCES estados(id_estado)
);

CREATE TABLE producto_terminado(
id_producto_terminado SERIAL PRIMARY KEY,
sku VARCHAR(10),
calidad	VARCHAR(80)
);

CREATE TABLE estiba(
id_estiba SERIAL PRIMARY KEY,
tipo VARCHAR(30),
descripcion VARCHAR(80)
);

CREATE TABLE plan_produccion(
id_plan_produccion SERIAL PRIMARY KEY,
semana INT,
id_zona INT REFERENCES zonas(id_zona),
id_finca INT REFERENCES fincas(id_finca),
fecha_empaque DATE,
dias_transito INT,
fecha_cita DATE,
id_cliente INT REFERENCES clientes(id_cliente),
id_producto_terminado INT REFERENCES producto_terminado (id_producto_terminado),
cajas_programadas INT,
id_estiba INT REFERENCES estiba(id_estiba),
comentarios VARCHAR(100),
lote VARCHAR(18),
estado INT REFERENCES estados(id_estado)
);

CREATE TABLE campos_editado(	
id_campo_editado SERIAL PRIMARY KEY,
nombre VARCHAR(80),
comentarios VARCHAR(120),
estado INT REFERENCES estados(id_estado)
);

CREATE TABLE cambios_plan(
id_cambio_plan SERIAL PRIMARY KEY,
id_plan_produccion INT REFERENCES plan_produccion(id_plan_produccion),
id_campo_editado INT REFERENCES campos_editado(id_campo_editado),
valor_anterior VARCHAR(80),
valor_nuevo VARCHAR(80),
motivo VARCHAR(120),
id_usuario INT REFERENCES usuarios(id_usuario)
);

CREATE TABLE lineas_fleteras(
id_linea_fletera SERIAL PRIMARY KEY,
razon_social VARCHAR(80),
rfc VARCHAR(13) UNIQUE,
id_tipo_persona INT REFERENCES tipo_persona(id_tipo_persona),
representante_legal VARCHAR(80),
telefono VARCHAR(10),
email VARCHAR(80),
regimen VARCHAR(80),
estado INT REFERENCES estados(id_estado)
);

CREATE TABLE tipo_servicio(
id_tipo_servicio SERIAL PRIMARY KEY,
tipo VARCHAR(30),
capacidad VARCHAR(20),
descripcion VARCHAR(80)
);

CREATE TABLE operadores(
id_operador SERIAL PRIMARY KEY,
nombre VARCHAR(100),
licencia VARCHAR(40),
id_linea_fletera INT REFERENCES lineas_fleteras(id_linea_fletera),
telefono VARCHAR(10)
);

CREATE TABLE tractos(
id_tracto SERIAL PRIMARY KEY,
placas VARCHAR(10),
color VARCHAR(20),
modelo VARCHAR(30),
marca VARCHAR(30),
id_linea_fletera INT REFERENCES lineas_fleteras(id_linea_fletera),
descripcion VARCHAR(100)
);

CREATE TABLE cajas_refrigeradas(
id_caja_refrigerada SERIAL PRIMARY KEY,
placas VARCHAR(10),
economico VARCHAR(10),
id_tracto INT REFERENCES tractos(id_tracto)
);

CREATE TABLE flete_terrestre(
id_flete_terrestre SERIAL PRIMARY KEY,
oc VARCHAR(20),
ov VARCHAR(20),
envio_operacion VARCHAR(20),
prefactura VARCHAR(20),
id_plan_produccion INT REFERENCES plan_produccion(id_plan_produccion),
id_linea_fletera INT REFERENCES lineas_fleteras(id_linea_fletera),
id_tipo_servicio INT REFERENCES tipo_servicio(id_tipo_servicio),
tarifa NUMERIC(10,2),
estado INT REFERENCES estados(id_estado)
);

CREATE TABLE gastos(
id_gasto SERIAL PRIMARY KEY,
descripcion VARCHAR(100)
);

CREATE TABLE gasto_adicional(
id_gasto_adicional SERIAL PRIMARY KEY,
id_flete_terrestre INT REFERENCES flete_terrestre(id_flete_terrestre),
id_gasto INT REFERENCES gastos(id_gasto),
precio NUMERIC(10,2)
);

CREATE TABLE despachos(
id_despacho SERIAL PRIMARY KEY,
fecha DATE DEFAULT CURRENT_DATE(),
hora TIME,
id_plan_produccion INT REFERENCES plan_produccion(id_plan_produccion),
cantidad_despachada INT CHECK (cantidad_despachada >= 0),
id_flete_terrestre INT REFERENCES flete_terrestre(id_flete_terrestre),
id_operador INT REFERENCES operadores(id_operador),
id_tracto INT REFERENCES tractos(id_tracto),
id_caja_refrigerada INT REFERENCES cajas_refrigeradas(id_caja_refrigerada),
termografo VARCHAR(20)
);

CREATE TABLE recepciones(
id_recepcion SERIAL PRIMARY KEY,
id_despacho INT REFERENCES despachos(id_despacho),
fecha DATE DEFAULT CURRENT_DATE(),
hora TIME,
id_cliente INT REFERENCES clientes(id_cliente),
cantidad_ok INT CHECK (cantidad_ok >= 0),
cantidad_rechazada INT CHECK (cantidad_rechazada >= 0),
observaciones VARCHAR(100),
id_empleado INT REFERENCES empleados(id_empleado),
estado INT REFERENCES estados(id_estado)
);

CREATE TABLE factura_flete(
id_factura_flete SERIAL PRIMARY KEY,
id_flete_terrestre INT REFERENCES flete_terrestre(id_flete_terrestre),
folio VARCHAR(20),
fecha_emision DATE,
uuid VARCHAR(20) UNIQUE,
subtotal NUMERIC(10,2),
iva NUMERIC(10,2),
retencion NUMERIC(10,2),
total NUMERIC(10,2),
fecha_pago DATE,
estado INT REFERENCES estados(id_estado)
);