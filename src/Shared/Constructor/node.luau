local types: {} = require("./types")

return function<T>(v: T) 
    return {
        data = v :: T,
        next = nil :: types.Node<T>?,
    } :: types.Node<T>
end
