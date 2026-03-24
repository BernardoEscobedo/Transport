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
    if(req.id_tipo_usuario == 3 ){
        return next()
    }
    return res.status(403).json({error:"Autorizado solo para personal operativo"})
}

