drop table detalle_recepciones;
drop table recepciones;
drop table detalle_despachos;
drop table despachos;
drop table gasto_adicional;
drop table gastos;
drop table flete_terrestre;
drop table cajas_refrigeradas;
drop table tractos;
drop table operadores;
drop table tipo_servicio;
drop table lineas_fleteras;
drop table cambios_plan;
drop table campos_editado;
drop table plan_produccion;
drop table almacenes_pt;
drop table camaras_preenfrio;
drop table estiba;
drop table producto_terminado;
drop table clientes;
drop table tipo_persona;
drop table fincas;
drop table zonas;
drop table usuarios;
drop table tipo_usuarios;
drop table empleados;
drop table estados



CREATE TABLE estados(
    id_estado   SERIAL PRIMARY KEY,
    descripcion VARCHAR(50),
    tipo        VARCHAR(50)
);

CREATE TABLE empleados(
    id_empleado    SERIAL PRIMARY KEY,
    nombre         VARCHAR(100),
    centro_trabajo VARCHAR(40),
    puesto         VARCHAR(50),
    estado         INT REFERENCES estados(id_estado),
    created_at     TIMESTAMP DEFAULT NOW(),
    updated_at     TIMESTAMP DEFAULT NOW()
);

CREATE TABLE tipo_usuarios(
    id_tipo_usuario SERIAL PRIMARY KEY,
    descripcion     VARCHAR(50)
);

CREATE TABLE usuarios(
    id_usuario      SERIAL PRIMARY KEY,
    id_empleado     INT REFERENCES empleados(id_empleado),
    correo          VARCHAR(100) UNIQUE,
    password_hash   VARCHAR(255),
    id_tipo_usuario INT REFERENCES tipo_usuarios(id_tipo_usuario),
    estado          INT REFERENCES estados(id_estado),
    created_at      TIMESTAMP DEFAULT NOW(),
    updated_at      TIMESTAMP DEFAULT NOW()
);

CREATE TABLE zonas(
    id_zona  SERIAL PRIMARY KEY,
    acronimo VARCHAR(10),
    zona     VARCHAR(30)
);

