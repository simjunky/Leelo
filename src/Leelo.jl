module Leelo

export greet
export function_to_test

greet() = print("Hello World!")

function function_to_test()::String
    return "Result-String"
end

end # module
