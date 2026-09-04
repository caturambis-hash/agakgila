--[[ components.lua — kontrol UI reusable PINK ELEGAN.
     Mengisi: ctx.makeToggle, ctx.makeInput, ctx.makeDropdown,
               ctx.makeSingleDropdown, ctx.makeButton, ctx.makeAccordion, ctx.makePage
     Fitur baru: tw() helper, toggle pill 44x22, accordion dengan accentBar,
                 tab dengan pill background gradient. ]]
return function(ctx)
	local C      = ctx.C
	local mk     = ctx.mk
	local corner = ctx.corner
	local stroke = ctx.stroke
	local pad    = ctx.pad
	local grad   = ctx.grad
	local TS     = game:GetService("TweenService")

	-- tw(): shorthand TweenService:Create(...):Play()
	local function tw(obj, t, props)
		TS:Create(obj, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
	end

	----------------------------------------------------------------- toggle (pill 44x22 dengan gradient on-state)
	local function makeToggle(parent, title, desc, getv, setv, order)
		local row = mk("Frame", { Size = UDim2.new(1, 0, 0, 48), BackgroundTransparency = 1, LayoutOrder = order }, parent)
		local txts = mk("Frame", { Size = UDim2.new(1, -58, 1, 0), BackgroundTransparency = 1 }, row)
		mk("TextLabel", { Size = UDim2.new(1, 0, 0, 20), Position = UDim2.fromOffset(0, 4), BackgroundTransparency = 1, Text = title, Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = C.txt, TextXAlignment = Enum.TextXAlignment.Left }, txts)
		mk("TextLabel", { Size = UDim2.new(1, 0, 0, 16), Position = UDim2.fromOffset(0, 22), BackgroundTransparency = 1, Text = desc or "", Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = C.sub, TextXAlignment = Enum.TextXAlignment.Left }, txts)

		-- pill 44x22
		local pill = mk("TextButton", { Size = UDim2.fromOffset(44, 22), Position = UDim2.new(1, -48, 0.5, -11), BackgroundColor3 = C.panel, Text = "", AutoButtonColor = false }, row)
		corner(pill, 11); stroke(pill, C.stroke, 1, 0.3)
		-- gradient overlay (visible when ON)
		local pillGrad = mk("Frame", { Size = UDim2.new(1,0,1,0), BackgroundColor3 = C.acc, BackgroundTransparency = 1, BorderSizePixel = 0 }, pill)
		corner(pillGrad, 11)
		grad(pillGrad, 0)
		local dot = mk("Frame", { Size = UDim2.fromOffset(16, 16), Position = UDim2.fromOffset(3, 3), BackgroundColor3 = C.sub }, pill)
		corner(dot, 8)

		local function render()
			local on = getv()
			dot:TweenPosition(on and UDim2.fromOffset(25, 3) or UDim2.fromOffset(3, 3), "Out", "Quad", 0.15, true)
			tw(pillGrad, 0.15, { BackgroundTransparency = on and 0 or 1 })
			tw(dot, 0.15, { BackgroundColor3 = on and Color3.new(1,1,1) or C.sub })
		end
		pill.MouseButton1Click:Connect(function() setv(not getv()); render() end)
		render()
		ctx.state.toggleRenders = ctx.state.toggleRenders or {}
		table.insert(ctx.state.toggleRenders, render)
		return render
	end

	----------------------------------------------------------------- input
	local function makeInput(parent, title, desc, getv, setv, order)
		local row = mk("Frame", { Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1, LayoutOrder = order }, parent)
		local txts = mk("Frame", { Size = UDim2.new(1, -130, 1, 0), BackgroundTransparency = 1 }, row)
		mk("TextLabel", { Size = UDim2.new(1, 0, 0, 20), Position = UDim2.fromOffset(0, 2), BackgroundTransparency = 1, Text = title, Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = C.txt, TextXAlignment = Enum.TextXAlignment.Left }, txts)
		mk("TextLabel", { Size = UDim2.new(1, 0, 0, 14), Position = UDim2.fromOffset(0, 20), BackgroundTransparency = 1, Text = desc or "", Font = Enum.Font.Gotham, TextSize = 9, TextColor3 = C.sub, TextXAlignment = Enum.TextXAlignment.Left }, txts)

		local box = mk("TextBox", { Size = UDim2.fromOffset(110, 26), Position = UDim2.new(1, -112, 0.5, -13), BackgroundColor3 = C.panel, Text = tostring(getv()), Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = C.acc, ClearTextOnFocus = false }, row)
		corner(box, 6); local bs = stroke(box)
		box.Focused:Connect(function() tw(bs, 0.15, { Color = C.acc, Transparency = 0 }) end)
		box.FocusLost:Connect(function() tw(bs, 0.15, { Color = C.stroke, Transparency = 0.5 }); setv(box.Text); box.Text = tostring(getv()) end)
		ctx.state.uiRefreshers = ctx.state.uiRefreshers or {}
		table.insert(ctx.state.uiRefreshers, function() box.Text = tostring(getv()) end)
		return box
	end

	----------------------------------------------------------------- multi dropdown
	local function makeDropdown(parent, title, desc, options, selSet, onChange, order)
		local row = mk("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = order }, parent)
		mk("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4) }, row)

		local head = mk("TextButton", { Size = UDim2.new(1, 0, 0, 48), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, LayoutOrder = 1 }, row)
		local txts = mk("Frame", { Size = UDim2.new(1, -200, 1, 0), BackgroundTransparency = 1 }, head)
		mk("TextLabel", { Size = UDim2.new(1, 0, 0, 20), Position = UDim2.fromOffset(0, 4), BackgroundTransparency = 1, Text = title, Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = C.txt, TextXAlignment = Enum.TextXAlignment.Left }, txts)
		mk("TextLabel", { Size = UDim2.new(1, 0, 0, 16), Position = UDim2.fromOffset(0, 22), BackgroundTransparency = 1, Text = desc or "", Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = C.sub, TextXAlignment = Enum.TextXAlignment.Left }, txts)

		local valLbl = mk("TextLabel", { Size = UDim2.new(0, 180, 1, 0), Position = UDim2.new(1, -200, 0, 0), BackgroundTransparency = 1, Text = "Select Options", Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = C.sub, TextXAlignment = Enum.TextXAlignment.Right }, head)
		local arrow = mk("TextLabel", { Size = UDim2.fromOffset(12, 12), Position = UDim2.new(1, -12, 0.5, -6), BackgroundTransparency = 1, Text = "v", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = C.sub, TextXAlignment = Enum.TextXAlignment.Center }, head)

		local function updateSummary()
			local sel = {}
			for _, o in ipairs(options) do if selSet[o] then sel[#sel + 1] = o end end
			if #sel == 0 then valLbl.Text = "Select Options"; valLbl.TextColor3 = C.sub
			else
				local txt = table.concat(sel, ", ")
				if #txt > 20 then txt = ("%d selected"):format(#sel) end
				valLbl.Text = txt; valLbl.TextColor3 = C.acc
			end
		end

		local listFrame = mk("Frame", { Size = UDim2.new(1, 0, 0, 180), BackgroundColor3 = C.panel, Visible = false, LayoutOrder = 2 }, row)
		corner(listFrame, 6); stroke(listFrame)
		local search = mk("TextBox", { Size = UDim2.new(1, -12, 0, 26), Position = UDim2.fromOffset(6, 6), BackgroundColor3 = C.row, PlaceholderText = "Search...", Text = "", Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = C.txt, ClearTextOnFocus = false }, listFrame)
		corner(search, 6); stroke(search)
		local scroll = mk("ScrollingFrame", { Size = UDim2.new(1, -12, 1, -40), Position = UDim2.fromOffset(6, 36), BackgroundTransparency = 1, ScrollBarThickness = 4, CanvasSize = UDim2.new(), AutomaticCanvasSize = "Y", ScrollBarImageColor3 = C.acc }, listFrame)
		mk("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, scroll)

		local built = false
		local optBtns = {}
		local rends = {}
		local function reorder()
			local i = 0
			for _, opt in ipairs(options) do
				if selSet[opt] and optBtns[opt] then i = i + 1; optBtns[opt].LayoutOrder = i end
			end
			for _, opt in ipairs(options) do
				if not selSet[opt] and optBtns[opt] then i = i + 1; optBtns[opt].LayoutOrder = i end
			end
		end
		local function buildOptions()
			if built then return end
			built = true
			for _, opt in ipairs(options) do
				local ob = mk("TextButton", { Size = UDim2.new(1, 0, 0, 24), BackgroundColor3 = C.row, Text = "  " .. opt, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = C.txt, AutoButtonColor = false }, scroll)
				corner(ob, 4)
				local check = mk("TextLabel", { Size = UDim2.fromOffset(20, 24), Position = UDim2.new(1, -22, 0, 0), BackgroundTransparency = 1, Text = "", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = C.green }, ob)
				local function rend() check.Text = selSet[opt] and "\u2713" or ""; ob.BackgroundColor3 = selSet[opt] and C.acc:Lerp(C.panel, 0.7) or C.row end
				ob.MouseButton1Click:Connect(function()
					if selSet[opt] then selSet[opt] = nil else selSet[opt] = true end
					rend(); updateSummary(); reorder(); if onChange then onChange() end
				end)
				rend()
				optBtns[opt] = ob
				rends[#rends + 1] = rend
			end
			reorder()
		end
		search:GetPropertyChangedSignal("Text"):Connect(function()
			local q = search.Text:lower()
			for opt, ob in pairs(optBtns) do ob.Visible = (q == "" or opt:lower():find(q, 1, true) ~= nil) end
		end)
		head.MouseButton1Click:Connect(function()
			if not built then buildOptions() end
			listFrame.Visible = not listFrame.Visible
			arrow.Text = listFrame.Visible and "^" or "v"
			if listFrame.Visible then reorder() end
		end)
		updateSummary()
		local function refresh()
			for _, r in ipairs(rends) do r() end
			updateSummary()
			if built then reorder() end
		end
		ctx.state.uiRefreshers = ctx.state.uiRefreshers or {}
		table.insert(ctx.state.uiRefreshers, refresh)
		return refresh
	end

	----------------------------------------------------------------- single dropdown
	local function makeSingleDropdown(parent, title, desc, options, getv, setv, order)
		local row = mk("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = order }, parent)
		mk("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4) }, row)

		local head = mk("TextButton", { Size = UDim2.new(1, 0, 0, 48), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, LayoutOrder = 1 }, row)
		local txts = mk("Frame", { Size = UDim2.new(1, -200, 1, 0), BackgroundTransparency = 1 }, head)
		mk("TextLabel", { Size = UDim2.new(1, 0, 0, 20), Position = UDim2.fromOffset(0, 2), BackgroundTransparency = 1, Text = title, Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = C.txt, TextXAlignment = Enum.TextXAlignment.Left }, txts)
		mk("TextLabel", { Size = UDim2.new(1, 0, 0, 14), Position = UDim2.fromOffset(0, 20), BackgroundTransparency = 1, Text = desc or "", Font = Enum.Font.Gotham, TextSize = 9, TextColor3 = C.sub, TextXAlignment = Enum.TextXAlignment.Left }, txts)

		local initialDisplay = getv()
		for _, opt in ipairs(options) do
			if type(opt) == "table" and opt.name == getv() then
				initialDisplay = opt.display; break
			elseif type(opt) == "string" and opt == getv() then
				initialDisplay = opt; break
			end
		end

		local valLbl = mk("TextLabel", { Size = UDim2.new(0, 180, 1, 0), Position = UDim2.new(1, -200, 0, 0), BackgroundTransparency = 1, Text = initialDisplay, Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = C.sub, TextXAlignment = Enum.TextXAlignment.Right }, head)
		local arrow = mk("TextLabel", { Size = UDim2.fromOffset(12, 12), Position = UDim2.new(1, -12, 0.5, -6), BackgroundTransparency = 1, Text = "v", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = C.sub, TextXAlignment = Enum.TextXAlignment.Center }, head)

		local listFrame = mk("Frame", { Size = UDim2.new(1, 0, 0, 160), BackgroundColor3 = C.panel, Visible = false, LayoutOrder = 2 }, row)
		corner(listFrame, 6); stroke(listFrame)
		local scroll = mk("ScrollingFrame", { Size = UDim2.new(1, -12, 1, -12), Position = UDim2.fromOffset(6, 6), BackgroundTransparency = 1, ScrollBarThickness = 4, CanvasSize = UDim2.new(), AutomaticCanvasSize = "Y", ScrollBarImageColor3 = C.acc }, listFrame)
		mk("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, scroll)

		local built = false
		local function buildOptions()
			if built then return end
			built = true
			for _, opt in ipairs(options) do
				local displayVal = type(opt) == "table" and opt.display or opt
				local codeVal = type(opt) == "table" and opt.name or opt
				local ob = mk("TextButton", { Size = UDim2.new(1, 0, 0, 24), BackgroundColor3 = C.row, Text = "  " .. displayVal, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = C.txt, AutoButtonColor = false }, scroll)
				corner(ob, 4)
				ob.MouseButton1Click:Connect(function()
					setv(codeVal)
					valLbl.Text = displayVal
					listFrame.Visible = false
					arrow.Text = "v"
				end)
			end
		end
		head.MouseButton1Click:Connect(function()
			if not built then buildOptions() end
			listFrame.Visible = not listFrame.Visible
			arrow.Text = listFrame.Visible and "^" or "v"
		end)
		return head
	end

	----------------------------------------------------------------- button dengan gradient hover
	local function makeButton(parent, title, color, onClick, order)
		local base = color or C.acc
		local btn = mk("TextButton", { Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = base, Text = title, Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Color3.new(1, 1, 1), AutoButtonColor = false, LayoutOrder = order }, parent)
		corner(btn, 6); stroke(btn, C.stroke, 1, 0.4)
		-- gradient accent bar di bawah button
		local bar = mk("Frame", { Size = UDim2.new(1, 0, 0, 2), Position = UDim2.new(0, 0, 1, -2), BackgroundColor3 = C.acc2, BorderSizePixel = 0 }, btn)
		corner(bar, 3)
		grad(bar, 0)
		btn.MouseEnter:Connect(function() tw(btn, 0.15, { BackgroundColor3 = base:Lerp(Color3.new(1, 1, 1), 0.12) }) end)
		btn.MouseLeave:Connect(function() tw(btn, 0.15, { BackgroundColor3 = base }) end)
		if onClick then btn.MouseButton1Click:Connect(onClick) end
		return btn
	end

	----------------------------------------------------------------- accordion dengan accentBar kiri
	local function makeAccordion(parent, title, order)
		local container = mk("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = C.row, BorderSizePixel = 0, LayoutOrder = order, ClipsDescendants = false }, parent)
		corner(container, 8); stroke(container)
		mk("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 0) }, container)

		local head = mk("TextButton", { Size = UDim2.new(1, 0, 0, 44), BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, LayoutOrder = 1 }, container)
		corner(head, 8)
		pad(head, 18, 12, 0, 0)

		-- accent bar kiri (pink, 3px)
		local accentBar = mk("Frame", { Size = UDim2.fromOffset(3, 20), Position = UDim2.new(0, 8, 0.5, -10), BackgroundColor3 = C.acc, BorderSizePixel = 0 }, head)
		corner(accentBar, 2)
		grad(accentBar, 90)

		local lbl = mk("TextLabel", { Size = UDim2.new(1, -30, 1, 0), BackgroundTransparency = 1, Text = title, Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = C.txt, TextXAlignment = Enum.TextXAlignment.Left }, head)
		local arrow = mk("TextLabel", { Size = UDim2.fromOffset(12, 12), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(1, -6, 0.5, 0), BackgroundTransparency = 1, Text = "v", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = C.sub, TextXAlignment = Enum.TextXAlignment.Center }, head)

		local line = mk("Frame", { Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = C.acc, BackgroundTransparency = 0.6, BorderSizePixel = 0, LayoutOrder = 2, Visible = false }, container)
		local body = mk("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Visible = false, LayoutOrder = 3 }, container)
		pad(body, 12, 12, 8, 12)
		mk("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, body)

		head.MouseEnter:Connect(function() tw(head, 0.2, { BackgroundTransparency = 0.94 }) end)
		head.MouseLeave:Connect(function() tw(head, 0.2, { BackgroundTransparency = 1 }) end)

		local function setOpen(open)
			body.Visible = open
			line.Visible = open
			tw(arrow, 0.25, { Rotation = open and 180 or 0 })
			tw(arrow, 0.2, { TextColor3 = open and C.acc or C.sub })
			tw(lbl, 0.2, { TextColor3 = open and C.acc or C.txt })
			tw(accentBar, 0.2, { BackgroundTransparency = open and 0 or 0.5 })
		end

		head.MouseButton1Click:Connect(function() setOpen(not body.Visible) end)
		return body, setOpen, container
	end

	----------------------------------------------------------------- page + tab (pill background)
	local function selectTab(name)
		local pages   = ctx.ui.pages
		local tabBtns = ctx.ui.tabBtns
		for n, p in pairs(pages) do p.Visible = (n == name) end
		for n, b in pairs(tabBtns) do
			local on = (n == name)
			tw(b.pill, 0.18, { BackgroundTransparency = on and 0.82 or 1 })
			b.btn.TextColor3 = on and C.txt or C.sub
			b.line.Visible = on
		end
	end
	ctx.selectTab = selectTab

	local function makePage(name, titleText, iconLabel, order)
		local tabButtonsFrame = ctx.ui.tabButtonsFrame
		local content         = ctx.ui.content
		local pages           = ctx.ui.pages
		local tabBtns         = ctx.ui.tabBtns

		-- pill background behind tab button
		local pillFrame = mk("Frame", {
			Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = C.acc, BackgroundTransparency = 1,
			LayoutOrder = order,
		}, tabButtonsFrame)
		corner(pillFrame, 8)
		grad(pillFrame, 0)

		local btn = mk("TextButton", {
			Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
			Text = "     " .. iconLabel .. " | " .. name, Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = C.sub,
			AutoButtonColor = false, TextXAlignment = Enum.TextXAlignment.Left
		}, pillFrame)

		local line = mk("Frame", { Size = UDim2.fromOffset(3, 18), Position = UDim2.new(0, 4, 0.5, -9), BackgroundColor3 = C.acc, Visible = false }, btn)
		corner(line, 2)
		tabBtns[name] = { btn = btn, line = line, pill = pillFrame }

		btn.MouseEnter:Connect(function() if not line.Visible then tw(pillFrame, 0.18, { BackgroundTransparency = 0.94 }) end end)
		btn.MouseLeave:Connect(function() if not line.Visible then tw(pillFrame, 0.18, { BackgroundTransparency = 1 }) end end)

		local pg = mk("ScrollingFrame", {
			Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false, ScrollBarThickness = 4,
			CanvasSize = UDim2.new(), AutomaticCanvasSize = "Y", ScrollBarImageColor3 = C.acc
		}, content)
		mk("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, pg)
		pages[name] = pg

		local pageHeader = mk("Frame", { Size = UDim2.new(1, 0, 0, 38), BackgroundTransparency = 1, LayoutOrder = 0 }, pg)
		mk("TextLabel", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = titleText, Font = Enum.Font.GothamBold, TextSize = 22, TextColor3 = C.txt, TextXAlignment = Enum.TextXAlignment.Left }, pageHeader)

		btn.MouseButton1Click:Connect(function() selectTab(name) end)
		return pg
	end

	ctx.makeToggle         = makeToggle
	ctx.makeInput          = makeInput
	ctx.makeDropdown       = makeDropdown
	ctx.makeSingleDropdown = makeSingleDropdown
	ctx.makeButton         = makeButton
	ctx.makeAccordion      = makeAccordion
	ctx.makePage           = makePage
end
