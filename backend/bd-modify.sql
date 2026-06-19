-- =====================================================
-- MODULO 1 - CATALOGOS Y SEGURIDAD
-- PostgreSQL
-- =====================================================

-- ==========================================
-- CATALOGO DE ESTADOS
-- ==========================================

CREATE TABLE catalogo_estados(
id_estado SERIAL PRIMARY KEY,
entidad VARCHAR(50) NOT NULL,
codigo VARCHAR(30) NOT NULL,
descripcion VARCHAR(100),

```
CONSTRAINT uk_estado
    UNIQUE(entidad,codigo)
```

);

-- ==========================================
-- TIPO USUARIO
-- ==========================================

CREATE TABLE tipo_usuarios(
id_tipo_usuario SERIAL PRIMARY KEY,
descripcion VARCHAR(50) NOT NULL UNIQUE
);

-- ==========================================
-- EMPLEADOS
-- ==========================================

CREATE TABLE empleados(
id_empleado SERIAL PRIMARY KEY,

```
nombre VARCHAR(100) NOT NULL,

centro_trabajo VARCHAR(50),

puesto VARCHAR(50),

estado INT NOT NULL
    REFERENCES catalogo_estados(id_estado),

created_at TIMESTAMP DEFAULT NOW(),

updated_at TIMESTAMP DEFAULT NOW()
```

);

-- ==========================================
-- USUARIOS
-- ==========================================

CREATE TABLE usuarios(
id_usuario SERIAL PRIMARY KEY,

```
id_empleado INT NOT NULL
    REFERENCES empleados(id_empleado),

correo VARCHAR(100) NOT NULL UNIQUE,

password_hash VARCHAR(255) NOT NULL,

id_tipo_usuario INT NOT NULL
    REFERENCES tipo_usuarios(id_tipo_usuario),

estado INT NOT NULL
    REFERENCES catalogo_estados(id_estado),

created_at TIMESTAMP DEFAULT NOW(),

updated_at TIMESTAMP DEFAULT NOW()
```

);

-- ==========================================
-- FUNCION UNIVERSAL UPDATED_AT
-- ==========================================

CREATE OR REPLACE FUNCTION fn_updated_at()
RETURNS TRIGGER
AS
$$
BEGIN
NEW.updated_at = NOW();
RETURN NEW;
END;
$$
LANGUAGE plpgsql;

-- ==========================================
-- TRIGGER EMPLEADOS
-- ==========================================

CREATE TRIGGER trg_empleados_updated
BEFORE UPDATE
ON empleados
FOR EACH ROW
EXECUTE FUNCTION fn_updated_at();

-- ==========================================
-- TRIGGER USUARIOS
-- ==========================================

CREATE TRIGGER trg_usuarios_updated
BEFORE UPDATE
ON usuarios
FOR EACH ROW
EXECUTE FUNCTION fn_updated_at();

-- ==========================================
-- INDICES
-- ==========================================

CREATE INDEX idx_empleado_estado
ON empleados(estado);

CREATE INDEX idx_usuario_empleado
ON usuarios(id_empleado);

CREATE INDEX idx_usuario_estado
ON usuarios(estado);

-- ==========================================
-- CATALOGO INICIAL ESTADOS
-- ==========================================

INSERT INTO catalogo_estados
(entidad,codigo,descripcion)
VALUES
('GENERAL','ACTIVO','Registro activo'),

('GENERAL','INACTIVO','Registro inactivo'),

('VIAJE','PLANEADO','Viaje planeado'),

('VIAJE','ASIGNADO','Unidad asignada'),

('VIAJE','DESPACHADO','Mercancia despachada'),

('VIAJE','EN_TRANSITO','Mercancia en transito'),

('VIAJE','ARRIBADO','Arribo a destino'),

('VIAJE','DESCARGADO','Descarga completada'),

('VIAJE','FINALIZADO','Viaje finalizado'),

('VIAJE','SINIESTRADO','Viaje siniestrado'),

('RECEPCION','PENDIENTE','Pendiente de recepcion'),

('RECEPCION','PARCIAL','Recepcion parcial'),

('RECEPCION','COMPLETA','Recepcion completa'),

('FACTURA','CAPTURADA','Factura capturada'),

('FACTURA','VALIDADA','Factura validada'),

('FACTURA','PAGADA','Factura pagada'),

('FACTURA','CANCELADA','Factura cancelada');

