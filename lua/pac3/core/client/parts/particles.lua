local cam_IgnoreZ = cam.IgnoreZ
local vector_origin = vector_origin
local FrameTime = FrameTime
local angle_origin = Angle(0,0,0)
local WorldToLocal = WorldToLocal
local particle_col = Color(255, 255, 255)

local BUILDER, PART = pac.PartTemplate("base_drawable")

PART.ClassName = "particles"
PART.Group = 'effects'
PART.Icon = 'icon16/water.png'

BUILDER:StartStorableVars()
	BUILDER:SetPropertyGroup("generic")
		BUILDER:PropertyOrder("Name")
		BUILDER:PropertyOrder("Hide")
		BUILDER:PropertyOrder("ParentName")
		BUILDER:GetSet("Follow", false)
		BUILDER:GetSet("Additive", false)
		BUILDER:GetSet("PositionSpreadType", "SphereHollow", {enums = {
			["Box"] = "Box",
			["Hollow sphere"] = "SphereHollow",
			["Filled sphere"] = "SphereFilled",
			["Hollow disc"] = "DiscHollow",
			["Filled disc"] = "DiscFilled",
		}})
		BUILDER:GetSet("PositionSpread", 0)
		BUILDER:GetSet("PositionSpread2", Vector(0,0,0))
	BUILDER:SetPropertyGroup("spread")
		BUILDER:GetSet("MinAngle", 0, {description = "applies to disc-related spreads and position spreads"})
		BUILDER:GetSet("MaxAngle", 360, {description = "applies to disc-related spreads and position spreads"})
		BUILDER:GetSet("SpreadType", "Legacy", {enums = {
			["Legacy"] = "Legacy",
			["Square cone"] = "SquareCone",
			["Flat cone"] = "FlatCone",
			["Cone"] = "Cone",
			["Disc"] = "Disc",
		}})
		BUILDER:GetSet("Spread", 0.1)
		BUILDER:GetSet("SpreadVector", Vector(0,0,0))
		BUILDER:GetSet("SpreadAngle", 0)
		BUILDER:GetSet("DieTime", 3)
		BUILDER:GetSet("StartSize", 2)
		BUILDER:GetSet("EndSize", 20)
		BUILDER:GetSet("StartLength", 0)
		BUILDER:GetSet("EndLength", 0)
		BUILDER:GetSet("ParticleAngle", Angle(0,0,0))
		BUILDER:GetSet("AddFrametimeLife", false)

	BUILDER:SetPropertyGroup("particle emissions")
		BUILDER:GetSet("FireDelay", 0.2)
		BUILDER:GetSet("FireOnce", false)
		BUILDER:GetSet("NumberParticles", 1, {editor_onchange = function(self,num) return math.Clamp(num,0,2000) end})
		BUILDER:GetSet("FireDuration", 0, {description = "how long to fire particles\n0 = infinite"})
		BUILDER:GetSet("Decay", 0, {description = "rate of decay for particle count, in particles per second\n0 = no decay\na positive number means simple decay starting at showtime\na negative number means delayed decay so that it reaches 0 at the time of 'fire duration'"})
		BUILDER:GetSet("FractionalChance", false, {description = "If 'number particles' has decimals, there is a chance to emit another particle\ne.g. 0.5 is 50% chance to emit a particle\ne.g. 1.25 is 25% chance to fire two / 75% to fire one particle)"})

		BUILDER:GetSet("SpawnOnMesh", false, {description = "Spawns particles across the triangles/faces of the target part's model. This calculates based on the default model's resting pose/t-pose, so it won't follow animations."})
		BUILDER:GetSet("SpawnOnBones", false, {description = "Randomly distributes particles across the target part's animated bones/hitboxes. Functionally, this is an alternative for spawning particles on a mesh, but it inherently sacrifices control."})
	BUILDER:SetPropertyGroup("mesh particles")
		BUILDER:GetSet("MeshParticle", false, {description = "Use 3D models as particles instead of 2D sprites. However, there is a hard ca to 100 max active particles at a time."})
		BUILDER:GetSet("ParticleModel", "models/props_junk/watermelon01.mdl", {editor_panel = "model"})
	BUILDER:SetPropertyGroup("stick")
		BUILDER:GetSet("AlignToSurface", true, {description = "requires 3D set to true"})
		BUILDER:GetSet("StickToSurface", true, {description = "requires 3D set to true, and sliding set to false"})
		BUILDER:GetSet("StickLifetime", 2)
		BUILDER:GetSet("StickStartSize", 20)
		BUILDER:GetSet("StickEndSize", 0)
		BUILDER:GetSet("StickStartAlpha", 255)
		BUILDER:GetSet("StickEndAlpha", 0)
	BUILDER:SetPropertyGroup("appearance")
		BUILDER:GetSet("Material", "effects/slime1")
		BUILDER:GetSet("StartAlpha", 255)
		BUILDER:GetSet("EndAlpha", 0)
		BUILDER:GetSet("Translucent", true)
		BUILDER:GetSet("Color2", Vector(255, 255, 255), {editor_panel = "color"})
		BUILDER:GetSet("Color1", Vector(255, 255, 255), {editor_panel = "color"})
		BUILDER:GetSet("HSVMode", false)
		BUILDER:GetSet("HSV1", Vector(360, 1, 1), {editor_friendly = "HSV1"})
		BUILDER:GetSet("HSV2", Vector(360, 1, 1), {editor_friendly = "HSV2"})
		BUILDER:GetSet("RandomColor", false)
		BUILDER:GetSet("ColorRamp", false, {description = "Linear interpolation of particle colors from Color1 to Color2 over the particle's lifetime."})
		BUILDER:GetSet("Lighting", true)
		BUILDER:GetSet("3D", false, {description = "The particles are oriented relative to the part instead of the viewer.\nYou might want to set zero angle to false if you use this."})
		BUILDER:GetSet("DoubleSided", true)
		BUILDER:GetSet("DrawManual", false)
	BUILDER:SetPropertyGroup("rotation")
		BUILDER:GetSet("ZeroAngle",true, {description = "A workaround for non-3D particles' roll with certain oriented textures. Forces 0,0,0 angles when the particle is emitted\nWith round textures you don't notice, but the same cannot be said of textures which need to be upright rather than having strangely tilted copies."})
		BUILDER:GetSet("RandomRollSpeed", 0)
		BUILDER:GetSet("RollDelta", 0)
		BUILDER:GetSet("ParticleAngleVelocity", Vector(0, 0, 0))
		BUILDER:GetSet("FireDirectionToAngle", false)
		BUILDER:GetSet("PositionSpreadToAngle", false)
	BUILDER:SetPropertyGroup("orientation")
	BUILDER:SetPropertyGroup("movement")
		BUILDER:GetSet("Velocity", 250)
		BUILDER:GetSet("Spread", 0.1)
		BUILDER:GetSet("AirResistance", 5)
		BUILDER:GetSet("Bounce", 5)
		BUILDER:GetSet("Gravity", Vector(0,0, -50))
		BUILDER:GetSet("Collide", true)
		BUILDER:GetSet("RemoveOnCollide", false)
		BUILDER:GetSet("Sliding", true)
		--BUILDER:GetSet("AddVelocityFromOwner", false)
		BUILDER:GetSet("OwnerVelocityMultiplier", 0)


	BUILDER:SetPropertyGroup("particle function")
		BUILDER:GetSet("ThinkFunction", "", {enums = {
			["none"] = "",
			["brownian"] = "brownian",
			["SpriteCard"] = "SpriteCard",
			["sine_alpha"] = "",
			["fading_inout_alpha"] = "fading_inout_alpha",
			["inject_proxy"] = "inject_proxy"
		}})
		BUILDER:GetSet("ThinkTime", 0)
		BUILDER:GetSet("PropertyName", "")
		BUILDER:GetSetPart("LinkedPart")
		BUILDER:GetSet("BrownianStrength", 0)

