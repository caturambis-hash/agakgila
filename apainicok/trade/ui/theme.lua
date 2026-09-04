--[[ theme.lua — palet warna PINK ELEGAN + helper pembuat Instance.
     Mengisi: ctx.C (warna), ctx.mk, ctx.corner, ctx.stroke, ctx.pad, ctx.grad ]]
return function(ctx)
	local C = {
		bg     = Color3.fromRGB(18, 10, 26),       -- Latar belakang utama (plum sangat gelap)
		panel  = Color3.fromRGB(28, 14, 40),       -- Sidebar / panel sekunder
		row    = Color3.fromRGB(42, 22, 58),       -- Card / row item
		stroke = Color3.fromRGB(255, 80, 160),     -- Border pink accent
		acc    = Color3.fromRGB(255, 60, 140),     -- Hot pink utama
		acc2   = Color3.fromRGB(200, 40, 200),     -- Magenta (gradient partner)
		txt    = Color3.fromRGB(255, 230, 248),    -- Teks utama (putih hangat pink)
		sub    = Color3.fromRGB(190, 130, 175),    -- Teks sekunder (pink muted)
		green  = Color3.fromRGB(255, 110, 180),    -- "Positif" — pink cerah
		red    = Color3.fromRGB(255, 55, 100),     -- "Negatif" — rose
		glow   = Color3.fromRGB(255, 60, 140),     -- Warna glow effect
	}

	local function mk(cls, props, parent)
		local o = Instance.new(cls)
		for k, v in pairs(props) do o[k] = v end
		o.Parent = parent
		return o
	end

	local function corner(o, r)
		mk("UICorner", { CornerRadius = UDim.new(0, r or 8) }, o)
	end

	local function stroke(o, col, thick, trans)
		return mk("UIStroke", {
			Color = col or C.stroke,
			Thickness = thick or 1,
			Transparency = trans or 0.5,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		}, o)
	end

	local function pad(o, l, r, t, b)
		mk("UIPadding", {
			PaddingLeft = UDim.new(0, l), PaddingRight = UDim.new(0, r),
			PaddingTop = UDim.new(0, t), PaddingBottom = UDim.new(0, b),
		}, o)
	end

	local function grad(o, rot)
		return mk("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, C.acc),
				ColorSequenceKeypoint.new(1, C.acc2),
			}),
			Rotation = rot or 90,
		}, o)
	end

	ctx.C      = C
	ctx.mk     = mk
	ctx.corner = corner
	ctx.stroke = stroke
	ctx.pad    = pad
	ctx.grad   = grad
end