-- ==========================================
-- TIPOS DE USUARIO
-- ==========================================

INSERT INTO tipo_usuarios(descripcion)
VALUES
('ADMIN'),
('OPERACIONES'),
('TRAFICO'),
('ALMACEN'),
('CONSULTA');

-- =====================================================
-- MODULO 2 - MAESTROS DEL NEGOCIO
-- =====================================================

-- ==========================================
-- TIPO PERSONA
-- ==========================================

CREATE TABLE tipo_persona(
id_tipo_persona SERIAL PRIMARY KEY,

```
descripcion VARCHAR(40) NOT NULL,

longitud_rfc INT NOT NULL
```

);

-- ==========================================
-- ZONAS
-- ==========================================

CREATE TABLE zonas(
id_zona SERIAL PRIMARY KEY,

```
acronimo VARCHAR(10) NOT NULL UNIQUE,

zona VARCHAR(50) NOT NULL UNIQUE
```

);

-- ==========================================
-- FINCAS
-- ==========================================

CREATE TABLE fincas(
id_finca SERIAL PRIMARY KEY,

```
finca VARCHAR(60) NOT NULL,

codigo_externo VARCHAR(30),

productor VARCHAR(60),

id_zona INT NOT NULL
    REFERENCES zonas(id_zona),

municipio VARCHAR(60),

propietario VARCHAR(80),

proveedor VARCHAR(80),

estado INT NOT NULL
    REFERENCES catalogo_estados(id_estado),

created_at TIMESTAMP DEFAULT NOW(),

updated_at TIMESTAMP DEFAULT NOW(),

CONSTRAINT uk_finca
    UNIQUE(finca)
```

);

-- ==========================================
-- CLIENTES
-- ==========================================

CREATE TABLE clientes(
id_cliente SERIAL PRIMARY KEY,

```
razon_social VARCHAR(120) NOT NULL,

nombre_comercial VARCHAR(80),

rfc VARCHAR(13) NOT NULL,

id_tipo_persona INT NOT NULL
    REFERENCES tipo_persona(id_tipo_persona),

acronimo VARCHAR(10),

cedis VARCHAR(80),

estado INT NOT NULL
    REFERENCES catalogo_estados(id_estado),

created_at TIMESTAMP DEFAULT NOW(),

updated_at TIMESTAMP DEFAULT NOW(),

CONSTRAINT uk_cliente_rfc
    UNIQUE(rfc)
```

);

-- ==========================================
-- PRODUCTO TERMINADO
-- ==========================================

CREATE TABLE producto_terminado(
id_producto_terminado SERIAL PRIMARY KEY,

```
sku VARCHAR(20) NOT NULL,

calidad VARCHAR(80) NOT NULL,

descripcion VARCHAR(150),

peso_estandar NUMERIC(10,2),

CONSTRAINT uk_producto_sku
    UNIQUE(sku)
```

);

-- ==========================================
-- ESTIBA
-- ==========================================

CREATE TABLE estiba(
id_estiba SERIAL PRIMARY KEY,

```
tipo VARCHAR(30) NOT NULL,

descripcion VARCHAR(100)
```

);

-- ==========================================
-- CAMARAS DE PREENFRIO
-- ==========================================

CREATE TABLE camaras_preenfrio(
id_preenfrio SERIAL PRIMARY KEY,

```
razon_social VARCHAR(120) NOT NULL,

rfc VARCHAR(13) NOT NULL,

id_tipo_persona INT NOT NULL
    REFERENCES tipo_persona(id_tipo_persona),

id_zona INT NOT NULL
    REFERENCES zonas(id_zona),

tarifa NUMERIC(12,2),

comision NUMERIC(12,2),

estado INT NOT NULL
    REFERENCES catalogo_estados(id_estado),

created_at TIMESTAMP DEFAULT NOW(),

updated_at TIMESTAMP DEFAULT NOW(),

CONSTRAINT uk_preenfrio_rfc
    UNIQUE(rfc)
```

);

-- ==========================================
-- ALMACENES PT
-- ==========================================

CREATE TABLE almacenes_pt(
id_almacen_pt SERIAL PRIMARY KEY,

```
descripcion VARCHAR(100) NOT NULL,

id_zona INT NOT NULL
    REFERENCES zonas(id_zona),

estado INT NOT NULL
    REFERENCES catalogo_estados(id_estado),

created_at TIMESTAMP DEFAULT NOW(),

updated_at TIMESTAMP DEFAULT NOW()
```

);

