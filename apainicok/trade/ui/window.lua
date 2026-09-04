--[[ window.lua — jendela utama PINK ELEGAN: sidebar, title bar, drag, min/max/close, content, status, log.
     Mengisi: ctx.state.gui, ctx.ui.{main,maxIcon,content,tabButtonsFrame,sidebar,pages,tabBtns,statusText,logBox}
              ctx.log, ctx.setStatus ]]
return function(ctx)
	local Players          = ctx.Services.Players
	local UserInputService = ctx.Services.UserInputService
	local TS               = game:GetService("TweenService")
	local LP  = ctx.LP
	local CFG = ctx.CFG
	local C   = ctx.C
	local mk, corner, stroke, pad, grad = ctx.mk, ctx.corner, ctx.stroke, ctx.pad, ctx.grad

	ctx.ui.pages   = {}
	ctx.ui.tabBtns = {}

	----------------------------------------------------------------- bersihkan GUI lama
	pcall(function()
		local host = (gethui and gethui()) or game:GetService("CoreGui")
		local old = host:FindFirstChild("GAGSeller"); if old then old:Destroy() end
		local pg = LP:FindFirstChild("PlayerGui")
		if pg and pg:FindFirstChild("GAGSeller") then pg.GAGSeller:Destroy() end
	end)

	local gui = Instance.new("ScreenGui")
	gui.Name = "GAGSeller"; gui.ResetOnSpawn = false; gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = LP:WaitForChild("PlayerGui")
	ctx.state.gui = gui
	ctx.state.isAlive = true
	gui.Destroying:Connect(function()
		ctx.state.isAlive = false
	end)

	----------------------------------------------------------------- Floating Maximize Button
	local maxIcon = mk("TextButton", {
		Size = UDim2.fromOffset(48, 48), Position = UDim2.new(0, 15, 0.5, -24),
		BackgroundColor3 = C.acc, Text = "\u2661", Font = Enum.Font.GothamBlack, TextSize = 20,
		TextColor3 = Color3.new(1,1,1), Visible = false, Active = true,
	}, gui)
	corner(maxIcon, 14)
	stroke(maxIcon, C.acc, 2, 0)
	local maxGlowRing = mk("Frame", {
		Size = UDim2.new(1, 14, 1, 14), Position = UDim2.new(0, -7, 0, -7),
		BackgroundColor3 = C.acc, BackgroundTransparency = 0.7, BorderSizePixel = 0, ZIndex = -1,
	}, maxIcon)
	corner(maxGlowRing, 20)
	pcall(function()
		local logo = ctx.getLogo and ctx.getLogo()
		if logo then
			maxIcon.Text = ""
			local img = mk("ImageLabel", { Size = UDim2.new(1,-8,1,-8), Position = UDim2.fromOffset(4,4), BackgroundTransparency = 1, Image = logo, ScaleType = Enum.ScaleType.Fit }, maxIcon)
			corner(img, 12)
		end
	end)
	do
		local dragging, ds, sp
		maxIcon.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true; ds = i.Position; sp = maxIcon.Position end end)
		UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - ds; maxIcon.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
		UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
	end

	----------------------------------------------------------------- Main Jendela
	local main = mk("Frame", {
		Size = UDim2.fromOffset(680, 460), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
		BackgroundColor3 = C.bg, BackgroundTransparency = 0.04, BorderSizePixel = 0, Active = true,
	}, gui)
	corner(main, 14)
	stroke(main, C.acc, 1.5, 0.3)
	local innerGlow = mk("Frame", {
		Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = C.acc,
		BackgroundTransparency = 0.92, BorderSizePixel = 0,
	}, main)
	corner(innerGlow, 14)

	local uiScale = Instance.new("UIScale"); uiScale.Parent = main
	local function fitScale()
		local cam = workspace.CurrentCamera
		local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
		local w, h = main.Size.X.Offset, main.Size.Y.Offset
		local s = math.min(1, (vp.X - 40) / w, (vp.Y - 40) / h)
		uiScale.Scale = math.max(0.4, s)
	end
	fitScale()
	pcall(function()
		local cam = workspace.CurrentCamera
		if cam then cam:GetPropertyChangedSignal("ViewportSize"):Connect(fitScale) end
	end)

	----------------------------------------------------------------- Title Bar
	local titleBar = mk("Frame", {
		Size = UDim2.new(1, 0, 0, 44), BackgroundColor3 = C.panel, BorderSizePixel = 0, ZIndex = 2,
	}, main)
	corner(titleBar, 14)
	local titleGrad = mk("Frame", {
		Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = C.acc,
		BackgroundTransparency = 0.82, BorderSizePixel = 0, ZIndex = 1,
	}, titleBar)
	corner(titleGrad, 14)
	grad(titleGrad, 0)
	mk("Frame", {
		Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1),
		BackgroundColor3 = C.acc, BackgroundTransparency = 0.4, BorderSizePixel = 0, ZIndex = 3,
	}, titleBar)
	mk("TextLabel", {
		Size = UDim2.fromOffset(28, 44), Position = UDim2.fromOffset(14, 0),
		BackgroundTransparency = 1, Text = "\u2736", Font = Enum.Font.GothamBlack,
		TextSize = 16, TextColor3 = C.acc, ZIndex = 3,
	}, titleBar)
	mk("TextLabel", {
		Size = UDim2.new(1, -120, 1, 0), Position = UDim2.fromOffset(40, 0),
		BackgroundTransparency = 1, Text = "CeszParadise  \u00b7  GAG Trade",
		Font = Enum.Font.GothamBlack, TextSize = 14, TextColor3 = C.txt,
		TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3,
	}, titleBar)
	do
		local dragging, ds, sp
		titleBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true; ds = i.Position; sp = main.Position end end)
		UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - ds; main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
		UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
	end

	local function makeTitleBtn(label, posX, bgCol)
		local btn = mk("TextButton", {
			Size = UDim2.fromOffset(28, 28), Position = UDim2.new(1, posX, 0, 8),
			BackgroundColor3 = bgCol or C.row, Text = label,
			Font = Enum.Font.GothamBlack, TextSize = 12, TextColor3 = C.txt, ZIndex = 4,
			AutoButtonColor = false,
		}, titleBar)
		corner(btn, 7)
		stroke(btn, C.acc, 1, 0.6)
		btn.MouseEnter:Connect(function()
			TS:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = C.acc, TextColor3 = Color3.new(1,1,1) }):Play()
		end)
		btn.MouseLeave:Connect(function()
			TS:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = bgCol or C.row, TextColor3 = C.txt }):Play()
		end)
		return btn
	end

	local minBtn   = makeTitleBtn("\u2013", -68)
	local closeBtn = makeTitleBtn("\u2715", -34, C.row)
	minBtn.MouseButton1Click:Connect(function() main.Visible = false; maxIcon.Visible = true end)
	maxIcon.MouseButton1Click:Connect(function() maxIcon.Visible = false; main.Visible = true end)
	closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

	----------------------------------------------------------------- Left Sidebar
	local sidebar = mk("Frame", {
		Size = UDim2.new(0, 158, 1, -44), Position = UDim2.fromOffset(0, 44),
		BackgroundColor3 = C.panel, BorderSizePixel = 0,
	}, main)
	corner(sidebar, 14)
	local sidebarBorder = mk("Frame", {
		Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(1, -1, 0, 0),
		BackgroundColor3 = C.acc, BackgroundTransparency = 0.5, BorderSizePixel = 0,
	}, sidebar)
	grad(sidebarBorder, 90)
	pad(sidebar, 10, 10, 10, 10)

	mk("TextLabel", {
		Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1,
		Text = "M E N U", Font = Enum.Font.GothamBlack, TextSize = 9,
		TextColor3 = C.acc, TextXAlignment = Enum.TextXAlignment.Left,
		LayoutOrder = 0,
	}, sidebar)

	local tabButtonsFrame = mk("ScrollingFrame", {
		Size = UDim2.new(1, 0, 1, -66), Position = UDim2.fromOffset(0, 22),
		BackgroundTransparency = 1, BorderSizePixel = 0,
		ScrollBarThickness = 2, ScrollBarImageColor3 = C.acc, ScrollBarImageTransparency = 0.5,
		ScrollingDirection = Enum.ScrollingDirection.Y, CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingEnabled = true,
	}, sidebar)
	mk("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder }, tabButtonsFrame)

	local profileCard = mk("Frame", {
		Size = UDim2.new(1, 0, 0, 46), Position = UDim2.new(0, 0, 1, -46),
		BackgroundColor3 = C.row, BorderSizePixel = 0,
	}, sidebar)
	corner(profileCard, 10)
	stroke(profileCard, C.acc, 1, 0.5)
	pad(profileCard, 8, 6, 6, 6)

	local avatar = mk("ImageLabel", {
		Size = UDim2.fromOffset(32, 32), BackgroundColor3 = C.panel, BorderSizePixel = 0,
	}, profileCard)
	corner(avatar, 16)
	stroke(avatar, C.acc, 1.5, 0.2)
	pcall(function()
		avatar.Image = Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
	end)

	local nameLabel = mk("TextLabel", {
		Size = UDim2.new(1, -40, 0, 16), Position = UDim2.fromOffset(40, 4),
		BackgroundTransparency = 1, Text = LP.Name,
		Font = Enum.Font.GothamBlack, TextSize = 11, TextColor3 = C.txt,
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
	}, profileCard)
	mk("TextLabel", {
		Size = UDim2.new(1, -40, 0, 14), Position = UDim2.fromOffset(40, 22),
		BackgroundTransparency = 1, Text = "Trade World",
		Font = Enum.Font.Gotham, TextSize = 9, TextColor3 = C.acc,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, profileCard)
	pcall(function()
		local short = LP.DisplayName
		if #short > 12 then short = short:sub(1, 10) .. ".." end
		nameLabel.Text = short
	end)

	----------------------------------------------------------------- Right Content Frame
	local content = mk("Frame", {
		Size = UDim2.new(1, -174, 1, -68), Position = UDim2.fromOffset(168, 46),
		BackgroundTransparency = 1,
	}, main)

	----------------------------------------------------------------- Resize grip
	local grip = mk("TextButton", {
		Size = UDim2.fromOffset(22, 22), Position = UDim2.new(1, -24, 1, -24),
		BackgroundTransparency = 1, Text = "\u25e2",
		Font = Enum.Font.GothamBlack, TextSize = 14, TextColor3 = C.sub,
		AutoButtonColor = false, Active = true, ZIndex = 20,
	}, main)
	grip.MouseEnter:Connect(function() grip.TextColor3 = C.acc end)
	grip.MouseLeave:Connect(function() grip.TextColor3 = C.sub end)
	do
		local rz, ds, ss
		grip.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				rz = true; ds = i.Position; ss = Vector2.new(main.Size.X.Offset, main.Size.Y.Offset)
			end
		end)
		UserInputService.InputChanged:Connect(function(i)
			if rz and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
				local scale = uiScale.Scale > 0 and uiScale.Scale or 1
				local d = i.Position - ds
				local w = math.clamp(ss.X + d.X / scale, 460, 1600)
				local h = math.clamp(ss.Y + d.Y / scale, 320, 1000)
				main.Size = UDim2.fromOffset(w, h)
				fitScale()
			end
		end)
		UserInputService.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then rz = false end
		end)
	end

	----------------------------------------------------------------- Status footer
	local statusFooter = mk("Frame", {
		Size = UDim2.new(1, -174, 0, 20), Position = UDim2.new(0, 168, 1, -22),
		BackgroundTransparency = 1,
	}, main)
	local statusPill = mk("Frame", {
		Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = C.acc, BackgroundTransparency = 0.8, BorderSizePixel = 0,
	}, statusFooter)
	corner(statusPill, 8)
	pad(statusPill, 8, 8, 0, 0)
	local statusText = mk("TextLabel", {
		Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1, Text = "\u25cf idle",
		Font = Enum.Font.GothamBlack, TextSize = 10, TextColor3 = C.acc,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, statusPill)

	function ctx.setStatus(s)
		local isActive = s == "active" or s:find("ON") ~= nil
		statusText.Text = (isActive and "\u25cf " or "\u25cb ") .. s .. "  |  Loop: " .. (CFG.autoSell and "ON \u2736" or "OFF")
		statusText.TextColor3 = isActive and C.green or C.sub
	end

	----------------------------------------------------------------- Logger
	local logLines = ctx.state.logLines
	function ctx.log(msg)
		table.insert(logLines, os.date("%H:%M:%S ") .. msg)
		while #logLines > 10 do table.remove(logLines, 1) end
		if ctx.ui.logBox then ctx.ui.logBox.Text = table.concat(logLines, "\n") end
	end

	ctx.ui.main            = main
	ctx.ui.maxIcon         = maxIcon
	ctx.ui.content         = content
	ctx.ui.tabButtonsFrame = tabButtonsFrame
	ctx.ui.sidebar         = sidebar
	ctx.ui.statusText      = statusText
end