BUILDER:EndStorableVars()

function PART:Initialize()
	self.number_particles = 0
end

function PART:GetNiceName()
	local str = (self:GetMaterial()):match(".+/(.+)") or ""
	--return pac.PrettifyName("/".. str) or "error"
	return "[".. math.Round(self.number_particles or 0,2) .. "] " .. str
end

local function RemoveCallback(particle)
	particle:SetLifeTime(0)
	particle:SetDieTime(0)

	particle:SetStartSize(0)
	particle:SetEndSize(0)

	particle:SetStartAlpha(0)
	particle:SetEndAlpha(0)
end

local function SlideCallback(particle, hitpos, normal)
	particle:SetBounce(1)
	local vel = particle:GetVelocity()
	vel.z = 0
	particle:SetVelocity(vel)
	particle:SetPos(hitpos + normal)
end

local function StickCallback(particle, hitpos, normal)
	particle:SetAngleVelocity(Angle(0, 0, 0))

	if particle.Align then
		local ang = normal:Angle()
		ang:RotateAroundAxis(normal, particle:GetAngles().y)
		particle:SetAngles(ang + particle.ParticleAngle + (particle.is_doubleside == true and Angle(180,0,0) or Angle(0,0,0)))
	end

	if particle.Stick then
		particle:SetVelocity(Vector(0, 0, 0))
		particle:SetGravity(Vector(0, 0, 0))
	end

	particle:SetLifeTime(0)
	particle:SetDieTime(particle.StickLifeTime or 0)

	particle:SetStartSize(particle.StickStartSize or 0)
	particle:SetEndSize(particle.StickEndSize or 0)

	particle:SetStartAlpha(particle.StickStartAlpha or 0)
	particle:SetEndAlpha(particle.StickEndAlpha or 0)
end

function PART:GetEmitter()
	if not self.emitter then
		self.NextShot = 0
		self.Created = pac.RealTime + 0.1
		self.emitter = ParticleEmitter(vector_origin, self:Get3D())
	end

	return self.emitter
end

function PART:SetDrawManual(b)
	self.DrawManual = b
	self:GetEmitter():SetNoDraw(b)
end

