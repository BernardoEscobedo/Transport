CREATE TABLE estados(
id_estado SERIAL PRIMARY KEY,
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
id_tipo_usuario INT REFERENCES tipo_usuarios(id_tipo_usuario),
estado INT REFERENCES estados(id_estado)
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

CREATE TABLE camaras_preenfrio(
id_preenfrio SERIAL PRIMARY KEY,
razon_social VARCHAR(80),
rfc VARCHAR(13) UNIQUE,
id_tipo_persona INT REFERENCES tipo_persona(id_tipo_persona),
id_zona INT REFERENCES zonas(id_zona),
tarifa NUMERIC(10,2),
comision NUMERIC(10,2)
);

CREATE TABLE almacenes_pt(
id_almacen_pt SERIAL PRIMARY KEY,
descripcion VARCHAR(100),
id_zona INT REFERENCES zonas(id_zona)
);

CREATE TABLE citas(
id_cita SERIAL PRIMARY KEY,
id_cliente INT REFERENCES clientes(id_cliente),
fecha_cita DATE NOT NULL,
hora_cita TIME NOT NULL,
cita VARCHAR(30),
confirmacion VARCHAR(30),
estado INT REFERENCES estados(id_estado)
);

CREATE TABLE plan_produccion(
id_plan_produccion SERIAL PRIMARY KEY,
semana INT,
id_zona INT REFERENCES zonas(id_zona),
id_finca INT REFERENCES fincas(id_finca),
fecha_empaque DATE,
dias_transito INT
);

CREATE TABLE detalle_plan_produccion(
id_detalle_plan_prod SERIAL PRIMARY KEY,
id_plan_produccion INT REFERENCES plan_produccion(id_plan_produccion),
id_cita INT REFERENCES citas(id_cita),
id_producto_terminado INT REFERENCES producto_terminado (id_producto_terminado),
cajas_procesadas INT,
id_estiba INT REFERENCES estiba(id_estiba),
comentarios VARCHAR(100),
lote VARCHAR(18),
id_preenfrio INT REFERENCES camaras_preenfrio(id_preenfrio),
estado INT REFERENCES estados(id_estado),
observaciones VARCHAR(150)
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
telefono VARCHAR(10),
estado INT REFERENCES estados(id_estado)
);

CREATE TABLE tractos(
id_tracto SERIAL PRIMARY KEY,
placas VARCHAR(10),
color VARCHAR(20),
modelo VARCHAR(30),
marca VARCHAR(30),
id_linea_fletera INT REFERENCES lineas_fleteras(id_linea_fletera),
descripcion VARCHAR(100),
estado INT REFERENCES estados(id_estado)
);

CREATE TABLE cajas_refrigeradas(
id_caja_refrigerada SERIAL PRIMARY KEY,
placas VARCHAR(10),
economico VARCHAR(10),
id_tracto INT REFERENCES tractos(id_tracto),
estado INT REFERENCES estados(id_estado)
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
fecha DATE DEFAULT CURRENT_DATE,
hora TIME,
folio_embarque VARCHAR(20),
origen_tipo VARCHAR(20) CHECK(origen_tipo IN ('FINCA','PREENFRIO')),
id_usuario INT REFERENCES usuarios(id_usuario),
estado INT REFERENCES estados(id_estado)
);

CREATE TABLE detalle_despachos(
id_detalle_despachos SERIAL PRIMARY KEY,
id_despacho INT REFERENCES despachos(id_despacho),
id_almacen_pt INT REFERENCES almacenes_pt(id_almacen_pt), --Aqui se colocal si es almacen de finca o almacen de preenfrio
cantidad_despachada INT CHECK (cantidad_despachada >= 0), --Cantidad fisica cargada
peso DECIMAL(10,2),
temperatura DECIMAL(5,2),
id_flete_terrestre INT REFERENCES flete_terrestre(id_flete_terrestre),
id_operador INT REFERENCES operadores(id_operador),
id_tracto INT REFERENCES tractos(id_tracto),
id_caja_refrigerada INT REFERENCES cajas_refrigeradas(id_caja_refrigerada),
termografo VARCHAR(20),
observaciones VARCHAR(300)
);

CREATE TABLE recepciones(
id_recepcion SERIAL PRIMARY KEY,
id_despacho INT REFERENCES despachos(id_despacho),
fecha DATE DEFAULT CURRENT_DATE,
hora TIME,
estado INT REFERENCES estados(id_estado)
);

CREATE TABLE detalle_recepciones(
id_detalle_recepcion SERIAL PRIMARY KEY,
id_recepcion INT REFERENCES recepciones(id_recepcion),
id_cliente INT REFERENCES clientes(id_cliente),
cantidad_ok INT CHECK (cantidad_ok >= 0),
cantidad_rechazada INT DEFAULT 0,
diferencias_cajas INT,
temperatura DECIMAL(5,2),
observaciones VARCHAR(100),
id_empleado INT REFERENCES empleados(id_empleado)
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