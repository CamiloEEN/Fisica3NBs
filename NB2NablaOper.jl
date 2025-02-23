### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ 04607040-10f5-4d42-8464-511fd1cc5153
begin
	using PlutoUI
	PlutoUI.TableOfContents(title="📚 Tabla de contenido", indent=true, depth=4, aside=true, include_definitions=true)
end

# ╔═╡ aee068dd-41c6-4d32-b95c-787f325967f6
begin
	using CairoMakie
	import GeometryBasics
	using LinearAlgebra
	using Statistics 
end

# ╔═╡ 4491e100-e4d6-11ef-2070-0de3361779e8
md"""
# Elementos diferenciales y operador Nabla
"""

# ╔═╡ 710c6ed9-ed62-42db-95ab-749d2698053c
md"""!!! info "📚 Recorderis 👀:" 
	__¿Por que los ángulos se miden en radianes?__

	Para responder la pregunta primero hay que definir que es un ángulo. Un ángulo $\theta$ es la razón entre la longitud de arco de una circunferencia $S$ y su radio $r$, es decir,

	$\theta=\frac{S}{r}$

	dicho ángulo medido de esa forma se dice que está en radianes, aunque en realidad es una medida adimensional pues es la razón entre dos magnitudes de longitud.

	Note que la longitud de arco $S$ varia desde $0$ a $P$ donde $P$ es el perímetro de la circunferencia, por lo que si quisieramos medir el ángulo de toda una circunferencia,

	$\theta=\frac{P}{r}$

	Recordando que el radio es la mitad del diámetro $r=\frac{D}{2}$:

	$\theta=\frac{P}{r}=2\frac{P}{D}$

	Da la casualidad que para cualquier circunferencia, la razón entre su perímetro y diámetro es una constante llamada $\pi$:

	$\pi=\frac{P}{D}$

	por lo tanto, el ángulo que corresponde a toda la circunferencia es:

	$\theta=2 \pi$
"""

# ╔═╡ 49c0a961-01c7-48b3-842b-e2548afe0470
begin
# Create figure and axis
fig1 = Figure()
ax1 = Axis(fig1[1,1], aspect = 1, title = "¿Que es un radián?", xlabel = "X", ylabel = "Y")

# Define circle
θ1 = LinRange(0, 2π, 200)
circle_x1 = cos.(θ1)
circle_y1 = sin.(θ1)
lines!(ax1, circle_x1, circle_y1, color=:black)

# Plot x axis
lines!(ax1, [0, 1], [0, 0], color=:blue, linewidth=2, label="Radius")

# Plot y axis
lines!(ax1, [0, 0], [0, 1], color=:blue, linewidth=2, label="Radius")

# Plot radius
lines!(ax1, [0, cos(1)], [0, sin(1)], color=:black, linewidth=2, label="Radius")

# Plot 1 radian arc
θ_radian1 = LinRange(0, 1, 50)  # 1 radian
arc_x_radian1 = cos.(θ_radian1)
arc_y_radian1 = sin.(θ_radian1)
lines!(ax1, arc_x_radian1, arc_y_radian1, color=:green, linewidth=2, label="1 Radian (s=r)")

# Plot 2 radian arc
θ_radian2 = LinRange(0, 1, 50)  # 1 radian
arc_x_radian2 = 0.3*cos.(θ_radian2)
arc_y_radian2 = 0.3*sin.(θ_radian2)
lines!(ax1, arc_x_radian2, arc_y_radian2, color=:red, linewidth=2, label="1 Radian (s=r)")

# Labels
text!(ax1, "S= 1m", position=(cos(π/4), sin(π/4)), fontsize=16, color=:green)
text!(ax1, "r= 1m", position=(0.5*cos(π/4)-0.3, 0.5*sin(π/4)+0.3), fontsize=16, color=:black)
text!(ax1, "θ=S/r=1 radián", position=(0.35*cos(1/2)-0.05, 0.35*sin(1/2)), fontsize=16, color=:red)
	
# Add legend
#axislegend(ax)

fig1

end

# ╔═╡ d0fb4eec-2013-436a-b4e1-1b4105c5cc6f
md"""
Para esta sección es muy importante tener en cuenta que la longitud de arco $S$ de se puede obtener como $S=r\theta$, donde $r$ es el radio de dicha circunferencia y $\theta$ es el ángulo medido en radianes. Dicha fórmula juega un papel importante para entender ciertas diferenciales de longitud.
"""

# ╔═╡ 7dbd4736-c117-40d4-9284-5f3402066a75
md"""
## Diferenciales de longitud 2D
"""

# ╔═╡ 1e0799d5-2708-44bf-a554-b24007b8e248
begin
	# Create figure and axis
fig3 = Figure()
ax3 = Axis(fig3[1,1], aspect = 1, title = "Diferenciales en Coordenadas Cartesianas",
          xlabel = "X", ylabel = "Y", limits = ((0, 2), (0, 2)))

#
# Define grid for differential area
dx3 = 0.5  # Small x step
dy3 = 0.5  # Small y step
x03, y03 = (1, 1)  # Base point

#Draw dashed line to base point
lines!(ax3, [0, x03], [y03,y03],color=:black, linewidth=2, linestyle=:dash )
lines!(ax3, [x03, x03], [0,y03],color=:black, linewidth=2, linestyle=:dash )

# Draw a small differential rectangle
poly!(ax3, [x03, x03+dx3, x03+dx3, x03], [y03, y03, y03+dy3, y03+dy3], color=:lightblue, strokewidth=2, strokecolor=:black)

# Draw dx and dy as arrows
arrows!(ax3, [x03], [y03], [dx3], [0], linewidth=2, color=:red)
arrows!(ax3, [x03], [y03], [0], [dy3], linewidth=2, color=:blue)

# Label dx and dy
text!(ax3, "dx", position=(x03+dx3/2, y03-0.1), fontsize=14, color=:red)
text!(ax3, "dy", position=(x03-0.1, y03+dy3/2), fontsize=14, color=:blue)

# Label differential area
dA_pos = (x03+dx3/2-0.22, y03+dy3/2)
text!(ax3, "dA = dx dy", position=dA_pos, fontsize=14, color=:black)

# Show the figure
fig3

end

# ╔═╡ 0506b7e6-445b-40b1-b3a9-9b0693b07411
begin

    # Create figure and axis
    fig2 = Figure()
    ax2 = Axis(fig2[1,1], aspect = 1, title = "Diferenciales en coordenadas polares", xlabel = "X", ylabel = "Y")

    # Define a small sector
    r2 = 1.0
    dr2 = 0.2
    dθ2 = π / 3

    # Define the main circle
    θ2 = LinRange(0, 2π, 200)
    circle_x2 = r2 * cos.(θ2)
    circle_y2 = r2 * sin.(θ2)
    lines!(ax2, circle_x2, circle_y2, color=:black)

    # Define the inner and outer arcs
    θ_sector = LinRange(0.7, dθ2, 50)
    arc_x_inner2 = r2 * cos.(θ_sector)
    arc_y_inner2 = r2 * sin.(θ_sector)
    arc_x_outer2 = (r2 + dr2) * cos.(θ_sector)
    arc_y_outer2 = (r2 + dr2) * sin.(θ_sector)
    lines!(ax2, arc_x_inner2, arc_y_inner2, color=:blue, linewidth=2, label="r dθ")
    lines!(ax2, arc_x_outer2, arc_y_outer2, color=:blue, linewidth=2)

	#Define angle arc
	θ_angle_arc2 = LinRange(0,0.7, 50)
	lines!(ax2, 0.3*r2*cos.(θ_angle_arc2), 0.3*r2*sin.(θ_angle_arc2), color=:red, linewidth=2)
	
	#Define diferential angle arc
	lines!(ax2, 0.3*arc_x_inner2, 0.3*arc_y_inner2, color=:red, linewidth=2)

    # Define radial lines
    lines!(ax2, [0, r2 * cos(0.7)], [0, r2 * sin(0.7)], color=:black, linewidth=2, label="dr")
    lines!(ax2, [0, r2 * cos(dθ2)], [0, r2 * sin(dθ2)], color=:black, linewidth=2)
	lines!(ax2, [r2 * cos(dθ2), (r2 + dr2)* cos(dθ2)], [r2 * sin(dθ2), (r2 + dr2) * sin(dθ2)], color=:red, linewidth=2)

	# Plot x axis
lines!(ax2, [0, 1], [0, 0], color=:black, linewidth=2)

# Plot y axis
lines!(ax2, [0, 0], [0, 1], color=:black, linewidth=2)

	
    # Highlight the differential area
    poly_x = [arc_x_inner2; reverse(arc_x_outer2)]
    poly_y = [arc_y_inner2; reverse(arc_y_outer2)]
    poly!(ax2, poly_x, poly_y, color=(:green, 0.3))

    # Labels
    text!(ax2, "dr", position=(r2 * cos(dθ2+0.1), r2 * sin(dθ2+0.1)), fontsize=16, color=:red)
    text!(ax2, "r dθ", position=(0.8*r2 * cos(dθ2 / 1.2), 0.8*r2 * sin(dθ2 / 1.2)), fontsize=16, color=:blue, rotation = π/4)
    text!(ax2, "dA = r dr dθ", position=(1.05*r2 * cos(0.7), 1.05*r2 * sin(0.7)), fontsize=16, color=:green, rotation = -π/3-0.1)
	text!(ax2, "θ+dθ", position=(0.35*r2 * cos(0.7), 0.35*r2 * sin(0.7)), fontsize=16, color=:red, rotation = π/4)
	text!(ax2, "θ", position=(0.35*r2 * cos(0.2), 0.35*r2 * sin(0.2)), fontsize=16, color=:red, rotation = π/6)

    fig2
end


# ╔═╡ 6effe90b-9268-48b8-9ca0-e86f038eadee
md"""
## Diferenciales de longitud en 3D
"""

# ╔═╡ ff3de673-f6d2-4905-9aab-1eb7b8a80301
md"""
### Diferenciales en coordenadas cartesianas
"""

# ╔═╡ ffb3cd02-7e51-4414-88e7-4d11331f2b90
begin
	
	# Create figure and 3D axis
	fig4 = Figure()
	ax4 = Axis3(fig4[1,1], title = "Diferenciales en coordenadas cartesianas",
	           xlabel = "X", ylabel = "Y", zlabel = "Z", azimuth = 0.15*π)
	
	# Define the box (cuboid)
	box4 = Rect3f(Vec3f(2, 2, 3), Vec3f(1, 1, 1))  # Box at (1,1,1) with size (2,2,2)
	
	# Draw the box
	mesh!(ax4, box4, color = (:blue, 0.3))  # 50% transparent blue
	
	# **Set limits to fully include the box**
	xlims!(ax4, -1, 4)
	ylims!(ax4, -1, 4)
	zlims!(ax4, -1, 4)

	# Draw full axis lines with labels for the legend
	lines!(ax4, [0, 2.5], [0, 0], [0, 0], color = :red, linewidth = 2)
	lines!(ax4, [0, 0], [0, 2.5], [0, 0], color = :green, linewidth = 2)
	lines!(ax4, [0, 0], [0, 0], [0, 2.5], color = :blue, linewidth = 2)

	# Add text labels for the axes
	text!(ax4, "X", position = (4, 0, 0), color = :red, fontsize = 20)
	text!(ax4, "Y", position = (0, 3, 0), color = :green, fontsize = 20)
	text!(ax4, "Z", position = (0, 0, 3), color = :blue, fontsize = 20)
	
	# Draw coordinate axes correctly
	arrows!(ax4, [0, 0, 0], [0, 0, 0], [0, 0, 0], [2.5, 0, 0], 
                     [0, 2.5, 0], [0, 0, 2.5], linewidth = 4, 
                     color = [:red, :green, :blue], arrowsize = 0.1, 
                     lengthscale = 1.0)

	#Drawing the back cornes box in dashed black
	lines!(ax4, [2,3], [2,2], [3,3], color=:black, linewidth=2, linestyle=:dash)
	lines!(ax4, [2,2], [2,3], [3,3], color=:black, linewidth=2, linestyle=:dash)
	lines!(ax4, [2,2], [2,2], [3,4], color=:black, linewidth=2, linestyle=:dash)
	#Drawing the front cornes box in black
	lines!(ax4, [2,3], [2,2], [4,4], color=:black, linewidth=2)
	lines!(ax4, [3,3], [2,3], [3,3], color=:black, linewidth=2)
	lines!(ax4, [3,3], [2,2], [3,4], color=:black, linewidth=2)
	lines!(ax4, [2,3], [3,3], [4,4], color=:black, linewidth=2)
	lines!(ax4, [3,3], [2,3], [4,4], color=:black, linewidth=2)
	lines!(ax4, [3,3], [3,3], [3,4], color=:black, linewidth=2)
	#draw references lines to identify the position of the box
	lines!(ax4, [2,2], [2,2], [0,3], color=:black, linewidth=2)
	lines!(ax4, [0,2], [2,2], [0,0], color=:black, linewidth=2)
	lines!(ax4, [2,2], [0,2], [0,0], color=:black, linewidth=2)
	#draw the cornes higlighted for dx, dy and dz labels
	lines!(ax4, [2,3], [3,3], [3,3], color=:red, linewidth=2)
	lines!(ax4, [2,2], [2,3], [4,4], color=:green, linewidth=2)
	lines!(ax4, [2,2], [3,3], [3,4], color=:blue, linewidth=2)
	

	#Add dx, dy and dz labels
	text!(ax4, "dx", position = (1.8, 2.7, 2), color = :red, fontsize = 20)
	text!(ax4, "dy", position = (1.7, 2.2, 4), color = :green, fontsize = 20)
	text!(ax4, "dz", position = (1.7, 3, 3), color = :blue, fontsize = 20)
	
	
	# Show the figure
	fig4
	
