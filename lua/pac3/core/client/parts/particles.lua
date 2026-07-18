local cam_IgnoreZ = cam.IgnoreZ
local vector_origin = vector_origin
local FrameTime = FrameTime
local angle_origin = Angle(0,0,0)
local WorldToLocal = WorldToLocal

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
		BUILDER:GetSet("PositionSpread", 0)
		BUILDER:GetSet("PositionSpread2", Vector(0,0,0))
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
		BUILDER:GetSet("SpawnOnMesh", false, {description = "Spawns particles across the triangles/faces of the owner's model. This works based on the default model's resting pose (so, the T-pose); it won't follow any animations."})
		BUILDER:GetSet("SpawnOnBones", false, {description = "Randomly distributes particles across the owner's animated bones/hitboxes. Functionally, this is an alternative for spawning particles on a mesh, but it inherently sacrifices control."})
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
		BUILDER:GetSet("ParticleAngleVelocity", Vector(50, 50, 50))
	BUILDER:SetPropertyGroup("orientation")
	BUILDER:SetPropertyGroup("movement")
		BUILDER:GetSet("Velocity", 250)
		BUILDER:GetSet("Spread", 0.1)
		BUILDER:GetSet("AirResistance", 5)
		BUILDER:GetSet("Bounce", 5)
		BUILDER:GetSet("Gravity", Vector(0,0, -50))
		BUILDER:GetSet("Collide", true)
		BUILDER:GetSet("Sliding", true)
		--BUILDER:GetSet("AddVelocityFromOwner", false)
		BUILDER:GetSet("OwnerVelocityMultiplier", 0)




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
		for i = #self.MeshParticlesList, 1, -1 do
			local p = self.MeshParticlesList[i]
			if CurTime() > p.life or not IsValid(p.ent) then
				if IsValid(p.ent) then SafeRemoveEntity(p.ent) end
				table.remove(self.MeshParticlesList, i)
			else
				local frac = math.Clamp(1 - ((p.life - CurTime()) / p.die_time), 0, 1)
				p.vel = p.vel + (p.gravity * frametime_val)
				if p.air_res > 0 then p.vel = p.vel - (p.vel * p.air_res * frametime_val) end

				local oldpos = p.ent:GetPos()
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
				p.ent:SetPos(newpos)

				local c1r, c1g, c1b = p.color1.r, p.color1.g, p.color1.b
				local c2r, c2g, c2b = p.color2.r, p.color2.g, p.color2.b
				p.ent:SetColor(Color(Lerp(frac, c1r, c2r), Lerp(frac, c1g, c2g), Lerp(frac, c1b, c2b)))

				local size = math.max(Lerp(frac, p.start_size, p.end_size) / 20, 0.001)
				local mat = Matrix()
				mat:Scale(Vector(size, size, size))
				p.ent:EnableMatrix("RenderMultiply", mat)

				if self.Follow then
					cam.Start3D(WorldToLocal(EyePos(), EyeAngles(), pos, ang))
					if self.IgnoreZ then cam.IgnoreZ(true) end
					p.ent:DrawModel()
					if self.IgnoreZ then cam.IgnoreZ(false) end
					cam.End3D()
				else
					p.ent:DrawModel()
				end
			end
		end
	end

	self:EmitParticles(self.Follow and vector_origin or pos, self.Follow and angle_origin or ang, ang)
end
function PART:OnRemove()
	if self.MeshParticlesList then
		for i = 1, #self.MeshParticlesList do
			local p = self.MeshParticlesList[i]
			if IsValid(p.ent) then SafeRemoveEntity(p.ent) end
		end
		self.MeshParticlesList = nil
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

