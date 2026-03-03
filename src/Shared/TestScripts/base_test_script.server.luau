local StackModule = require(game:GetService("ReplicatedStorage").stack)
local TestStack = StackModule.create("TestStack")

-- Testing insertion
StackModule.push(TestStack, "TestStack2")
print(TestStack)

-- Testing deletion
StackModule.pop(TestStack)
print(TestStack)

-- Testing viewing
print(StackModule.peek(TestStack))

-- Testing predication
local NewStack = StackModule.create(5)
local someFunction = function(value)
	return type(value) == "string"
end
if StackModule.some(NewStack, someFunction) then
	print("NewStack contains a string")
end
if StackModule.some(TestStack, someFunction) then
	print("TestStack contains a string")
end

-- Testing freezing
--local FrozenStack = StackModule.freeze(TestStack, true)
--StackModule.push(FrozenStack, 50) -- errors

-- Deep cleaning
StackModule.deepClean(TestStack)
print(TestStack)
