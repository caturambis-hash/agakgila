--[[ theme.lua — palet + helper Instance (garden, dominasi pink). ]]
return function(ctx)
	local C = {
		bg      = Color3.fromRGB(26, 15, 26),    -- sangat gelap keunguan
		panel   = Color3.fromRGB(35, 22, 35),    -- panel lebih terang
		row     = Color3.fromRGB(46, 30, 46),    -- kartu / baris
		rowAlt  = Color3.fromRGB(40, 26, 40),
		stroke  = Color3.fromRGB(70, 50, 70),    -- garis pembatas pink gelap
		acc     = Color3.fromRGB(255, 105, 180), -- hot pink (aksen utama)
		txt     = Color3.fromRGB(245, 235, 245), -- putih dengan sedikit pink
		sub     = Color3.fromRGB(190, 160, 190), -- abu pink
		green   = Color3.fromRGB(90, 200, 120),  -- tetap hijau
		red     = Color3.fromRGB(220, 80, 80),   -- tetap merah
	}


	local function mk(cls, props, parent)
		local o = Instance.new(cls); for k, v in pairs(props) do o[k] = v end; o.Parent = parent; return o
	end
	local function corner(o, r) mk("UICorner", { CornerRadius = UDim.new(0, r or 8) }, o) end
	local function stroke(o, col, thick)
		return mk("UIStroke", { Color = col or C.stroke, Thickness = thick or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, o)
	end
	local function pad(o, l, r, t, b)
		mk("UIPadding", { PaddingLeft = UDim.new(0, l), PaddingRight = UDim.new(0, r), PaddingTop = UDim.new(0, t), PaddingBottom = UDim.new(0, b) }, o)
	end

	ctx.C = C; ctx.mk = mk; ctx.corner = corner; ctx.stroke = stroke; ctx.pad = pad
end
