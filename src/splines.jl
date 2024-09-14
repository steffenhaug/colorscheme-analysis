# If you are interested in splines, do yourself a favor and watch this:
# https://www.youtube.com/watch?v=aVwxzDHniEw
# https://www.youtube.com/watch?v=jvPPXbo87ds

"""
    lerp(p1, p2, t)

Linear interpolation.
"""
function lerp(p1, p2, t)
  (1 - t) * p1 + t * p2
end

"""
    cumgaussquad(f)

Cumulative Gaussian quadrature.
"""
function cumgaussquad(f; N = 100, a = 0, b = 1)
  x, w = gauss(N, a, b)
  y = f.(x)
  x, cumsum(w .* y)
end

"""
Spline interface.
"""
abstract type AbstractSpline end

function points(spline::AbstractSpline) end
function interpolate(s::AbstractSpline, t::Real) end
function derivative(s::AbstractSpline, t::Real) end

function arclength(s::AbstractSpline)
  f(t) = norm(derivative(s, t) .* [3.6, 1])
  arclen, err = quadgk(f, 0, 1)
  return arclen
end

function cumarclength(s::AbstractSpline)
  f(t) = norm(derivative(s, t) .* [3.6, 1])
  t, a = cumgaussquad(f)
  return t, a
end

"""
    inverse(x, y, y0)

Evaluate the inverse function y(x) at y0.
"""
function inverse(x, y, l0)
  # Index of first l > l0
  idx = searchsortedfirst(y, l0)

  if idx == 1
    return x[begin]
  end

  if idx > length(x)
    return x[end]
  end

  # The two points "surrounding" l0
  t1, t2 = x[idx - 1], x[idx]
  l1, l2 = y[idx - 1], y[idx]

  # LERP
  slope = (t2 - t1) / (l2 - l1)
  return t1 + slope * (l0 - l1)
end

function uniformsamples(s::AbstractSpline, n::Integer)
  t_u, l = cumarclength(s)

  # Uniformly sampled arc lengths.
  l_u = range(0, arclength(s), n)

  # Calculate the inverse of arclength(t) for uniform arc lengths.
  t = [inverse(t_u, l, l0) for l0 in l_u]

  return t
end

"""
    CatmullRomSpline(points)

Catmull-Rom spline.
"""
struct CatmullRom <: AbstractSpline
  points::Vector{Point{2, Float64}}
end

"""
Linear spline.
"""
struct Linear <: AbstractSpline
  points::Vector{Point{2, Float64}}
end

function interpolate(s::Linear, t::Real)
  lerp(s.points[begin], s.points[end], t)
end

function points(s::Linear)
  return s.points
end

"""
Quadratic Bézier spline.
"""
struct Quadratic <: AbstractSpline
  points::Vector{Point{2, Float64}}
end

function points(s::Quadratic)
  return s.points
end

function interpolate(s::Quadratic, t::Real)::Point
  T = SA[t^2 t 1]

  M = SA[ 1 -2  1
         -2  2  0
          1  0  0]

  P = SMatrix{2, 3}(reinterpret(Float64, s.points))

  return T * M * P'
end

function derivative(s::Quadratic, t::Real)::Point
  T = SA[2t 1 0]

  M = SA[ 1 -2  1
         -2  2  0
          1  0  0]

  P = SMatrix{2, 3}(reinterpret(Float64, s.points))

  return T * M * P'
end

"""
Cubic Bézier spline.
"""
struct Cubic <: AbstractSpline
  points::Vector{Point{2, Float64}}
end

function points(s::Cubic)
  return s.points
end

function interpolate(s::Cubic, t::Real)::Point
  T = SA[t^3 t^2 t 1]

  M = SA[-1  3 -3  1
          3 -6  3  0
         -3  3  0  0
          1  0  0  0]

  P = SMatrix{2, 4}(reinterpret(Float64, s.points))

  return T * M * P'
end

function derivative(s::Cubic, t::Real)::Point
  T = SA[3t^2 2t 1 0]

  M = SA[-1  3 -3  1
          3 -6  3  0
         -3  3  0  0
          1  0  0  0]

  P = SMatrix{2, 4}(reinterpret(Float64, s.points))

  return T * M * P'
end
