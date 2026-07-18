local SKIN = {}

SKIN.PrintName = "PAC3 Dark"
SKIN.Author = "PAC3"
SKIN.DermaVersion = 1
SKIN.GwenTexture = Material("gwenskin/GModDefault.png")

SKIN.Colours = setmetatable({}, {
	__index = function(t, k)
		local default_skin = derma.GetSkinTable()["Default"]
		if default_skin and default_skin.Colours and default_skin.Colours[k] then
			t[k] = table.Copy(default_skin.Colours[k])
			return t[k]
		end
		return nil
	end
})

-- custom pac theme colors
local bg_dark = Color(45, 45, 45, 255)
local bg_mid = Color(60, 60, 60, 255)
local bg_light = Color(75, 75, 75, 255)
local highlight = Color(90, 160, 220, 255)
local text_normal = Color(255, 255, 255, 255)
local text_hover = Color(255, 255, 255, 255)
local text_dark = Color(180, 180, 180, 255)
local border = Color(30, 30, 30, 255)

SKIN.control_color = bg_mid
SKIN.control_color_highlight = bg_light
SKIN.control_color_active = highlight
SKIN.control_color_dark = bg_dark
SKIN.fontFrame = "DermaDefault"

-- overriding default Derma Colours
SKIN.Colours.Window = SKIN.Colours.Window or {}
SKIN.Colours.Window.TitleActive = text_normal
SKIN.Colours.Window.TitleInactive = text_dark

SKIN.Colours.Button = SKIN.Colours.Button or {}
SKIN.Colours.Button.Normal = text_normal
SKIN.Colours.Button.Hover = text_hover
SKIN.Colours.Button.Down = text_hover
SKIN.Colours.Button.Disabled = text_dark

SKIN.Colours.Tree = SKIN.Colours.Tree or {}
SKIN.Colours.Tree.Lines = text_dark
SKIN.Colours.Tree.Normal = text_normal
SKIN.Colours.Tree.Hover = text_hover
SKIN.Colours.Tree.Selected = highlight

SKIN.Colours.Properties = SKIN.Colours.Properties or {}
SKIN.Colours.Properties.Line_Normal = bg_mid
SKIN.Colours.Properties.Line_Selected = bg_light
SKIN.Colours.Properties.Line_Hover = bg_light
SKIN.Colours.Properties.Title = text_normal
SKIN.Colours.Properties.Column_Normal = bg_mid
SKIN.Colours.Properties.Column_Selected = highlight
SKIN.Colours.Properties.Column_Hover = bg_light
SKIN.Colours.Properties.Border = border
SKIN.Colours.Properties.Label_Normal = text_normal
SKIN.Colours.Properties.Label_Selected = text_hover
SKIN.Colours.Properties.Label_Hover = text_hover

SKIN.Colours.Category = SKIN.Colours.Category or {}
SKIN.Colours.Category.Header = text_normal
SKIN.Colours.Category.Header_Closed = text_dark
SKIN.Colours.Category.Line = SKIN.Colours.Category.Line or {}
SKIN.Colours.Category.Line.Text = text_normal
SKIN.Colours.Category.Line.Text_Hover = text_hover
SKIN.Colours.Category.Line.Text_Selected = text_hover
SKIN.Colours.Category.Line.Button = bg_mid
SKIN.Colours.Category.Line.Button_Hover = bg_light
SKIN.Colours.Category.Line.Button_Selected = highlight
SKIN.Colours.Category.AltLine = SKIN.Colours.Category.AltLine or {}
SKIN.Colours.Category.AltLine.Text = text_normal
SKIN.Colours.Category.AltLine.Text_Hover = text_hover
SKIN.Colours.Category.AltLine.Text_Selected = text_hover
SKIN.Colours.Category.AltLine.Button = bg_dark
SKIN.Colours.Category.AltLine.Button_Hover = bg_light
SKIN.Colours.Category.AltLine.Button_Selected = highlight

SKIN.Colours.Label = SKIN.Colours.Label or {}
SKIN.Colours.Label.Default = text_normal
SKIN.Colours.Label.Bright = text_normal
SKIN.Colours.Label.Dark = text_dark
SKIN.Colours.Label.Highlight = highlight

SKIN.Colours.Tab = SKIN.Colours.Tab or {}
SKIN.Colours.Tab.Active = SKIN.Colours.Tab.Active or {}
SKIN.Colours.Tab.Active.Normal = text_normal
SKIN.Colours.Tab.Active.Hover = text_hover
SKIN.Colours.Tab.Active.Down = text_hover
SKIN.Colours.Tab.Active.Disabled = text_dark
SKIN.Colours.Tab.Inactive = SKIN.Colours.Tab.Inactive or {}
SKIN.Colours.Tab.Inactive.Normal = text_dark
SKIN.Colours.Tab.Inactive.Hover = text_hover
SKIN.Colours.Tab.Inactive.Down = text_hover
SKIN.Colours.Tab.Inactive.Disabled = text_dark

