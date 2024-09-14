### A Pluto.jl notebook ###
# v0.19.46

using Markdown
using InteractiveUtils

# ╔═╡ 2213bef9-b401-4913-8b55-f8f646f3de48
begin
    import Pkg
    Pkg.activate("pluto"; shared=true)
	Pkg.resolve()
    using Revise
end

# ╔═╡ 91bf2022-df1f-490f-99c7-ed3cb14182b5
using QuadGK

# ╔═╡ 6b42b624-fbe5-11ee-1f83-81f190e07725
using Colors

# ╔═╡ ecec791c-2a9e-4ba8-b833-0a68eb494e99
using ColorSchemes

# ╔═╡ ea2dc258-e925-43cc-bbff-b51aadec7962
using CairoMakie

# ╔═╡ a5e4f8b3-a1fc-457e-a402-74d7b8fd5fb8
using LaTeXStrings

# ╔═╡ 0b82a925-3c5e-41cf-9f9e-f49d53c574f2
using IterTools

# ╔═╡ 31a87a11-c605-4637-af00-2d7007df3bdc
using Images

# ╔═╡ 4cbdf779-35d2-4fd7-9f37-1c3d947a22c5
using LinearAlgebra

# ╔═╡ e823d453-3ba1-4c21-86f8-11a1e5d77016
using StaticArrays

# ╔═╡ a9db0f4b-4513-4ce4-8af6-9ea213684ebd
using ColorSchemeAnalysis

# ╔═╡ ad8b0e2a-f7c0-41ed-a45f-81acae98d576
md"### Custom Packages"

# ╔═╡ 333fe9f6-d5df-4580-b95a-6a0bdef941e3
chanterelle = ColorScheme(
	range(LCHab(25.0, 10.0, 160.0),
		  LCHab(85.0, 50.0,  80.0))
)

# ╔═╡ 78dea45c-f337-4899-81cd-8c074f52091f
[chanterelle[x] for x in LinRange(0, 1, 5)]

# ╔═╡ 8b2078c4-c8a0-47c3-83cd-e58437ef14d9
[hex(chanterelle[x]) for x in LinRange(0, 1, 5)]

# ╔═╡ dbb2518f-2672-4427-afb2-63667741f606
md"""
### Compressed Lightness Variant
WCAG AA contrast against black in the entire range.
"""

# ╔═╡ d052e14d-4bfc-4718-aabc-52000dd0bee3
chanterelle_light = ColorScheme(
	range(LCHab(50.0, 25.0, 160.0),
		  LCHab(85.0, 50.0,  80.0))
)

# ╔═╡ 41eb4f0d-a163-452b-ac4c-aa01fc89af76
[chanterelle_light[x] for x in LinRange(0, 1, 5)]

# ╔═╡ 9f5a2a8d-b2d2-4875-b4f5-49d17c61d8bf
[hex(chanterelle_light[x]) for x in LinRange(0, 1, 5)]

# ╔═╡ 63309cbe-0981-472e-b16e-8cc71e3c92b9
md"### Background & Border Colors"

# ╔═╡ d368d77b-6f46-4e4c-beae-5ae16d9819d6
[ LCHab(lch.l - 15.0, lch.c, lch.h) for lch in [chanterelle_light[x] for x in LinRange(0, 1, 5)]]

# ╔═╡ 7ffd444c-cdf3-4157-8ecc-0e532dade3a5
[ hex(LCHab(lch.l - 15.0, lch.c, lch.h)) for lch in [chanterelle_light[x] for x in LinRange(0, 1, 5)]]

# ╔═╡ 36d43db0-c75e-4afb-8ce1-197214b02ce1
[ LCHab(lch.l - 20.0, lch.c, lch.h)
	for lch in [chanterelle_light[x] for x in LinRange(0, 1, 5)]]

# ╔═╡ 607630c9-4214-4294-9564-c8402f460ae3
[ hex(LCHab(lch.l - 20.0, lch.c, lch.h))
	for lch in [chanterelle_light[x] for x in LinRange(0, 1, 5)]]

# ╔═╡ 431461a2-4903-4a0a-9370-5ec7f109675d
amanita = [LCHab(50,65,40), LCHab(35,65,40), LCHab(30,65,40)]

