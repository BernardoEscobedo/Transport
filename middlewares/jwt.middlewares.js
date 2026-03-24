import jwt from "jsonwebtoken"

export const verifyToken = (req, res, next) => {
    let token = req.headers.authorization

    if(!token || !token.startsWith('Bearer')){
        return res.status(401).json({error: "Formato de token invalido"})
    }

    console.log({token})
    token = token.split(" ")[1]

    console.log({token})

    try {
        const {correo, id_tipo_usuario} = jwt.verify(token, process.env.JWT_SECRET)
        console.log(correo)
        req.email = email
        req.id_tipo_usuario = id_tipo_usuario
        next()
    } catch (error) {
        console.log(error)
        return res.status(400).json({error: "Token invalido"})
    }
} 

export const verifyAdminUsuario = (req, res, next) => {
    if(req.id_tipo_usuario == 1 || req.id_tipo_usuario == 2){
        return next()
    }
    return res.status(403).json({error:"Autorizado solo para usuario administrador"})
}

export const verifyOperativo = ( req, res, next ) => {
    if(req.id_tipo_usuario == 3 || req.id_tipo_usuario == 1 ){
        return next()
    }
    return res.status(403).json({error:"Autorizado solo para personal operativo"})
}

export const verifyTransportista =( req, res, next ) => {
    if(req.id_tipo_usuario == 4 || req.id_tipo_usuario == 1){
        return next()
    }
    return res.status(403).json({error:"Autorizado solo para proveedores de transporte"})
}

export const verifyCliente =( req, res, next ) => {
    if(req.id_tipo_usuario == 5 || req.id_tipo_usuario == 1){
        return next()
    }
    return res.status(403).json({error:"Autorizado solo para clientes"})
}

export const verifyCedisPropio =( req, res, next ) => {
    if(req.id_tipo_usuario == 6 || req.id_tipo_usuario == 1){
        return next()
    }
    return res.status(403).json({error:"Autorizado solo para cedis propios"})
}