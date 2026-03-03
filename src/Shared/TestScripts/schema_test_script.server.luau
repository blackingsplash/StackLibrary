local StackModule = require(game:GetService("ReplicatedStorage").schemastack)
local TestStack = StackModule.create("TestStack")
print(TestStack)

-- Testing univalue mechanic
-- StackModule.push(TestStack2, 5) -- errors

-- Testing insertion
StackModule.push(TestStack, "TestStack2")
print(TestStack)

-- Testing deletion
StackModule.pop(TestStack)
print(TestStack)

-- Testing viewing
-- print(StackModule.peek(TestStack))

-- Testing predication
local NewStack = StackModule.create("Something")
local someFunction = function(value)
	return value == "Something"
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
