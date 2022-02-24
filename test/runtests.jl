
using Test
using Leelo

@testset verbose=true "Leelo Testset" begin
    @test function_to_test() == "Result-String"
end