# ╔═╡ 5db50616-8e16-473a-b1ce-649262a56d0e
moss = LCHab{Float64}(55.0, 50, 120)

# ╔═╡ d0e8f784-e0d1-40f7-9ca2-f685db938f2f
println(moss)

# ╔═╡ 27ecb642-86ac-4125-a81e-596a5097ee26
hex.(amanita)

# ╔═╡ 4e9e184f-249a-480c-873f-03c4aaf25bf0
accents = (ochre = colorant"#d69c48",
           terracotta = colorant"#c37f64",
           sky = colorant"#b5cdd9",
           storm = colorant"#516378",
           soil = colorant"#67594C")

# ╔═╡ 5466b3a4-8523-4fbe-8132-ac75446d3762
porcini = LCHab(50, 33, 50)

# ╔═╡ 50d8e4e8-087f-4db4-b952-3e1715c8e208
accentmatrix = [
	amanita[begin],        accents.ochre,    accents.soil, 
	accents.sky,    accents.storm,    porcini
]

# ╔═╡ 472676f2-7dcb-4495-963c-215900ae8ef6
hex(porcini)

# ╔═╡ 4286aaa2-b7fb-483c-a4c0-7d3446803a2d
md"## Color Difference Analysis"

# ╔═╡ 96089911-90f3-4727-b698-21b68eb7d4cc
with_theme(ColorSchemeAnalysis.theme, backgroundcolor="#eee") do
	cumcoldiff(chanterelle)
end

# ╔═╡ fd528cc1-7663-4e1e-841f-332280fa9b3a
with_theme(ColorSchemeAnalysis.theme, backgroundcolor="#eee") do
	cumcoldiff(ColorSchemes.deep)
end

# ╔═╡ 7696fefc-26ac-4444-b604-c199216499d7
with_theme(ColorSchemeAnalysis.theme, backgroundcolor="#eee") do
	cumcoldiff(ColorSchemes.viridis)
end

# ╔═╡ 45943265-83a2-4500-8971-38ff685c5153
with_theme(ColorSchemeAnalysis.theme, backgroundcolor="#eee") do
	cumcoldiff(chanterelle_light)
end

# ╔═╡ 964e6025-4d49-4dbf-a0d2-3d4e220eeb62
md"""
## CET Test Images
[Kovesi, P. Good Colour Maps: How to Design Them](https://arxiv.org/abs/1509.03700)
"""

# ╔═╡ af12a9f7-0409-44da-9b06-e77d29c8ce5d
with_theme(ColorSchemeAnalysis.theme, backgroundcolor="#eee") do
	testimages(chanterelle)
end

# ╔═╡ 63f9de64-9365-476c-a3d2-0b203140274a
with_theme(ColorSchemeAnalysis.theme, backgroundcolor="#eee") do
	testimages(ColorSchemes.viridis)
end

# ╔═╡ 224d377c-b890-46f4-86b4-3736570fc68c
md"""
## Perceptual Lightness

"The most important factor in
designing a colour map is to ensure that the magnitude of the incre-
mental change in perceptual lightness of the colours is uniform"
(Peter Kovesi, CET, 2015)
"""

# ╔═╡ 013abd85-f73a-4336-a9b1-1cccde55e6f2
with_theme(ColorSchemeAnalysis.theme, backgroundcolor="#eee") do
	cmaps = Dict(
		"Chanterelle" => chanterelle,
		"Viridis" => ColorSchemes.viridis,
		"Chanterelle Light" => chanterelle_light
	)
	lightness(cmaps)
end

# ╔═╡ dcdc9785-ee1a-44e3-9b64-ae9c744ad421
with_theme(ColorSchemeAnalysis.theme, backgroundcolor="#eee") do
	spline = ColorSchemeAnalysis.Cubic(
		[(10.0, 320.0), (20.0, 300.0), (25.0, 200.), (40.0, 160.0)]
	)
	colorspace(spline; L2=100.0)
end

# ╔═╡ 5d78ca10-e786-4b33-8ec0-4fb95b03afcf
let
	spline = Cubic(
		[(10.0, 330.0), (20.0, 300.0), (25.0, 220.0), (20.0, 170.0),]
	)
	
	colorspace(spline; L1=5, L2=100.0)
end

