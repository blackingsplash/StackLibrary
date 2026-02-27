--!strict
--!optimize 2
local _types: {} = require("./types")
local _config: { } = require("../Config/config")
local node: (v: any) -> ConstructorNode<any> = require("./node")

export type ConstructorNode<K> = _types.Node<K>
export type Constructor = _types.LinkedList

local methods = {}
methods.__index = methods
methods.__add = function(t1: Constructor, t2: Constructor): Constructor
    if not (t1 and t1.bottom) or not (t2 and t2.bottom) then
        error(`expected LinkedList type, got {typeof(t1)} and {typeof(t2)}`) 
    end

    t1.bottom.next = t2.top
    t1.bottom = t2.bottom

    return t1
end

function methods.new(v: any)
    local curr: ConstructorNode<any> = node(v)
    return setmetatable(methods, {
        top = curr :: ConstructorNode<any>,
        bottom = curr :: ConstructorNode<any>,
        height = 0 :: number,
    })
end

function methods:push(v: any): ()
    local curr: ConstructorNode<any> = node(v)
    if self.height > 0 then
        curr.next = self.top
        self.top = curr
    else
        self.top = curr
        self.bottom = curr 
    end
    self.height += 1
end

function methods:pop(): ConstructorNode<any>?
    if self.height == 0 or not self.top then return nil end;
    local res: ConstructorNode<any>? = self.top

    self.top = self.top.next
    res.next = nil
    self.height -= 1

    if self.height == 0 then self.bottom = nil end
    return res
end

return methods :: Constructor