local max_active_particles = CreateClientConVar("pac_limit_particles_per_emitter", "8000")
local max_emit_particles = CreateClientConVar("pac_limit_particles_per_emission", "100")
function PART:SetNumberParticles(num)
	local max = max_emit_particles:GetInt()
	if num > max or num > 100 then self:SetWarning("You're trying to set the number of particles beyond the pac_limit_particles_per_emission limit, the default limit is 100.\nFor reference, the default max active particles for the emitter is around 8000 but can be further limited with pac_limit_particles_per_emitter") else self:SetWarning() end
	self.NumberParticles = math.Clamp(num, 0, max)
end

function PART:Set3D(b)
	self["3D"] = b
	self.emitter = nil
end

function PART:OnShow(from_rendering)
	self.number_particles = self.NumberParticles
	self.CanKeepFiring = true
	self.FirstShot = true
	self.FirstShotTime = RealTime()
	if not from_rendering then
		self.NextShot = 0
		local pos, ang = self:GetDrawPosition()
		self:EmitParticles(self.Follow and vector_origin or pos, self.Follow and angle_origin or ang, ang)
	end
end

function PART:OnDraw()
	self.number_particles = self.NumberParticles or 0
	if not self.FireOnce then
		if self.Decay == 0 then
			self.number_particles = self.NumberParticles or 0
		elseif self.Decay > 0 then
			self.number_particles = math.Clamp(self.NumberParticles - (RealTime() - self.FirstShotTime) * self.Decay,0,self.NumberParticles)
		else
			self.number_particles = math.Clamp(-self.FireDuration * self.Decay + self.NumberParticles - (RealTime() - self.FirstShotTime) * self.Decay,0,self.NumberParticles)
		end
		if self.FireDuration <= 0 then
			self.CanKeepFiring = true
		else
			if RealTime() > self.FirstShotTime + self.FireDuration then self.number_particles = 0 end
		end
		if self.Decay ~= 0 then
			if pace and pace.IsActive() and self.Name == "" then
				if IsValid(self.pace_tree_node) then
					self.pace_tree_node:SetText(self:GetNiceName())
				end
			end
		end
	end
	local pos, ang = self:GetDrawPosition()
	local emitter = self:GetEmitter()

	emitter:SetPos(pos)
	if self.DrawManual or self.IgnoreZ or self.Follow or self.BlendMode ~= "" then

		if not self.nodraw then
			emitter:SetNoDraw(true)
			self.nodraw = true
		end

		if self.Follow then
			cam.Start3D(WorldToLocal(EyePos(), EyeAngles(), pos, ang))
			if self.IgnoreZ then cam.IgnoreZ(true) end
			emitter:Draw()
			if self.IgnoreZ then cam.IgnoreZ(false) end
			cam.End3D()
		else
			emitter:Draw()
		end
	else
		if self.nodraw then
			self:SetDrawManual(self:GetDrawManual())
			self.nodraw = false
		end
	end
	if self.MeshParticlesList then
		local frametime_val = FrameTime()
		local particle_matrix = Matrix()
		for i = #self.MeshParticlesList, 1, -1 do
			local p = self.MeshParticlesList[i]
			if CurTime() > p.life or not IsValid(p.ent) then
				if IsValid(p.ent) then SafeRemoveEntity(p.ent) end
				table.remove(self.MeshParticlesList, i)
			else
				local frac = math.Clamp(1 - ((p.life - CurTime()) / p.die_time), 0, 1)
				p.vel = p.vel + (p.gravity * frametime_val)
				if p.air_res > 0 then p.vel = p.vel * math.exp(-p.air_res * frametime_val) end

				local oldpos = p.pos or p.ent:GetPos()
				local newpos = oldpos + p.vel * frametime_val

				if p.collide then
					local tr = util.TraceLine({start = oldpos, endpos = newpos, filter = p.ent})
					if tr.Hit then
						newpos = tr.HitPos + tr.HitNormal
						if p.sliding then
							p.vel.z = 0
							p.bounce = 1
						else
							p.vel = p.vel * -p.bounce
						end
					end
				end
				p.pos = newpos
				p.ent:SetPos(newpos)
				local newang = p.ent:GetAngles()
				newang = newang + p.ang_vel * frametime_val
				if p.roll_speed ~= 0 then newang.r = newang.r + p.roll_speed * frametime_val end
				p.ent:SetAngles(newang)

				local c1r, c1g, c1b = p.color1.r, p.color1.g, p.color1.b
				local c2r, c2g, c2b = p.color2.r, p.color2.g, p.color2.b
				particle_col.r = Lerp(frac, c1r, c2r)
				particle_col.g = Lerp(frac, c1g, c2g)
				particle_col.b = Lerp(frac, c1b, c2b)
				particle_col.a = Lerp(frac, p.start_a, p.end_a)
				p.ent:SetColor(particle_col)

				local size = math.max(Lerp(frac, p.start_size, p.end_size) / 10, 0.001)
				p.ent:SetModelScale(size, 0)
				p.ent:SetupBones()
				local override_mat = nil
				if self.Materialm and self.Material ~= "effects/slime1" then
					override_mat = self.Materialm
				elseif self.Material ~= "" and self.Material ~= "effects/slime1" then
					override_mat = pac.Material(self.Material, self)
				end
				if override_mat then
					render.MaterialOverride(override_mat)
				end
				render.SetColorModulation(particle_col.r / 255, particle_col.g / 255, particle_col.b / 255)
				render.SetBlend(particle_col.a / 255)

				if not self.Lighting then render.SuppressEngineLighting(true) end

				if self.Follow then
					cam.Start3D(WorldToLocal(EyePos(), EyeAngles(), pos, ang))
					if self.IgnoreZ then cam.IgnoreZ(true) end
					p.ent:DrawModel()
					if self.IgnoreZ then cam.IgnoreZ(false) end
					cam.End3D()
				else
					p.ent:DrawModel()
				end

				if not self.Lighting then render.SuppressEngineLighting(false) end
				if override_mat then render.MaterialOverride() end
				render.SetColorModulation(1, 1, 1)
				render.SetBlend(1)
			end
		end
	end

	self:EmitParticles(self.Follow and vector_origin or pos, self.Follow and angle_origin or ang, ang)