-- ==========================================
-- TRIGGERS UPDATED_AT
-- ==========================================

CREATE TRIGGER trg_fincas_updated
BEFORE UPDATE ON fincas
FOR EACH ROW
EXECUTE FUNCTION fn_updated_at();

CREATE TRIGGER trg_clientes_updated
BEFORE UPDATE ON clientes
FOR EACH ROW
EXECUTE FUNCTION fn_updated_at();

CREATE TRIGGER trg_preenfrio_updated
BEFORE UPDATE ON camaras_preenfrio
FOR EACH ROW
EXECUTE FUNCTION fn_updated_at();

CREATE TRIGGER trg_almacen_updated
BEFORE UPDATE ON almacenes_pt
FOR EACH ROW
EXECUTE FUNCTION fn_updated_at();

-- ==========================================
-- INDICES
-- ==========================================

CREATE INDEX idx_finca_zona
ON fincas(id_zona);

CREATE INDEX idx_finca_estado
ON fincas(estado);

CREATE INDEX idx_cliente_estado
ON clientes(estado);

CREATE INDEX idx_cliente_tipo_persona
ON clientes(id_tipo_persona);

CREATE INDEX idx_preenfrio_zona
ON camaras_preenfrio(id_zona);

CREATE INDEX idx_almacen_zona
ON almacenes_pt(id_zona);

-- =====================================================
-- MODULO 3 - PLANEACION
-- =====================================================

CREATE TABLE plan_produccion(
id_plan_produccion SERIAL PRIMARY KEY,

```
anio SMALLINT NOT NULL,

semana SMALLINT NOT NULL
    CHECK(semana BETWEEN 1 AND 53),

id_zona INT NOT NULL
    REFERENCES zonas(id_zona),

id_finca INT NOT NULL
    REFERENCES fincas(id_finca),

fecha_empaque DATE NOT NULL,

fecha_programada_embarque DATE,

dias_transito INT
    CHECK(dias_transito >= 0),

fecha_cita DATE,

id_cliente INT NOT NULL
    REFERENCES clientes(id_cliente),

id_producto_terminado INT NOT NULL
    REFERENCES producto_terminado(id_producto_terminado),

cajas_programadas INT NOT NULL
    CHECK(cajas_programadas > 0),

id_estiba INT
    REFERENCES estiba(id_estiba),

lote VARCHAR(30) NOT NULL,

id_preenfrio INT
    REFERENCES camaras_preenfrio(id_preenfrio),

comentarios VARCHAR(300),

estado INT NOT NULL
    REFERENCES catalogo_estados(id_estado),

created_at TIMESTAMP DEFAULT NOW(),

updated_at TIMESTAMP DEFAULT NOW(),

CONSTRAINT uk_lote
    UNIQUE(lote)
```

);

-- ==========================================
-- TRIGGER UPDATED_AT
-- ==========================================

CREATE TRIGGER trg_plan_produccion_updated
BEFORE UPDATE
ON plan_produccion
FOR EACH ROW
EXECUTE FUNCTION fn_updated_at();

-- ==========================================
-- INDICES
-- ==========================================

CREATE INDEX idx_plan_anio_semana
ON plan_produccion(anio,semana);

CREATE INDEX idx_plan_zona
ON plan_produccion(id_zona);

CREATE INDEX idx_plan_finca
ON plan_produccion(id_finca);

CREATE INDEX idx_plan_cliente
ON plan_produccion(id_cliente);

CREATE INDEX idx_plan_producto
ON plan_produccion(id_producto_terminado);

CREATE INDEX idx_plan_estado
ON plan_produccion(estado);

CREATE INDEX idx_plan_preenfrio
ON plan_produccion(id_preenfrio);

CREATE INDEX idx_plan_fecha_empaque
ON plan_produccion(fecha_empaque);

CREATE INDEX idx_plan_fecha_cita
ON plan_produccion(fecha_cita);

-- =====================================================
-- MODULO 4 - OPERACION LOGISTICA
-- =====================================================

-- ==========================================
-- LINEAS FLETERAS
-- ==========================================

