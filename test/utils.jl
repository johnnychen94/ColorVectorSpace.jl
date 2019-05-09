macro test_colortype_approx_eq(a, b)
    :(test_colortype_approx_eq($(esc(a)), $(esc(b)), $(string(a)), $(string(b))))
end

n8sum(x,y) = Float64(N0f8(x)) + Float64(N0f8(y))

function test_colortype_approx_eq(a::Colorant, b::Colorant, astr, bstr)
    @test typeof(a) == typeof(b)
    n = length(fieldnames(typeof(a)))
    for i = 1:n
        @test getfield(a, i) ≈ getfield(b,i)
    end
end