CREATE TABLE fincas(
    id_finca   SERIAL PRIMARY KEY,
    finca      VARCHAR(40),
    finca_inv  VARCHAR(40),
    productor  VARCHAR(40),
    id_zona    INT REFERENCES zonas(id_zona),
    municipio  VARCHAR(40),
    propietario VARCHAR(60),
    proveedor  VARCHAR(40),
    estado     INT REFERENCES estados(id_estado),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE tipo_persona(
    id_tipo_persona SERIAL PRIMARY KEY,
    descripcion     VARCHAR(40),
    longitud_rfc    INT
);

CREATE TABLE clientes(
    id_cliente  SERIAL PRIMARY KEY,
    razon_social VARCHAR(60),
    rfc         VARCHAR(13),
    id_tipo_persona INT REFERENCES tipo_persona(id_tipo_persona),
    acronimo    VARCHAR(10),
    cedis       VARCHAR(40),
    estado      INT REFERENCES estados(id_estado),
    created_at  TIMESTAMP DEFAULT NOW(),
    updated_at  TIMESTAMP DEFAULT NOW()
);

CREATE TABLE producto_terminado(
    id_producto_terminado SERIAL PRIMARY KEY,
    sku     VARCHAR(10),
    calidad VARCHAR(80)
);

CREATE TABLE estiba(
    id_estiba   SERIAL PRIMARY KEY,
    tipo        VARCHAR(30),
    descripcion VARCHAR(80)
);

CREATE TABLE camaras_preenfrio(
    id_preenfrio    SERIAL PRIMARY KEY,
    razon_social    VARCHAR(80),
    rfc             VARCHAR(13) UNIQUE,
    id_tipo_persona INT REFERENCES tipo_persona(id_tipo_persona),
    id_zona         INT REFERENCES zonas(id_zona),
    tarifa          NUMERIC(10,2),
    comision        NUMERIC(10,2)
);

CREATE TABLE almacenes_pt(
    id_almacen_pt SERIAL PRIMARY KEY,
    descripcion   VARCHAR(100),
    id_zona       INT REFERENCES zonas(id_zona)
);

CREATE TABLE plan_produccion(
    id_plan_produccion    SERIAL PRIMARY KEY,
    semana                INT,
    id_zona               INT REFERENCES zonas(id_zona),
    id_finca              INT REFERENCES fincas(id_finca),
    fecha_empaque         DATE,
    dias_transito         INT,
    fecha_cita            DATE,
    id_cliente            INT REFERENCES clientes(id_cliente),
    id_producto_terminado INT REFERENCES producto_terminado(id_producto_terminado),
    cajas_programadas     INT,
    id_estiba             INT REFERENCES estiba(id_estiba),
    comentarios           VARCHAR(100),
    lote                  VARCHAR(18),
    id_preenfrio          INT REFERENCES camaras_preenfrio(id_preenfrio),
    estado                INT REFERENCES estados(id_estado),
    created_at            TIMESTAMP DEFAULT NOW(),
    updated_at            TIMESTAMP DEFAULT NOW()
);

CREATE TABLE campos_editado(
    id_campo_editado SERIAL PRIMARY KEY,
    nombre           VARCHAR(80),
    comentarios      VARCHAR(120),
    estado           INT REFERENCES estados(id_estado)
);

CREATE TABLE cambios_plan(
    id_cambio_plan   SERIAL PRIMARY KEY,
    id_plan_produccion INT REFERENCES plan_produccion(id_plan_produccion),
    id_campo_editado INT REFERENCES campos_editado(id_campo_editado),
    valor_anterior   VARCHAR(80),
    valor_nuevo      VARCHAR(80),
    motivo           VARCHAR(120),
    id_usuario       INT REFERENCES usuarios(id_usuario),
    created_at       TIMESTAMP DEFAULT NOW()
);

CREATE TABLE lineas_fleteras(
    id_linea_fletera   SERIAL PRIMARY KEY,
    razon_social       VARCHAR(80),
    rfc                VARCHAR(13) UNIQUE,
    id_tipo_persona    INT REFERENCES tipo_persona(id_tipo_persona),
    representante_legal VARCHAR(80),
    telefono           VARCHAR(10),
    email              VARCHAR(80),
    regimen            VARCHAR(80),
    estado             INT REFERENCES estados(id_estado),
    created_at         TIMESTAMP DEFAULT NOW(),
    updated_at         TIMESTAMP DEFAULT NOW()
);

CREATE TABLE tipo_servicio(
    id_tipo_servicio SERIAL PRIMARY KEY,
    tipo             VARCHAR(30),
    capacidad        VARCHAR(20),
    descripcion      VARCHAR(80)
);

CREATE TABLE operadores(
    id_operador      SERIAL PRIMARY KEY,
    nombre           VARCHAR(100),
    licencia         VARCHAR(40),
    id_linea_fletera INT REFERENCES lineas_fleteras(id_linea_fletera),
    telefono         VARCHAR(10),
    estado           INT REFERENCES estados(id_estado)
);

CREATE TABLE tractos(
    id_tracto        SERIAL PRIMARY KEY,
    placas           VARCHAR(10),
    color            VARCHAR(20),
    modelo           VARCHAR(30),
    marca            VARCHAR(30),
    id_linea_fletera INT REFERENCES lineas_fleteras(id_linea_fletera),
    descripcion      VARCHAR(100),
    estado           INT REFERENCES estados(id_estado)
);

CREATE TABLE cajas_refrigeradas(
    id_caja_refrigerada SERIAL PRIMARY KEY,
    placas              VARCHAR(10),
    economico           VARCHAR(10),
    estado              INT REFERENCES estados(id_estado)
);

CREATE TABLE flete_terrestre(
    id_flete_terrestre SERIAL PRIMARY KEY,
    oc                 VARCHAR(20),
    ov                 VARCHAR(20),
    envio_operacion    VARCHAR(20),
    prefactura         VARCHAR(20),
    id_plan_produccion INT REFERENCES plan_produccion(id_plan_produccion),
    id_linea_fletera   INT REFERENCES lineas_fleteras(id_linea_fletera),
    id_tipo_servicio   INT REFERENCES tipo_servicio(id_tipo_servicio),
    tarifa             NUMERIC(10,2),
    estado             INT REFERENCES estados(id_estado)
);

CREATE TABLE gastos(
    id_gasto    SERIAL PRIMARY KEY,
    descripcion VARCHAR(100)
);

CREATE TABLE gasto_adicional(
    id_gasto_adicional SERIAL PRIMARY KEY,
    id_flete_terrestre INT REFERENCES flete_terrestre(id_flete_terrestre),
    id_gasto           INT REFERENCES gastos(id_gasto),
    precio             NUMERIC(10,2)
);

CREATE TABLE despachos(
    id_despacho     SERIAL PRIMARY KEY,
    fecha           DATE DEFAULT CURRENT_DATE,
    hora            TIME,
    folio_embarque  VARCHAR(20),
    origen_tipo     VARCHAR(20) CHECK(origen_tipo IN ('FINCA','PREENFRIO')),
    id_usuario      INT REFERENCES usuarios(id_usuario),
    estado          INT REFERENCES estados(id_estado)
);

CREATE TABLE detalle_despachos(
    id_detalle_despachos SERIAL PRIMARY KEY,
    id_despacho          INT REFERENCES despachos(id_despacho),
    id_almacen_pt        INT REFERENCES almacenes_pt(id_almacen_pt),
    cantidad_despachada  INT CHECK (cantidad_despachada >= 0),
    peso                 DECIMAL(10,2),
    temperatura          DECIMAL(5,2),
    id_flete_terrestre   INT REFERENCES flete_terrestre(id_flete_terrestre),
    id_operador          INT REFERENCES operadores(id_operador),
    id_tracto            INT REFERENCES tractos(id_tracto),
    id_caja_refrigerada  INT REFERENCES cajas_refrigeradas(id_caja_refrigerada),
    termografo           VARCHAR(20),
    observaciones        VARCHAR(300)
);

CREATE TABLE recepciones(
    id_recepcion SERIAL PRIMARY KEY,
    id_despacho  INT REFERENCES despachos(id_despacho),
    fecha        DATE DEFAULT CURRENT_DATE,
    hora         TIME,
    estado       INT REFERENCES estados(id_estado)
);

CREATE TABLE detalle_recepciones(
    id_detalle_recepcion SERIAL PRIMARY KEY,
    id_recepcion         INT REFERENCES recepciones(id_recepcion),
    id_cliente           INT REFERENCES clientes(id_cliente),
    cantidad_ok          INT CHECK (cantidad_ok >= 0),
    cantidad_rechazada   INT DEFAULT 0 CHECK (cantidad_rechazada >= 0),
    diferencias_cajas    INT DEFAULT 0 CHECK (diferencias_cajas >= -9999),
    temperatura          DECIMAL(5,2),
    observaciones        VARCHAR(100),
    id_empleado          INT REFERENCES empleados(id_empleado)
);

CREATE TABLE factura_flete(
    id_factura_flete   SERIAL PRIMARY KEY,
    id_flete_terrestre INT REFERENCES flete_terrestre(id_flete_terrestre),
    folio              VARCHAR(20),
    fecha_emision      DATE,
    uuid               UUID UNIQUE,
    subtotal           NUMERIC(10,2),
    iva                NUMERIC(10,2),
    retencion          NUMERIC(10,2),
    total              NUMERIC(10,2),
    fecha_pago         DATE,
    estado             INT REFERENCES estados(id_estado)
);

-- plan_produccion
CREATE INDEX idx_plan_zona         ON plan_produccion(id_zona);
CREATE INDEX idx_plan_finca        ON plan_produccion(id_finca);
CREATE INDEX idx_plan_cliente      ON plan_produccion(id_cliente);
CREATE INDEX idx_plan_preenfrio    ON plan_produccion(id_preenfrio);
CREATE INDEX idx_plan_estado       ON plan_produccion(estado);

-- cambios_plan
CREATE INDEX idx_cambios_plan_plan ON cambios_plan(id_plan_produccion);
CREATE INDEX idx_cambios_plan_user ON cambios_plan(id_usuario);

-- flete_terrestre
CREATE INDEX idx_flete_plan        ON flete_terrestre(id_plan_produccion);
CREATE INDEX idx_flete_linea       ON flete_terrestre(id_linea_fletera);

-- detalle_despachos
CREATE INDEX idx_dd_despacho       ON detalle_despachos(id_despacho);
CREATE INDEX idx_dd_flete          ON detalle_despachos(id_flete_terrestre);
CREATE INDEX idx_dd_tracto         ON detalle_despachos(id_tracto);
CREATE INDEX idx_dd_caja           ON detalle_despachos(id_caja_refrigerada);

-- recepciones / detalle
CREATE INDEX idx_recepcion_despacho ON recepciones(id_despacho);
CREATE INDEX idx_dr_recepcion       ON detalle_recepciones(id_recepcion);
CREATE INDEX idx_dr_cliente         ON detalle_recepciones(id_cliente);

-- factura_flete
CREATE INDEX idx_factura_flete_ft  ON factura_flete(id_flete_terrestre);

-- usuarios
CREATE INDEX idx_usuario_empleado  ON usuarios(id_empleado);

INSERT INTO estados (descripcion, tipo) VALUES('ACTIVO','ACTIVO');
INSERT INTO estados (descripcion, tipo) VALUES('INACTIVO','INACTIVO');
INSERT INTO estados (descripcion, tipo) VALUES('INICIADO','INICIADO');
INSERT INTO estados (descripcion, tipo) VALUES('EN TRANSITO','EN TRANSITO');
INSERT INTO estados (descripcion, tipo) VALUES('FINALIZADO','FINALIZADO');
INSERT INTO estados (descripcion, tipo) VALUES('DESCARGADO','DESCARGADO');
INSERT INTO estados (descripcion, tipo) VALUES('SINIESTRADO','SINIESTRADO');
INSERT INTO estados (descripcion, tipo) VALUES('INCOMPLETO','INCOMPLETO');
INSERT INTO estados (descripcion, tipo) VALUES('SOBRANTE','SOBRANTE');
INSERT INTO estados (descripcion, tipo) VALUES('DESPACHADO','DESPACHADO');

select *from estados;
select *from empleados;
select *from usuarios;
select *from tipo_usuarios

INSERT INTO empleados(nombre, centro_trabajo, puesto, estado) VALUES('Bernardo Escobedo', 'Oficina Central', 'Analista de producto terminado', 1);
INSERT INTO empleados(nombre, centro_trabajo, puesto, estado) VALUES('Juan Perez', 'Oficina Central', 'Analista de inventarios', 1);
INSERT INTO empleados(nombre, centro_trabajo, puesto, estado) VALUES('Maria Hernandez', 'Oficina Colony', 'Analista financiero', 1);
INSERT INTO empleados(nombre, centro_trabajo, puesto, estado) VALUES('Carmen Jimenez', 'Oficina Colony', 'Analista de cuentas por cobrar', 1);
INSERT INTO empleados(nombre, centro_trabajo, puesto, estado) VALUES('Jose Lopez', 'Almacen tultitlan', 'Encargado de almacen', 1);

INSERT INTO tipo_usuarios(descripcion) VALUES('ADMIN_USER');
INSERT INTO tipo_usuarios(descripcion) VALUES('DEV_USER');
INSERT INTO tipo_usuarios(descripcion) VALUES('EMPLEADO_USER');