end

# ╔═╡ 9d08a61e-bf7e-4e71-b0f0-b0a422fbe6e8
md"""
De manera general un diferencial de longitud en coordenadas cartesianas queda expresado como:

$d\vec{l}=dx\hat{a}_x+ dy\hat{a}_y+ dz\hat{a}_z$

"""

# ╔═╡ 28e8b962-2fd9-4990-86ea-760af014b8e5
md"""
A continuación se pueden apreciar los diferenciales de área:
"""

# ╔═╡ 717c9fa1-d90c-4970-808e-dbdd9d387323
begin
	
	# Create figure and 3D axis
	fig5 = Figure()
	ax5 = Axis3(fig5[1,1], title = L" \textbf{Diferencial de superficie $d\vec{S}=dydz \hat{a}_x$}",
	           xlabel = "X", ylabel = "Y", zlabel = "Z", azimuth = 0.15*π)
	
	# Define the box (cuboid)
	box5 = Rect3f(Vec3f(2, 2, 3), Vec3f(1, 1, 1))  # Box at (1,1,1) with size (2,2,2)
	
	# Draw the box
	mesh!(ax5, box5, color = (:blue, 0.3))  # 30% transparent blue

	# **Set limits to fully include the box**
	xlims!(ax5, -1, 4)
	ylims!(ax5, -1, 4)
	zlims!(ax5, -1, 4)

	# Draw full axis lines with labels for the legend
	lines!(ax5, [0, 2.5], [0, 0], [0, 0], color = :red, linewidth = 2)
	lines!(ax5, [0, 0], [0, 2.5], [0, 0], color = :green, linewidth = 2)
	lines!(ax5, [0, 0], [0, 0], [0, 2.5], color = :blue, linewidth = 2)

	# Add text labels for the axes
	text!(ax5, "X", position = (4, 0, 0), color = :red, fontsize = 20)
	text!(ax5, "Y", position = (0, 3, 0), color = :green, fontsize = 20)
	text!(ax5, "Z", position = (0, 0, 3), color = :blue, fontsize = 20)
	
	# Draw coordinate axes correctly
	arrows!(ax5, [0, 0, 0], [0, 0, 0], [0, 0, 0], [2.5, 0, 0], 
                     [0, 2.5, 0], [0, 0, 2.5], linewidth = 4, 
                     color = [:red, :green, :blue], arrowsize = 0.1, 
                     lengthscale = 1.0)

	#Drawing the back cornes box in dashed black
	lines!(ax5, [2,3], [2,2], [3,3], color=:black, linewidth=2, linestyle=:dash)
	lines!(ax5, [2,2], [2,3], [3,3], color=:black, linewidth=2, linestyle=:dash)
	lines!(ax5, [2,2], [2,2], [3,4], color=:black, linewidth=2, linestyle=:dash)
	#Drawing the front cornes box in black
	lines!(ax5, [2,3], [2,2], [4,4], color=:black, linewidth=2)
	lines!(ax5, [3,3], [2,3], [3,3], color=:black, linewidth=2)
	lines!(ax5, [3,3], [2,2], [3,4], color=:black, linewidth=2)
	lines!(ax5, [2,3], [3,3], [4,4], color=:black, linewidth=2)
	lines!(ax5, [3,3], [2,3], [4,4], color=:black, linewidth=2)
	lines!(ax5, [3,3], [3,3], [3,4], color=:black, linewidth=2)
	#draw references lines to identify the position of the box
	lines!(ax5, [2,2], [2,2], [0,3], color=:black, linewidth=2)
	lines!(ax5, [0,2], [2,2], [0,0], color=:black, linewidth=2)
	lines!(ax5, [2,2], [0,2], [0,0], color=:black, linewidth=2)
	#draw the cornes higlighted for dx, dy and dz labels
	lines!(ax5, [2,3], [3,3], [3,3], color=:red, linewidth=2)
	lines!(ax5, [2,2], [2,3], [4,4], color=:green, linewidth=2)
	lines!(ax5, [2,2], [3,3], [3,4], color=:blue, linewidth=2)
	

	#Add dx, dy and dz labels
	text!(ax5, "dx", position = (1.8, 2.7, 2), color = :red, fontsize = 20)
	text!(ax5, "dy", position = (1.7, 2.2, 4), color = :green, fontsize = 20)
	text!(ax5, "dz", position = (1.7, 3, 3), color = :blue, fontsize = 20)
	
	################################################################################
	#draw diferential surface x
	vertices_x = decompose(Point3f, box5)
	faces_x = GeometryBasics.faces(box5)

	# Extract the face (for example, the front face)
	highlight_face_x = faces_x[2]  # Select front face
	highlight_vertices_x = [vertices_x[i] for i in highlight_face_x]  # Get face's corner points

	highlight_faces_x = [1 2 3; 3 4 1]
	# Draw the highlighted face in solid red
	mesh!(ax5, highlight_vertices_x, highlight_faces_x, color = :black)

	# Compute the normal vector to the face (using the first triangle of the face)
	v1x = highlight_vertices_x[2] - highlight_vertices_x[1]
	v2x = highlight_vertices_x[3] - highlight_vertices_x[1]
	normalx = cross(v1x, v2x)  # Cross product of the vectors v1 and v2 gives the normal

	# Normalize the normal vector
	normalx = normalize(normalx)

	# Compute the centroid of the face (average of the vertices)
	centroidx = mean(highlight_vertices_x)

	#fixed center position for visualization
	centroidx = centroidx - Point3f(0,0.2,0.2)

	# Draw the normal vector (starting from the centroid, scaling for visibility)
	arrows!(ax5, [centroidx], [normalx * 0.5], color = :red, arrowsize = 0.05, lengthscale = 0.5)

	#Add label
	text!(ax5, L"\hat{a}_x", position = centroidx+Point3f(1,-0.27,0), color = :red, fontsize = 20)

	#################################################################################
	
	# Show the figure
	fig5
	
end

# ╔═╡ 7fd7f9e3-8812-43a1-8a7e-4f779c56c0ad
begin
	
	# Create figure and 3D axis
	fig6 = Figure()
	ax6 = Axis3(fig6[1,1], title =  L" \textbf{Diferencial de superficie $d\vec{S}=dxdz \hat{a}_y$}",
	           xlabel = "X", ylabel = "Y", zlabel = "Z", azimuth = 0.15*π)
	
	# Define the box (cuboid)
	box6 = Rect3f(Vec3f(2, 2, 3), Vec3f(1, 1, 1))  # Box at (1,1,1) with size (2,2,2)
	
	# Draw the box
	mesh!(ax6, box6, color = (:blue, 0.3))  # 30% transparent blue

	# **Set limits to fully include the box**
	xlims!(ax6, -1, 4)
	ylims!(ax6, -1, 4)
	zlims!(ax6, -1, 4)

	# Draw full axis lines with labels for the legend
	lines!(ax6, [0, 2.5], [0, 0], [0, 0], color = :red, linewidth = 2)
	lines!(ax6, [0, 0], [0, 2.5], [0, 0], color = :green, linewidth = 2)
	lines!(ax6, [0, 0], [0, 0], [0, 2.5], color = :blue, linewidth = 2)

	# Add text labels for the axes
	text!(ax6, "X", position = (4, 0, 0), color = :red, fontsize = 20)
	text!(ax6, "Y", position = (0, 3, 0), color = :green, fontsize = 20)
	text!(ax6, "Z", position = (0, 0, 3), color = :blue, fontsize = 20)
	
	# Draw coordinate axes correctly
	arrows!(ax6, [0, 0, 0], [0, 0, 0], [0, 0, 0], [2.5, 0, 0], 
                     [0, 2.5, 0], [0, 0, 2.5], linewidth = 4, 
                     color = [:red, :green, :blue], arrowsize = 0.1, 
                     lengthscale = 1.0)

	#Drawing the back cornes box in dashed black
	lines!(ax6, [2,3], [2,2], [3,3], color=:black, linewidth=2, linestyle=:dash)
	lines!(ax6, [2,2], [2,3], [3,3], color=:black, linewidth=2, linestyle=:dash)
	lines!(ax6, [2,2], [2,2], [3,4], color=:black, linewidth=2, linestyle=:dash)
	#Drawing the front cornes box in black
	lines!(ax6, [2,3], [2,2], [4,4], color=:black, linewidth=2)
	lines!(ax6, [3,3], [2,3], [3,3], color=:black, linewidth=2)
	lines!(ax6, [3,3], [2,2], [3,4], color=:black, linewidth=2)
	lines!(ax6, [2,3], [3,3], [4,4], color=:black, linewidth=2)
	lines!(ax6, [3,3], [2,3], [4,4], color=:black, linewidth=2)
	lines!(ax6, [3,3], [3,3], [3,4], color=:black, linewidth=2)
	#draw references lines to identify the position of the box
	lines!(ax6, [2,2], [2,2], [0,3], color=:black, linewidth=2)
	lines!(ax6, [0,2], [2,2], [0,0], color=:black, linewidth=2)
	lines!(ax6, [2,2], [0,2], [0,0], color=:black, linewidth=2)
	#draw the cornes higlighted for dx, dy and dz labels
	lines!(ax6, [2,3], [3,3], [3,3], color=:red, linewidth=2)
	lines!(ax6, [2,2], [2,3], [4,4], color=:green, linewidth=2)
	lines!(ax6, [2,2], [3,3], [3,4], color=:blue, linewidth=2)
	

	#Add dx, dy and dz labels
	text!(ax6, "dx", position = (1.8, 2.7, 2), color = :red, fontsize = 20)
	text!(ax6, "dy", position = (1.7, 2.2, 4), color = :green, fontsize = 20)
	text!(ax6, "dz", position = (1.7, 3, 3), color = :blue, fontsize = 20)
	
	################################################################################
	#draw diferential surface x
	vertices_y = decompose(Point3f, box6)
	faces_y = GeometryBasics.faces(box6)

	# Extract the face (for example, the front face)
	highlight_face_y = faces_y[4]  # Select front face
	highlight_vertices_y = [vertices_y[i] for i in highlight_face_y]  # Get face's corner points

	highlight_faces_y = [1 2 3; 3 4 1]
	# Draw the highlighted face in solid red
	mesh!(ax6, highlight_vertices_y, highlight_faces_y, color = :black)

	# Compute the normal vector to the face (using the first triangle of the face)
	v1y = highlight_vertices_y[2] - highlight_vertices_y[1]
	v2y = highlight_vertices_y[3] - highlight_vertices_y[1]
	normaly = cross(v1y, v2y)  # Cross product of the vectors v1 and v2 gives the normal

	# Normalize the normal vector
	normaly = normalize(normaly)

	# Compute the centroid of the face (average of the vertices)
	centroidy = mean(highlight_vertices_y)

	#fixed center position for visualization
	centroidy = centroidy - Point3f(0.5,0.0,0.3)

	# Draw the normal vector (starting from the centroid, scaling for visibility)
	arrows!(ax6, [centroidy], [normaly * 0.5], color = :green, arrowsize = 0.05, lengthscale = 0.4)

	#Add label
	text!(ax6, L"\hat{a}_y", position = centroidy+Point3f(1,1,0), color = :green, fontsize = 20)

	#################################################################################
	
	# Show the figure
	fig6
	
end

