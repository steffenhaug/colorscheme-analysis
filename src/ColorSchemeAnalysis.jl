module ColorSchemeAnalysis

using GeometryBasics
using Colors
using ColorSchemes
using Makie
using IterTools
using StaticArrays
using LinearAlgebra
using QuadGK

export Linear, Cubic, Quadratic, CatmullRom
export arclength, cumarclength, uniformsamples, points, interpolate, derivative
include("splines.jl")

export cumcoldiff, testimages, lightness, colorspace

function cumcoldiff(cmap)
  # Dimensions of the image
  M, N = 32, 1024

  x = LinRange(0, 1, N)
  y = LinRange(0, 1, M)
  img = x * ones(M)'

  f = Figure(; size = (800, 800))

  ax1 = Makie.Axis(f[1, 1])
  hidedecorations!(ax1)
  heatmap!(ax1, x, y, img; colormap = cmap)

  dE = map(((c1, c2),) -> colordiff(c1, c2), partition(cmap, 2))
  dE´ = map(((c1, c2),) -> abs(LCHab(c2).l - LCHab(c1).l), partition(cmap, 2))
  x = LinRange(0, 1, length(dE))

  ax2 = Makie.Axis(f[2:3, 1]; title = "Perceived Color Difference",)
  xlims!(ax2, 0, 1)
  ylims!(ax2, 0, 1)
  lines!(ax2, x, dE; color = :black)
  lines!(ax2, x, dE´;
         linestyle = (:dash, :normal),
         color = :black)

  E = cumsum(dE)
  E´ = cumsum(dE´)
  x = LinRange(0, 1, length(E))

  ax3 = Makie.Axis(f[4:5, 1]; title = "Cumulative Color Difference",)
  xlims!(ax3, 0, 1)
  lines!(ax3, x, E; color = :black, label = "CIEDE2000 Color Difference")
  lines!(ax3, x, E´;
         linestyle = (:dash, :normal),
         color = :black,
         label = "CIE76 Perceptual Lightness")

  leg = Legend(f[6, 1], ax3, "Color Difference Metric"; nbanks = 2)
  leg.tellheight = true
  leg.tellwidth = false

  f
end

"""
Plot the two CET test images in a given colorscheme.
"""
function testimages(cmap; periods = 100)
  # Dimensions of the image
  M, N = 32, 1024

  r = LinRange(0, 1, M)
  ϑ = LinRange(0, 2pi, N)

  ramp = ϑ .* ones(M)'
  wave = (pi / 10) * sin.(periods * ϑ)
  wave2d = wave .* (LinRange(0, 1, M) .^ 2)'

  img = ramp + wave2d

  f = Figure(;)

  ax1 = Makie.PolarAxis(f[1:3, 1];
                        title = "Cyclic Test Image",
                        rticklabelsvisible = false,
                        thetaticklabelsvisible = false,
                        rgridvisible = false,
                        thetagridvisible = false,
                        backgroundcolor = :transparent,
                        clip = false,)

  surface!(ax1, ϑ, r .+ 0.3, mod.(img, 2pi); colormap = cmap,
           shading = Makie.NoShading)
  lines!(ax1, ϑ, 0.3 * ones(N); color = :black)
  tightlimits!(ax1)

  ax2 = Makie.Axis(f[4, 1];
                   title = "Linear Test Image",
                   xticklabelsvisible = false,
                   xticksvisible = false,
                   yticklabelsvisible = false,
                   yticksvisible = false)

  heatmap!(ax2, ϑ, r, img; colormap = cmap)
  hidedecorations!(ax2)

  f
end

"""
Plot a comparison of the range of perceived lightnesses of colorschemes.
"""
function lightness(cmaps)
  f = Figure(; size = (800, 400))
  ax = Makie.Axis(f[1, 1];
                  backgroundcolor = "#111",
                  white_frame...)

  x = LinRange(0, 1, 64)

  for (name, cmap) in cmaps
    L = map(x -> LCHab(cmap[x]).l, x)
    lines!(ax, x, L; color = x, colormap = cmap, label = name)
  end

  leg = Legend(f[2, 1], ax;
               nbanks = length(cmaps),
               tellwidth = false,
               tellheight = true)

  f
end

function colorspace(spline::AbstractSpline; L1 = 25, L2 = 85)
  f = Figure(; size = (800, 1800))
  ax = Makie.Axis(f[1:4, 1]; title = "LCHab", xlabel = "Chroma", ylabel = "Hue")

  chroma = LinRange(0.0, 100.0, 100)
  hue = LinRange(0.0, 360.0, 100)
  heatmap!(ax, chroma, hue, (c, h) -> LCHab(75.0, c, h))

  t = uniformsamples(spline, 64)
  P = interpolate.(Ref(spline), t)

  lines!(ax, P; color = :black)
  # scatter!(ax, P; color = :black)
  scatter!(ax, points(spline); color = :black, markersize = 15)

  colors = map(((t, ch),) -> LCHab(L1 + (L2 - L1)t, ch[1], ch[2]), zip(t, P))
  cmap = ColorScheme(colors)

  M, N = 32, 128
  x = LinRange(0, 1, N)
  y = LinRange(0, 1, M)
  img = x * ones(M)'
  ax = Makie.Axis(f[5, 1]; title = "Colormap")
  heatmap!(ax, x, y, img; colormap = cmap)

  dE = map(((c1, c2),) -> colordiff(c1, c2), partition(cmap, 2))
  dE´ = map(((c1, c2),) -> abs(LCHab(c2).l - LCHab(c1).l), partition(cmap, 2))
  x = LinRange(0, 1, length(dE))

  ax2 = Makie.Axis(f[6:7, 1]; title = "Perceived Color Difference",)
  tightlimits!(ax2)
  xlims!(ax2, 0, 1)
  lines!(ax2, x, dE; color = :black)
  lines!(ax2, x, dE´;
         linestyle = (:dash, :normal),
         color = :black)

  E = cumsum(dE)
  E´ = cumsum(dE´)
  x = LinRange(0, 1, length(E))

  ax3 = Makie.Axis(f[8:9, 1]; title = "Cumulative Color Difference",)
  xlims!(ax3, 0, 1)
  lines!(ax3, x, E; color = :black, label = "CIEDE2000 Color Difference")
  lines!(ax3, x, E´;
         linestyle = (:dash, :normal),
         color = :black,
         label = "CIE76 Perceptual Lightness")

  f
end

function colorblindsim(test_subject)
  [protanopic.(test_subject);
   tritanopic.(test_subject);
   deuteranopic.(test_subject)]
  # TODO add perceived brightness + CIE76 Lightness
end

theme = Theme(; backgroundcolor = :transparent,
              Axis = (backgroundcolor = :white,
                      xminorticks = IntervalsBetween(6),
                      xminorticksvisible = true,
                      yminorticks = IntervalsBetween(6),
                      yminorticksvisible = true,
                      xgridvisible = false,
                      ygridvisible = false,
                      xtickalign = 1.0,
                      xticksize = 10.0,
                      xminorticksize = 5.0,
                      xminortickalign = 1.0,
                      ytickalign = 1.0,
                      yminortickalign = 1.0,
                      yticksize = 10.0,
                      yminorticksize = 5.0),
              Lines = (;
                       linewidth = 2.5))

white_frame = (xtickcolor = "#eee",
               xminortickcolor = "#eee",
               ytickcolor = "#eee",
               yminortickcolor = "#eee",
               topspinecolor = "#eee",
               bottomspinecolor = "#eee",
               leftspinecolor = "#eee",
               rightspinecolor = "#eee")
end # module ColorSchemeAnalysis
