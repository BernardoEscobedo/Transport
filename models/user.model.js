import { text } from 'express'
import {db} from '../database/connection.database.js'

const registrarUsuario = async ({id_empleado, correo, password_hash, id_tipo_usuario})=>{
    const query={
        text:`
            INSERT INTO usuarios (id_empleado, correo, password_hash, id_tipo_usuario)
            VALUES ($1,$2,$3,$4)
            RETURNING id_empleado, correo, password_hash, id_tipo_usuario
        `,
        values: [id_empleado, correo, password_hash, id_tipo_usuario]
    }
    const {rows} = await db.query(query)
    return rows[0]
}

const encontrarPorCorreo = async(correo)=>{
    const query ={
        text: `
        SELECT id_usuario, id_empleado, correo, password_hash, id_tipo_usuario, estado
        FROM usuarios
        WHERE correo = $1
        `,
        values: [correo]
    }
    const {rows} = await db.query(query);
    return rows[0]
}

const listarUsuarios = async () => {
    const query = {
        text:`
        SELECT id_empleado, correo, id_tipo_usuario, estado
        FROM usuarios
        `
    }
    const {rows} = await db.query(query)
    return rows
}

const encontrarPorId = async (id_usuario) => {
    const query = {
        text: `
        SELECT id_empleado, correo, id_tipo_usuario, estado
        FROM usuarios WHERE id_usuario = $1
        `,
        values: [id_usuario]
    }
    const {rows} = await db.query(query)
    return rows[0]
}

const actualizarUsuario = async(id_usuario, updateData)=>{
    const validFields = ['correo','password_hash', 'id_tipo_usuario', 'estado'] // campos actualizables
    const fieldsToUpdate ={}

    Object.keys(updateData).forEach(key=>{
        if(validFields.includes(key) && updateData[key] !== undefined){
            fieldsToUpdate[key] = updateData[key]
        }
    });

    if(Object.keys(fieldsToUpdate).length === 0){
        throw new Error('No se proporcionaron campos para actualizar');
    }

     const setClause = Object.keys(fieldsToUpdate)
     .map((key,index) => `${key} = $${index +1}`)
     .join(', ');

     const values = Object.values(fieldsToUpdate)
     values.push(id_usuario)

     const query ={
        text:`
        UPDATE usuarios
        SET ${setClause}
        WHERE id_usuario = $${values.length}
        RETURNING *
        `,
        values: values
     }

     const {rows} = await db.query(query)
     return rows[0]
}

export const userModel={
    registrarUsuario,
    encontrarPorCorreo,
    encontrarPorId,
    listarUsuarios,
    actualizarUsuario
}