# ╔═╡ 4c54cd2b-9c92-4ffb-a96d-d74f11bc52ea
begin
	
	# Create figure and 3D axis
	fig7 = Figure()
	ax7 = Axis3(fig7[1,1], title =  L" \textbf{Diferencial de superficie $d\vec{S}=dxdy \hat{a}_z$}",
	           xlabel = "X", ylabel = "Y", zlabel = "Z", azimuth = 0.15*π)
	
	# Define the box (cuboid)
	box7 = Rect3f(Vec3f(2, 2, 3), Vec3f(1, 1, 1))  # Box at (1,1,1) with size (2,2,2)
	
	# Draw the box
	mesh!(ax7, box7, color = (:blue, 0.3))  # 30% transparent blue

	# **Set limits to fully include the box**
	xlims!(ax7, -1, 5)
	ylims!(ax7, -1, 5)
	zlims!(ax7, -1, 5)

	# Draw full axis lines with labels for the legend
	lines!(ax7, [0, 2.5], [0, 0], [0, 0], color = :red, linewidth = 2)
	lines!(ax7, [0, 0], [0, 2.5], [0, 0], color = :green, linewidth = 2)
	lines!(ax7, [0, 0], [0, 0], [0, 2.5], color = :blue, linewidth = 2)

	# Add text labels for the axes
	text!(ax7, "X", position = (4, 0, 0), color = :red, fontsize = 20)
	text!(ax7, "Y", position = (0, 3, 0), color = :green, fontsize = 20)
	text!(ax7, "Z", position = (0, 0, 3), color = :blue, fontsize = 20)
	
	# Draw coordinate axes correctly
	arrows!(ax7, [0, 0, 0], [0, 0, 0], [0, 0, 0], [2.5, 0, 0], 
                     [0, 2.5, 0], [0, 0, 2.5], linewidth = 4, 
                     color = [:red, :green, :blue], arrowsize = 0.1, 
                     lengthscale = 1.0)

	#Drawing the back cornes box in dashed black
	lines!(ax7, [2,3], [2,2], [3,3], color=:black, linewidth=2, linestyle=:dash)
	lines!(ax7, [2,2], [2,3], [3,3], color=:black, linewidth=2, linestyle=:dash)
	lines!(ax7, [2,2], [2,2], [3,4], color=:black, linewidth=2, linestyle=:dash)
	#Drawing the front cornes box in black
	lines!(ax7, [2,3], [2,2], [4,4], color=:black, linewidth=2)
	lines!(ax7, [3,3], [2,3], [3,3], color=:black, linewidth=2)
	lines!(ax7, [3,3], [2,2], [3,4], color=:black, linewidth=2)
	lines!(ax7, [2,3], [3,3], [4,4], color=:black, linewidth=2)
	lines!(ax7, [3,3], [2,3], [4,4], color=:black, linewidth=2)
	lines!(ax7, [3,3], [3,3], [3,4], color=:black, linewidth=2)
	#draw references lines to identify the position of the box
	lines!(ax7, [2,2], [2,2], [0,3], color=:black, linewidth=2)
	lines!(ax7, [0,2], [2,2], [0,0], color=:black, linewidth=2)
	lines!(ax7, [2,2], [0,2], [0,0], color=:black, linewidth=2)
	#draw the cornes higlighted for dx, dy and dz labels
	lines!(ax7, [2,3], [3,3], [3,3], color=:red, linewidth=2)
	lines!(ax7, [2,2], [2,3], [4,4], color=:green, linewidth=2)
	lines!(ax7, [2,2], [3,3], [3,4], color=:blue, linewidth=2)
	

	#Add dx, dy and dz labels
	text!(ax7, "dx", position = (1.8, 2.7, 2), color = :red, fontsize = 20)
	text!(ax7, "dy", position = (1.7, 2.2, 4), color = :green, fontsize = 20)
	text!(ax7, "dz", position = (1.7, 3, 3), color = :blue, fontsize = 20)
	
	################################################################################
	#draw diferential surface x
	vertices_z = decompose(Point3f, box7)
	faces_z = GeometryBasics.faces(box7)

	# Extract the face (for example, the front face)
	highlight_face_z = faces_z[6]  # Select front face
	highlight_vertices_z = [vertices_z[i] for i in highlight_face_z]  # Get face's corner points

	highlight_faces_z = [1 2 3; 3 4 1]
	# Draw the highlighted face in solid red
	mesh!(ax7, highlight_vertices_z, highlight_faces_z, color = :black)

	# Compute the normal vector to the face (using the first triangle of the face)
	v1z = highlight_vertices_z[2] - highlight_vertices_z[1]
	v2z = highlight_vertices_z[3] - highlight_vertices_z[1]
	normalz = cross(v1z, v2z)  # Cross product of the vectors v1 and v2 gives the normal

	# Normalize the normal vector
	normalz = normalize(normalz)

	# Compute the centroid of the face (average of the vertices)
	centroidz = mean(highlight_vertices_z)

	#fixed center position for visualization
	centroidz = centroidz + Point3f(-0.2,-0.2,0.5)

	# Draw the normal vector (starting from the centroid, scaling for visibility)
	arrows!(ax7, [centroidz], [normalz * 0.5], color = :blue, arrowsize = 0.05, lengthscale = 0.4)

	#Add label
	text!(ax7, L"\hat{a}_z", position = centroidz+Point3f(0,-0.7,0.2), color = :blue, fontsize = 20)

	#################################################################################
	
	# Show the figure
	fig7
	
end

# ╔═╡ b234396a-c1ff-48e4-8a03-30f5a89a21c0
md"""
El correspondiente diferencial de volumen es simplemente $dV=dxdydz$.
"""

# ╔═╡ 32c53067-982e-4cf1-b437-925f3cdaeaf6
md"""
### Diferenciales en coordenadas cilíndricas:
"""

# ╔═╡ ac32bdd0-18b5-4a2f-9423-efffef7aa355
# Create sliders for ρ, φ, z
@bind cilindCoord PlutoUI.combine() do Child
	md""" ρ = $(Child( PlutoUI.Slider(0:4; default=2, show_value=true))),  ϕ = $(Child( PlutoUI.Slider(0:0.1:π/2 ; default=π/5, show_value=true))), z= $(Child( PlutoUI.Slider(0:4; default=1, show_value=true)))"""

end

# ╔═╡ a820de5c-01ac-4c10-90c4-c580bf021c18
begin
	# Define the differential volume element
	dρ = 0.5
	dϕ = π/7
	dz_cylind = 2.0
	
	ρ0 = cilindCoord[1]     # Initial radius and thickness
	ϕ0 = cilindCoord[2]    # Initial angle and small angular slice
	z0_cylind = cilindCoord[3]    # Initial height and small vertical thickness
end

# ╔═╡ ca1d58ae-3844-4830-a58d-1707fefe8b3d
begin

##################FUNCTION TO CREATE VERTICES AND FACES#######################
function differential_volume_cylind(r0, dr, θ0, dθ, z0, dz)
    # Define the eight corner vertices of the differential volume
    vertices = [
        (r0 * cos(θ0), r0 * sin(θ0), z0);          
        ((r0 + dr) * cos(θ0), (r0 + dr) * sin(θ0), z0);  
        ((r0 + dr) * cos(θ0 + dθ), (r0 + dr) * sin(θ0 + dθ), z0);  
        (r0 * cos(θ0 + dθ), r0 * sin(θ0 + dθ), z0);  
        
        (r0 * cos(θ0), r0 * sin(θ0), z0 + dz);  
        ((r0 + dr) * cos(θ0), (r0 + dr) * sin(θ0), z0 + dz);  
        ((r0 + dr) * cos(θ0 + dθ), (r0 + dr) * sin(θ0 + dθ), z0 + dz);  
        (r0 * cos(θ0 + dθ), r0 * sin(θ0 + dθ), z0 + dz)  
    ]

    # Convert to 3D points
    vertices = [Point3f(p...) for p in vertices]

    # Define faces using a matrix instead of tuples
    faces = [
        1 2 3; 3 4 1;  # Bottom face
        5 6 7; 7 8 5;  # Top face
        1 2 6; 6 5 1;  # Side face 1
        2 3 7; 7 6 2;  # Side face 2
        3 4 8; 8 7 3;  # Side face 3
        4 1 5; 5 8 4   # Side face 4
    ]

    return vertices, faces
end
##################END OF FUNCTION TO CREATE VERTICES AND FACES#######################
	
# Set up a figure and 3D axis
fig8 = Figure()
ax8 = Axis3(fig8[1, 1], title = "Diferenciales en Coordenadas Cilíndricas",
xlabel = "X", ylabel = "Y", zlabel = "Z", azimuth = 0.15*π)

	# **Set limits to fully include the box**
	xlims!(ax8, -1, 5)
	ylims!(ax8, -1, 5)
	zlims!(ax8, -1, 5)

	# Draw full axis lines with labels for the legend
	lines!(ax8, [0, 2.5], [0, 0], [0, 0], color = :red, linewidth = 2)
	lines!(ax8, [0, 0], [0, 2.5], [0, 0], color = :green, linewidth = 2)
	lines!(ax8, [0, 0], [0, 0], [0, 2.5], color = :blue, linewidth = 2)

	# Add text labels for the axes
	text!(ax8, "X", position = (4, 0, 0), color = :red, fontsize = 20)
	text!(ax8, "Y", position = (0, 3, 0), color = :green, fontsize = 20)
	text!(ax8, "Z", position = (0, 0, 3), color = :blue, fontsize = 20)
	
	# Draw coordinate axes correctly
	arrows!(ax8, [0, 0, 0], [0, 0, 0], [0, 0, 0], [2.5, 0, 0], 
                     [0, 2.5, 0], [0, 0, 2.5], linewidth = 4, 
                     color = [:red, :green, :blue], arrowsize = 0.1, 
                     lengthscale = 1.0)
	
vertices_cylind, faces_cylind = differential_volume_cylind(ρ0, dρ, ϕ0, dϕ, z0_cylind, dz_cylind)

# Plot the differential volume
mesh!(ax8, vertices_cylind, faces_cylind, color = (:blue, 0.3))

########################ADD LINES FOR VISUALIZATION###########################

####################For differential volume visualization#####################
# draw point
scatter!((ρ0+dρ)*cos(ϕ0), (ρ0+dρ)*sin(ϕ0), z0_cylind+ dz_cylind, color = :black )

#draw internal dashed lines
lines!(ax8, [ρ0*cos(ϕ0+dϕ),ρ0*cos(ϕ0+dϕ)],[ρ0*sin(ϕ0+dϕ),ρ0*sin(ϕ0+dϕ)],[z0_cylind,z0_cylind+dz_cylind],color = :black, linewidth = 2, linestyle= :dash )
lines!(ax8, [ρ0*cos(ϕ0+dϕ),(ρ0+dρ)*cos(ϕ0+dϕ)],[ρ0*sin(ϕ0+dϕ),(ρ0+dρ)*sin(ϕ0+dϕ)],[z0_cylind,z0_cylind],color = :black, linewidth = 2, linestyle= :dash )

ϕ_range_cylind_dashed = LinRange(ϕ0, ϕ0+ dϕ, 50)
circle_bottom_cylind_x_dashed = (ρ0)*cos.(ϕ_range_cylind_dashed)
circle_bottom_cylind_y_dashed = (ρ0)*sin.(ϕ_range_cylind_dashed)

lines!(ax8, circle_bottom_cylind_x_dashed, circle_bottom_cylind_y_dashed, fill(z0_cylind,length(ϕ_range_cylind_dashed)), color = :black, linewidth = 2, linestyle= :dash)

#draw radial distance dashed lines
lines!(ax8, [0,(ρ0+dρ)*cos(ϕ0)],[0,(ρ0+dρ)*sin(ϕ0)],[z0_cylind+ dz_cylind,z0_cylind+ dz_cylind],color = :black, linewidth = 2, linestyle= :dash )
lines!(ax8, [0,(ρ0+dρ)*cos(ϕ0+dϕ)],[0,(ρ0+dρ)*sin(ϕ0+dϕ)],[z0_cylind+ dz_cylind,z0_cylind+ dz_cylind],color = :black, linewidth = 2, linestyle= :dash )

# draw bottom front curve ρdϕ
lines!(ax8, (ρ0+dρ)*circle_bottom_cylind_x_dashed/ρ0, (ρ0+dρ)*circle_bottom_cylind_y_dashed/ρ0, fill(z0_cylind,length(ϕ_range_cylind_dashed)), color = :black, linewidth = 2)

text!(ax8, L"ρdϕ", position = ((ρ0+dρ)*cos(ϕ0+dϕ/3), (ρ0+dρ)*sin(ϕ0+dϕ/3), z0_cylind-0.7), color = :black, fontsize = 20 )

# draw vertical line dz
lines!(ax8, [(ρ0+dρ)*cos(ϕ0+dϕ),(ρ0+dρ)*cos(ϕ0+dϕ)],[(ρ0+dρ)*sin(ϕ0+dϕ),(ρ0+dρ)*sin(ϕ0+dϕ)],[z0_cylind,z0_cylind+dz_cylind],color = :black, linewidth = 2)

text!(ax8, L"dz", position =((ρ0+dρ)*cos(ϕ0+dϕ+0.05), (ρ0+dρ)*sin(ϕ0+dϕ+0.05),z0_cylind+dz_cylind/3 ), color = :black, fontsize = 20 )

# draw radial line dρ
lines!(ax8, [ρ0*cos(ϕ0+dϕ),(ρ0+dρ)*cos(ϕ0+dϕ)],[ρ0*sin(ϕ0+dϕ),(ρ0+dρ)*sin(ϕ0+dϕ)],[z0_cylind+dz_cylind,z0_cylind+dz_cylind],color = :black, linewidth = 2)

text!(ax8, L"d\rho", position =((ρ0+dρ/3)*cos(ϕ0+dϕ), (ρ0+dρ/3)*sin(ϕ0+dϕ),z0_cylind+dz_cylind +0.2), color = :black, fontsize = 20 )

#################For projection and perspective visualization##################
#draw lines and curves indicating projections to the xy plane
lines!(ax8, [(ρ0+dρ)*cos(ϕ0),(ρ0+dρ)*cos(ϕ0)], [(ρ0+dρ)*sin(ϕ0),(ρ0+dρ)*sin(ϕ0)]
, [0,z0_cylind+ dz_cylind ], color = :black, linewidth = 2) # point to xy plane

lines!(ax8, [0,(ρ0+dρ)*cos(ϕ0)], [0,(ρ0+dρ)*sin(ϕ0)]
, [0,0 ], color = :black, linewidth = 2) #origin to point projection on xy plane

# define and draw the bottom curve projection
ϕ_range_cylind = LinRange(0, π/2, 50)
circle_bottom_cylind_x = (ρ0+dρ)*cos.(ϕ_range_cylind)
circle_bottom_cylind_y = (ρ0+dρ)*sin.(ϕ_range_cylind)

lines!(ax8, circle_bottom_cylind_x, circle_bottom_cylind_y, zeros(length(ϕ_range_cylind)), color = :black)

#draw the top curve
lines!(ax8, circle_bottom_cylind_x, circle_bottom_cylind_y, fill(z0_cylind+ dz_cylind,length(ϕ_range_cylind)), color = :black)

#vertical lines
lines!(ax8, [(ρ0+dρ),(ρ0+dρ)], [0,0]
, [0,z0_cylind+ dz_cylind ], color = :black, linewidth = 2)

lines!(ax8, [0,0], [(ρ0+dρ),(ρ0+dρ)]
, [0,z0_cylind+ dz_cylind ], color = :black, linewidth = 2)

#parralel to xy plane lines
lines!(ax8, [0,(ρ0+dρ)], [0,0]
, [z0_cylind+ dz_cylind,z0_cylind+ dz_cylind ], color = :black, linewidth = 2)
lines!(ax8, [0,0], [0,(ρ0+dρ)]
, [z0_cylind+ dz_cylind,z0_cylind+ dz_cylind ], color = :black, linewidth = 2)
################################################################################
	
# Show the figure
fig8

