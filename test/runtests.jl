# Packages required for testing
using Test
using Logging

# Package Under Test
using PGFMapPlots

# Set logging level
global_logger(SimpleLogger(stderr, Logging.Debug))

# Define package tests
@time @testset "PGFMapPlots Package Tests" begin
    testdir = joinpath(dirname(@__DIR__), "test")
    @time @testset "PGFMapPlots.LoadData" begin
        include(joinpath(testdir, "test_load_data.jl"))
    end
end