# ╔═╡ 89256fc4-d5f0-4c22-b7e3-03438d65ddc5
let
	spline = Cubic(
		[(10.0, 190.0), (20.0, 180.0), (40.0, 80.0), (50.0, 80.0),]
	)
	
	colorspace(spline, L1=20, L2=85)
end

# ╔═╡ 9218a2cb-93d9-420e-9047-e03ed59e5637
let
	spline = Cubic(
		[(30.0, 20.0), (50.0, 5.0), (60.0, 80.0), (90.0, 60.0),]
	)
	
	colorspace(spline, L1=10, L2=85)
end

# ╔═╡ bc643082-9ea0-41fe-bbe2-2d1f6d0cca15
let
	spline = Cubic(
		[(20.0, 250.0), (50.0, 200.0), (50.0, 80.0), (70.0, 80.0),]
	)
	
	colorspace(spline, L1=5, L2=95)
end

# ╔═╡ 411460f8-0280-43b0-8c33-3585675701e2


# ╔═╡ 7e3f28cc-638d-40af-933b-37a9a6bf4203


# ╔═╡ c1a37aff-0b2a-4ee9-8ac9-b208e59bc138


# ╔═╡ e9649bb8-0b27-4dc2-81c0-5f3333b5519b


# ╔═╡ 3f6bf09d-7097-4b77-87e4-47a4b909331a


# ╔═╡ f71d89a3-f3ec-4b37-ae65-fe19407b64a9


# ╔═╡ 21110cf5-d5f5-4b99-9dff-e103d696a141


# ╔═╡ 315750f5-750a-4fa9-86e4-b83fdc099372
for color in [chanterelle[x] for x in LinRange(0, 1, 5)]
	println(hex(color))
end

# ╔═╡ 0f91303c-f2fd-44a9-9053-ff1e1e315c01
for color in [chanterelle_light[x] for x in LinRange(0, 1, 5)]
	println(hex(color))
end

# ╔═╡ 84501bc2-af49-4e7d-993a-287a1926f390
md"## Favicon"

# ╔═╡ 5ef47573-05bd-42df-9fcb-9aaddd1ac9bb
let
	x = floor.((0:31) ./ 8)
	img = x' .+ x
	normalized = img ./ maximum(img)

	grayscale = Gray.(normalized)
	colored = map(c -> chanterelle[c], normalized)
	light = map(c -> chanterelle_light[c], normalized)

	save("favicon.ico", colored)

	[ grayscale, colored, light]'
end

# ╔═╡ 8bb3d04c-38b2-40f0-8a99-b110a17e3f96
md"## Syntax theme"

# ╔═╡ 9f055410-84ce-4650-a450-e0a7a2f8dc99
let
	theme = [chanterelle_isoluminant[x] for x in LinRange(0, 1, 5)]
	fg = colorant"#ddd"
	bg = colorant"#222222"

	vcat(theme, [fg, bg])
end

# ╔═╡ 8f9f0910-dcde-4cad-ba67-d7ef2df3d941
md"# Color Math"

# ╔═╡ e62bbc6f-8472-4f2f-805e-0bb9a1fae241
md"Relative Luminance"

# ╔═╡ 371070d1-7984-482a-8f33-61cd781b17e6
function Y(c)
	c = RGB(c)

	function gamma22(x)
		if x <= 0.03928
			x / 12.92
		else
			((x + 0.055) / 1.055)^2.4
		end
	end
	
	R = gamma22(c.r)
	G = gamma22(c.g)
	B = gamma22(c.b)
	0.2126R + 0.7152G + 0.0722B
end

# ╔═╡ 58605949-0d8f-4142-ade7-576cf5782296
function contrast(c1, c2)
	L₁ = max(Y(c2), Y(c1))
	L₂ = min(Y(c2), Y(c1))
	(L₁ + 0.05) / (L₂ + 0.05)
end

# ╔═╡ 40ce1322-8e94-4b49-a635-edaee805497b
function brightness(c)
	(25.29 * (100*Y(c))^(1/3) - 18.38) / 100
end

# ╔═╡ 3bedbec3-53c3-4ef8-bead-1c6b7ffd3a3f
md"Simple color difference (CIEDE2000)"

# ╔═╡ 35abc5f5-71bc-4e05-89cc-cf5a48788790
ΔE((c1, c2)) = colordiff(c1, c2)