end

# ╔═╡ d250da1e-6b2c-48fc-be8b-573678683efe
md"""
De manera general un diferencial de longitud en coordenadas cílindricas queda expresado como:

$d\vec{l}=d\rho \hat{a}_\rho+ \rho d\phi \hat{a}_\phi+ dz\hat{a}_z$

"""

# ╔═╡ 7721ed95-7ffa-4050-85dc-9fdc304e81d4
begin #THIS WORKS WITH SURFACE! FUNCTION TO CREATE FACES BUT IS SLOWER THAN MESH!
		# Define faces
		@enum diffaces bottom top front back left right
	
		# Create function that returns face points in matrix form
		# The matrix is required for surface! to know which are the nearest neigbor
		function facePointsCylind(diffaces, r0, dr, θ0, dθ, z0, dz)
			n_points::Int = 3
			
			if diffaces == bottom
				r_ranges = LinRange(r0, r0+dr, n_points)
				θ_ranges = LinRange(θ0, θ0+dθ, n_points)
				
				x = [r * cos(θ) for r in r_ranges, θ in θ_ranges]
				y = [r * sin(θ) for r in r_ranges, θ in θ_ranges]
				z = [z0 for r in r_ranges, θ in θ_ranges]
	
				return x, y, z
			elseif diffaces == top
				r_ranges = LinRange(r0, r0+dr, n_points)
				θ_ranges = LinRange(θ0, θ0+dθ, n_points)
				
				x = [r * cos(θ) for r in r_ranges, θ in θ_ranges]
				y = [r * sin(θ) for r in r_ranges, θ in θ_ranges]
				z = [z0+dz_cylind for r in r_ranges, θ in θ_ranges]
	
				return x, y, z
			elseif diffaces == front
				θ_ranges = LinRange(θ0, θ0+dθ, n_points)
				z_ranges = LinRange(z0, z0+dz_cylind, n_points)
	
				x = [(r0+dr) * cos(θ) for z in z_ranges, θ in θ_ranges]
				y = [(r0+dr) * sin(θ) for z in z_ranges, θ in θ_ranges]
				z = [z for z in z_ranges, θ in θ_ranges]
	
				return x, y, z
			elseif diffaces == back
				θ_ranges = LinRange(θ0, θ0+dθ, n_points)
				z_ranges = LinRange(z0, z0+dz_cylind, n_points)
	
				x = [r0 * cos(θ) for z in z_ranges, θ in θ_ranges]
				y = [r0 * sin(θ) for z in z_ranges, θ in θ_ranges]
				z = [z for z in z_ranges, θ in θ_ranges]

				return x, y, z
			elseif diffaces == left
				r_ranges = LinRange(r0, r0+dr, n_points)
				z_ranges = LinRange(z0, z0+dz_cylind, n_points)
	
				x = [r * cos(θ0+dθ) for r in r_ranges, z in z_ranges]
				y = [r * sin(θ0+dθ) for r in r_ranges, z in z_ranges]
				z = [z for r in r_ranges, z in z_ranges]
	
				return x, y, z
			elseif diffaces == right
				r_ranges = LinRange(r0, r0+dr, n_points)
				z_ranges = LinRange(z0, z0+dz_cylind, n_points)
	
				x = [r * cos(θ0) for r in r_ranges, z in z_ranges]
				y = [r * sin(θ0) for r in r_ranges, z in z_ranges]
				z = [z for r in r_ranges, z in z_ranges]
	
				return x, y, z
			end
			
		end
end

# ╔═╡ 7f5fa0bc-4343-4a39-91f1-ebdaa6e3f61c
md"""
De manera similar a las coordenadas cartesianas se tienen los 3 diferenciales de superficie:

$\begin{align}
d\vec{S}&= (\rho d\phi) (dz) \hat{a}_\rho \\
d\vec{S}&= (d\rho )(dz) \hat{a}_\phi \\
d\vec{S}&= ( d\rho) (\rho d\phi) \hat{a}_z
\end{align}$
"""

# ╔═╡ fd175a60-5e0d-4ec9-86dc-9da65f4511e7
md"""
Note que ignorando la parte vectorial, los diferenciales de superficie son productos entre diferenciales de longitud como en las coordenadas cartesianas, además, Los vectores unitarios son ortogonales a la superficie en questión como en el caso de coordenadas cartesianas.
"""

# ╔═╡ 28e68492-0984-40a4-b934-c672f4cdadef
md"""
Finalmente el diferencial de volumen se obtiene como:

$dV= (d\rho)(\rho d\phi)(dz) = \rho d\rho d\phi dz$
"""

# ╔═╡ 5bb62fda-8afe-4919-bd5c-d3a1201c6691
md"""
### Diferenciales en coordenadas esféricas:
"""

# ╔═╡ 2242c83d-0bf2-4b2f-a286-06a3180fb630
# Create sliders for r, θ, φ
@bind esferCoord PlutoUI.combine() do Child
	md""" r = $(Child( PlutoUI.Slider(0:0.5:4; default=2, show_value=true))),  θ = $(Child( PlutoUI.Slider(0:0.1:π/2 ; default=π/4, show_value=true))), ϕ= $(Child( PlutoUI.Slider(-π/2:0.1:π/2; default=0, show_value=true)))"""

end

# ╔═╡ 9eb1f2a6-15e9-4baf-ac5c-43dfc4107f66
begin
	# Define the differential volume element
	dr = 1.5
	dθ = π/12
	dφ = π/7
	r0 = esferCoord[1]      # Initial radius and thickness
	θ0 = esferCoord[2]     # Initial angle and small angular slice
	φ0 = esferCoord[3]    # Initial azimuthal angle and small slice
end

# ╔═╡ 3818be09-3bbe-4152-984c-6bd2ad4f1461
begin
	
	function differential_volume_spherical(r0, dr, θ0, dθ, φ0, dφ)
	    # Define the eight corner vertices of the differential volume
	    vertices = [
	        (r0 * sin(θ0) * cos(φ0), r0 * sin(θ0) * sin(φ0), r0 * cos(θ0));  # Bottom face: v1
	        ((r0 + dr) * sin(θ0) * cos(φ0), (r0 + dr) * sin(θ0) * sin(φ0), (r0 + dr) * cos(θ0));  # Bottom face: v2
	        ((r0 + dr) * sin(θ0 + dθ) * cos(φ0), (r0 + dr) * sin(θ0 + dθ) * sin(φ0), (r0 + dr) * cos(θ0 + dθ));  # Bottom face: v3
	        (r0 * sin(θ0 + dθ) * cos(φ0), r0 * sin(θ0 + dθ) * sin(φ0), r0 * cos(θ0 + dθ));  # Bottom face: v4
	        
	        (r0 * sin(θ0) * cos(φ0 + dφ), r0 * sin(θ0) * sin(φ0 + dφ), r0 * cos(θ0));  # Top face: v5
	        ((r0 + dr) * sin(θ0) * cos(φ0 + dφ), (r0 + dr) * sin(θ0) * sin(φ0 + dφ), (r0 + dr) * cos(θ0));  # Top face: v6
	        ((r0 + dr) * sin(θ0 + dθ) * cos(φ0 + dφ), (r0 + dr) * sin(θ0 + dθ) * sin(φ0 + dφ), (r0 + dr) * cos(θ0 + dθ));  # Top face: v7
	        (r0 * sin(θ0 + dθ) * cos(φ0 + dφ), r0 * sin(θ0 + dθ) * sin(φ0 + dφ), r0 * cos(θ0 + dθ))  # Top face: v8
	    ]
	    
	    # Convert to 3D points (Point3f)
	    vertices = [Point3f(p...) for p in vertices]
	    
	    # Define faces using a matrix
	    faces = [
	        1 2 3; 3 4 1;  # Bottom face
	        5 6 7; 7 8 5;  # Top face
	        1 2 6; 6 5 1;  # Side face 1
	        2 3 7; 7 6 2;  # Side face 2
	        3 4 8; 8 7 3;  # Side face 3
	        4 1 5; 5 8 4   # Side face 4
	    ]
	    
	    return vertices, faces
	end
	
	# Set up a figure and 3D axis
	fig = Figure()
	ax = Axis3(fig[1, 1],  title = "Diferenciales en Coordenadas Esféricas",
xlabel = "X", ylabel = "Y", zlabel = "Z", azimuth = 0.15*π)
	
	vertices, faces = differential_volume_spherical(r0, dr, θ0, dθ, φ0, dφ)
	
	# Plot the differential volume
	mesh!(ax, vertices, faces, color=(:blue, 0.3))
	
	# **Set limits to fully include the box**
	xlims!(ax, -1, 5)
	ylims!(ax, -1, 5)
	zlims!(ax, -1, 5)

	# Draw full axis lines with labels for the legend
	lines!(ax, [0, 2.5], [0, 0], [0, 0], color = :red, linewidth = 2)
	lines!(ax, [0, 0], [0, 2.5], [0, 0], color = :green, linewidth = 2)
	lines!(ax, [0, 0], [0, 0], [0, 2.5], color = :blue, linewidth = 2)

	# Add text labels for the axes
	text!(ax, "X", position = (4, 0, 0), color = :red, fontsize = 20)
	text!(ax, "Y", position = (0, 3, 0), color = :green, fontsize = 20)
	text!(ax, "Z", position = (0, 0, 3), color = :blue, fontsize = 20)
	
	# Draw coordinate axes correctly
	arrows!(ax, [0, 0, 0], [0, 0, 0], [0, 0, 0], [2.5, 0, 0], 
                     [0, 2.5, 0], [0, 0, 2.5], linewidth = 4, 
                     color = [:red, :green, :blue], arrowsize = 0.1, 
                     lengthscale = 1.0)

	#############Adding lines for visualization#######################
	lines!(ax, [0, (r0+dr)*sin(θ0+dθ)*cos(φ0)],[0, (r0+dr)*sin(θ0+dθ)*sin(φ0)],[0,(r0+dr)*cos(θ0+dθ)], color = :black, linewidth = 2)

	lines!(ax, [0, (r0+dr)*sin(θ0)*cos(φ0)],[0, (r0+dr)*sin(θ0)*sin(φ0)],[0,(r0+dr)*cos(θ0)], color = :black, linewidth = 2)

	#lines!(ax, [0, (r0+dr)*sin(θ0+dθ)*cos(φ0+dφ)],[0, (r0+dr)*sin(θ0+dθ)*sin(φ0+dφ)],[0,(r0+dr)*cos(θ0+dθ)], color = :black, linewidth = 2)

	#lines!(ax, [0, (r0+dr)*sin(θ0)*cos(φ0+dφ)],[0, (r0+dr)*sin(θ0)*sin(φ0+dφ)],[0,(r0+dr)*cos(θ0)], color = :black, linewidth = 2)

	# draw dashed lines indicating diferent values of θ
	#left curve
	θ_range = LinRange(0, π/2, 50)
	θ_circle_left_x = (r0+dr)*sin.(θ_range)*cos(φ0)
	θ_circle_left_y = (r0+dr)*sin.(θ_range)*sin(φ0)
	θ_circle_z = (r0+dr)*cos.(θ_range)

	lines!(ax,θ_circle_left_x, θ_circle_left_y, θ_circle_z, color = :black, linewidth = 2, linestyle = :dash )
	
	#right curve
	θ_circle_right_x = (r0+dr)*sin.(θ_range)*cos(φ0+dφ)
	θ_circle_right_y = (r0+dr)*sin.(θ_range)*sin(φ0+dφ)
	
	lines!(ax,θ_circle_right_x, θ_circle_right_y, θ_circle_z, color = :black, linewidth = 2, linestyle = :dash )

	# draw dashed lines indicating diferent values of φ
	#Bottom dashed circle
	φ_range = LinRange(0, π/2, 50)
	φ_circle_bottom_x = (r0+dr)*sin(θ0+dθ)*cos.(φ_range)
	φ_circle_bottom_y = (r0+dr)*sin(θ0+dθ)*sin.(φ_range)
	φ_circle_bottom_z = fill( (r0+dr)*cos(θ0+dθ), length(φ_range))

	lines!(ax, φ_circle_bottom_x, φ_circle_bottom_y, φ_circle_bottom_z, color = :black, linewidth = 2, linestyle = :dash)

	#Top dashed circle
	φ_circle_top_x = (r0+dr)*sin(θ0)*cos.(φ_range)
	φ_circle_top_y = (r0+dr)*sin(θ0)*sin.(φ_range)
	φ_circle_top_z = fill( (r0+dr)*cos(θ0), length(φ_range))

	lines!(ax, φ_circle_top_x, φ_circle_top_y, φ_circle_top_z, color = :black, linewidth = 2, linestyle = :dash)

	#Drawing lines indicating the limits of the portion of the sphere
	#xz plane leftmost θ curve
	θ_circle_leftmost_x = (r0+dr)*sin.(θ_range)
	θ_circle_leftmost_y = fill( 0, length(φ_range))

	lines!(ax,θ_circle_leftmost_x, θ_circle_leftmost_y, θ_circle_z, color = :black, linewidth = 2 )

	#yz plane rightmost θ curve
	θ_circle_rightmost_x = fill( 0, length(φ_range))
	θ_circle_rightmost_y = (r0+dr)*sin.(θ_range)

	lines!(ax,θ_circle_rightmost_x, θ_circle_rightmost_y, θ_circle_z, color = :black, linewidth = 2 )

	#bottom φ curve
	φ_circle_bottommost_x = (r0+dr)*cos.(φ_range)
	φ_circle_bottommost_y = (r0+dr)*sin.(φ_range)
	φ_circle_bottommost_z = fill( 0, length(φ_range))

	lines!(ax, φ_circle_bottommost_x, φ_circle_bottommost_y, φ_circle_bottommost_z, color = :black, linewidth = 2)

	#Labels indicating the curves
	text!(ax, L"r\sin(\theta) d \phi", position = ((r0+dr)*sin(θ0+dθ)*cos(φ0+0.02), (r0+dr)*sin(θ0+dθ)*sin(φ0+0.02),(r0+dr)*cos(θ0+dθ+0.22)), color = :black, fontsize = 20 )
	
	text!(ax, L"rd\theta", position = ((r0+dr)*sin(θ0+dθ/3)*cos(φ0+dφ), (r0+dr)*sin(θ0+dθ/3)*sin(φ0+dφ),(r0+dr)*cos(θ0+dθ/2)), color = :black, fontsize = 20 )

	# Show the figure
	fig
	
