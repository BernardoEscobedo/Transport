import bcrypt from 'bcryptjs'
import jwt from "jsonwebtoken"
import {userModel} from '../models/user.model.js'
import { request } from 'express'

const registrarUsuario = async (req,res) =>{
    try {
        const {id_empleado,correo,password_hash, id_tipo_usuario} = req.body

        const missingFields=[]
        if(!id_empleado) missingFields.push('id_empleado')
        if(!correo) missingFields.push('correo')
        if(!password_hash) missingFields.push('password_hash')
        if(!id_tipo_usuario) missingFields.push('id_tipo_usuario')

        if(missingFields.length > 0){
            return res.status(400).json({
                ok:false,
                msg:`Faltan los siguientes campos: ${missingFields.join(', ')}`
            })
        }
            const user = await userModel.encontrarPorCorreo(correo)
            if(user){
                return res.status(409).json({ok: false, msg: "El correo ya existe"})
            }
            const salt = await bcrypt.genSalt(10)
            const hashedPassword = await bcrypt.hash(password_hash, salt)

            const usuarioNuevo = await userModel.registrarUsuario({id_empleado, correo, password_hash:hashedPassword, id_tipo_usuario})
            const token = jwt.sign({email: usuarioNuevo.correo, role_id: usuarioNuevo.id_tipo_usuario},
            process.env.JWT_SECRET,
            {
                expiresIn:"1h"
            }
        )
        return res.status(201).json({
            ok:true,
            msg:{
                token, role_id: usuarioNuevo.id_tipo_usuario
            }
        })
    } catch (error) {
        console.error(error)

        return res.status(500).json({
            ok:false,
            msg: 'Error en el servidor'
        })
    }
}

const login = async(req,res)=>{
    try{
        const {correo, password_hash} = req.body

        const missingFields = []
        if(!correo) missingFields.push('correo')
        if(!password_hash) missingFields.push('password_hash')
        
        if(missingFields.length>0){
            return res.status(400).json({
                ok:false,
                msg: `Faltan los siguientes campos: ${missingFields.join(', ')}`
            });
        }
        const usuario = await userModel.encontrarPorCorreo(correo)
        if(!usuario){
            return res.status(404).json({ok:false, msg:"Correo no encontrado"})
        }

        const isMatch=await bcrypt.compare(password_hash, usuario.password_hash)

        if(!isMatch){
            return res.status(401).json({ok: false, msg:"Contraseña incorrecta"})
        }

        const token = jwt.sign({correo: usuario.correo, id_tipo_usuario: usuario.id_tipo_usuario},
            process.env.JWT_SECRET,
            {
                expiresIn:"2h"
            }
        )

        return res.json({
            ok:true,
            token,
            id_tipo_usuario: usuario.id_tipo_usuario,
            correo: correo.correo
        })
    }catch(error){
        console.log(error)
        return res.status(500).json({
            ok:false,
            msg: 'Error en el servidor'
        })
    }
}

const perfilUsuario = async(req,res)=>{
    try {
        const usuario = await userModel.encontrarPorCorreo(req.correo)
        return res.json({ok:true, msg: {correo: usuario.correo}})
    } catch (error) {
        console.log(error)
        return res.status(500).json({
            ok:false,
            msg:'Error en el servidor'
        })
    }
}

const listarUsuarios = async(req,res)=>{
    try {
        const usuarios = await userModel.listarUsuarios()

        return res.json({ok:true, msg: usuarios})
    } catch (error) {
        console.log(error)
        return res.status(500).json({
            ok:false,
            msg:'Error en el servidor'
        })
    }
}

const actualizarUsuario = async(req,res) => {
    try {
        const {id_usurio} = req.params
        const datoActualizado = req.body

        if(!datoActualizado || Object.keys(datoActualizado).length === 0){
            return res.status(400).json({
                ok:false,
                msg:'No se proporcionaron datos para actualizar'
            })
        }

        const usuario = await userModel.encontrarPorId(id_usurio)
        if(!usuario){
            return res.status(404).json({
                ok:false,
                msg:'Usuario no encontrado'
            })
        }

        if(datoActualizado.correo && datoActualizado.correo !== usuario.correo){
            const usuarioExistente = await userModel.encontrarPorId(datoActualizado.correo)
            if(usuarioExistente){
                return res.status(409).json({
                    ok: false,
                    msg: 'El correo ya esta en uso por otro usuario'
                })
            }
        }

        if(datoActualizado.password_hash){
            const salt = await bcrypt.genSalt(10)
            datoActualizado.password_hash = await bcrypt.hash(datoActualizado.password_hash, salt)
        }

        const actualizarDato = await userModel.actualizarUsuario(id_usurio, datoActualizado)

        return res.json({
            ok: true,
            msg: 'Usuario actualizado correctamente',
            usuario: actualizarDato
        })
    } catch (error) {
        console.log(error)
        return res.status(500).json({
            ok:false,
            msg:'Error en el servidor'
        })
    }
}

export const usuarioController = {
    registrarUsuario,
    login,
    perfilUsuario,
    listarUsuarios,
    actualizarUsuario
}