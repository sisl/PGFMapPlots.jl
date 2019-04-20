__precompile__(true)
module PGFMapPlots

using WorldMapData
using PGFPlots


"""
Extract lon/lat points from polygon shapes.
"""
function extract_points(polygon)
    n_points = length(polygon.points)
    lon = zeros(Float64, n_points)
    lat = zeros(Float64, n_points)
    
    for (idx, pnt) in enumerate(polygon.points)
        lon[idx] = polygon.points[idx].x
        lat[idx] = polygon.points[idx].y
    end
    
    return lon, lat
end

"""
Check if any point in the given polygon is within the lat/lon bounding area. If 
it is return **true** return **false** otherwise
"""
function any_in_bounds(polygon; lblon::Real=-180.0, ublon::Real=180.0, lblat::Real=-90.0, ublat::Real=90.0)
    # Check if all points of polygon are within the given area
    if any(p -> (lblon <= p.x <= ublon) && (lblat <= p.y <= ublat), polygon.points)
        return true
    else
        return false
    end
end


export plotmap
"""
Generate a map plot.

Arguments:
- `llcrnrlon::Real` Lower left corner longitude [deg]
- `llcrnrlat::Real` Lower left corner latitude [deg]
- `urcrnrlon::Real` Upper right corner longitude [deg]
- `urcrnrlat::Real` Upper right corner latitude [deg]

Returns:
- `ax::Axis` Axis
"""
function plotmap(;llcrnrlon::Real=-180.0, llcrnrlat::Real=-90.0,
    urcrnrlon::Real=180.0, urcrnrlat::Real=90.0,
    landresolution::Union{Symbol, Nothing}=nothing, landlevel::Union{Integer, Nothing}=1, landstyle::String="no marks, black, solid",
    borderresolution::Union{Symbol, Nothing}=nothing, borderlevel::Union{Integer, Nothing}=1, borderstyle::String="no marks, black, solid",
    riverresolution::Union{Symbol, Nothing}=nothing, riverlevel::Union{Integer, Nothing}=1, riverstyle::String="no marks, black, solid",
    oceanstyle="",
    style::String="")

    lines = PGFPlots.Plots.Linear[]
    
    # Plot ocean points
    if oceanstyle != ""
        # Hard code land points
        x = Float64[llcrnrlon, llcrnrlon, urcrnrlon, urcrnrlon, llcrnrlon]
        y = Float64[llcrnrlat, urcrnrlat, urcrnrlat, llcrnrlat, llcrnrlat]
        push!(lines, PGFPlots.Plots.Linear(x, y, style=oceanstyle))
    end

    # Plot land shapes
    if landresolution != nothing

        # Load land data 
        for lvl in 1:landlevel
            if (landresolution == :CRUDE) && (lvl == 4)
                # Skip plotting this combination since the data
                # doesn't exist in the GSHHS data
                continue
            end
                
            land_data = load_GSHHS_data(resolution=landresolution, level=lvl)

            for ply in land_data.shapes
                if any_in_bounds(ply, lblon=llcrnrlon, ublon=urcrnrlon, lblat=llcrnrlat, ublat=urcrnrlat)
                    push!(lines, PGFPlots.Plots.Linear(extract_points(ply)..., style=landstyle))
                end
            end
        end
        
        # Load antartica data
        ant_data = load_GSHHS_data(resolution=landresolution, level=6)
        
        for ply in ant_data.shapes
            if any_in_bounds(ply, lblon=llcrnrlon, ublon=urcrnrlon, lblat=llcrnrlat, ublat=urcrnrlat)
                push!(lines, PGFPlots.Plots.Linear(extract_points(ply)..., style=landstyle))
            end
        end
    end
    
    # Plot borders
    if borderresolution != nothing

        # Load land data 
        for lvl in 1:borderlevel
            border_data = load_WDBII_border_data(resolution=borderresolution, level=lvl)

            for ply in border_data.shapes
                if any_in_bounds(ply, lblon=llcrnrlon, ublon=urcrnrlon, lblat=llcrnrlat, ublat=urcrnrlat)
                    push!(lines, PGFPlots.Plots.Linear(extract_points(ply)..., style=borderstyle))
                end
            end
        end
    end
    
    # Plot rivers
    if riverresolution != nothing

        # Load land data 
        for lvl in 1:riverlevel
            river_data = load_WDBII_river_data(resolution=riverresolution, level=lvl)

            for ply in river_data.shapes
                if any_in_bounds(ply, lblon=llcrnrlon, ublon=urcrnrlon, lblat=llcrnrlat, ublat=urcrnrlat)
                    push!(lines, PGFPlots.Plots.Linear(extract_points(ply)..., style=riverstyle))
                end
            end
        end
    end
    
    # Set style if none is provided
    if style == ""
        style = "width=25cm,height=12.5cm"
    end
    
    return PGFPlots.Axis(lines, xmin=llcrnrlon, xmax=urcrnrlon, ymin=llcrnrlat, ymax=urcrnrlat, style=style)
end

end # module