end

# ╔═╡ a052a87b-937c-4db3-b62c-71e289750fde
md"""
__RECORDAR GRAFICAR LOS LABELS INDICANDO LOS DIFERENCIALES DE LONGITUD__
"""

# ╔═╡ 7877bc9d-c3fd-4570-a54c-6f632efbe90e
md"""
De manera general un diferencial de longitud en coordenadas cílindricas queda expresado como:

$d\vec{l}=dr \hat{a}_r+ r d\theta \hat{a}_\theta+ r\sin(\theta)d\phi \hat{a}_\phi$

"""

# ╔═╡ d467aed8-237c-4b98-920f-523749cbfe1d
md"""
Los 3 diferenciales de superficie son:

$\begin{align}
d\vec{S}&= (r \sin(\theta) d\phi) (r d\theta) \hat{a}_r \\
d\vec{S}&= (dr )(r \sin(\theta) d\phi) \hat{a}_\theta \\
d\vec{S}&= (dr ) (r d\theta) \hat{a}_\phi
\end{align}$
"""

# ╔═╡ 9c56ff63-f3f7-4d14-86f3-7f26eafff6d4
md"""
y el diferencial de volumen es:

$dV= (dr )(r d\theta)(r \sin(\theta) d\phi) = r^2 \sin(\theta) dr d\theta d\phi$
"""

# ╔═╡ ac56c583-a1f1-4f00-83de-6b867b0d5d63
md"""!!! info "📚 Sobre los diferenciales de superficie:" 

	Note que todo diferencial de superficie $d\vec{S}$ se puede expresar como $d\vec{S}= dS \hat{a}_n$, donde $\hat{a}_n$ es un vector unitario normal a la superficie $dS$.

"""

# ╔═╡ 467d9eee-a5fc-4866-ad31-3b6945b0decf
md"""
## Operador Nabla $\nabla$
"""

# ╔═╡ ffe21721-9fde-460f-8e33-c2a48a05f6fb
md"""
El operador $\nabla$ (Nabla) es un operador diferencial del vector:

$\vec{\nabla} = \frac{\partial}{\partial x} \hat{a}_x + \frac{\partial}{\partial y} \hat{a}_y + \frac{\partial}{\partial z} \hat{a}_z$
"""

# ╔═╡ f36752f3-727e-4e65-9fa8-59861020e197
md"""
Este operador también es llamado operador gradiente. No es un vector por si solo, solo tiene sentido si actúa u opera sobre un campo escalar (también llamada función escalar), por ejemplo:

sea $\vec{\nabla} ψ$ un campo escalar, su gradiente está dado por 

$\vec{\nabla} ψ= \frac{\partial ψ}{\partial x} \hat{a}_x + \frac{\partial ψ}{\partial y} \hat{a}_y + \frac{\partial ψ}{\partial z} \hat{a}_z$

o

$\vec{\nabla} ψ= 
\begin{pmatrix} 
\frac{\partial ψ}{\partial x} \\
\frac{\partial ψ}{\partial y} \\
 \frac{\partial ψ}{\partial z}
\end{pmatrix}$
"""

# ╔═╡ 28256a37-5f08-4c18-8255-daeaff8b6d54
md"""!!! info "📚 Notación:" 
	El operador $\vec{\nabla}$ es el gradiente, mientras $\nabla$ es Nabla. En el libro de Sadiku escriben únicamente $\nabla$, sin embargo, la notación preferida por su profesor incluye la flecha de vector encima de nabla. Escribir $\vec{\nabla}$ en varias formulas permite deducir el tipo de resultado de las siguientes operaciones:

	1. Gradiente de un campo escalar $ψ$ se escribe $\vec{\nabla} ψ$. El resultado es un campo vectorial.
	2. La divergencia de un campo vectorial $\vec{A}$ se escribe $\vec{\nabla} \cdot \vec{A}$. El resultado es un campo escalar (como si fuese un producto punto).
	3. El rotacional de un campo vectorial $\vec{A}$ se ecribe $\vec{\nabla} \times \vec{A}$. El resultado es otro campo vectorial (como si fuese un producto cruz).
	4. El laplaciano de un campo escalar  $ψ$ se escribe $\nabla^2 ψ$. El resultado es un campo escalar.

	Estas operaciones se verán más adelante.
"""

# ╔═╡ dcf572ac-b920-44b9-9e95-aba0939a3021
md"""
### Gradiente en coordenadas cilíndricas
"""

# ╔═╡ f68b8fd1-264a-4101-b43a-ab729fdec67b
md"""
Suponga que se desea obtener el gradiente en coordendas cílindricas $(\rho, \phi, z)$. Recordemos que:
"""

# ╔═╡ 3d5c4094-4aa2-48fe-b576-3c8ff983a52c
md"""!!! success "📏 Transformaciones entre puntos:"

	$x=\rho \cos(\phi) \qquad \qquad \qquad \rho^2=x^2+y^2$
	$y=\rho \sin(\phi) \qquad \qquad \qquad \tan(\phi)=\frac{y}{x}$
	$z=z \qquad \qquad \qquad z=z$
"""

# ╔═╡ 4db4f92f-f6ec-49e0-bccb-a1e96e427b53
md"""
Si $ψ(\rho, \phi, z)$ es un campo escalar en coordenadas cilíndricas, entonces:

$\frac{\partial ψ}{\partial x} = \frac{\partial \rho}{\partial x}\frac{\partial ψ}{\partial \rho} + \frac{\partial \phi}{\partial x}\frac{\partial ψ}{\partial \phi} + \frac{\partial z}{\partial x}\frac{\partial ψ}{\partial z}$

Note que se ha utilizado la regla de la cadena y cabe recordar que las coordenadas $x$ y $z$ son completamente independientes entre si por lo tanto:

$\frac{\partial z}{\partial x} = 0$

y tenemos solamente

$\frac{\partial ψ}{\partial x} = \frac{\partial \rho}{\partial x}\frac{\partial ψ}{\partial \rho} + \frac{\partial \phi}{\partial x}\frac{\partial ψ}{\partial \phi}$

"""

# ╔═╡ 4a0c96bd-ba00-48c6-b36f-931b9381a3eb
md"""
No se puede decir lo mismo de $\rho$ con $x$ o  $\phi$ con $x$, pues ambas están relacionadas con la coordenada $x$ como $\rho^2=x^2+y^2$ y $\tan(\phi)=\frac{y}{x}$ respectivamente. De hecho con la primera obtenemos que:

$\begin{align}
\frac{\partial \rho}{\partial x} &= \frac{1}{\cancel{2}}\frac{1}{\sqrt{x^2+y^2}}\cancel{2}x = \frac{\cancel{\rho} \cos(\phi)}{\cancel{\rho}} = \cos(\phi) \\
\frac{\partial \rho}{\partial x} &= \cos(\phi)
\end{align}$
"""

# ╔═╡ f96396fe-72b2-4d5f-b966-822da85d921c
md"""
La derivada parcial de $\phi$ con respecto a $x$ se obtiene más facilmente derivando implícitamente $\tan(\phi)=\frac{y}{x}$:

$\sec^2(\phi) \frac{\partial \phi}{\partial x} = -\frac{y}{x^2} \implies \frac{\partial \phi}{\partial x} = -\frac{y \cos^2(\phi)}{x^2}$
"""

# ╔═╡ c637f6aa-4065-4238-b43b-640c973340b4
md"""
Reemplazando $x$ y $y$ por su expresión en términos de $\rho$ y $\phi$:

$\frac{\partial \phi}{\partial x} = -\frac{\rho \sin(\phi) \cos^2(\phi)}{(\rho \cos(\phi))^2}= - \frac{\sin(\phi)}{\rho}$
"""

# ╔═╡ d63c2f88-b0cd-4bf2-a446-7609483397dc
md"""
Por lo tanto:

$\frac{\partial ψ}{\partial x} = \cos(\phi)\frac{\partial ψ}{\partial \rho} - \frac{\sin(\phi)}{\rho}\frac{\partial ψ}{\partial \phi}$
"""

# ╔═╡ 377d636c-5c37-41d3-9a51-05e2f87926ac
md"""
Un procedimiento análogo permite obtener:

$\begin{align}
\frac{\partial ψ}{\partial y} &= \frac{\partial \rho}{\partial y}\frac{\partial ψ}{\partial \rho} + \frac{\partial \phi}{\partial y}\frac{\partial ψ}{\partial \phi} \\
\frac{\partial ψ}{\partial y} &= \sin(\phi)\frac{\partial ψ}{\partial \rho} + \frac{\cos(\phi)}{\rho}\frac{\partial ψ}{\partial \phi}
\end{align}$
"""

# ╔═╡ 85087c4a-f656-4a20-af9f-6132067a8393
md"""
De manera general se tiene que:

$\begin{align}
\frac{\partial }{\partial x} &= \cos(\phi)\frac{\partial }{\partial \rho} - \frac{\sin(\phi)}{\rho}\frac{\partial }{\partial \phi} \\
\frac{\partial }{\partial y} &= \sin(\phi)\frac{\partial }{\partial \rho} + \frac{\cos(\phi)}{\rho}\frac{\partial }{\partial \phi}
\end{align}$
"""

# ╔═╡ d320a6fa-0720-4cd3-8b0a-47b79f30bc84
md"""
Por lo que si se desea obtener el gradiente de $ψ$ en coordenadas cilíndricas:

$\begin{align}
\vec{\nabla} ψ &= \frac{\partial ψ}{\partial x} \hat{a}_x + \frac{\partial ψ}{\partial y} \hat{a}_y + \frac{\partial ψ}{\partial z} \hat{a}_z \\
\vec{\nabla} ψ &= \left( \cos(\phi)\frac{\partial ψ}{\partial \rho} - \frac{\sin(\phi)}{\rho}\frac{\partial ψ}{\partial \phi} \right) \hat{a}_x 
+ \left(  \sin(\phi)\frac{\partial ψ}{\partial \rho} + \frac{\cos(\phi)}{\rho}\frac{\partial ψ}{\partial \phi} \right) \hat{a}_y + \frac{\partial ψ}{\partial z} \hat{a}_z
\end{align}$
"""

# ╔═╡ 27605a7e-5da8-4962-a31a-0b7d98ca35f5
md"""
El último paso consiste en transformar el vector de coordenadas cartesianas a cilíndricas, esto se puede realizar recordando que:

$\hat{a}_x =\cos(\phi) \hat{a}_\rho-\sin(\phi)\hat{a}_\phi$
$\hat{a}_y =\sin(\phi) \hat{a}_\rho+\cos(\phi)\hat{a}_\phi$
"""

# ╔═╡ 0a72baba-20e3-458c-b44e-515f324aa685
md"""
Por lo tanto

$\begin{align}
\vec{\nabla} ψ &= \left( \cos(\phi)\frac{\partial ψ}{\partial \rho} - \frac{\sin(\phi)}{\rho}\frac{\partial ψ}{\partial \phi} \right) \hat{a}_x 
+ \left(  \sin(\phi)\frac{\partial ψ}{\partial \rho} + \frac{\cos(\phi)}{\rho}\frac{\partial ψ}{\partial \phi} \right) \hat{a}_y + \frac{\partial ψ}{\partial z} \hat{a}_z \\
\vec{\nabla} ψ &= \left( \cos(\phi)\frac{\partial ψ}{\partial \rho} - \frac{\sin(\phi)}{\rho}\frac{\partial ψ}{\partial \phi} \right) 
\left[ \cos(\phi) \hat{a}_\rho-\sin(\phi)\hat{a}_\phi \right] \\
&+ \left(  \sin(\phi)\frac{\partial ψ}{\partial \rho} + \frac{\cos(\phi)}{\rho}\frac{\partial ψ}{\partial \phi} \right) 
\left[ \sin(\phi) \hat{a}_\rho+\cos(\phi)\hat{a}_\phi \right] \\
&+ \frac{\partial ψ}{\partial z} \hat{a}_z \\
\end{align}$

"""

# ╔═╡ 0c0210b7-72a1-45cd-88c3-1fb6fdaa8712
md"""
Simplificando se obtiene:

$\vec{\nabla} ψ = \frac{\partial ψ}{\partial \rho} \hat{a}_\rho 
+ \frac{1}{\rho} \frac{\partial ψ}{\partial \phi} \hat{a}_\phi + \frac{\partial ψ}{\partial z} \hat{a}_z$

"""

# ╔═╡ 2e884d00-0bbc-4b40-a797-0b67a3e43d07
md"""
### Gradiente en coordenadas esféricas
"""

# ╔═╡ 302cc3d5-8016-4187-af10-0b00132723e3
md"""!!! danger "🏠 Tarea:"
	Demuestre que el gradiente de un campo escalar $ψ$ en coordenadas esféricas es:

	$\vec{\nabla} ψ = \frac{\partial ψ}{\partial r} \hat{a}_r
	+ \frac{1}{r} \frac{\partial ψ}{\partial \theta} \hat{a}_\theta + \frac{1}{r \sin(\theta)}\frac{\partial ψ}{\partial \phi} \hat{a}_\phi$

"""

