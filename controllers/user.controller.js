import bcrypt from 'bcryptjs'
import jwt from "jsonwebtoken"
import {userModel} from '../models/user.model.js'
import { request } from 'express'

const registrarUsuario = async (req,res) =>{
    try {
        const {id_empleado,correo,password_hash, id_tipo_empleado} = req.body

        const missingFields=[]
        if(!id_empleado) missingFields.push('id_empleado')
        if(!correo) missingFields.push('correo')
        if(!password_hash) missingFields.push('password_hash')
        if(!id_tipo_empleado) missingFields.push('id_tipo_empleado')

        if(missingFields.length > 0){
            return res.status(400).json({
                ok:false,
                msg:`Faltan los siguientes campos: ${missingFields.join(', ')}`
            })

            const user = await userModel.encontrarPorCorreo(correo)
            if(user){
                return res.status(409).json({ok: false, msg: "El correo ya existe"})
            }
            const salt = await bcrypt.genSalt(10)
            const hashedPassword = await bcrypt.hash(password_hash, salt)

            const usuarioNuevo = await userModel.registrarUsuario({id_empleado, correo, password_hash:hashedPassword, id_empleado})
            const token = jwt.sign({email: usuarioNuevo.correo, role_id: usuarioNuevo.id_tipo_empleado},
            process.env.JWT_SECRET,
            {
                expiresIn:"1h"
            }
        )
        }
    } catch (error) {
        
    }
}