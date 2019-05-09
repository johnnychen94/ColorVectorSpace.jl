@testset "Arithemtic with RGB" begin
    cf = RGB{Float32}(0.1,0.2,0.3)
    @test @inferred(zero(cf)) === RGB{Float32}(0,0,0)
    @test @inferred(oneunit(cf)) === RGB{Float32}(1,1,1)
    @test +cf == cf
    @test -cf == RGB(-0.1f0, -0.2f0, -0.3f0)
    ccmp = RGB{Float32}(0.2,0.4,0.6)
    @test 2*cf == ccmp
    @test cf*2 == ccmp
    @test ccmp/2 == cf
    @test 2.0f0*cf == ccmp
    @test eltype(2.0*cf) == Float64
    cu = RGB{N0f8}(0.1,0.2,0.3)
    @test_colortype_approx_eq 2*cu RGB(2*cu.r, 2*cu.g, 2*cu.b)
    @test_colortype_approx_eq 2.0f0*cu RGB(2.0f0*cu.r, 2.0f0*cu.g, 2.0f0*cu.b)
    f = N0f8(0.5)
    @test (f*cu).r ≈ f*cu.r
    @test cf/2.0f0 == RGB{Float32}(0.05,0.1,0.15)
    @test cu/2 ≈ RGB(cu.r/2,cu.g/2,cu.b/2)
    @test cu/0.5f0 == RGB(cu.r/0.5f0, cu.g/0.5f0, cu.b/0.5f0)
    @test cf+cf == ccmp
    @test cu * 1//2 == mapc(x->Float64(Rational(x)/2), cu)
    @test_colortype_approx_eq (cf.*[0.8f0])[1] RGB{Float32}(0.8*0.1,0.8*0.2,0.8*0.3)
    @test_colortype_approx_eq ([0.8f0].*cf)[1] RGB{Float32}(0.8*0.1,0.8*0.2,0.8*0.3)
    @test isfinite(cf)
    @test !isinf(cf)
    @test !isnan(cf)
    @test !isfinite(RGB(NaN, 1, 0.5))
    @test !isinf(RGB(NaN, 1, 0.5))
    @test isnan(RGB(NaN, 1, 0.5))
    @test !isfinite(RGB(1, Inf, 0.5))
    @test isinf(RGB(1, Inf, 0.5))
    @test !isnan(RGB(1, Inf, 0.5))
    @test abs(RGB(0.1,0.2,0.3)) ≈ 0.6
    @test sum(abs2, RGB(0.1,0.2,0.3)) ≈ 0.14
    @test norm(RGB(0.1,0.2,0.3)) ≈ sqrt(0.14)

    acu = RGB{N0f8}[cu]
    acf = RGB{Float32}[cf]
    @test typeof(acu+acf) == Vector{RGB{Float32}}
    @test typeof(acu-acf) == Vector{RGB{Float32}}
    @test typeof(acu.+acf) == Vector{RGB{Float32}}
    @test typeof(acu.-acf) == Vector{RGB{Float32}}
    @test typeof(acu.+cf) == Vector{RGB{Float32}}
    @test typeof(acu.-cf) == Vector{RGB{Float32}}
    @test typeof(2*acf) == Vector{RGB{Float32}}
    @test typeof(convert(UInt8, 2)*acu) == Vector{RGB{Float32}}
    @test typeof(acu/2) == Vector{RGB{typeof(N0f8(0.5)/2)}}
    rcu = rand(RGB{N0f8}, 3, 5)
    @test @inferred(rcu./trues(3, 5)) == rcu
    @test typeof(rcu./trues(3, 5)) == Matrix{typeof(cu/true)}

    a = RGB{N0f8}[RGB(1,0,0), RGB(1,0.8,0)]
    @test sum(a) == RGB(2.0,0.8,0)
    @test isapprox(a, a)
    a = RGB{Float64}(1.0, 1.0, 0.9999999999999999)
    b = RGB{Float64}(1.0, 1.0, 1.0)

    @test isapprox(a, b)
    a = RGB{Float64}(1.0, 1.0, 0.99)
    @test !(isapprox(a, b, rtol = 0.01))
    @test isapprox(a, b, rtol = 0.1)
    # issue #56
    @test RGB24(1,0,0)*N0f8(0.5) === RGB{N0f8}(0.5,0,0)
    @test RGB24(1,0,0)*0.5 === RGB(0.5,0,0)
    @test RGB24(1,0,0)/2   === RGB(0.5f0,0,0)
    @test RGB24(1,0,0)/2.0 === RGB(0.5,0,0)
end