# ╔═╡ 3f16e477-c508-487b-8c03-65960be69001
md"""
### Divergencia y rotacional
"""

# ╔═╡ cc145c58-e4ad-4b03-9dda-0bbae0a4c1a8
md"""
En el curso de cálculo los estudiantes tendrán la oportunidad de ver más en detalle estas operaciones. Se deja un resumen de ellas para futuras consultas.
"""

# ╔═╡ c20cc05b-8151-459d-8331-70cce256422a
md"""!!! success "📏 Gradiente, divergencia y rotacional en coordenadas cartesianas:"

	$\nabla f =  \frac{\partial f}{\partial x}\hat{a}_x + \frac{\partial f}{\partial y}\hat{a}_y + \frac{\partial f}{\partial z}\hat{a}_z$

	$\nabla \cdot \mathbf{F} = \frac{\partial F_x}{\partial x} + \frac{\partial F_y}{\partial y} + \frac{\partial F_z}{\partial z}$

	$\nabla \times \mathbf{F} =
	\begin{vmatrix}
	\hat{a}_x & \hat{a}_y & \hat{a}_z \\
	\frac{\partial}{\partial x} & \frac{\partial}{\partial y} & \frac{\partial}{\partial z} \\
	F_x & F_y & F_z
	\end{vmatrix}$

	$\nabla^2 f = \frac{\partial^2 f}{\partial x^2} + \frac{\partial^2 f}{\partial y^2} + \frac{\partial^2 f}{\partial z^2}$
"""

# ╔═╡ f966bcad-2d50-4b4b-917d-59e34c96c43f
md"""!!! success "📏 Gradiente, divergencia y rotacional en coordenadas cilíndricas:"

	$\nabla f =
	\frac{\partial f}{\partial \rho} \hat{a}_\rho +
	\frac{1}{\rho} \frac{\partial f}{\partial \phi} \hat{a}_\phi +
	\frac{\partial f}{\partial z} \hat{a}_z$

	$\nabla \cdot \mathbf{F} =
	\frac{1}{\rho} \frac{\partial}{\partial \rho} (\rho F_\rho) +
	\frac{1}{\rho} \frac{\partial F_\phi}{\partial \phi} +
	\frac{\partial F_z}{\partial z}$

	$\nabla \times \mathbf{F} =
	\begin{vmatrix}
	\hat{a}_\rho & \hat{a}_\phi & \hat{a}_z \\
	\frac{\partial}{\partial \rho} & \frac{1}{\rho} \frac{\partial}{\partial \phi} & \frac{\partial}{\partial z} \\
	F_\rho & F_\phi & F_z
	\end{vmatrix}$

	$\nabla^2 f =
	\frac{1}{\rho} \frac{\partial}{\partial \rho} \left( \rho \frac{\partial f}{\partial \rho} \right) +
	\frac{1}{\rho^2} \frac{\partial^2 f}{\partial \phi^2} +
	\frac{\partial^2 f}{\partial z^2}$
"""

