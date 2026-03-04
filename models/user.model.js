import {db} from '../database/connection.database.js'

const registrarUsuario = async ({id_empleado, correo, password_hash, id_tipo_usuario})=>{
    const query={
        text:`
            INSERT INTO usuarios (id_empleado, correo, password_hash, id_tipo_usuario)
            VALUES ($1,$2,$3,$4)
            RETURNING id_empleado, correo, password_hash, id_tipo_usuario
        `,
        values: [id_empleado, correo, password_hash, tipo_usuario]
    }
    const {rows} = await db.query(query)
    return rows[0]
}