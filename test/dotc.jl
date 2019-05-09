@testset "dotc" begin
    @test dotc(0.2, 0.2) == 0.2^2
    @test dotc(0.2, 0.3f0) == 0.2*0.3f0
    @test dotc(N0f8(0.2), N0f8(0.3)) == Float32(N0f8(0.2))*Float32(N0f8(0.3))
    @test dotc(Gray{N0f8}(0.2), Gray24(0.3)) == Float32(N0f8(0.2))*Float32(N0f8(0.3))
    xc, yc = RGB(0.2,0.2,0.2), RGB{N0f8}(0.3,0.3,0.3)
    @test isapprox(dotc(xc, yc) , dotc(convert(Gray, xc), convert(Gray, yc)), atol=1e-6)
    @test dotc(RGB(1,0,0), RGB(0,1,1)) == 0
end
