@testset "Arithmetic with GrayA" begin
    p1 = GrayA{Float32}(Gray(0.8), 0.2)
    @test @inferred(zero(p1)) === GrayA{Float32}(0,0)
    @test @inferred(oneunit(p1)) === GrayA{Float32}(1,1)
    @test +p1 == p1
    @test -p1 == GrayA(-0.8f0, -0.2f0)
    p2 = GrayA{Float32}(Gray(0.6), 0.3)
    @test_colortype_approx_eq p1+p2 GrayA{Float32}(Gray(1.4),0.5)
    @test_colortype_approx_eq (p1+p2)/2 GrayA{Float32}(Gray(0.7),0.25)
    @test_colortype_approx_eq 0.4f0*p1+0.6f0*p2 GrayA{Float32}(Gray(0.68),0.26)
    @test_colortype_approx_eq ([p1]+[p2])[1] GrayA{Float32}(Gray(1.4),0.5)
    @test_colortype_approx_eq ([p1].+[p2])[1] GrayA{Float32}(Gray(1.4),0.5)
    @test_colortype_approx_eq ([p1].+p2)[1] GrayA{Float32}(Gray(1.4),0.5)
    @test_colortype_approx_eq ([p1]-[p2])[1] GrayA{Float32}(Gray(0.2),-0.1)
    @test_colortype_approx_eq ([p1].-[p2])[1] GrayA{Float32}(Gray(0.2),-0.1)
    @test_colortype_approx_eq ([p1].-p2)[1] GrayA{Float32}(Gray(0.2),-0.1)
    @test_colortype_approx_eq ([p1]/2)[1] GrayA{Float32}(Gray(0.4),0.1)
    @test_colortype_approx_eq (0.4f0*[p1]+0.6f0*[p2])[1] GrayA{Float32}(Gray(0.68),0.26)

    a = GrayA{N0f8}[GrayA(0.8,0.7), GrayA(0.5,0.2)]
    @test sum(a) == GrayA(n8sum(0.8,0.5), n8sum(0.7,0.2))
    @test isapprox(a, a)
    a = AGray{Float64}(1.0, 0.9999999999999999)
    b = AGray{Float64}(1.0, 1.0)

    @test a ≈ b
    a = AGray{Float64}(1.0, 0.99)
    @test !isapprox(a, b, rtol = 0.01)
    @test isapprox(a, b, rtol = 0.1)

    # issue #56
    @test AGray32(0.8,0.2)*N0f8(0.5) === AGray{N0f8}(0.4,0.1)
    @test AGray32(0.8,0.2)*0.5 === AGray(0.4,0.1)
    @test AGray32(0.8,0.2)/2   === AGray(0.5f0*N0f8(0.8),0.5f0*N0f8(0.2))
    @test AGray32(0.8,0.2)/2.0 === AGray(0.4,0.1)
end