end
function PART:OnRemove()
	self:ClearMeshParticles()
end

function PART:ClearMeshParticles()
	if self.MeshParticlesList then
		for i = 1, #self.MeshParticlesList do
			local p = self.MeshParticlesList[i]
			if IsValid(p.ent) then SafeRemoveEntity(p.ent) end
		end
		self.MeshParticlesList = nil
	end
end

function PART:SetMeshParticle(b)
	self.MeshParticle = b
	if not b then
		self:ClearMeshParticles()
	end
end

function PART:SetAdditive(b)
	self.Additive = b

	self:SetMaterial(self:GetMaterial())
end

function PART:SetMaterial(var)
	var = var or ""

	if not pac.Handleurltex(self, var, function(mat)
		mat:SetFloat("$alpha", 0.999)
		mat:SetInt("$spriterendermode", self.Additive and 5 or 1)
		self.Materialm = mat
		self:CallRecursive("OnMaterialChanged")
	end, "Sprite") then
		if var == "" then
			self.Materialm = nil
		else
			self.Materialm = pac.Material(var, self)
			self:CallRecursive("OnMaterialChanged")
		end
	end

	self.Material = var
end
local function brownian(self)
	self:SetVelocity(self:GetVelocity() + VectorRand(-self.part.BrownianStrength,self.part.BrownianStrength))
	self:SetNextThink(CurTime() + self.thinktime)
end

local function alpha_sin(self)
	self:SetStartAlpha(150 * (0.5 + 0.5*math.sin(self.birth + CurTime() * 5)))
	self:SetEndAlpha(150 * (0.5 + 0.5*math.sin(self.birth + CurTime() * 5)))
	self:SetNextThink(CurTime() + self.thinktime)
end

local function inject_proxy(self)
	if self.valid_part then
		local num = (self.part.LinkedPart.feedback[1] or 0)
		if self.part.PropertyName == "StartSize" or self.part.PropertyName == "EndSize" then
			self:SetStartSize(num)
			self:SetEndSize(num)
		elseif self["Set" .. self.part.PropertyName] then

		end
	end
	self:SetNextThink(CurTime() + self.thinktime)
end

local function spritecard(self)
	if CurTime() > self.next_frame then self.frame = self.frame + 1 end
	self:SetNextThink(CurTime() + self.thinktime)
end

local expanded_mats_pool = {}

