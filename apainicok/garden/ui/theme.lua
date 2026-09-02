--[[ theme.lua — palet + helper Instance (garden, dominasi pink lucu & elegan). ]]
return function(ctx)
	local C = {
		bg      = Color3.fromRGB(42, 27, 42),    -- ungu-pink gelap
		panel   = Color3.fromRGB(61, 42, 61),    -- panel sedikit terang
		row     = Color3.fromRGB(79, 58, 79),    -- kartu/baris utama
		rowAlt  = Color3.fromRGB(69, 51, 69),    -- alternatif
		stroke  = Color3.fromRGB(106, 74, 106),  -- garis batas pink keabu-abuan
		acc     = Color3.fromRGB(255, 107, 157), -- pink cerah (aksen)
		txt     = Color3.fromRGB(245, 230, 245), -- putih dengan sedikit pink
		sub     = Color3.fromRGB(201, 166, 201), -- abu-pink halus
		green   = Color3.fromRGB(123, 204, 158), -- hijau mint
		red     = Color3.fromRGB(229, 115, 115), -- merah lembut
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
