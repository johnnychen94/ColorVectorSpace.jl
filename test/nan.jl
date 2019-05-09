@testset "nan" begin
    function make_checked_nan(::Type{T}) where T
        x = nan(T)
        isa(x, T) && isnan(x)
    end
    for S in (Float32, Float64)
        @test make_checked_nan(S)
        @test make_checked_nan(Gray{S})
        @test make_checked_nan(AGray{S})
        @test make_checked_nan(GrayA{S})
        @test make_checked_nan(RGB{S})
        @test make_checked_nan(ARGB{S})
        @test make_checked_nan(ARGB{S})
    end
end