# ╔═╡ 2e71bf99-213f-4cc7-837e-a01aa216278f
md"""!!! success "📏 Gradiente, divergencia y rotacional en coordenadas esféricas:"

	$\nabla f =
	\frac{\partial f}{\partial r} \hat{a}_r +
	\frac{1}{r} \frac{\partial f}{\partial \theta} \hat{a}_\theta +
	\frac{1}{r \sin\theta} \frac{\partial f}{\partial \phi} \hat{a}_\phi$

	$\nabla \cdot \mathbf{F} =
	\frac{1}{r^2} \frac{\partial}{\partial r} (r^2 F_r) +
	\frac{1}{r \sin\theta} \frac{\partial}{\partial \theta} (\sin\theta F_\theta) +
	\frac{1}{r \sin\theta} \frac{\partial F_\phi}{\partial \phi}$

	$\nabla \times \mathbf{F} =
	\begin{vmatrix}
	\hat{a}_r & \hat{a}_\theta & \hat{a}_\phi \\
	\frac{\partial}{\partial r} & \frac{1}{r} \frac{\partial}{\partial \theta} & \frac{1}{r \sin\theta} \frac{\partial}{\partial \phi} \\
	F_r & F_\theta & F_\phi
	\end{vmatrix}$

	$\nabla^2 f =
	\frac{1}{r^2} \frac{\partial}{\partial r} \left( r^2 \frac{\partial f}{\partial r} \right) +
	\frac{1}{r^2 \sin\theta} \frac{\partial}{\partial \theta} \left( \sin\theta \frac{\partial f}{\partial \theta} \right) +
	\frac{1}{r^2 \sin^2\theta} \frac{\partial^2 f}{\partial \phi^2}$
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CairoMakie = "13f3f980-e62b-5c42-98c6-ff1f3baf88f0"
GeometryBasics = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[compat]
CairoMakie = "~0.13.1"
GeometryBasics = "~0.5.1"
PlutoUI = "~0.7.60"
Statistics = "~1.11.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.3"
manifest_format = "2.0"
project_hash = "f85b8053f5c3f1b22069108d4e471858c8d93d1a"

[[deps.AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "d92ad398961a3ed262d8bf04a1a2b8340f915fef"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.5.0"
weakdeps = ["ChainRulesCore", "Test"]

    [deps.AbstractFFTs.extensions]
    AbstractFFTsChainRulesCoreExt = "ChainRulesCore"
    AbstractFFTsTestExt = "Test"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.AbstractTrees]]
git-tree-sha1 = "2d9c9a55f9c93e8887ad391fbae72f8ef55e1177"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.5"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "50c3c56a52972d78e8be9fd135bfb91c9574c140"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "4.1.1"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.AdaptivePredicates]]
git-tree-sha1 = "7e651ea8d262d2d74ce75fdf47c4d63c07dba7a6"
uuid = "35492f91-a3bd-45ad-95db-fcad7dcfedb7"
version = "1.2.0"

[[deps.AliasTables]]
deps = ["PtrArrays", "Random"]
git-tree-sha1 = "9876e1e164b144ca45e9e3198d0b689cadfed9ff"
uuid = "66dad0bd-aa9a-41b7-9441-69ab47430ed8"
version = "1.1.3"

[[deps.Animations]]
deps = ["Colors"]
git-tree-sha1 = "e092fa223bf66a3c41f9c022bd074d916dc303e7"
uuid = "27a7e980-b3e6-11e9-2bcd-0b925532e340"
version = "0.4.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Automa]]
deps = ["PrecompileTools", "SIMD", "TranscodingStreams"]
git-tree-sha1 = "a8f503e8e1a5f583fbef15a8440c8c7e32185df2"
uuid = "67c07d97-cdcb-5c2c-af73-a7f9c32a568b"
version = "1.1.0"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "01b8ccb13d68535d73d2b0c23e39bd23155fb712"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.1.0"

[[deps.AxisArrays]]
deps = ["Dates", "IntervalSets", "IterTools", "RangeArrays"]
git-tree-sha1 = "16351be62963a67ac4083f748fdb3cca58bfd52f"
uuid = "39de3d68-74b9-583c-8d2d-e117c070f3a9"
version = "0.4.7"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "8873e196c2eb87962a2048b3b8e08946535864a1"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+4"

[[deps.CEnum]]
git-tree-sha1 = "389ad5c84de1ae7cf0e28e381131c98ea87d54fc"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.5.0"

[[deps.CRC32c]]
uuid = "8bf52ea8-c179-5cab-976a-9e18b702a9bc"
version = "1.11.0"

[[deps.CRlibm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e329286945d0cfc04456972ea732551869af1cfc"
uuid = "4e9b3aee-d8a1-5a3d-ad8b-7d824db253f0"
version = "1.0.1+0"

[[deps.Cairo]]
deps = ["Cairo_jll", "Colors", "Glib_jll", "Graphics", "Libdl", "Pango_jll"]
git-tree-sha1 = "71aa551c5c33f1a4415867fe06b7844faadb0ae9"
uuid = "159f3aea-2a34-519c-b102-8c37f9878175"
version = "1.1.1"

[[deps.CairoMakie]]
deps = ["CRC32c", "Cairo", "Cairo_jll", "Colors", "FileIO", "FreeType", "GeometryBasics", "LinearAlgebra", "Makie", "PrecompileTools"]
git-tree-sha1 = "6d76f05dbc8b7a52deaa7cdabe901735ae7b6724"
uuid = "13f3f980-e62b-5c42-98c6-ff1f3baf88f0"
version = "0.13.1"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "009060c9a6168704143100f36ab08f06c2af4642"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.18.2+1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra"]
git-tree-sha1 = "1713c74e00545bfe14605d2a2be1712de8fbcb58"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.25.1"
weakdeps = ["SparseArrays"]

    [deps.ChainRulesCore.extensions]
    ChainRulesCoreSparseArraysExt = "SparseArrays"

[[deps.ColorBrewer]]
deps = ["Colors", "JSON"]
git-tree-sha1 = "e771a63cc8b539eca78c85b0cabd9233d6c8f06f"
uuid = "a2cac450-b92f-5266-8821-25eda20663c8"
version = "0.4.1"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "26ec26c98ae1453c692efded2b17e15125a5bea1"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.28.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"
weakdeps = ["SpecialFunctions"]

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "64e15186f0aa277e174aa81798f7eb8598e0157e"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.13.0"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "8ae8d32e09f0dcf42a36b90d4e17f5dd2e4c4215"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.16.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.ConstructionBase]]
git-tree-sha1 = "76219f1ed5771adbb096743bff43fb5fdd4c1157"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.8"
weakdeps = ["IntervalSets", "LinearAlgebra", "StaticArrays"]

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseLinearAlgebraExt = "LinearAlgebra"
    ConstructionBaseStaticArraysExt = "StaticArrays"

[[deps.Contour]]
git-tree-sha1 = "439e35b0b36e2e5881738abc8857bd92ad6ff9a8"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.3"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "1d0a14036acb104d9e89698bd408f63ab58cdc82"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.20"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.DelaunayTriangulation]]
deps = ["AdaptivePredicates", "EnumX", "ExactPredicates", "Random"]
git-tree-sha1 = "5620ff4ee0084a6ab7097a27ba0c19290200b037"
uuid = "927a84f5-c5f4-47a5-9785-b46e178433df"
version = "1.6.4"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"
version = "1.11.0"

[[deps.Distributions]]
deps = ["AliasTables", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns"]
git-tree-sha1 = "03aa5d44647eaec98e1920635cdfed5d5560a8b9"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.117"

    [deps.Distributions.extensions]
    DistributionsChainRulesCoreExt = "ChainRulesCore"
    DistributionsDensityInterfaceExt = "DensityInterface"
    DistributionsTestExt = "Test"

    [deps.Distributions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DensityInterface = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
    Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e3290f2d49e661fbd94046d7e3726ffcb2d41053"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.4+0"

[[deps.EnumX]]
git-tree-sha1 = "bdb1942cd4c45e3c678fd11569d5cccd80976237"
uuid = "4e289a0a-7415-4d19-859d-a7e5c4648b56"
version = "1.0.4"

[[deps.ExactPredicates]]
deps = ["IntervalArithmetic", "Random", "StaticArrays"]
git-tree-sha1 = "b3f2ff58735b5f024c392fde763f29b057e4b025"
uuid = "429591f6-91af-11e9-00e2-59fbe8cec110"
version = "2.2.8"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e51db81749b0777b2147fbe7b783ee79045b8e99"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.6.4+3"

[[deps.Extents]]
git-tree-sha1 = "063512a13dbe9c40d999c439268539aa552d1ae6"
uuid = "411431e0-e8b7-467b-b5e0-f676ba4f2910"
version = "0.1.5"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "8cc47f299902e13f90405ddb5bf87e5d474c0d38"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "6.1.2+0"

[[deps.FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "4820348781ae578893311153d69049a93d05f39d"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.8.0"

[[deps.FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4d81ed14783ec49ce9f2e168208a12ce1815aa25"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+3"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "2dd20384bf8c6d411b5c7370865b1e9b26cb2ea3"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.6"

    [deps.FileIO.extensions]
    HTTPExt = "HTTP"

    [deps.FileIO.weakdeps]
    HTTP = "cd3eb016-35fb-5094-929b-558a96fad6f3"

[[deps.FilePaths]]
deps = ["FilePathsBase", "MacroTools", "Reexport", "Requires"]
git-tree-sha1 = "919d9412dbf53a2e6fe74af62a73ceed0bce0629"
uuid = "8fc22ac5-c921-52a6-82fd-178b2807b824"
version = "0.8.3"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates"]
git-tree-sha1 = "7878ff7172a8e6beedd1dea14bd27c3c6340d361"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.22"
weakdeps = ["Mmap", "Test"]

    [deps.FilePathsBase.extensions]
    FilePathsBaseMmapExt = "Mmap"
    FilePathsBaseTestExt = "Test"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.FillArrays]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "6a70198746448456524cb442b8af316927ff3e1a"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.13.0"
weakdeps = ["PDMats", "SparseArrays", "Statistics"]

    [deps.FillArrays.extensions]
    FillArraysPDMatsExt = "PDMats"
    FillArraysSparseArraysExt = "SparseArrays"
    FillArraysStatisticsExt = "Statistics"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Zlib_jll"]
git-tree-sha1 = "21fac3c77d7b5a9fc03b0ec503aa1a6392c34d2b"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.15.0+0"

[[deps.Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

[[deps.FreeType]]
deps = ["CEnum", "FreeType2_jll"]
git-tree-sha1 = "907369da0f8e80728ab49c1c7e09327bf0d6d999"
uuid = "b38be410-82b0-50bf-ab77-7b57e271db43"
version = "4.1.1"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "786e968a8d2fb167f2e4880baba62e0e26bd8e4e"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.3+1"

[[deps.FreeTypeAbstraction]]
deps = ["ColorVectorSpace", "Colors", "FreeType", "GeometryBasics"]
git-tree-sha1 = "d52e255138ac21be31fa633200b65e4e71d26802"
uuid = "663a7486-cb36-511b-a19d-713bb74d65c9"
version = "0.10.6"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "846f7026a9decf3679419122b49f8a1fdb48d2d5"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.16+0"

[[deps.GeoFormatTypes]]
git-tree-sha1 = "8e233d5167e63d708d41f87597433f59a0f213fe"
uuid = "68eda718-8dee-11e9-39e7-89f7f65f511f"
version = "0.4.4"

[[deps.GeoInterface]]
deps = ["DataAPI", "Extents", "GeoFormatTypes"]
git-tree-sha1 = "294e99f19869d0b0cb71aef92f19d03649d028d5"
uuid = "cf35fbd7-0cd7-5166-be24-54bfbe79505f"
version = "1.4.1"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "Extents", "GeoInterface", "IterTools", "LinearAlgebra", "PrecompileTools", "Random", "StaticArrays"]
git-tree-sha1 = "c1a9c159c3ac53aa09663d8662c7277ef3fa508d"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.5.1"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Giflib_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6570366d757b50fabae9f4315ad74d2e40c0560a"
uuid = "59f7168a-df46-5410-90c8-f2779963d0ec"
version = "5.2.3+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "b0036b392358c80d2d2124746c2bf3d48d457938"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.82.4+0"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "a641238db938fff9b2f60d08ed9030387daf428c"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.3"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "01979f9b37367603e2848ea225918a3b3861b606"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+1"

[[deps.GridLayoutBase]]
deps = ["GeometryBasics", "InteractiveUtils", "Observables"]
git-tree-sha1 = "dc6bed05c15523624909b3953686c5f5ffa10adc"
uuid = "3955a311-db13-416c-9275-1d80ed98e5e9"
version = "0.11.1"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll"]
git-tree-sha1 = "55c53be97790242c29031e5cd45e8ac296dadda3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "8.5.0+0"

[[deps.HypergeometricFunctions]]
deps = ["LinearAlgebra", "OpenLibm_jll", "SpecialFunctions"]
git-tree-sha1 = "b1c2585431c382e3fe5805874bda6aea90a95de9"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.25"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[deps.ImageAxes]]
deps = ["AxisArrays", "ImageBase", "ImageCore", "Reexport", "SimpleTraits"]
git-tree-sha1 = "e12629406c6c4442539436581041d372d69c55ba"
uuid = "2803e5a7-5153-5ecf-9a86-9b4c37f5f5ac"
version = "0.6.12"

[[deps.ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "eb49b82c172811fd2c86759fa0553a2221feb909"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.7"

[[deps.ImageCore]]
deps = ["ColorVectorSpace", "Colors", "FixedPointNumbers", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "PrecompileTools", "Reexport"]
git-tree-sha1 = "8c193230235bbcee22c8066b0374f63b5683c2d3"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.10.5"

[[deps.ImageIO]]
deps = ["FileIO", "IndirectArrays", "JpegTurbo", "LazyModules", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs", "WebP"]
git-tree-sha1 = "696144904b76e1ca433b886b4e7edd067d76cbf7"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.9"

[[deps.ImageMetadata]]
deps = ["AxisArrays", "ImageAxes", "ImageBase", "ImageCore"]
git-tree-sha1 = "2a81c3897be6fbcde0802a0ebe6796d0562f63ec"
uuid = "bc367c6b-8a6b-528e-b4bd-a4b897500b49"
version = "0.9.10"

[[deps.Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "0936ba688c6d201805a83da835b55c61a180db52"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.11+0"

[[deps.IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[deps.Inflate]]
git-tree-sha1 = "d1b1b796e47d94588b3757fe84fbf65a5ec4a80d"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.5"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl"]
git-tree-sha1 = "10bd689145d2c3b2a9844005d01087cc1194e79e"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2024.2.1+0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.Interpolations]]
deps = ["Adapt", "AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "88a101217d7cb38a7b481ccd50d21876e1d1b0e0"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.15.1"
weakdeps = ["Unitful"]

    [deps.Interpolations.extensions]
    InterpolationsUnitfulExt = "Unitful"

[[deps.IntervalArithmetic]]
deps = ["CRlibm_jll", "LinearAlgebra", "MacroTools", "RoundingEmulator"]
git-tree-sha1 = "ffb76d09ab0dc9f5a27edac2acec13c74a876cc6"
uuid = "d1acc4aa-44c8-5952-acd4-ba5d80a2a253"
version = "0.22.21"

    [deps.IntervalArithmetic.extensions]
    IntervalArithmeticDiffRulesExt = "DiffRules"
    IntervalArithmeticForwardDiffExt = "ForwardDiff"
    IntervalArithmeticIntervalSetsExt = "IntervalSets"
    IntervalArithmeticRecipesBaseExt = "RecipesBase"

    [deps.IntervalArithmetic.weakdeps]
    DiffRules = "b552c78f-8df3-52c6-915a-8e097449b14b"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    RecipesBase = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"

[[deps.IntervalSets]]
git-tree-sha1 = "dba9ddf07f77f60450fe5d2e2beb9854d9a49bd0"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.10"

    [deps.IntervalSets.extensions]
    IntervalSetsRandomExt = "Random"
    IntervalSetsRecipesBaseExt = "RecipesBase"
    IntervalSetsStatisticsExt = "Statistics"

    [deps.IntervalSets.weakdeps]
    Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
    RecipesBase = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
    Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.InverseFunctions]]
git-tree-sha1 = "a779299d77cd080bf77b97535acecd73e1c5e5cb"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.17"
weakdeps = ["Dates", "Test"]

    [deps.InverseFunctions.extensions]
    InverseFunctionsDatesExt = "Dates"
    InverseFunctionsTestExt = "Test"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.Isoband]]
deps = ["isoband_jll"]
git-tree-sha1 = "f9b6d97355599074dc867318950adaa6f9946137"
uuid = "f1662d9f-8043-43de-a69a-05efc1cc6ff4"
version = "0.1.1"

[[deps.IterTools]]
git-tree-sha1 = "42d5f897009e7ff2cf88db414a389e5ed1bdd023"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.10.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "a007feb38b422fbdab534406aeca1b86823cb4d6"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.7.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo]]
deps = ["CEnum", "FileIO", "ImageCore", "JpegTurbo_jll", "TOML"]
git-tree-sha1 = "fa6d0bcff8583bac20f1ffa708c3913ca605c611"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.5"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "eac1206917768cb54957c65a615460d87b455fc1"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.1.1+0"

[[deps.KernelDensity]]
deps = ["Distributions", "DocStringExtensions", "FFTW", "Interpolations", "StatsBase"]
git-tree-sha1 = "7d703202e65efa1369de1279c162b915e245eed1"
uuid = "5ab0869b-81aa-558d-bb23-cbf5423bbe9b"
version = "0.6.9"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "170b660facf5df5de098d866564877e119141cbd"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.2+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "aaafe88dccbd957a8d82f7d05be9b69172e0cee3"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "4.0.1+0"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "78211fb6cbc872f77cad3fc0b6cf647d923f4929"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "18.1.7+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1c602b1127f4751facb671441ca72715cc95938a"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.3+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "dda21b8cbd6a6c40d9d02a73230f9d70fed6918c"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.4.0"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"
version = "1.11.0"

[[deps.LazyModules]]
git-tree-sha1 = "a560dd966b386ac9ae60bdd3a3d3a326062d3c3e"
uuid = "8cdb02fc-e678-4876-92c5-9defec4f444e"
version = "0.3.1"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.6.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.7.2+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "27ecae93dd25ee0909666e6835051dd684cc035e"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+2"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll"]
git-tree-sha1 = "8be878062e0ffa2c3f67bb58a595375eda5de80b"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.11.0+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "ff3b4b9d35de638936a525ecd36e86a8bb919d11"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.7.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "df37206100d39f79b3376afb6b9cee4970041c61"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.51.1+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "be484f5c92fad0bd8acfef35fe017900b0b73809"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.18.0+0"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "89211ea35d9df5831fca5d33552c02bd33878419"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.40.3+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "4ab7581296671007fc33f07a721631b8855f4b1d"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.7.1+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e888ad02ce716b319e6bdb985d2ef300e7089889"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.40.3+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "13ca9e2586b89836fd20cccf56e57e2b9ae7f38f"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.29"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "oneTBB_jll"]
git-tree-sha1 = "f046ccd0c6db2832a9f639e2c669c6fe867e5f4f"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2024.2.0+0"

[[deps.MacroTools]]
git-tree-sha1 = "72aebe0b5051e5143a079a4685a46da330a40472"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.15"

[[deps.Makie]]
deps = ["Animations", "Base64", "CRC32c", "ColorBrewer", "ColorSchemes", "ColorTypes", "Colors", "Contour", "Dates", "DelaunayTriangulation", "Distributions", "DocStringExtensions", "Downloads", "FFMPEG_jll", "FileIO", "FilePaths", "FixedPointNumbers", "Format", "FreeType", "FreeTypeAbstraction", "GeometryBasics", "GridLayoutBase", "ImageBase", "ImageIO", "InteractiveUtils", "Interpolations", "IntervalSets", "InverseFunctions", "Isoband", "KernelDensity", "LaTeXStrings", "LinearAlgebra", "MacroTools", "MakieCore", "Markdown", "MathTeXEngine", "Observables", "OffsetArrays", "PNGFiles", "Packing", "PlotUtils", "PolygonOps", "PrecompileTools", "Printf", "REPL", "Random", "RelocatableFolders", "Scratch", "ShaderAbstractions", "Showoff", "SignedDistanceFields", "SparseArrays", "Statistics", "StatsBase", "StatsFuns", "StructArrays", "TriplotBase", "UnicodeFun", "Unitful"]
git-tree-sha1 = "9680336a5b67f9f9f6eaa018f426043a8cd68200"
uuid = "ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a"
version = "0.22.1"

[[deps.MakieCore]]
deps = ["ColorTypes", "GeometryBasics", "IntervalSets", "Observables"]
git-tree-sha1 = "c731269d5a2c85ffdc689127a9ba6d73e978a4b1"
uuid = "20f20a25-4f0e-4fdf-b5d1-57303727442b"
version = "0.9.0"

[[deps.MappedArrays]]
git-tree-sha1 = "2dab0221fe2b0f2cb6754eaa743cc266339f527e"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.2"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MathTeXEngine]]
deps = ["AbstractTrees", "Automa", "DataStructures", "FreeTypeAbstraction", "GeometryBasics", "LaTeXStrings", "REPL", "RelocatableFolders", "UnicodeFun"]
git-tree-sha1 = "f45c8916e8385976e1ccd055c9874560c257ab13"
uuid = "0a4f8689-d25c-4efe-a92b-7142dfc1aa53"
version = "0.6.2"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "7b86a5d4d70a9f5cdf2dacb3cbe6d251d1a61dbe"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.4"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "030ea22804ef91648f29b7ad3fc15fa49d0e6e71"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.3"

[[deps.Netpbm]]
deps = ["FileIO", "ImageCore", "ImageMetadata"]
git-tree-sha1 = "d92b107dbb887293622df7697a2223f9f8176fcd"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.1.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Observables]]
git-tree-sha1 = "7438a59546cf62428fc9d1bc94729146d37a7225"
uuid = "510215fc-4207-5dde-b226-833fc4488ee2"
version = "0.5.5"

[[deps.OffsetArrays]]
git-tree-sha1 = "5e1897147d1ff8d98883cda2be2187dcf57d8f0c"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.15.0"
weakdeps = ["Adapt"]

    [deps.OffsetArrays.extensions]
    OffsetArraysAdaptExt = "Adapt"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "97db9e07fe2091882c765380ef58ec553074e9c7"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.3"

[[deps.OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "8292dd5c8a38257111ada2174000a33745b06d4e"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.2.4+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+2"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7493f61f55a6cce7325f197443aa80d32554ba10"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.15+3"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1346c9208249809840c91b26703912dff463d335"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.6+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6703a85cb3781bd5909d48730a67205f3f31a575"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.3+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "12f1439c4f986bb868acda6ea33ebc78e19b95ad"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.7.0"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+1"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "966b85253e959ea89c53a9abebbf2e964fbf593b"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.32"

[[deps.PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "67186a2bc9a90f9f85ff3cc8277868961fb57cbd"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.4.3"

[[deps.Packing]]
deps = ["GeometryBasics"]
git-tree-sha1 = "bc5bf2ea3d5351edf285a06b0016788a121ce92c"
uuid = "19eb6ba3-879d-56ad-ad62-d5c202156566"
version = "0.5.1"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "0fac6313486baae819364c52b4f483450a9d793f"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.12"

[[deps.Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "ed6834e95bd326c52d5675b4181386dfbe885afb"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.55.5+0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "35621f10a7531bc8fa58f74610b1bfb70a3cfc6b"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.43.4+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"
weakdeps = ["REPL"]

    [deps.Pkg.extensions]
    REPLExt = "REPL"

[[deps.PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "f9501cc0430a26bc3d156ae1b5b0c1b47af4d6da"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.3.3"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "StableRNGs", "Statistics"]
git-tree-sha1 = "3ca9a356cd2e113c420f2c13bea19f8d3fb1cb18"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.4.3"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eba4810d5e6a01f612b948c9fa94f905b49087b0"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.60"

[[deps.PolygonOps]]
git-tree-sha1 = "77b3d3605fc1cd0b42d95eba87dfcd2bf67d5ff6"
uuid = "647866c9-e3ac-4575-94e7-e3d426903924"
version = "0.1.2"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "8f6bc219586aef8baf0ff9a5fe16ee9c70cb65e4"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.10.2"

[[deps.PtrArrays]]
git-tree-sha1 = "1d36ef11a9aaf1e8b74dacc6a731dd1de8fd493d"
uuid = "43287f4e-b6f4-7ad1-bb20-aadabca52c3d"
version = "1.3.0"

[[deps.QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "8b3fc30bc0390abdce15f8822c889f669baed73d"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.1"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "cda3b045cf9ef07a08ad46731f5a3165e56cf3da"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.11.1"

    [deps.QuadGK.extensions]
    QuadGKEnzymeExt = "Enzyme"

    [deps.QuadGK.weakdeps]
    Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "StyledStrings", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.RangeArrays]]
git-tree-sha1 = "b9039e93773ddcfc828f12aadf7115b4b4d225f5"
uuid = "b3c3ace0-ae52-54e7-9d0b-2c1406fd6b9d"
version = "0.3.2"

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "1342a47bf3260ee108163042310d26f2be5ec90b"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.5"
weakdeps = ["FixedPointNumbers"]

    [deps.Ratios.extensions]
    RatiosFixedPointNumbersExt = "FixedPointNumbers"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "852bd0f55565a9e973fcfee83a84413270224dc4"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.8.0"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "58cdd8fb2201a6267e1db87ff148dd6c1dbd8ad8"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.5.1+0"

[[deps.RoundingEmulator]]
git-tree-sha1 = "40b9edad2e5287e05bd413a38f61a8ff55b9557b"
uuid = "5eaf0fd0-dfba-4ccb-bf02-d820a40db705"
version = "0.2.1"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SIMD]]
deps = ["PrecompileTools"]
git-tree-sha1 = "fea870727142270bdf7624ad675901a1ee3b4c87"
uuid = "fdea26ae-647d-5447-a871-4b548cad5224"
version = "3.7.1"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.ShaderAbstractions]]
deps = ["ColorTypes", "FixedPointNumbers", "GeometryBasics", "LinearAlgebra", "Observables", "StaticArrays"]
git-tree-sha1 = "818554664a2e01fc3784becb2eb3a82326a604b6"
uuid = "65257c39-d410-5151-9873-9b3e5be5013e"
version = "0.5.0"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"
version = "1.11.0"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SignedDistanceFields]]
deps = ["Random", "Statistics", "Test"]
git-tree-sha1 = "d263a08ec505853a5ff1c1ebde2070419e3f28e9"
uuid = "73760f76-fbc4-59ce-8f25-708e95d2df96"
version = "0.4.0"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "2da10356e31327c7096832eb9cd86307a50b1eb6"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"
version = "1.11.0"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.11.0"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "64cca0c26b4f31ba18f13f6c12af7c85f478cfde"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.5.0"
weakdeps = ["ChainRulesCore"]

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

[[deps.StableRNGs]]
deps = ["Random"]
git-tree-sha1 = "83e6cce8324d49dfaf9ef059227f91ed4441a8e5"
uuid = "860ef19b-820b-49d6-a774-d7a799459cd3"
version = "1.0.2"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "47091a0340a675c738b1304b58161f3b0839d454"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.10"
weakdeps = ["ChainRulesCore", "Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "192954ef1208c7019899fbf8049e717f92959682"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.3"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"
weakdeps = ["SparseArrays"]

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["AliasTables", "DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "29321314c920c26684834965ec2ce0dacc9cf8e5"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.4"

[[deps.StatsFuns]]
deps = ["HypergeometricFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "b423576adc27097764a90e163157bcfc9acf0f46"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.3.2"
weakdeps = ["ChainRulesCore", "InverseFunctions"]

    [deps.StatsFuns.extensions]
    StatsFunsChainRulesCoreExt = "ChainRulesCore"
    StatsFunsInverseFunctionsExt = "InverseFunctions"

[[deps.StructArrays]]
deps = ["ConstructionBase", "DataAPI", "Tables"]
git-tree-sha1 = "5a3a31c41e15a1e042d60f2f4942adccba05d3c9"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.7.0"

    [deps.StructArrays.extensions]
    StructArraysAdaptExt = "Adapt"
    StructArraysGPUArraysCoreExt = ["GPUArraysCore", "KernelAbstractions"]
    StructArraysLinearAlgebraExt = "LinearAlgebra"
    StructArraysSparseArraysExt = "SparseArrays"
    StructArraysStaticArraysExt = "StaticArrays"

    [deps.StructArrays.weakdeps]
    Adapt = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    KernelAbstractions = "63c18a36-062a-441e-b654-da1e3ab1ce7c"
    LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.StyledStrings]]
uuid = "f489334b-da3d-4c2e-b8f0-e476e12c162b"
version = "1.11.0"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.7.0+0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "598cd7c1f68d1e205689b1c2fe65a9f85846f297"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.12.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[deps.TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "Mmap", "OffsetArrays", "PkgVersion", "ProgressMeter", "SIMD", "UUIDs"]
git-tree-sha1 = "3c0faa42f2bd3c6d994b06286bba2328eae34027"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.11.2"

[[deps.TranscodingStreams]]
git-tree-sha1 = "0c45878dcfdcfa8480052b6ab162cdd138781742"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.3"

[[deps.Tricks]]
git-tree-sha1 = "6cae795a5a9313bbb4f60683f7263318fc7d1505"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.10"

[[deps.TriplotBase]]
git-tree-sha1 = "4d4ed7f294cda19382ff7de4c137d24d16adc89b"
uuid = "981d1d27-644d-49a2-9326-4793e63143c3"
version = "0.1.0"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "c0667a8e676c53d390a09dc6870b3d8d6650e2bf"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.22.0"
weakdeps = ["ConstructionBase", "InverseFunctions"]

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

[[deps.WebP]]
deps = ["CEnum", "ColorTypes", "FileIO", "FixedPointNumbers", "ImageCore", "libwebp_jll"]
git-tree-sha1 = "aa1ca3c47f119fbdae8770c29820e5e6119b83f2"
uuid = "e3aaa7dc-3e4b-44e0-be63-ffb868ccd7c1"
version = "0.1.3"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "c1a7aa6219628fcd757dede0ca95e245c5cd9511"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "1.0.0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "a2fccc6559132927d4c5dc183e3e01048c6dcbd6"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.13.5+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "7d1671acbe47ac88e981868a078bd6b4e27c5191"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.42+0"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "beef98d5aad604d9e7d60b2ece5181f7888e2fd6"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.6.4+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "9dafcee1d24c4f024e7edc92603cedba72118283"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+3"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e9216fdcd8514b7072b43653874fd688e4c6c003"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.12+0"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "89799ae67c17caa5b3b5a19b8469eeee474377db"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.5+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "d7155fea91a4123ef59f42c4afb5ab3b4ca95058"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.6+3"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "a490c6212a0e90d2d55111ac956f7c4fa9c277a6"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.11+1"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "c57201109a9e4c0585b208bb408bc41d205ac4e9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.2+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "1a74296303b6524a0472a8cb12d3d87a78eb3612"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.17.0+3"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6dba04dbfb72ae3ebe5418ba33d087ba8aa8cb00"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.1+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "622cf78670d067c738667aaa96c553430b65e269"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.7+0"

[[deps.isoband_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51b5eeb3f98367157a7a12a1fb0aa5328946c03c"
uuid = "9a68df92-36a6-505f-a73e-abb412b6bfb4"
version = "0.2.3+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "522c1df09d05a71785765d19c9524661234738e9"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.11.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "e17c115d55c5fbb7e52ebedb427a0dca79d4484e"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.2+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8a22cf860a7d27e4f3498a0fe0811a7957badb38"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.3+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d7b5bbf1efbafb5eca466700949625e07533aff2"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.45+1"

[[deps.libsixel_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "libpng_jll"]
git-tree-sha1 = "c1733e347283df07689d71d61e14be986e49e47a"
uuid = "075b6546-f08a-558a-be8f-8157d0f608a5"
version = "1.10.5+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "490376214c4721cdaca654041f635213c6165cb3"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+2"

[[deps.libwebp_jll]]
deps = ["Artifacts", "Giflib_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libglvnd_jll", "Libtiff_jll", "libpng_jll"]
git-tree-sha1 = "d2408cac540942921e7bd77272c32e58c33d8a77"
uuid = "c5f90fcd-3b7e-5836-afba-fc50a0988cb2"
version = "1.5.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.59.0+0"

[[deps.oneTBB_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7d0ea0f4895ef2f5cb83645fa689e52cb55cf493"
uuid = "1317d2d5-d96f-522e-a858-c73665f53c3e"
version = "2021.12.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "14cc7083fc6dff3cc44f2bc435ee96d06ed79aa7"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "10164.0.1+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "dcc541bb19ed5b0ede95581fb2e41ecf179527d2"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.6.0+0"
"""

