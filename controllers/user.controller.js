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
    } catch (error) {
        
    }
}