CREATE TABLE lineas_fleteras(
id_linea_fletera SERIAL PRIMARY KEY,

```
razon_social VARCHAR(120) NOT NULL,

rfc VARCHAR(13) NOT NULL,

id_tipo_persona INT NOT NULL
    REFERENCES tipo_persona(id_tipo_persona),

representante_legal VARCHAR(100),

telefono VARCHAR(20),

email VARCHAR(100),

regimen VARCHAR(100),

estado INT NOT NULL
    REFERENCES catalogo_estados(id_estado),

created_at TIMESTAMP DEFAULT NOW(),

updated_at TIMESTAMP DEFAULT NOW(),

CONSTRAINT uk_fletera_rfc
    UNIQUE(rfc)
```

);

-- ==========================================
-- TIPO SERVICIO
-- ==========================================

CREATE TABLE tipo_servicio(
id_tipo_servicio SERIAL PRIMARY KEY,

```
tipo VARCHAR(50) NOT NULL,

capacidad VARCHAR(30),

descripcion VARCHAR(100)
```

);

-- ==========================================
-- OPERADORES
-- ==========================================

CREATE TABLE operadores(
id_operador SERIAL PRIMARY KEY,

```
nombre VARCHAR(100) NOT NULL,

licencia VARCHAR(40) NOT NULL,

telefono VARCHAR(20),

id_linea_fletera INT NOT NULL
    REFERENCES lineas_fleteras(id_linea_fletera),

estado INT NOT NULL
    REFERENCES catalogo_estados(id_estado),

CONSTRAINT uk_operador_licencia
    UNIQUE(licencia)
```

);

-- ==========================================
-- TRACTOS
-- ==========================================

CREATE TABLE tractos(
id_tracto SERIAL PRIMARY KEY,

```
placas VARCHAR(15) NOT NULL,

color VARCHAR(30),

modelo VARCHAR(30),

marca VARCHAR(30),

descripcion VARCHAR(150),

id_linea_fletera INT NOT NULL
    REFERENCES lineas_fleteras(id_linea_fletera),

estado INT NOT NULL
    REFERENCES catalogo_estados(id_estado),

CONSTRAINT uk_tracto_placas
    UNIQUE(placas)
```

);

-- ==========================================
-- CAJAS REFRIGERADAS
-- ==========================================

CREATE TABLE cajas_refrigeradas(
id_caja_refrigerada SERIAL PRIMARY KEY,

```
placas VARCHAR(15) NOT NULL,

economico VARCHAR(20),

capacidad_cajas INT,

estado INT NOT NULL
    REFERENCES catalogo_estados(id_estado),

CONSTRAINT uk_caja_placas
    UNIQUE(placas)
```

);

-- ==========================================
-- EMBARQUES
-- ==========================================

CREATE TABLE embarques(
id_embarque SERIAL PRIMARY KEY,

```
folio_embarque VARCHAR(30) NOT NULL,

id_cliente INT NOT NULL
    REFERENCES clientes(id_cliente),

fecha_embarque TIMESTAMP NOT NULL,

cajas_embarcadas INT NOT NULL
    CHECK(cajas_embarcadas > 0),

peso_embarcado NUMERIC(12,2),

estado INT NOT NULL
    REFERENCES catalogo_estados(id_estado),

created_at TIMESTAMP DEFAULT NOW(),

updated_at TIMESTAMP DEFAULT NOW(),

CONSTRAINT uk_embarque_folio
    UNIQUE(folio_embarque)
```

);

-- ==========================================
-- DETALLE EMBARQUE
-- ==========================================

CREATE TABLE detalle_embarque(
id_detalle_embarque SERIAL PRIMARY KEY,

```
id_embarque INT NOT NULL
    REFERENCES embarques(id_embarque),

id_plan_produccion INT NOT NULL
    REFERENCES plan_produccion(id_plan_produccion),

cajas_embarcadas INT NOT NULL,

peso_embarcado NUMERIC(12,2),

CONSTRAINT uk_embarque_plan
    UNIQUE(id_embarque,id_plan_produccion)
```

);

-- ==========================================
-- FLETE TERRESTRE
-- ==========================================

CREATE TABLE flete_terrestre(
id_flete_terrestre SERIAL PRIMARY KEY,

```
oc VARCHAR(30),

ov VARCHAR(30),

envio_operacion VARCHAR(30),

prefactura VARCHAR(30),

id_linea_fletera INT NOT NULL
    REFERENCES lineas_fleteras(id_linea_fletera),

id_tipo_servicio INT NOT NULL
    REFERENCES tipo_servicio(id_tipo_servicio),

tarifa NUMERIC(12,2) NOT NULL,

estado INT NOT NULL
    REFERENCES catalogo_estados(id_estado),

created_at TIMESTAMP DEFAULT NOW(),

updated_at TIMESTAMP DEFAULT NOW()
```

);

