module ColorVectorSpaceTests

using LinearAlgebra, Statistics
using ColorVectorSpace, Colors, FixedPointNumbers, StatsBase

using Test


include("utils.jl")

@testset "Colortypes" begin

    include("nan.jl")
    include("arithmetic_gray.jl")
    include("arithmetic_graya.jl")
    include("arithmetic_rgb.jl")
    include("arithmetic_rgba.jl")
    include("dotc.jl")

    @testset "Mixed-type arithmetic" begin
        @test RGB(1,0,0) + Gray(0.2f0) == RGB{Float32}(1.2,0.2,0.2)
        @test RGB(1,0,0) - Gray(0.2f0) == RGB{Float32}(0.8,-0.2,-0.2)
    end

    @testset "typemin/max" begin
        for T in (Normed{UInt8,8}, Normed{UInt8,6}, Normed{UInt16,16}, Normed{UInt16,14}, Float32, Float64)
            @test typemin(Gray{T}) === Gray{T}(typemin(T))
            @test typemax(Gray{T}) === Gray{T}(typemax(T))
            @test typemin(Gray{T}(0.5)) === Gray{T}(typemin(T))
            @test typemax(Gray{T}(0.5)) === Gray{T}(typemax(T))
            A = maximum(Gray{T}.([1 0 0; 0 1 0]); dims=1)  # see PR#44 discussion
            @test isa(A, Matrix{Gray{T}})
            @test size(A) == (1,3)
        end
    end
end

end