SKIN.Colours.Menu = SKIN.Colours.Menu or {}
SKIN.Colours.Menu.Normal = text_normal
SKIN.Colours.Menu.Hover = text_hover

SKIN.Colours.MenuOption = SKIN.Colours.MenuOption or {}
SKIN.Colours.MenuOption.Normal = text_normal
SKIN.Colours.MenuOption.Hover = text_hover
SKIN.Colours.MenuOption.Active = text_hover
SKIN.Colours.MenuOption.Disabled = text_dark

SKIN.Colours.TooltipText = text_normal

-- Paint overrides
function SKIN:PaintFrame(panel, w, h)
	surface.SetDrawColor(border)
	surface.DrawRect(0, 0, w, h)
	surface.SetDrawColor(bg_dark)
	surface.DrawRect(1, 1, w - 2, h - 2)
	surface.SetDrawColor(bg_mid)
	surface.DrawRect(1, 1, w - 2, 24)
end

function SKIN:PaintPanel(panel, w, h)
	if not panel.m_bBackground then return end
	surface.SetDrawColor(bg_dark)
	surface.DrawRect(0, 0, w, h)
end

function SKIN:PaintButton(panel, w, h)
	if not panel.m_bBackground then return end
	if panel.Depressed or panel:IsSelected() or panel:GetToggle() then
		surface.SetDrawColor(highlight)
	elseif panel.Hovered then
		surface.SetDrawColor(bg_light)
	else
		surface.SetDrawColor(bg_mid)
	end
	surface.DrawRect(0, 0, w, h)
	surface.SetDrawColor(border)
	surface.DrawOutlinedRect(0, 0, w, h)
end

function SKIN:PaintWindowCloseButton(panel, w, h)
	if not panel.m_bBackground then return end
	if panel.Depressed or panel:IsSelected() then
		surface.SetDrawColor(200, 50, 50, 255)
	elseif panel.Hovered then
		surface.SetDrawColor(250, 80, 80, 255)
	else
		surface.SetDrawColor(bg_mid)
	end
	surface.DrawRect(0, 0, w, h)
	surface.SetDrawColor(text_normal)
	surface.DrawLine(w*0.3, h*0.3, w*0.7, h*0.7)
	surface.DrawLine(w*0.3, h*0.7, w*0.7, h*0.3)
end

function SKIN:PaintVScrollBar(panel, w, h)
	surface.SetDrawColor(bg_dark)
	surface.DrawRect(0, 0, w, h)
end

function SKIN:PaintScrollBarGrip(panel, w, h)
	if panel.Depressed then
		surface.SetDrawColor(highlight)
	elseif panel.Hovered then
		surface.SetDrawColor(bg_light)
	else
		surface.SetDrawColor(bg_mid)
	end
	surface.DrawRect(0, 0, w, h)
	surface.SetDrawColor(border)
	surface.DrawOutlinedRect(0, 0, w, h)
end

function SKIN:PaintMenu(panel, w, h)
	surface.SetDrawColor(bg_dark)
	surface.DrawRect(0, 0, w, h)
	surface.SetDrawColor(border)
	surface.DrawOutlinedRect(0, 0, w, h)
end

function SKIN:PaintMenuOption(panel, w, h)
	if panel.m_bBackground and (panel.Hovered or panel.Highlight) then
		surface.SetDrawColor(highlight)
		surface.DrawRect(0, 0, w, h)
	end
end

function SKIN:PaintPropertySheet(panel, w, h)
	local ActiveTab = panel:GetActiveTab()
	local Offset = 0
	if IsValid(ActiveTab) then Offset = ActiveTab:GetTall() - 8 end

	surface.SetDrawColor(bg_dark)
	surface.DrawRect(0, Offset, w, h - Offset)
	surface.SetDrawColor(border)
	surface.DrawOutlinedRect(0, Offset, w, h - Offset)
end

function SKIN:PaintTab(panel, w, h)
	if panel:GetPropertySheet():GetActiveTab() == panel then
		surface.SetDrawColor(bg_dark)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(highlight)
		surface.DrawRect(0, 0, w, 2)
	else
		surface.SetDrawColor(bg_mid)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(border)
		surface.DrawOutlinedRect(0, 0, w, h)
	end
end

function SKIN:PaintCategoryList(panel, w, h)
	surface.SetDrawColor(bg_dark)
	surface.DrawRect(0, 0, w, h)
end

function SKIN:PaintCategoryButton(panel, w, h)
	surface.SetDrawColor(bg_mid)
	surface.DrawRect(0, 0, w, h)
	surface.SetDrawColor(border)
	surface.DrawOutlinedRect(0, 0, w, h)
end

function SKIN:PaintTree(panel, w, h)
	surface.SetDrawColor(bg_dark)
	surface.DrawRect(0, 0, w, h)
end

function SKIN:PaintTreeNode(panel, w, h)
	-- transparency thing
end