function PART:EmitParticles(pos, ang, real_ang)
	self.number_particles = self.number_particles or 0
	if self.FireOnce and not self.FirstShot then self.CanKeepFiring = false end
	local emt = self:GetEmitter()
	if not emt then return end

	if self.NextShot < pac.RealTime and self.CanKeepFiring then
		if self.Material == "" then return end
		if self.Velocity == 500.01 then return end

		local originalAng = ang
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
		local base_pos = pos
		local frametime_val = FrameTime()

		for _ = 1, math.min(self.number_particles,max) do
			if use_random_mat then
				self.Materialm = pac.Material(table.Random(mats), self)
				self:CallRecursive("OnMaterialChanged")
			end
			local vec = Vector()

			if self.Spread ~= 0 then
				vec = Vector(
					math.sin(math.Rand(0, 360)) * math.Rand(-self.Spread, self.Spread),
					math.cos(math.Rand(0, 360)) * math.Rand(-self.Spread, self.Spread),
					math.sin(math.random()) * math.Rand(-self.Spread, self.Spread)
				)
			end

			local r, g, b
			if self.RandomColor then
				r = math.random(math.min(self.Color1.r, self.Color2.r), math.max(self.Color1.r, self.Color2.r))
				g = math.random(math.min(self.Color1.g, self.Color2.g), math.max(self.Color1.g, self.Color2.g))
				b = math.random(math.min(self.Color1.b, self.Color2.b), math.max(self.Color1.b, self.Color2.b))
			else
				r, g, b = self.Color1.r, self.Color1.g, self.Color1.b
			end

			local roll = math.Rand(-self.RollDelta, self.RollDelta)
			local particle_pos = base_pos
			if self.SpawnOnBones then
				local owner = self:GetOwner()
				if IsValid(owner) and owner.GetBoneCount then
					local count = owner:GetBoneCount()
					if count and count > 0 then
						local bone = math.random(0, count - 1)
						local bpos = owner:GetBonePosition(bone)
						if bpos then particle_pos = bpos end
					end
				end
			elseif self.SpawnOnMesh then
				local owner = self:GetOwner()
				if IsValid(owner) and owner:GetModel() then
					local mdl = owner:GetModel()
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
						particle_pos = owner:LocalToWorld(lpos)
					end
				end
			end

			if self.PositionSpread ~= 0 then
				particle_pos = particle_pos + Angle(math.Rand(-180, 180), math.Rand(-180, 180), math.Rand(-180, 180)):Forward() * self.PositionSpread
			end

			if self.PositionSpread2 ~= vector_origin then
				local vecAdd = Vector(
					math.Rand(-self.PositionSpread2.x, self.PositionSpread2.x),
					math.Rand(-self.PositionSpread2.y, self.PositionSpread2.y),
					math.Rand(-self.PositionSpread2.z, self.PositionSpread2.z)
				)
				vecAdd:Rotate(originalAng)
				particle_pos = particle_pos + vecAdd
			end
			if self.MeshParticle and self.ParticleModel ~= "" then
				self.MeshParticlesList = self.MeshParticlesList or {}
				if #self.MeshParticlesList < 100 then
					local ent_model = ClientsideModel(self.ParticleModel)
					if IsValid(ent_model) then
						ent_model:SetNoDraw(true)
						ent_model:SetPos(particle_pos)
						ent_model:SetAngles(ang:Angle())

						local life = math.Clamp(self.DieTime, 0.0001, 50)
						if self.AddFrametimeLife then life = life + frametime_val end

						table.insert(self.MeshParticlesList, {
							ent = ent_model,
							vel = (vec + ang) * self.Velocity,
							life = CurTime() + life,
							start_time = CurTime(),
							die_time = life,
							gravity = self.Gravity,
							bounce = self.Bounce,
							air_res = self.AirResistance,
							collide = self.Collide,
							sliding = self.Sliding,
							start_size = self.StartSize,
							end_size = self.EndSize,
							color1 = self.Color1,
							color2 = self.ColorRamp and self.Color2 or self.Color1
						})
					end
				end
				continue
			end
			for i = 1, double do
				local particle = emt:Add(self.Materialm or self.Material, particle_pos)

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

				if self.OwnerVelocityMultiplier ~= 0 then
					local owner = self:GetRootPart():GetOwner()
					if owner:IsValid() then
						vec = vec + (owner:GetVelocity() * self.OwnerVelocityMultiplier)
					end
				end

				particle:SetVelocity((vec + ang) * self.Velocity)
				particle:SetColor(r, g, b)
				if self.ColorRamp then
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
				if self.ZeroAngle then particle:SetAngles(Angle(0,0,0))
				else particle:SetAngles(particle:GetAngles() + self.ParticleAngle) end
				particle:SetLighting(self.Lighting)

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
