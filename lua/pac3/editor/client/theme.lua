local SKIN = {}

SKIN.PrintName = "PAC3 Dark"
SKIN.Author = "PAC3"
SKIN.DermaVersion = 1
SKIN.GwenTexture = Material("gwenskin/GModDefault.png")

local base_skin = derma.GetSkinTable()["Default"]
if base_skin then
	SKIN.Colours = table.Copy(base_skin.Colours)
else
	SKIN.Colours = {}
end

-- custom pac theme colors
local bg_dark = Color(45, 45, 45, 255)
local bg_mid = Color(60, 60, 60, 255)
local bg_light = Color(75, 75, 75, 255)
local highlight = Color(90, 160, 220, 255)
local text_normal = Color(220, 220, 220, 255)
local text_hover = Color(255, 255, 255, 255)
local text_dark = Color(150, 150, 150, 255)
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

derma.DefineSkin("pac3_dark", "PAC3 Dark Theme", SKIN)