-- ==========================================
-- VIAJES
-- ==========================================

CREATE TABLE viajes(
id_viaje SERIAL PRIMARY KEY,

```
id_embarque INT NOT NULL UNIQUE
    REFERENCES embarques(id_embarque),

id_flete_terrestre INT NOT NULL
    REFERENCES flete_terrestre(id_flete_terrestre),

fecha_salida TIMESTAMP,

fecha_llegada_estimada TIMESTAMP,

fecha_llegada_real TIMESTAMP,

km_programados NUMERIC(10,2),

km_reales NUMERIC(10,2),

estado INT NOT NULL
    REFERENCES catalogo_estados(id_estado),

created_at TIMESTAMP DEFAULT NOW(),

updated_at TIMESTAMP DEFAULT NOW()
```

);

-- ==========================================
-- ASIGNACION DE UNIDADES
-- ==========================================

CREATE TABLE asignacion_unidades(
id_asignacion SERIAL PRIMARY KEY,

```
id_viaje INT NOT NULL UNIQUE
    REFERENCES viajes(id_viaje),

id_operador INT NOT NULL
    REFERENCES operadores(id_operador),

id_tracto INT NOT NULL
    REFERENCES tractos(id_tracto),

id_caja_refrigerada INT NOT NULL
    REFERENCES cajas_refrigeradas(id_caja_refrigerada),

fecha_asignacion TIMESTAMP DEFAULT NOW()
```

);

-- ==========================================
-- TRIGGERS UPDATED_AT
-- ==========================================

CREATE TRIGGER trg_fletera_updated
BEFORE UPDATE ON lineas_fleteras
FOR EACH ROW
EXECUTE FUNCTION fn_updated_at();

CREATE TRIGGER trg_embarque_updated
BEFORE UPDATE ON embarques
FOR EACH ROW
EXECUTE FUNCTION fn_updated_at();

CREATE TRIGGER trg_flete_updated
BEFORE UPDATE ON flete_terrestre
FOR EACH ROW
EXECUTE FUNCTION fn_updated_at();

CREATE TRIGGER trg_viaje_updated
BEFORE UPDATE ON viajes
FOR EACH ROW
EXECUTE FUNCTION fn_updated_at();

-- ==========================================
-- INDICES
-- ==========================================

CREATE INDEX idx_embarque_cliente
ON embarques(id_cliente);

CREATE INDEX idx_embarque_estado
ON embarques(estado);

CREATE INDEX idx_detalle_embarque_plan
ON detalle_embarque(id_plan_produccion);

CREATE INDEX idx_flete_fletera
ON flete_terrestre(id_linea_fletera);

CREATE INDEX idx_viaje_estado
ON viajes(estado);

CREATE INDEX idx_viaje_flete
ON viajes(id_flete_terrestre);

CREATE INDEX idx_operador_fletera
ON operadores(id_linea_fletera);

CREATE INDEX idx_tracto_fletera
ON tractos(id_linea_fletera);

-- =====================================================
-- MODULO 5 - TRAZABILIDAD Y RECEPCION
-- =====================================================

-- ==========================================
-- TRACKING DE VIAJE
-- ==========================================

CREATE TABLE tracking_viaje(
id_tracking SERIAL PRIMARY KEY,

```
id_viaje INT NOT NULL
    REFERENCES viajes(id_viaje),

fecha_evento TIMESTAMP NOT NULL
    DEFAULT NOW(),

estado_anterior INT
    REFERENCES catalogo_estados(id_estado),

estado_nuevo INT NOT NULL
    REFERENCES catalogo_estados(id_estado),

ubicacion VARCHAR(150),

comentario VARCHAR(300),

id_usuario INT
    REFERENCES usuarios(id_usuario)
```

);

-- ==========================================
-- TIPO INCIDENCIA
-- ==========================================

CREATE TABLE tipo_incidencia(
id_tipo_incidencia SERIAL PRIMARY KEY,

```
descripcion VARCHAR(100) NOT NULL UNIQUE
```

);

-- ==========================================
-- INCIDENCIAS
-- ==========================================