# ╔═╡ b2b5576b-992e-4168-9259-c328cce44858
theme = Theme()

# ╔═╡ 3dfded4e-4857-478f-9a4e-94e21b5c43e4
  chroma = (
      Background = colorant"#222222",
      Foreground = colorant"#ddd",
      LineNumbers = colorant"#4d4d4d",
      Line = colorant"#fff",
      Keyword = theme[1],
      KeywordType = theme[5],
  
      Name = colorant"#ddd",
      NameAttribute = colorant"#ddd",
      NameBuiltin = theme[2],
      NameConstant = colorant"#ddd",
  	  NameClass = theme[2],
      NameException = colorant"#ddd",
      NameFunction = colorant"#ddd",
      NameLabel = colorant"#ddd",
      NameNamespace = theme[5],
      NameVariable = colorant"#ddd",
  
      Literal = colorant"#fff",
      LiteralString = theme[3],
      LiteralStringDoc = theme[4],
      LiteralStringRegex = theme[5],
      LiteralNumber = theme[3],
      LiteralNumberFloat = theme[3],
      LiteralNumberInteger = theme[3],
  
      Operator = colorant"#ddd",
      Comment = colorant"#5d5d5d",
      CommentHashbang = colorant"#fff",
      CommentPreproc = colorant"#fff",
);

# ╔═╡ 56251d39-4766-4198-91b7-0ba548c94de4
css = """
.chroma { 
  background-color: #$(hex(chroma.Background));
  color: #$(hex(chroma.Foreground));
}

/* LineNumbersTable */ .chroma .lnt { 
  white-space: pre;
  -webkit-user-select: none;
  user-select: none;
  margin-right: 0.4em;
  padding: 0 0.4em 0 0.4em;
  color: #$(hex(chroma.LineNumbers));
}

/* Line */ .chroma .line { 
  display: flex;
}

/* Keyword */ .chroma .k { 
  color: #$(hex(chroma.Keyword));
  font-weight: bold;
}

/* KeywordConstant */ .chroma .kc { 
  color: #$(hex(chroma.Keyword));
  font-weight: bold;
}

/* KeywordDeclaration */ .chroma .kd {
  color: #$(hex(chroma.Keyword));
  font-weight: bold;
}

/* KeywordNamespace */ .chroma .kn {
  color: #$(hex(chroma.Keyword));
  font-weight: bold;
}

/* KeywordPseudo */ .chroma .kp { 
  color: #$(hex(chroma.Keyword));
}

/* KeywordReserved */ .chroma .kr {
  color: #$(hex(chroma.Keyword));
  font-weight: bold;
}

/* KeywordType */ .chroma .kt {
  color: #$(hex(chroma.KeywordType));
}

/* Name */ .chroma .n {
  color: #$(hex(chroma.Name)); 
}

/* NameAttribute */ .chroma .na {
  color: #$(hex(chroma.NameAttribute));
}

/* NameBuiltin */ .chroma .nb {
  color: #$(hex(chroma.NameBuiltin));
}

/* NameClass */ .chroma .nc { 
  color: #$(hex(chroma.NameClass));
}

/* NameConstant */ .chroma .no { 
  color: #$(hex(chroma.NameConstant));
}

/* NameDecorator */ .chroma .nd { 
  color: #$(hex(chroma.Name));
  font-weight: bold;
}

/* NameEntity */ .chroma .ni {
  color: #$(hex(chroma.Name));
  font-weight: bold;
}

/* NameException */ .chroma .ne { 
  color: #$(hex(chroma.NameException));
}

/* NameFunction */ .chroma .nf { 
  color: #$(hex(chroma.NameFunction));
}

/* NameLabel */ .chroma .nl { 
  color: #$(hex(chroma.NameLabel));
  font-weight: bold;
}

/* NameNamespace */ .chroma .nn {
  color: #$(hex(chroma.NameNamespace));
}

/* NameTag */ .chroma .nt { 
  color: #$(hex(chroma.Name));
  font-weight: bold;
}

/* NameVariable */ .chroma .nv { 
  color: #$(hex(chroma.NameVariable));
}

/* LiteralString */ .chroma .s { 
  color: #$(hex(chroma.LiteralString));
}

/* LiteralStringAffix */ .chroma .sa {
  color: #$(hex(chroma.LiteralString));
}

/* LiteralStringBacktick */ .chroma .sb { 
  color: #$(hex(chroma.LiteralString));
}

/* LiteralStringDoc */ .chroma .sd { 
  color: #$(hex(chroma.LiteralStringDoc));
  font-style: italic;
}

/* LiteralStringDouble */ .chroma .s2 { 
  color: #$(hex(chroma.LiteralString));
}

/* LiteralStringRegex */ .chroma .sr {
  color: #$(hex(chroma.LiteralStringRegex));
}

/* LiteralStringSingle */ .chroma .s1 { 
  color: #$(hex(chroma.LiteralString));
}

/* LiteralStringSymbol */ .chroma .ss {
  color: #$(hex(chroma.LiteralString));
}

/* LiteralNumber */ .chroma .m { 
  color: #$(hex(chroma.LiteralNumber));
}

/* LiteralNumberBin */ .chroma .mb { 
  color: #$(hex(chroma.LiteralNumberInteger));
}

/* LiteralNumberFloat */ .chroma .mf {
  color: #$(hex(chroma.LiteralNumberFloat));
}

/* LiteralNumberHex */ .chroma .mh {
  color: #$(hex(chroma.LiteralNumberInteger));
}

/* LiteralNumberInteger */ .chroma .mi { 
  color: #$(hex(chroma.LiteralNumberInteger));
}

/* LiteralNumberIntegerLong*/ .chroma .il { 
  color: #$(hex(chroma.LiteralNumberInteger));
}

/* LiteralNumberOct */ .chroma .mo {
  color: #$(hex(chroma.LiteralNumberInteger));
}

/* Operator */ .chroma .o { 
  color: #$(hex(chroma.Operator));
}

/* OperatorWord */ .chroma .ow {
  color: #$(hex(chroma.Operator));
  font-weight: bold;
}

/* Comment */ .chroma .c { 
  color: #$(hex(chroma.Comment));
  font-style: italic;
}

/* CommentHashbang */ .chroma .ch {
  color:#$(hex(chroma.CommentHashbang));
  font-style:italic;
}

/* CommentMultiline */ .chroma .cm {
  color: #$(hex(chroma.Comment));
  font-style: italic;
}

/* CommentSingle */ .chroma .c1 {
  color: #$(hex(chroma.Comment));
  font-style: italic;
}

/* CommentPreproc */ .chroma .cp { 
  color: #$(hex(chroma.CommentPreproc));
}

/* CommentPreprocFile */ .chroma .cpf { 
  color: #$(hex(chroma.CommentPreproc));
}
"""