local function spritecard2(self)
	self.next_frame = self.next_frame or CurTime() + 0.1
	self.mat_series = expanded_mats_pool[self.mat_name]
	if CurTime() > self.next_frame then
		self.frame = self.frame + 1
		self.clamp_frame = math.Clamp(self.frame, 1, #self.mat_series)
		self.next_frame = CurTime() + 0.1
	end
	self.clamp_frame = self.clamp_frame or self.frame
	if self.mat_series == nil then return end

	self:SetMaterial(self.mat_series[self.clamp_frame])
	if self.frame > 10 then
		self:SetMaterial("models/wireframe")
	end
	self:SetNextThink(CurTime() + self.thinktime)
end

local function fading_inout_alpha(self)
	local alpha = 255*math.Clamp(-self.birth + CurTime(),0,1)*math.Clamp(self.maxlife - (-self.birth + CurTime()),0,1)
	self:SetStartAlpha(alpha) self:SetEndAlpha(alpha)
	self:SetNextThink(CurTime() + self.thinktime)
end

function PART:SetThinkFunction(str)
	self.particle_think_function = nil
	if str == "brownian" then
		self.particle_think_function = brownian
	elseif str == "alpha_sin" then
		self.particle_think_function = alpha_sin
	elseif str == "inject_proxy" then
		self.particle_think_function = inject_proxy
	elseif str == "SpriteCard" then
		self.particle_think_function = spritecard
	elseif str == "SpriteCard2" then
		self.particle_think_function = spritecard2
	elseif str == "fading_inout_alpha" then
		self.particle_think_function = fading_inout_alpha
	end
	self.ThinkFunction = str
end

local half_turn = Angle(0,180,0)
local function NonZero(num)
	if num == 0 then return 0.01 else return num end
end

function PART:EmitParticles(pos, ang, real_ang)
	self.number_particles = self.number_particles or 0
	if self.FireOnce and not self.FirstShot then self.CanKeepFiring = false end
	local emt = self:GetEmitter()
	if not emt then return end

	if self.NextShot < pac.RealTime and self.CanKeepFiring then
		if self.Material == "" then return end
		if self.Velocity == 500.01 then return end

		local originalAng = ang
		local originalAng_norm_forward = originalAng:Forward():GetNormalized()
		local originalAng_norm_right = originalAng:Right():GetNormalized()
		local originalAng_norm_up = originalAng:Up():GetNormalized()
		ang = ang:Forward()

		local double = 1
		if self.DoubleSided then
			double = 2
		end

		local free_particles = math.max(max_active_particles:GetInt() - emt:GetNumActiveParticles(),0)
		local max = math.min(free_particles, max_emit_particles:GetInt())
		--self.number_particles is self.NumberParticles with optional decay applied
		local fractional_chance = 0
		if self.FractionalChance then
			--e.g. treat 0.5 as 50% chance to emit or not
			local delta = self.number_particles - math.floor(self.number_particles)
			if math.random() < delta then
				self.number_particles = self.number_particles + 1
			end
		end

		local mats = self.Material:Split(";")
		local use_random_mat = #mats > 1
		local original_pos = pos
		local frametime_val = FrameTime()
		local nonzero_vel = NonZero(self.Velocity)

		for _ = 1, math.min(self.number_particles,max) do
			local base_pos = original_pos
			if not self.LegacyPositionSpread then pos = original_pos end
			if use_random_mat then
				self.Materialm = pac.Material(table.Random(mats), self)
				self:CallRecursive("OnMaterialChanged")
			end
			local vec = Vector()
			local alt_vec_dir = nil
			local added_dir_rotation = Angle(0,0,0)

			if self.Spread ~= 0 then
				if self.SpreadType == "Legacy" or not self.SpreadType then
					vec = Vector(
						math.sin(math.Rand(0, 360)) * math.Rand(-self.Spread, self.Spread),
						math.cos(math.Rand(0, 360)) * math.Rand(-self.Spread, self.Spread),
						math.sin(math.random()) * math.Rand(-self.Spread, self.Spread)
					)
				end
			end
			if self.SpreadType and self.SpreadType ~= "Legacy" then
				if self.SpreadType == "Disc" then
					local angle = math.rad(math.Rand(self.MinAngle,self.MaxAngle))
					local depth_spread = math.Rand(-1,1)*math.tan(math.rad(self.SpreadAngle/2)) * math.max(self.SpreadVector.y,self.SpreadVector.z)
					alt_vec_dir = Vector(
						self.SpreadVector.x + depth_spread,
						self.SpreadVector.y*math.cos(angle),
						self.SpreadVector.z*math.sin(angle)
					)
					added_dir_rotation = AngleRand(-self.SpreadAngle / 4, self.SpreadAngle / 4)
				elseif self.SpreadType == "FlatCone" then
					local angle = math.rad(math.Rand(self.MinAngle,self.MaxAngle))
					local radius = math.random()
					alt_vec_dir = Vector(
						0,
						radius*self.SpreadVector.y*math.cos(angle),
						radius*self.SpreadVector.z*math.sin(angle)
					)
				elseif self.SpreadType == "SquareCone" then
					alt_vec_dir = Vector(
						math.Rand(-1,1)*self.SpreadVector.x,
						math.Rand(-1,1)*self.SpreadVector.y,
						math.Rand(-1,1)*self.SpreadVector.z
					)
				elseif self.SpreadType == "Cone" then
					alt_vec_dir = Vector(1,0,0)
					added_dir_rotation = AngleRand(-self.SpreadAngle / 2, self.SpreadAngle / 2)
				end
			end

			local r, g, b
			if self.RandomColor then
				if self.HSVMode then
					local col = HSVToColor(
						math.random(math.min(self.HSV1.x, self.HSV2.x), math.max(self.HSV1.x, self.HSV2.x)),
						math.random(math.min(self.HSV1.y, self.HSV2.y), math.max(self.HSV1.y, self.HSV2.y)),
						math.random(math.min(self.HSV1.z, self.HSV2.z), math.max(self.HSV1.z, self.HSV2.z))
					)
					r, g, b = col.r, col.g, col.b
				else
					r = math.random(math.min(self.Color1.r, self.Color2.r), math.max(self.Color1.r, self.Color2.r))
					g = math.random(math.min(self.Color1.g, self.Color2.g), math.max(self.Color1.g, self.Color2.g))
					b = math.random(math.min(self.Color1.b, self.Color2.b), math.max(self.Color1.b, self.Color2.b))
				end
			else
				if self.HSVMode then
					local col = HSVToColor(self.HSV1.x, self.HSV1.y, self.HSV1.z)
					r, g, b = col.r, col.g, col.b
				else
					r, g, b = self.Color1.r, self.Color1.g, self.Color1.b
				end
			end

			local roll = math.Rand(-self.RollDelta, self.RollDelta)

			local particle_pos = base_pos
			local spawn_owner = nil
			local target_part = nil
			if IsValid(self.TargetEntity) and self.TargetEntity ~= self then
				target_part = self.TargetEntity
			end

			if target_part then
				local ok, owner = pcall(target_part.GetOwner, target_part)
				if ok and IsValid(owner) then
					spawn_owner = owner
					if not owner:IsPlayer() and not owner:IsNPC() then
						local pos, ang = target_part:GetDrawPosition()
						if pos and ang then
							owner:SetPos(pos)
							owner:SetAngles(ang)
						end
					end
					owner:SetupBones()
				end
			end
			if not IsValid(spawn_owner) then
				local ok, self_owner = pcall(self.GetOwner, self)
				if ok and IsValid(self_owner) then
					spawn_owner = self_owner
				end
			end

			if self.SpawnOnBones then
				local bone_owner = spawn_owner
				if target_part and target_part.BoneMerge then
					local ok_parent, parent_owner = pcall(target_part.GetParentOwner, target_part)
					if ok_parent and IsValid(parent_owner) then
						bone_owner = parent_owner
					end
				end
				if IsValid(bone_owner) and bone_owner.GetBoneCount then
					local count = bone_owner:GetBoneCount()
					if count and count > 0 then
						local bone = math.random(0, count - 1)
						local bpos, bang = bone_owner:GetBonePosition(bone)
						if bpos and bpos ~= bone_owner:GetPos() then
							particle_pos = bpos
						elseif bpos then
							local matrix = bone_owner:GetBoneMatrix(bone)
							if matrix then
								particle_pos = matrix:GetTranslation()
							end
						end
					end
				end
			elseif self.SpawnOnMesh then
				if IsValid(spawn_owner) and spawn_owner:GetModel() then
					local mdl = spawn_owner:GetModel()
					if not pac.MeshTriangles then pac.MeshTriangles = {} end
					if not pac.MeshTriangles[mdl] then
						local meshes = util.GetModelMeshes(mdl)
						local tris = {}
						if meshes then
							for i = 1, #meshes do
								local m = meshes[i]
								if m.triangles then
									for i = 1, #m.triangles, 3 do
										if m.triangles[i] and m.triangles[i+1] and m.triangles[i+2] then
											table.insert(tris, {m.triangles[i].pos, m.triangles[i+1].pos, m.triangles[i+2].pos})
										end
									end
								end
							end
						end
						pac.MeshTriangles[mdl] = tris
					end
					local tris = pac.MeshTriangles[mdl]
					if tris and #tris > 0 then
						local tri = tris[math.random(1, #tris)]
						local r1, r2 = math.random(), math.random()
						if r1 + r2 > 1 then r1 = 1 - r1; r2 = 1 - r2 end
						local lpos = tri[1] + (tri[2] - tri[1]) * r1 + (tri[3] - tri[1]) * r2
						-- apply target part scale if applicable
						if target_part then
							local scale = target_part.Scale or Vector(1, 1, 1)
							local size = target_part.Size or 1
							lpos = lpos * (scale * size)
						end
						particle_pos = spawn_owner:LocalToWorld(lpos)
					end
				end
			end

			if self.PositionSpread ~= 0 then
				if self.PositionSpreadType == "SphereHollow" or not self.PositionSpreadType then
					particle_pos = particle_pos + Angle(math.Rand(-180, 180), math.Rand(-180, 180), math.Rand(-180, 180)):Forward() * self.PositionSpread
				elseif self.PositionSpreadType == "SphereFilled" then
					particle_pos = particle_pos + Angle(math.Rand(-180, 180), math.Rand(-180, 180), math.Rand(-180, 180)):Forward() * math.random() * self.PositionSpread
				elseif self.PositionSpreadType == "Box" then
					particle_pos = particle_pos + Vector(math.Rand(-self.PositionSpread, self.PositionSpread), math.Rand(-self.PositionSpread, self.PositionSpread), math.Rand(-self.PositionSpread, self.PositionSpread))
				end
			end
			if self.PositionSpreadType == "DiscFilled" then
				local angle = math.rad(math.Rand(self.MinAngle,self.MaxAngle))
				local right = originalAng_norm_right * self.PositionSpread2.y*math.cos(angle)*math.random()
				local up = originalAng_norm_up * self.PositionSpread2.z*math.sin(angle)*math.random()
				particle_pos = particle_pos + right + up + Angle(math.Rand(-180, 180), math.Rand(-180, 180), math.Rand(-180, 180)):Forward() * math.random() * self.PositionSpread
				particle_pos = particle_pos + Angle(math.Rand(-180, 180), math.Rand(-180, 180), math.Rand(-180, 180)):Forward() * math.random() * self.PositionSpread
			elseif self.PositionSpreadType == "DiscHollow" then
				local angle = math.rad(math.Rand(self.MinAngle,self.MaxAngle))
				local right = originalAng_norm_right * self.PositionSpread2.y*math.cos(angle)
				local up = originalAng_norm_up * self.PositionSpread2.z*math.sin(angle)
				particle_pos = particle_pos + right + up + Angle(math.Rand(-180, 180), math.Rand(-180, 180), math.Rand(-180, 180)):Forward() * math.random() * self.PositionSpread
			else
				if self.PositionSpread2 ~= vector_origin then
					local vecAdd = Vector(
						math.Rand(-self.PositionSpread2.x, self.PositionSpread2.x),
						math.Rand(-self.PositionSpread2.y, self.PositionSpread2.y),
						math.Rand(-self.PositionSpread2.z, self.PositionSpread2.z)
					)
					vecAdd:Rotate(originalAng)
					particle_pos = particle_pos + vecAdd
				end
			end
			if self.MeshParticle then
				local model_path = self.ParticleModel
				if model_path == "" and IsValid(spawn_owner) and spawn_owner:GetModel() then
					if target_part and target_part:GetOwner() ~= self:GetPlayerOwner() then
						model_path = spawn_owner:GetModel()
					end
				end
				if model_path ~= "" then
					self.MeshParticlesList = self.MeshParticlesList or {}
					if #self.MeshParticlesList < 100 then
						local ent_model = pac.CreateEntity(model_path)
						if IsValid(ent_model) then
							ent_model:SetNoDraw(true)
							ent_model:SetPos(particle_pos)

							if self.Additive then ent_model:SetRenderMode(RENDERMODE_TRANSADD)
							elseif self.Translucent or self.StartAlpha < 255 or self.EndAlpha < 255 then ent_model:SetRenderMode(RENDERMODE_TRANSALPHA)
							end

							if self.ZeroAngle then ent_model:SetAngles(Angle(0,0,0))
							else ent_model:SetAngles(ang:Angle() + self.ParticleAngle) end

							local spawn_vec = Vector(vec.x, vec.y, vec.z)
							if self.OwnerVelocityMultiplier ~= 0 then
								local root_owner = self:GetRootPart():GetOwner()
								if root_owner:IsValid() then spawn_vec = spawn_vec + (root_owner:GetVelocity() * self.OwnerVelocityMultiplier) end
							end

							local life = math.Clamp(self.DieTime, 0.0001, 50)
							if self.AddFrametimeLife then life = life + frametime_val end

							local cur_time = CurTime()
							self.MeshParticlesList[#self.MeshParticlesList + 1] = {
								ent = ent_model,
								pos = particle_pos,
								vel = (spawn_vec + ang) * self.Velocity,
								ang_vel = Angle(self.ParticleAngleVelocity.x, self.ParticleAngleVelocity.y, self.ParticleAngleVelocity.z),
								roll_speed = self.RandomRollSpeed * 36,
								roll_delta = self.RollDelta + roll,
								life = cur_time + life,
								start_time = cur_time,
								die_time = life,
								gravity = self.Gravity,
								bounce = self.Bounce,
								air_res = self.AirResistance,
								collide = self.Collide,
								sliding = self.Sliding,
								start_size = self.StartSize,
								end_size = self.EndSize,
								start_a = self.StartAlpha,
								end_a = self.EndAlpha,
								color1 = self.Color1,
								color2 = self.ColorRamp and self.Color2 or self.Color1
							}
						end
					end
				end
				continue
			end
			local ang_2d = Angle(math.rad(self.ParticleAngle.r),0,0)
			local angvel_2d = Angle(math.rad(self.ParticleAngleVelocity.z),0,0)
			for i = 1, double do
				local particle
				local material = self.Materialm or self.Material
				local basematerial = self.Materialm or self.Material
				if self.ThinkFunction == "SpriteCard2" then
					local matname = basematerial:GetName()
					local kvs = basematerial:GetKeyValues()
					if not expanded_mats_pool[matname] or self.FireOnce then
						expanded_mats_pool[matname] = {}
						local j = 1
						for _, v in pairs(kvs) do
							if isnumber(v) then
								if j == 1 then
									expanded_mats_pool[matname][1] = pac.Material(matname, self)
									j = j + 1
								end
							elseif type(v) == "ITexture" then
								expanded_mats_pool[matname][j] = CreateMaterial(matname .. tostring(j), "UnlitGeneric", {
									["$basetexture"] = v:GetName(),
									["$additive"] = self.Additive and 1 or 0,
									["$vertexcolor"] = 1,
									["$vertexalpha"] = 1
								})
								j = j + 1
							end
						end
					end
					particle = emt:Add(expanded_mats_pool[matname][1], particle_pos)
					particle.frame = 1
					particle.mat_name = matname
					particle.mat_series = expanded_mats_pool[matname]
				else
					material = basematerial
					particle = emt:Add(material, particle_pos)
				end

				if self.particle_think_function ~= nil and isfunction(self.particle_think_function) then
					particle:SetNextThink(CurTime())
					particle.thinktime = self.ThinkTime
					particle.birth = CurTime()
					particle.part = self
					particle.maxlife = self.DieTime
					particle:SetThinkFunction(self.particle_think_function)
					particle.material = material
				end

				if double == 2 then
					local ang_
					if i == 1 then
						ang_ = (ang * -1):Angle()
					elseif i == 2 then
						ang_ = ang:Angle()
					end
					particle:SetAngles(ang_)
				else
					particle:SetAngles(ang:Angle())
				end

				if self.FireDirectionToAngle or self.PositionSpreadToAngle then
					local angle
					if self.FireDirectionToAngle then
						local ang2 = ang:Angle()
						ang2:Rotate(added_dir_rotation)
						local consolidated_spread_ang = Angle(0,0,0)
						if alt_vec_dir then consolidated_spread_ang = alt_vec_dir:Angle() end
						angle = (ang2 + (consolidated_spread_ang + ang2) / nonzero_vel):Angle()
					elseif self.PositionSpreadToAngle then
						angle = (particle_pos - original_pos):Angle()
					end
					if self["3D"] then
						particle:SetAngles(angle)
					else
						particle:SetAngles(Angle(angle.r, 0, 0))
					end
				end

				if self.OwnerVelocityMultiplier ~= 0 then
					local owner = self:GetRootPart():GetOwner()
					if owner:IsValid() then
						vec = vec + (owner:GetVelocity() * self.OwnerVelocityMultiplier)
					end
				end

				local final_vec
				if alt_vec_dir then
					local consolidated_spread_ang = alt_vec_dir:Angle()
					local ang2 = ang:Angle()
					ang2:Rotate(added_dir_rotation)
					final_vec = (ang2 + (consolidated_spread_ang + ang2) / nonzero_vel)
					local velocity = nonzero_vel
					particle:SetVelocity((ang2 + (consolidated_spread_ang + ang2) / nonzero_vel) * velocity)
				else
					final_vec = (vec + ang)
					particle:SetVelocity(final_vec * self.Velocity)
				end

				particle:SetColor(r, g, b)

				if self.ColorRamp and not self.particle_think_function then
					local c1r, c1g, c1b = self.Color1.r, self.Color1.g, self.Color1.b
					local c2r, c2g, c2b = self.Color2.r, self.Color2.g, self.Color2.b
					particle:SetThinkFunction(function(p)
						local p_life = p:GetLifeTime()
						local p_die = p:GetDieTime()
						if p_die > 0 then
							local frac = math.Clamp(p_life / p_die, 0, 1)
							p:SetColor(Lerp(frac, c1r, c2r), Lerp(frac, c1g, c2g), Lerp(frac, c1b, c2b))
						end
						p:SetNextThink(CurTime())
					end)
					particle:SetNextThink(CurTime())
				end

				local life = math.Clamp(self.DieTime, 0.0001, 50)
				if self.AddFrametimeLife then
					life = life + frametime_val
				end
				particle:SetDieTime(life)

				particle:SetStartAlpha(self.StartAlpha)
				particle:SetEndAlpha(self.EndAlpha)
				particle:SetStartSize(self.StartSize)
				particle:SetEndSize(self.EndSize)
				particle:SetStartLength(self.StartLength)
				particle:SetEndLength(self.EndLength)

				if self.RandomRollSpeed ~= 0 then
					particle:SetRoll(self.RandomRollSpeed * 36)
				end

				if self.RollDelta ~= 0 then
					particle:SetRollDelta(self.RollDelta + roll)
				end

				particle:SetAirResistance(self.AirResistance)
				particle:SetBounce(self.Bounce)
				particle:SetGravity(self.Gravity)

				if not self.FireDirectionToAngle and not self.PositionSpreadToAngle then
					if self.ZeroAngle then particle:SetAngles(Angle(0,0,0))
					else particle:SetAngles(particle:GetAngles() + self.ParticleAngle) end
				end

				particle:SetLighting(self.Lighting)
				if self.RemoveOnCollide then
					particle:SetCollideCallback(RemoveCallback)
				end

				if not self.Follow then
					particle:SetCollide(self.Collide)
				end

				if self.Sliding then
					particle:SetCollideCallback(SlideCallback)
				end

				if self["3D"] then
					if not self.Sliding then
						if i == 1 and not self.StickToSurface then
							particle:SetCollideCallback(RemoveCallback)
						else
							if i == 1 then
								particle:SetCollideCallback(StickCallback)
							else
								particle.is_doubleside = true
								particle:SetCollideCallback(StickCallback)
							end
						end
					end

					particle:SetAngleVelocity(Angle(self.ParticleAngleVelocity.x, self.ParticleAngleVelocity.y, self.ParticleAngleVelocity.z))

					particle.ParticleAngle = self.ParticleAngle
					particle.Align = self.AlignToSurface
					particle.Stick = self.StickToSurface
					particle.StickLifeTime = self.StickLifetime
					particle.StickStartSize = self.StickStartSize
					particle.StickEndSize = self.StickEndSize
					particle.StickStartAlpha = self.StickStartAlpha
					particle.StickEndAlpha = self.StickEndAlpha
				end
			end
		end


		self.NextShot = pac.RealTime + self.FireDelay
	end
	self.FirstShot = false
end

BUILDER:Register()
