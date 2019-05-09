cf = Gray{Float32}(0.1)
ccmp = Gray{Float32}(0.2)
cu = Gray{N0f8}(0.1)
acu = Gray{N0f8}[cu]
acf = Gray{Float32}[cf]

@testset "Arithmetic with Gray" begin
    @testset "Base" begin
    @info "Base"
        @testset "Unary operations" begin
            @testset "+" begin
                @test +cf == cf
                @test -cf == Gray(-0.1f0)
                @test +acu === acu
            end

            @testset "abs" begin
                @test abs(Gray(0.1)) ≈ 0.1
            end
            @testset "abs2" begin
                @test abs2(ccmp) == 0.2f0^2
            end

            @testset "finite infinite" begin
                @test isfinite(cf)
                @test !isfinite(Gray(NaN))
                @test isfinite(Gray(true))
                @test !isinf(cf)
                @test !isnan(cf)
                @test !isinf(Gray(NaN))
                @test isnan(Gray(NaN))
                @test !isfinite(Gray(Inf))
                @test Gray(Inf) |> isinf
                @test !isnan(Gray(Inf))
            end

            @testset "eps" begin
                @test eps(Gray{N0f8}) == Gray(eps(N0f8))  # #282
            end
        end # unary operations

        @testset "Binary operations" begin
            @testset "+" begin
                @test cf+cf == ccmp
                @test typeof(acu+acf) == Vector{Gray{Float32}}
                @test typeof(acu.+acf) == Vector{Gray{Float32}}
                @test typeof(acu.+cf) == Vector{Gray{Float32}}
            end

            @testset "-" begin
                @test typeof(acu-acf) == Vector{Gray{Float32}}
                @test typeof(acu.-acf) == Vector{Gray{Float32}}
                @test typeof(acu.-cf) == Vector{Gray{Float32}}
            end

            @testset "*" begin
                f = N0f8(0.5)
                @test 2*cf == ccmp
                @test cf*2 == ccmp
                @test 2.0f0*cf == ccmp
                @test eltype(2.0*cf) == Float64
                @test 2*cu == Gray(2*cu.val)
                @test 2.0f0*cu == Gray(2.0f0*cu.val)
                @test (f*cu).val ≈ f*cu.val
                @test typeof(2*acf) == Vector{Gray{Float32}}
                @test typeof(2 .* acf) == Vector{Gray{Float32}}
                @test typeof(0x02*acu) == Vector{Gray{Float32}}
            end

            @testset "/" begin
                @test ccmp/2 == cf
                @test cf/2.0f0 == Gray{Float32}(0.05)
                @test cu/2 == Gray(cu.val/2)
                @test cu/0.5f0 == Gray(cu.val/0.5f0)
                @test typeof(acu./trues(1)) == Vector{typeof(cu/true)}
                @test @inferred(acu./trues(1)) == acu
                @test typeof(ones(Int, 1)./acu) == Vector{typeof(1/cu)}
                @test @inferred(ones(Int, 1)./acu) == [1/cu]
                @test @inferred(acu./acu) == [1]
                @test typeof(acu./acu) == Vector{typeof(cu/cu)}
                @test typeof(acu/2) == Vector{Gray{typeof(N0f8(0.5)/2)}}
                @test (acu./Gray{N0f8}(0.5))[1] == gray(acu[1])/N0f8(0.5)
                @test (acf./Gray{Float32}(2))[1] ≈ 0.05f0
                @test (acu/2)[1] == Gray(gray(acu[1])/2)
                @test (acf/2)[1] ≈ Gray{Float32}(0.05f0)
            end

            @testset "^" begin
                @test_colortype_approx_eq cf*cf Gray{Float32}(0.01)
                @test_colortype_approx_eq cf^2 Gray{Float32}(0.01)
                @test_colortype_approx_eq cf^3.0f0 Gray{Float32}(0.001)
                @test typeof(acf.^2) == Vector{Gray{Float32}}
            end

            @testset "atan" begin
                @test atan(Gray(0.1), Gray(0.2)) == atan(0.1, 0.2)
            end
        end # binary operations

        @testset "sum" begin
            a = Gray{N0f8}[0.8,0.7]
            @test sum(abs2, ccmp) == 0.2f0^2
            @test sum(abs2, [cf, ccmp]) ≈ 0.05f0
            @test sum(a) == Gray(n8sum(0.8,0.7))
        end

        @testset "isapprox" begin
            a = Gray{N0f8}[0.8,0.7]
            @test isapprox(a, a)
        end

        @testset "conversion" begin
            @test real(Gray{Float32}) <: Real
            @test typeof(float(Gray{N0f16}(0.5))) <: AbstractFloat
        end

        @testset "zero" begin
            @test zero(ColorTypes.Gray) == 0
        end

        @testset "oneunit" begin
            @test oneunit(ColorTypes.Gray) == 1
        end
    end # Base

    @testset "LinearAlgebra" begin
    @info "LinearAlgebra"
        @testset "norm" begin
            @test norm(cf) == 0.1f0
        end
    end # LinearAlgebra

    @testset "Statistics" begin
    @info "Statistics"
        @testset "norm" begin
            @test norm(cf) == 0.1f0
        end
        @testset "var" begin
            a = Gray{N0f8}[0.8,0.7]
            @test abs( var(a) - (a[1]-a[2])^2 / 2 ) <= 0.001
        end
        @testset "histrange" begin
            a = Gray{N0f8}[0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
            @test StatsBase.histrange(a,10) == 0.1f0:0.1f0:1f0
        end
        @testset "quantile" begin
            @test quantile( Gray{N0f16}[0.0,0.5,1.0], 0.1) ≈ 0.10000152590218968
        end
        @testset "middle" begin
            @test middle(Gray(0.2)) === Gray(0.2)
            @test middle(Gray(0.2), Gray(0.4)) === Gray((0.2+0.4)/2)
        end
    end

    # @test gray(0.8) == 0.8 # This belongs to ColorTypes


    # issue #56
    @test Gray24(0.8)*N0f8(0.5) === Gray{N0f8}(0.4)
    @test Gray24(0.8)*0.5 === Gray(0.4)
    @test Gray24(0.8)/2   === Gray(0.5f0*N0f8(0.8))
    @test Gray24(0.8)/2.0 === Gray(0.4)
end # Arithmetic with Gray

@testset "Comparisons with Gray" begin
    g1 = Gray{N0f8}(0.2)
    g2 = Gray{N0f8}(0.3)
    @test isless(g1, g2)
    @test !(isless(g2, g1))
    @test g1 < g2
    @test !(g2 < g1)
    @test isless(g1, 0.5)
    @test !(isless(0.5, g1))
    @test g1 < 0.5
    @test !(0.5 < g1)
    @test (@inferred(max(g1, g2)) ) == g2
    @test max(g1, 0.1) == 0.2
    @test (@inferred(min(g1, g2)) ) == g1
    @test min(g1, 0.1) == 0.1
    a = Gray{Float64}(0.9999999999999999)
    b = Gray{Float64}(1.0)

    @test isapprox(a, b)
    a = Gray{Float64}(0.99)
    @test !(isapprox(a, b, rtol = 0.01))
    @test isapprox(a, b, rtol = 0.1)
end # Comparisons with Gray

@testset "Unary operations with Gray" begin
    for g in (Gray(0.4), Gray{N0f8}(0.4))
        @test @inferred(zero(g)) === typeof(g)(0)
        @test @inferred(oneunit(g)) === typeof(g)(1)
        for op in ColorVectorSpace.unaryOps
            try
                v = @eval $op(gray(g))  # if this fails, don't bother
                @show op
                @test op(g) == v
            catch
            end
        end
    end
    u = N0f8(0.4)
    @test ~Gray(u) == Gray(~u)
    @test -Gray(u) == Gray(-u)
end