# ╔═╡ 21f88cf6-ca88-4b2a-9142-8ff109ba9393
write("/Users/st/Code/haug.codes/static/chanterelle.css", css)

# ╔═╡ Cell order:
# ╠═2213bef9-b401-4913-8b55-f8f646f3de48
# ╠═91bf2022-df1f-490f-99c7-ed3cb14182b5
# ╠═6b42b624-fbe5-11ee-1f83-81f190e07725
# ╠═ecec791c-2a9e-4ba8-b833-0a68eb494e99
# ╠═ea2dc258-e925-43cc-bbff-b51aadec7962
# ╠═a5e4f8b3-a1fc-457e-a402-74d7b8fd5fb8
# ╠═0b82a925-3c5e-41cf-9f9e-f49d53c574f2
# ╠═31a87a11-c605-4637-af00-2d7007df3bdc
# ╠═4cbdf779-35d2-4fd7-9f37-1c3d947a22c5
# ╠═e823d453-3ba1-4c21-86f8-11a1e5d77016
# ╟─ad8b0e2a-f7c0-41ed-a45f-81acae98d576
# ╠═a9db0f4b-4513-4ce4-8af6-9ea213684ebd
# ╠═333fe9f6-d5df-4580-b95a-6a0bdef941e3
# ╟─78dea45c-f337-4899-81cd-8c074f52091f
# ╟─8b2078c4-c8a0-47c3-83cd-e58437ef14d9
# ╟─dbb2518f-2672-4427-afb2-63667741f606
# ╠═d052e14d-4bfc-4718-aabc-52000dd0bee3
# ╟─41eb4f0d-a163-452b-ac4c-aa01fc89af76
# ╟─9f5a2a8d-b2d2-4875-b4f5-49d17c61d8bf
# ╟─63309cbe-0981-472e-b16e-8cc71e3c92b9
# ╟─d368d77b-6f46-4e4c-beae-5ae16d9819d6
# ╟─7ffd444c-cdf3-4157-8ecc-0e532dade3a5
# ╟─36d43db0-c75e-4afb-8ce1-197214b02ce1
# ╟─607630c9-4214-4294-9564-c8402f460ae3
# ╠═431461a2-4903-4a0a-9370-5ec7f109675d
# ╠═5db50616-8e16-473a-b1ce-649262a56d0e
# ╠═d0e8f784-e0d1-40f7-9ca2-f685db938f2f
# ╟─27ecb642-86ac-4125-a81e-596a5097ee26
# ╠═4e9e184f-249a-480c-873f-03c4aaf25bf0
# ╠═5466b3a4-8523-4fbe-8132-ac75446d3762
# ╠═50d8e4e8-087f-4db4-b952-3e1715c8e208
# ╠═472676f2-7dcb-4495-963c-215900ae8ef6
# ╟─4286aaa2-b7fb-483c-a4c0-7d3446803a2d
# ╟─96089911-90f3-4727-b698-21b68eb7d4cc
# ╟─fd528cc1-7663-4e1e-841f-332280fa9b3a
# ╠═7696fefc-26ac-4444-b604-c199216499d7
# ╟─45943265-83a2-4500-8971-38ff685c5153
# ╟─964e6025-4d49-4dbf-a0d2-3d4e220eeb62
# ╠═af12a9f7-0409-44da-9b06-e77d29c8ce5d
# ╠═63f9de64-9365-476c-a3d2-0b203140274a
# ╟─224d377c-b890-46f4-86b4-3736570fc68c
# ╠═013abd85-f73a-4336-a9b1-1cccde55e6f2
# ╟─dcdc9785-ee1a-44e3-9b64-ae9c744ad421
# ╟─5d78ca10-e786-4b33-8ec0-4fb95b03afcf
# ╟─89256fc4-d5f0-4c22-b7e3-03438d65ddc5
# ╟─9218a2cb-93d9-420e-9047-e03ed59e5637
# ╟─bc643082-9ea0-41fe-bbe2-2d1f6d0cca15
# ╟─411460f8-0280-43b0-8c33-3585675701e2
# ╟─7e3f28cc-638d-40af-933b-37a9a6bf4203
# ╟─c1a37aff-0b2a-4ee9-8ac9-b208e59bc138
# ╟─e9649bb8-0b27-4dc2-81c0-5f3333b5519b
# ╟─3f6bf09d-7097-4b77-87e4-47a4b909331a
# ╟─f71d89a3-f3ec-4b37-ae65-fe19407b64a9
# ╟─21110cf5-d5f5-4b99-9dff-e103d696a141
# ╠═315750f5-750a-4fa9-86e4-b83fdc099372
# ╠═0f91303c-f2fd-44a9-9053-ff1e1e315c01
# ╟─84501bc2-af49-4e7d-993a-287a1926f390
# ╠═5ef47573-05bd-42df-9fcb-9aaddd1ac9bb
# ╟─8bb3d04c-38b2-40f0-8a99-b110a17e3f96
# ╠═9f055410-84ce-4650-a450-e0a7a2f8dc99
# ╠═58605949-0d8f-4142-ade7-576cf5782296
# ╠═3dfded4e-4857-478f-9a4e-94e21b5c43e4
# ╠═56251d39-4766-4198-91b7-0ba548c94de4
# ╠═21f88cf6-ca88-4b2a-9142-8ff109ba9393
# ╟─8f9f0910-dcde-4cad-ba67-d7ef2df3d941
# ╟─e62bbc6f-8472-4f2f-805e-0bb9a1fae241
# ╠═371070d1-7984-482a-8f33-61cd781b17e6
# ╠═40ce1322-8e94-4b49-a635-edaee805497b
# ╟─3bedbec3-53c3-4ef8-bead-1c6b7ffd3a3f
# ╠═35abc5f5-71bc-4e05-89cc-cf5a48788790
# ╠═b2b5576b-992e-4168-9259-c328cce44858