CREATE TABLE incidencias(
id_incidencia SERIAL PRIMARY KEY,

```
id_viaje INT NOT NULL
    REFERENCES viajes(id_viaje),

id_tipo_incidencia INT NOT NULL
    REFERENCES tipo_incidencia(id_tipo_incidencia),

fecha TIMESTAMP NOT NULL
    DEFAULT NOW(),

descripcion VARCHAR(500),

cajas_afectadas INT DEFAULT 0,

costo_estimado NUMERIC(12,2),

id_usuario INT
    REFERENCES usuarios(id_usuario)
```

);

-- ==========================================
-- TEMPERATURA
-- ==========================================

CREATE TABLE monitoreo_temperatura(
id_monitoreo SERIAL PRIMARY KEY,

```
id_viaje INT NOT NULL
    REFERENCES viajes(id_viaje),

fecha_lectura TIMESTAMP NOT NULL,

temperatura NUMERIC(5,2) NOT NULL
```

);

-- ==========================================
-- DOCUMENTOS
-- ==========================================

CREATE TABLE documentos_viaje(
id_documento SERIAL PRIMARY KEY,

```
id_viaje INT NOT NULL
    REFERENCES viajes(id_viaje),

tipo_documento VARCHAR(50) NOT NULL,

nombre_archivo VARCHAR(255) NOT NULL,

ruta_archivo VARCHAR(500) NOT NULL,

fecha_carga TIMESTAMP DEFAULT NOW(),

id_usuario INT
    REFERENCES usuarios(id_usuario)
```

);

-- ==========================================
-- CITAS
-- ==========================================

CREATE TABLE citas_cliente(
id_cita SERIAL PRIMARY KEY,

```
id_viaje INT NOT NULL UNIQUE
    REFERENCES viajes(id_viaje),

fecha_programada TIMESTAMP,

fecha_real TIMESTAMP,

comentarios VARCHAR(300)
```

);

-- ==========================================
-- RECEPCIONES
-- ==========================================

CREATE TABLE recepciones(
id_recepcion SERIAL PRIMARY KEY,

```
id_viaje INT NOT NULL UNIQUE
    REFERENCES viajes(id_viaje),

fecha_recepcion TIMESTAMP NOT NULL,

cajas_recibidas INT NOT NULL,

cajas_rechazadas INT DEFAULT 0,

diferencias_cajas INT DEFAULT 0,

temperatura_recepcion NUMERIC(5,2),

observaciones VARCHAR(500),

id_empleado INT
    REFERENCES empleados(id_empleado),

estado INT NOT NULL
    REFERENCES catalogo_estados(id_estado),

created_at TIMESTAMP DEFAULT NOW()
```

);

-- ==========================================
-- INDICES TRACKING
-- ==========================================

CREATE INDEX idx_tracking_viaje
ON tracking_viaje(id_viaje);

CREATE INDEX idx_tracking_fecha
ON tracking_viaje(fecha_evento);

-- ==========================================
-- INDICES INCIDENCIAS
-- ==========================================

CREATE INDEX idx_incidencia_viaje
ON incidencias(id_viaje);

CREATE INDEX idx_incidencia_tipo
ON incidencias(id_tipo_incidencia);

-- ==========================================
-- INDICES TEMPERATURA
-- ==========================================

CREATE INDEX idx_temperatura_viaje
ON monitoreo_temperatura(id_viaje);

CREATE INDEX idx_temperatura_fecha
ON monitoreo_temperatura(fecha_lectura);

-- ==========================================
-- INDICES DOCUMENTOS
-- ==========================================

CREATE INDEX idx_documento_viaje
ON documentos_viaje(id_viaje);

-- ==========================================
-- INDICES RECEPCION
-- ==========================================

CREATE INDEX idx_recepcion_estado
ON recepciones(estado);

-- ==========================================
-- GASTOS
-- ==========================================