function SKIN:PaintTreeNodeButton(panel, w, h)
	if panel.m_bSelected then
		surface.SetDrawColor(highlight)
		surface.DrawRect(0, 0, w, h)
	elseif panel.Hovered then
		surface.SetDrawColor(bg_light)
		surface.DrawRect(0, 0, w, h)
	end
end

function SKIN:PaintTextEntry(panel, w, h)
	if panel.m_bBackground then
		if panel:HasFocus() then
			surface.SetDrawColor(bg_light)
		else
			surface.SetDrawColor(bg_mid)
		end
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(border)
		surface.DrawOutlinedRect(0, 0, w, h)
	end
	panel:DrawTextEntryText(text_normal, highlight, text_normal)
end

function SKIN:PaintExpandButton(panel, w, h)
	if not panel.m_bPainted then return end
	-- draw the expand/collapse arrow in white so it's visible on dark backgrounds
	local col = panel.Hovered and text_hover or text_normal
	surface.SetDrawColor(col)
	if panel:GetExpanded() then
		-- down arrow (expanded)
		local cx, cy = w / 2, h / 2
		local sz = math.min(w, h) * 0.35
		local verts = {
			{x = cx - sz, y = cy - sz * 0.4},
			{x = cx + sz, y = cy - sz * 0.4},
			{x = cx, y = cy + sz * 0.6},
		}
		draw.NoTexture()
		surface.DrawPoly(verts)
	else
		-- right arrow (collapsed)
		local cx, cy = w / 2, h / 2
		local sz = math.min(w, h) * 0.35
		local verts = {
			{x = cx - sz * 0.4, y = cy - sz},
			{x = cx + sz * 0.6, y = cy},
			{x = cx - sz * 0.4, y = cy + sz},
		}
		draw.NoTexture()
		surface.DrawPoly(verts)
	end
end

function SKIN:PaintTooltip(panel, w, h)
	surface.SetDrawColor(bg_dark)
	surface.DrawRect(0, 0, w, h)
	surface.SetDrawColor(border)
	surface.DrawOutlinedRect(0, 0, w, h)
end

function SKIN:PaintMenuBar(panel, w, h)
	surface.SetDrawColor(bg_dark)
	surface.DrawRect(0, 0, w, h)
	surface.SetDrawColor(border)
	surface.DrawLine(0, h-1, w, h-1)
end

derma.DefineSkin("pac3_dark", "PAC3's dark theme", SKIN)

local dark_skin = derma.GetSkinTable()["pac3_dark"]
if dark_skin then
	dark_skin.tex = dark_skin.tex or {}
	dark_skin.tex.CategoryList = dark_skin.tex.CategoryList or {}
	dark_skin.tex.CategoryList.Outer = function(x, y, w, h)
		surface.SetDrawColor(bg_dark)
		surface.DrawRect(x, y, w, h)
	end
	dark_skin.tex.CategoryList.Header = function(x, y, w, h)
		surface.SetDrawColor(bg_mid)
		surface.DrawRect(x, y, w, h)
		surface.SetDrawColor(border)
		surface.DrawOutlinedRect(x, y, w, h)
	end
	dark_skin.tex.Menu_Strip = function(x, y, w, h)
		surface.SetDrawColor(bg_dark)
		surface.DrawRect(x, y, w, h)
	end
	dark_skin.tex.Tab_Control = function(x, y, w, h)
		surface.SetDrawColor(bg_dark)
		surface.DrawRect(x, y, w, h)
	end
	dark_skin.tex.Scroller = dark_skin.tex.Scroller or {}
	dark_skin.tex.Scroller.TrackH = function(x, y, w, h)
		surface.SetDrawColor(bg_dark)
		surface.DrawRect(x, y, w, h)
	end
	dark_skin.tex.Scroller.ButtonH_Normal = function(x, y, w, h)
		surface.SetDrawColor(bg_mid)
		surface.DrawRect(x, y, w, h)
	end
	dark_skin.tex.Scroller.ButtonH_Hover = function(x, y, w, h)
		surface.SetDrawColor(bg_light)
		surface.DrawRect(x, y, w, h)
	end
	dark_skin.tex.Scroller.ButtonH_Down = function(x, y, w, h)
		surface.SetDrawColor(highlight)
		surface.DrawRect(x, y, w, h)
	end
	dark_skin.tex.Scroller.ButtonH_Disabled = function(x, y, w, h)
		surface.SetDrawColor(bg_dark)
		surface.DrawRect(x, y, w, h)
	end
end

-- override DermaMenu to inherit the active pac theme when the editor is open
local original_DermaMenu = DermaMenu
function DermaMenu(parent, ...)
	local menu = original_DermaMenu(parent, ...)
	if IsValid(menu) and pace and IsValid(pace.Editor) and pace.Editor:IsVisible() then
		local cv = GetConVar("pac_editor_theme")
		local active_theme = cv and cv:GetString() or "default"
		if active_theme and active_theme ~= "" and active_theme ~= "default" then
			menu:SetSkin(active_theme)
		end
	end
	return menu
end
-- please work