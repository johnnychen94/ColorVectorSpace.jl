@testset "Arithemtic with RGBA" begin
    cf = RGBA{Float32}(0.1,0.2,0.3,0.4)
    @test @inferred(zero(cf)) === RGBA{Float32}(0,0,0,0)
    @test @inferred(oneunit(cf)) === RGBA{Float32}(1,1,1,1)
    @test +cf == cf
    @test -cf == RGBA(-0.1f0, -0.2f0, -0.3f0, -0.4f0)
    ccmp = RGBA{Float32}(0.2,0.4,0.6,0.8)
    @test 2*cf == ccmp
    @test cf*2 == ccmp
    @test ccmp/2 == cf
    @test 2.0f0*cf == ccmp
    @test eltype(2.0*cf) == Float64
    cu = RGBA{N0f8}(0.1,0.2,0.3,0.4)
    @test_colortype_approx_eq 2*cu RGBA(2*cu.r, 2*cu.g, 2*cu.b, 2*cu.alpha)
    @test_colortype_approx_eq 2.0f0*cu RGBA(2.0f0*cu.r, 2.0f0*cu.g, 2.0f0*cu.b, 2.0f0*cu.alpha)
    f = N0f8(0.5)
    @test (f*cu).r ≈ f*cu.r
    @test cf/2.0f0 == RGBA{Float32}(0.05,0.1,0.15,0.2)
    @test cu/2 == RGBA(cu.r/2,cu.g/2,cu.b/2,cu.alpha/2)
    @test cu/0.5f0 == RGBA(cu.r/0.5f0, cu.g/0.5f0, cu.b/0.5f0, cu.alpha/0.5f0)
    @test cf+cf == ccmp
    @test_colortype_approx_eq (cf.*[0.8f0])[1] RGBA{Float32}(0.8*0.1,0.8*0.2,0.8*0.3,0.8*0.4)
    @test_colortype_approx_eq ([0.8f0].*cf)[1] RGBA{Float32}(0.8*0.1,0.8*0.2,0.8*0.3,0.8*0.4)
    @test isfinite(cf)
    @test !isinf(cf)
    @test !isnan(cf)
    @test isnan(RGBA(NaN, 1, 0.5, 0.8))
    @test !isinf(RGBA(NaN, 1, 0.5))
    @test isnan(RGBA(NaN, 1, 0.5))
    @test !isfinite(RGBA(1, Inf, 0.5))
    @test RGBA(1, Inf, 0.5) |> isinf
    @test !isnan(RGBA(1, Inf, 0.5))
    @test !isfinite(RGBA(0.2, 1, 0.5, NaN))
    @test !isinf(RGBA(0.2, 1, 0.5, NaN))
    @test isnan(RGBA(0.2, 1, 0.5, NaN))
    @test !isfinite(RGBA(0.2, 1, 0.5, Inf))
    @test RGBA(0.2, 1, 0.5, Inf) |> isinf
    @test !isnan(RGBA(0.2, 1, 0.5, Inf))
    @test abs(RGBA(0.1,0.2,0.3,0.2)) ≈ 0.8

    acu = RGBA{N0f8}[cu]
    acf = RGBA{Float32}[cf]
    @test typeof(acu+acf) == Vector{RGBA{Float32}}
    @test typeof(acu-acf) == Vector{RGBA{Float32}}
    @test typeof(acu.+acf) == Vector{RGBA{Float32}}
    @test typeof(acu.-acf) == Vector{RGBA{Float32}}
    @test typeof(acu.+cf) == Vector{RGBA{Float32}}
    @test typeof(acu.-cf) == Vector{RGBA{Float32}}
    @test typeof(2*acf) == Vector{RGBA{Float32}}
    @test typeof(convert(UInt8, 2)*acu) == Vector{RGBA{Float32}}
    @test typeof(acu/2) == Vector{RGBA{typeof(N0f8(0.5)/2)}}

    a = RGBA{N0f8}[RGBA(1,0,0,0.8), RGBA(0.7,0.8,0,0.9)]
    @test sum(a) == RGBA(n8sum(1,0.7),0.8,0,n8sum(0.8,0.9))
    @test isapprox(a, a)
    a = ARGB{Float64}(1.0, 1.0, 1.0, 0.9999999999999999)
    b = ARGB{Float64}(1.0, 1.0, 1.0, 1.0)

    @test isapprox(a, b)
    a = ARGB{Float64}(1.0, 1.0, 1.0, 0.99)
    @test !(isapprox(a, b, rtol = 0.01))
    @test isapprox(a, b, rtol = 0.1)
    # issue #56
    @test ARGB32(1,0,0,0.8)*N0f8(0.5) === ARGB{N0f8}(0.5,0,0,0.4)
    @test ARGB32(1,0,0,0.8)*0.5 === ARGB(0.5,0,0,0.4)
    @test ARGB32(1,0,0,0.8)/2   === ARGB(0.5f0,0,0,0.5f0*N0f8(0.8))
    @test ARGB32(1,0,0,0.8)/2.0 === ARGB(0.5,0,0,0.4)
end