CREATE TABLE gastos(
    id_gasto SERIAL PRIMARY KEY,

    descripcion VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE gasto_adicional(
    id_gasto_adicional SERIAL PRIMARY KEY,

    id_viaje INT NOT NULL
        REFERENCES viajes(id_viaje),

    id_gasto INT NOT NULL
        REFERENCES gastos(id_gasto),

    importe NUMERIC(12,2) NOT NULL,

    observaciones VARCHAR(300),

    fecha_registro TIMESTAMP DEFAULT NOW(),

    id_usuario INT
        REFERENCES usuarios(id_usuario)
);

CREATE TABLE factura_flete(
    id_factura_flete SERIAL PRIMARY KEY,

    id_viaje INT NOT NULL UNIQUE
        REFERENCES viajes(id_viaje),

    folio VARCHAR(50),

    uuid UUID UNIQUE,

    fecha_emision DATE,

    subtotal NUMERIC(12,2),

    iva NUMERIC(12,2),

    retencion NUMERIC(12,2),

    total NUMERIC(12,2),

    fecha_pago DATE,

    estado INT NOT NULL
        REFERENCES catalogo_estados(id_estado),

    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE auditoria(
    id_auditoria BIGSERIAL PRIMARY KEY,

    tabla VARCHAR(100),

    operacion VARCHAR(20),

    registro_id BIGINT,

    valores_anteriores JSONB,

    valores_nuevos JSONB,

    usuario_bd VARCHAR(100),

    fecha TIMESTAMP DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION fn_auditoria()
RETURNS TRIGGER
AS
$$
BEGIN

    IF TG_OP = 'DELETE' THEN

        INSERT INTO auditoria(
            tabla,
            operacion,
            registro_id,
            valores_anteriores
        )
        VALUES(
            TG_TABLE_NAME,
            TG_OP,
            OLD.id_viaje,
            to_jsonb(OLD)
        );

        RETURN OLD;

    ELSIF TG_OP = 'UPDATE' THEN

        INSERT INTO auditoria(
            tabla,
            operacion,
            registro_id,
            valores_anteriores,
            valores_nuevos
        )
        VALUES(
            TG_TABLE_NAME,
            TG_OP,
            NEW.id_viaje,
            to_jsonb(OLD),
            to_jsonb(NEW)
        );

        RETURN NEW;

    ELSIF TG_OP = 'INSERT' THEN

        INSERT INTO auditoria(
            tabla,
            operacion,
            registro_id,
            valores_nuevos
        )
        VALUES(
            TG_TABLE_NAME,
            TG_OP,
            NEW.id_viaje,
            to_jsonb(NEW)
        );

        RETURN NEW;

    END IF;

    RETURN NULL;

END;
$$
LANGUAGE plpgsql;

----------------------------------------------------

CREATE TRIGGER trg_audit_viajes
AFTER INSERT OR UPDATE OR DELETE
ON viajes
FOR EACH ROW
EXECUTE FUNCTION fn_auditoria();

CREATE TRIGGER trg_audit_embarques
AFTER INSERT OR UPDATE OR DELETE
ON embarques
FOR EACH ROW
EXECUTE FUNCTION fn_auditoria();

CREATE TRIGGER trg_audit_recepciones
AFTER INSERT OR UPDATE OR DELETE
ON recepciones
FOR EACH ROW
EXECUTE FUNCTION fn_auditoria();

------------------------------------------------------
CREATE VIEW vw_control_logistico AS
SELECT

    v.id_viaje,

    e.folio_embarque,

    c.acronimo cliente,

    lf.razon_social fletera,

    o.nombre operador,

    t.placas tracto,

    cr.placas caja,

    v.fecha_salida,

    v.fecha_llegada_estimada,

    v.fecha_llegada_real,

    v.estado

FROM viajes v

INNER JOIN embarques e
ON v.id_embarque = e.id_embarque

INNER JOIN clientes c
ON e.id_cliente = c.id_cliente

INNER JOIN asignacion_unidades au
ON v.id_viaje = au.id_viaje

INNER JOIN operadores o
ON au.id_operador = o.id_operador

INNER JOIN tractos t
ON au.id_tracto = t.id_tracto

INNER JOIN cajas_refrigeradas cr
ON au.id_caja_refrigerada = cr.id_caja_refrigerada

INNER JOIN flete_terrestre ft
ON v.id_flete_terrestre = ft.id_flete_terrestre

INNER JOIN lineas_fleteras lf
ON ft.id_linea_fletera = lf.id_linea_fletera;

-----------------------------------------------------------
CREATE VIEW vw_costos_viaje AS
SELECT

    v.id_viaje,

    ft.tarifa,

    COALESCE(SUM(ga.importe),0) gastos_adicionales,

    ft.tarifa +
    COALESCE(SUM(ga.importe),0)
    costo_total

FROM viajes v

INNER JOIN flete_terrestre ft
ON v.id_flete_terrestre = ft.id_flete_terrestre

LEFT JOIN gasto_adicional ga
ON v.id_viaje = ga.id_viaje

GROUP BY
    v.id_viaje,
    ft.tarifa;