# ╔═╡ Cell order:
# ╠═04607040-10f5-4d42-8464-511fd1cc5153
# ╠═aee068dd-41c6-4d32-b95c-787f325967f6
# ╟─4491e100-e4d6-11ef-2070-0de3361779e8
# ╟─710c6ed9-ed62-42db-95ab-749d2698053c
# ╟─49c0a961-01c7-48b3-842b-e2548afe0470
# ╟─d0fb4eec-2013-436a-b4e1-1b4105c5cc6f
# ╟─7dbd4736-c117-40d4-9284-5f3402066a75
# ╟─1e0799d5-2708-44bf-a554-b24007b8e248
# ╟─0506b7e6-445b-40b1-b3a9-9b0693b07411
# ╟─6effe90b-9268-48b8-9ca0-e86f038eadee
# ╟─ff3de673-f6d2-4905-9aab-1eb7b8a80301
# ╟─ffb3cd02-7e51-4414-88e7-4d11331f2b90
# ╟─9d08a61e-bf7e-4e71-b0f0-b0a422fbe6e8
# ╟─28e8b962-2fd9-4990-86ea-760af014b8e5
# ╟─717c9fa1-d90c-4970-808e-dbdd9d387323
# ╟─7fd7f9e3-8812-43a1-8a7e-4f779c56c0ad
# ╟─4c54cd2b-9c92-4ffb-a96d-d74f11bc52ea
# ╟─b234396a-c1ff-48e4-8a03-30f5a89a21c0
# ╟─32c53067-982e-4cf1-b437-925f3cdaeaf6
# ╟─ac32bdd0-18b5-4a2f-9423-efffef7aa355
# ╟─a820de5c-01ac-4c10-90c4-c580bf021c18
# ╟─ca1d58ae-3844-4830-a58d-1707fefe8b3d
# ╟─d250da1e-6b2c-48fc-be8b-573678683efe
# ╟─7721ed95-7ffa-4050-85dc-9fdc304e81d4
# ╟─7f5fa0bc-4343-4a39-91f1-ebdaa6e3f61c
# ╟─fd175a60-5e0d-4ec9-86dc-9da65f4511e7
# ╟─28e68492-0984-40a4-b934-c672f4cdadef
# ╟─5bb62fda-8afe-4919-bd5c-d3a1201c6691
# ╟─2242c83d-0bf2-4b2f-a286-06a3180fb630
# ╟─9eb1f2a6-15e9-4baf-ac5c-43dfc4107f66
# ╟─3818be09-3bbe-4152-984c-6bd2ad4f1461
# ╟─a052a87b-937c-4db3-b62c-71e289750fde
# ╟─7877bc9d-c3fd-4570-a54c-6f632efbe90e
# ╟─d467aed8-237c-4b98-920f-523749cbfe1d
# ╟─9c56ff63-f3f7-4d14-86f3-7f26eafff6d4
# ╟─ac56c583-a1f1-4f00-83de-6b867b0d5d63
# ╟─467d9eee-a5fc-4866-ad31-3b6945b0decf
# ╟─ffe21721-9fde-460f-8e33-c2a48a05f6fb
# ╟─f36752f3-727e-4e65-9fa8-59861020e197
# ╟─28256a37-5f08-4c18-8255-daeaff8b6d54
# ╟─dcf572ac-b920-44b9-9e95-aba0939a3021
# ╟─f68b8fd1-264a-4101-b43a-ab729fdec67b
# ╟─3d5c4094-4aa2-48fe-b576-3c8ff983a52c
# ╟─4db4f92f-f6ec-49e0-bccb-a1e96e427b53
# ╟─4a0c96bd-ba00-48c6-b36f-931b9381a3eb
# ╟─f96396fe-72b2-4d5f-b966-822da85d921c
# ╟─c637f6aa-4065-4238-b43b-640c973340b4
# ╟─d63c2f88-b0cd-4bf2-a446-7609483397dc
# ╟─377d636c-5c37-41d3-9a51-05e2f87926ac
# ╟─85087c4a-f656-4a20-af9f-6132067a8393
# ╟─d320a6fa-0720-4cd3-8b0a-47b79f30bc84
# ╟─27605a7e-5da8-4962-a31a-0b7d98ca35f5
# ╟─0a72baba-20e3-458c-b44e-515f324aa685
# ╟─0c0210b7-72a1-45cd-88c3-1fb6fdaa8712
# ╟─2e884d00-0bbc-4b40-a797-0b67a3e43d07
# ╟─302cc3d5-8016-4187-af10-0b00132723e3
# ╟─3f16e477-c508-487b-8c03-65960be69001
# ╟─cc145c58-e4ad-4b03-9dda-0bbae0a4c1a8
# ╟─c20cc05b-8151-459d-8331-70cce256422a
# ╟─f966bcad-2d50-4b4b-917d-59e34c96c43f
# ╟─2e71bf99-213f-4cc7-837e-a01aa216278f
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
