let
    # Test constructor errors
    @test_throws ArgumentError load_GSHHS_data(resolution=:INVALID)
    @test_throws ArgumentError load_GSHHS_data(resolution=:FULL, level=7)
    @test_throws ArgumentError load_GSHHS_data(resolution=:CRUDE, level=4)


    for res in PGFMapPlots.VALID_RESOLUTIONS
        for level in 1:6
            # Skip invalid products
            if res == :CRUDE && level == 4
                continue
            end

            data = load_GSHHS_data(resolution=res, level=level)
            @test length(data.shapes) > 0
        end
    end
end

let
    # Test constructor errors
    @test_throws ArgumentError load_WDBII_border_data(resolution=:INVALID)
    @test_throws ArgumentError load_WDBII_border_data(resolution=:FULL, level=4)
    

    for res in PGFMapPlots.VALID_RESOLUTIONS
        for level in 1:3
            data = load_WDBII_border_data(resolution=res, level=level)
            @test length(data.shapes) > 0
        end
    end
end

let
    # Test constructor errors
    @test_throws ArgumentError load_WDBII_river_data(resolution=:INVALID)
    @test_throws ArgumentError load_WDBII_river_data(resolution=:FULL, level=12)


    for res in PGFMapPlots.VALID_RESOLUTIONS
        for level in 1:11
            data = load_WDBII_river_data(resolution=res, level=level)
            @test length(data.shapes) > 0
        end
    end
end