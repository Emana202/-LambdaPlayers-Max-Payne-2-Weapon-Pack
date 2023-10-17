local IsValid = IsValid
local net = net
local EffectData = EffectData
local util_Effect = util.Effect
local PrecacheModel = util.PrecacheModel

LAMBDA_MP2 = LAMBDA_MP2 or { PrecachedMdls = {} }

if ( CLIENT ) then

	net.Receive( "lambda_mp2_setmuzzlename", function()
		local weapon = net.ReadEntity()
		if IsValid( weapon ) then weapon.MuzzleName = net.ReadString() end
	end )

	net.Receive( "lambda_mp2_setshelldata", function()
		local weapon = net.ReadEntity()
		if !IsValid( weapon ) then return end

		local shellMdl = net.ReadString()
		if !LAMBDA_MP2.PrecachedMdls[ shellMdl ] then
			PrecacheModel( shellMdl )
			LAMBDA_MP2.PrecachedMdls[ shellMdl ] = true
		end

		weapon.shellmodel = shellMdl
		weapon.shellcollidesound = net.ReadString()
		weapon.shellfreezesound = net.ReadString()
	end )
	
	net.Receive( "lambda_mp2_setmagazinedata", function()
		local weapon = net.ReadEntity()
		if !IsValid( weapon ) then return end

		local magMdl = net.ReadString()
		if !LAMBDA_MP2.PrecachedMdls[ magMdl ] then
			PrecacheModel( magMdl )
			LAMBDA_MP2.PrecachedMdls[ magMdl ] = true
		end

		weapon.magazinemodel = magMdl
		weapon.magazinecollidesound = net.ReadString()
		weapon.magazinefreezesound = weapon.magazinecollidesound
		weapon.MagazineVel = net.ReadFloat()
	end )

	net.Receive( "lambda_mp2_createmuzzleflash", function()
		local weapon = net.ReadEntity()
		if !IsValid( weapon ) or weapon:IsDormant() or !weapon:GetAttachment( 1 ) then return end
		
		local effectData = EffectData()
		effectData:SetEntity( weapon )
		effectData:SetAttachment( net.ReadUInt( 3 ) )			
		util_Effect( "mp2tfomp_muzzle", effectData, true, true ) 
	end )

	local function GetWeaponSmokeBlastParticle( weapon )
		local lambda = weapon:GetParent()
		if IsValid( lambda ) and lambda.GetWeaponName then
			local wepData = _LAMBDAPLAYERSWEAPONS[ lambda:GetWeaponName() ]
			if wepData and wepData.origin == "Max Payne 1" then return "mp1_smokeblast_eject" end
		end
		return "mp2_smokeblast_eject"
	end

	local function GetWeaponMuzzleFlashPos( weapon, muzzleAttach )
		local attach = weapon:GetAttachment( muzzleAttach )
		return ( attach and attach.Pos or weapon:GetPos() )
	end

	local function OnLambdaInitialize( lambda, weapon )
		if !IsValid( weapon ) then return end

		weapon.MuzzleName = "mp2_muzzleflash_beretta"
		weapon.BulletSize = 1
		weapon.GetSmokeBlastParticle = GetWeaponSmokeBlastParticle
		weapon.GetMuzzleFlashPos = GetWeaponMuzzleFlashPos
	end

	hook.Add( "LambdaOnInitialize", "Lambda_MP2_OnLambdaInitialize", OnLambdaInitialize )

end

if ( SERVER ) then

	local random = math.random
	local Rand = math.Rand
	local ents_Create = ents.Create
	local sound_Play = sound.Play
	local IsFirstTimePredicted = IsFirstTimePredicted
	local isvector = isvector
	local isentity = isentity
	local CurTime = CurTime
	local Vector = Vector
	local GetConVar = GetConVar
	local weapons_Get = weapons.Get
	local IsSinglePlayer = game.SinglePlayer

	local damageMult, fireProjectiles, projVelMult, infiniteAmmo
	local fireBulletTbl = { Tracer = 0 }

	util.AddNetworkString( "lambda_mp2_setmuzzlename" )
	util.AddNetworkString( "lambda_mp2_setshelldata" )
	util.AddNetworkString( "lambda_mp2_setmagazinedata" )
	util.AddNetworkString( "lambda_mp2_createmuzzleflash" )

	function LAMBDA_MP2:SetMuzzleName( weapon, name )
		name = name or "mp2_muzzleflash_beretta"

		net.Start( "lambda_mp2_setmuzzlename" )
			net.WriteEntity( weapon )
			net.WriteString( name )
		net.Broadcast()
	end

	function LAMBDA_MP2:SetShellEject( weapon, model, collideSnd, freezeSnd )
		model = model or "models/mp2tfomp/Projectiles/shell_9mm.mdl"
		collideSnd = collideSnd or "MP2TFoMP.Shell9mmRicochet"
		freezeSnd = freezeSnd or "MP2TFoMP.Shell9mmFreeze"

		if !LAMBDA_MP2.PrecachedMdls[ model ] then
			PrecacheModel( model )
			LAMBDA_MP2.PrecachedMdls[ model ] = true
		end

		net.Start( "lambda_mp2_setshelldata" )
			net.WriteEntity( weapon )
			net.WriteString( model )
			net.WriteString( collideSnd )
			net.WriteString( freezeSnd )
		net.Broadcast()
	end

	function LAMBDA_MP2:SetMagazineData( weapon, model, collideSnd, vel )
		model = model or "models/mp2tfomp/Weapons/w_beretta_mag.mdl"
		collideSnd = collideSnd or "MP2TFoMP.ClipPistolRicochet"
		vel = vel or 200

		if !LAMBDA_MP2.PrecachedMdls[ model ] then
			PrecacheModel( model )
			LAMBDA_MP2.PrecachedMdls[ model ] = true
		end

		net.Start( "lambda_mp2_setmagazinedata" )
			net.WriteEntity( weapon )
			net.WriteString( model )
			net.WriteString( collideSnd )
			net.WriteFloat( vel )
		net.Broadcast()
	end

	function LAMBDA_MP2:CreateShellEject( weapon, attach )
		MP_ClientsideUtilEffect( "mp2tfomp_shell", ( attach or weapon.MP2Data.ShellAttachment or 2 ), weapon, weapon:GetPos(), nil, nil )
	end

	function LAMBDA_MP2:DropMagazine( weapon, attach )
		MP_ClientsideUtilEffect( "mp2tfomp_magazine", ( attach or 3 ), weapon, weapon:GetPos(), nil, nil )
	end

	local function LambdaGetActiveWeapon( lambda )
		return lambda.WeaponEnt
	end
	local function NullFunction() end

	local function WeaponFireCallBack( weapon, attacker, tr, dmginfo, phys_bullet_ent )
		if !IsValid( attacker ) then return end

		local hitEnt = tr.Entity
		if !IsValid( hitEnt ) then return end

		dmginfo:SetAttacker( attacker )
		dmginfo:SetInflictor( phys_bullet_ent or weapon )

		if weapon.MP2Data.IsShotgun and ( hitEnt:IsPlayer() or hitEnt:IsRagdoll() ) then 
			dmginfo:SetDamageForce( dmginfo:GetDamageForce() / 6 ) 
		end	

		local class = hitEnt:GetClass()
		if class == "npc_rollermine" or class == "npc_turret_floor" or class == "npc_manhack" then 
			dmginfo:SetDamageType( DMG_PREVENT_PHYSICS_FORCE ) 
		end
		
		if hitEnt:IsNPC() or hitEnt:IsPlayer() then 
			dmginfo:SetDamageForce( dmginfo:GetDamageForce() + vector_up * ( weapon.MP2Data.Force * 575 ) )
		end
	end
	local WeaponFireCallBackImpact = {
		default = function( weapon, attacker, tr, dmginfo, muzzleAttach )
			net.Start( "MPX_ShootBulletDefault" )
				net.WriteEntity( weapon )
				net.WriteVector( tr.StartPos )
				net.WriteVector( tr.HitPos )
				net.WriteUInt( muzzleAttach, 4 )
			net.Broadcast()							

			local impact_sound = mp2_lib.hit_sound[tr.MatType]
			if impact_sound and !tr.HitSky then sound_Play( impact_sound, tr.HitPos ) end	
		end,
		physics = function( weapon, attacker, tr, dmginfo )
			local sound = mp2_lib.hit_sound[ tr.MatType ]
			if sound and !tr.HitSky then weapon:EmitSound( sound ) end	
		end
	}

	function LAMBDA_MP2:InitializeWeapon( lambda, weapon, class )
		weapon.MP2Data = {}
		weapon.MP2Data.StoredClass = class
		weapon.MP2Data.StoredTable = weapons_Get( class )
		weapon.MP2Data.DoImpactEffect = weapon.MP2Data.StoredTable.DoImpactEffect

		lambda.GetActiveWeapon = LambdaGetActiveWeapon
		weapon.SetClip1 = NullFunction
		weapon.FireCallBack = WeaponFireCallBack
		weapon.FireCallBackImpact = WeaponFireCallBackImpact
	end

	local function OnBulletDoImpactEffect( bullet, ... )
		if !bullet.l_Lambdified or !IsValid( bullet.entOwner ) then return end
		return bullet.wp_DoImpactEffect( bullet.wp_stored, ... ) 
	end

	function LAMBDA_MP2:FireWeapon( lambda, weapon, target, noDelay, noSnd )
	    if lambda.l_Clip <= 0 then lambda:ReloadWeapon() return true end
	    local mp2Data = weapon.MP2Data

	    infiniteAmmo = infiniteAmmo or GetConVar( "mp2_infinite_ammo" )
	    if infiniteAmmo:GetInt() != 2 then lambda.l_Clip = lambda.l_Clip - ( mp2Data.ClipUsage or 1 ) end

	    if !noDelay then
		    local fireDelay = mp2Data.RateOfFire
		    lambda.l_WeaponUseCooldown = CurTime() + ( istable( fireDelay ) and Rand( fireDelay[ 1 ], fireDelay[ 2 ] ) or fireDelay or 0.1 )
		end

	    local fireAnim = mp2Data.Animation
	    if fireAnim then lambda:RemoveGesture( fireAnim ); lambda:AddGesture( fireAnim ) end

	    if !noSnd then
		    local fireSnd = mp2Data.Sound
		    if fireSnd then weapon:EmitSound( fireSnd ) end
		end

		local shootPos = weapon:GetPos()
	    local firePos = ( isvector( target ) and target or ( ( isentity( target ) and IsValid( target ) ) and target:WorldSpaceCenter() or nil ) )
	    if !firePos then firePos = ( shootPos + lambda:GetForward() * 8197 ) end

		local aimVec = ( firePos - shootPos ):Angle()
		local targPos = firePos + aimVec:Up() * random( -25, 25 ) + aimVec:Right() * random( -25, 25 )
		aimVec = ( targPos - shootPos ):Angle()

		local muzzleAttach = ( mp2Data.MuzzleAttachment or 1 )
		net.Start( "lambda_mp2_createmuzzleflash" )
			net.WriteEntity( weapon )
			net.WriteUInt( muzzleAttach, 3 )
		net.Broadcast()

		if mp2Data.EjectShell != false then 
			LAMBDA_MP2:CreateShellEject( weapon ) 
		end

		damageMult = damageMult or GetConVar( "mp2_damage_mul" )
		local dmg_mul = damageMult:GetFloat()

		local spread = mp2Data.Spread
		local numShots = ( mp2Data.Pellets or 1 )
		local dmg = mp2Data.Damage
		local force = mp2Data.Force

		fireProjectiles = fireProjectiles or GetConVar( "mp2_projectiles" )
		if fireProjectiles:GetBool() then
			local mul = ( mp2Data.BulletSpeedScale or 0.5 )
			local bulletVel = ( mp2Data.BulletVelocity or 5905.5 )
			local model = ( mp2Data.BulletModel or "models/mp2tfomp/Projectiles/bullet_beretta.mdl" )

			projVelMult = projVelMult or GetConVar( "mp2_prj_vel_mul" )
			local velMult = projVelMult:GetFloat()

			if isentity( target ) and IsValid( target ) then
				local targVel = ( target:IsNextBot() and target.loco:GetVelocity() or target:GetVelocity() )
				aimVec = ( ( targPos + targVel * ( ( targPos:Distance(shootPos) / bulletVel ) * Rand( 0.33, 1.0 ) ) ) - shootPos ):Angle()
			end

			for i = 1, numShots do 
				local bullet = ents_Create( "ent_mp2tfomp_bullet_easy" )
				local spread = ( ( spread * 5 ) / ( random( 1, 100 ) > 75 and 1 or 2 ) )
				local vel = ( ( bulletVel + ( bulletVel / 100 ) * random( -mul, mul ) ) * velMult )

				bullet.data = {
					model = model,
					vel = vel,
					force = force,
					damage = ( dmg * dmg_mul ),
					spread = spread,
					bullcam = false,
					owner = lambda
				}
				
				local ang = aimVec
				if !mp2Data.IsShotgun or i != numShots then
					ang:RotateAroundAxis( ang:Forward(), Rand( -spread, spread ) )
					ang:RotateAroundAxis( ang:Right(), Rand( -spread, spread ) )
					ang:RotateAroundAxis( ang:Up(), Rand( -spread, spread ) )
				end

				bullet.ForwardDir = ang:Forward() 
				bullet.DistanceLimit = ( mp2Data.Distance or 0 )
				bullet.muzzleAttach = muzzleAttach
				bullet.DoImpactEffect = OnBulletDoImpactEffect

				bullet:SetAngles( ang )
				bullet:SetPos( shootPos )
				bullet:Spawn()
				bullet:Activate() 
				
				bullet.l_Lambdified = true
            	bullet.l_UseLambdaDmgModifier = true
            	bullet.l_killiconname = mp2Data.StoredClass

				bullet.swep = nil
				bullet.swep_recovery_class = weapon.MP2Data.StoredTable
				bullet.wp_DoImpactEffect = mp2Data.DoImpactEffect
				bullet.wp_stored_class = mp2Data.StoredClass
				bullet.wp_stored = mp2Data.StoredTable
				bullet.wp = weapon
			end
		else
			fireBulletTbl.Attacker = lambda
			fireBulletTbl.IgnoreEntity = lambda
			fireBulletTbl.Damage = ( mp2Data.Damage * dmg_mul )
			fireBulletTbl.Force = ( mp2Data.Force or 1 )
			fireBulletTbl.Dir = aimVec:Forward()
			fireBulletTbl.Src = shootPos
			fireBulletTbl.Callback = function( attacker, tr, dmginfo )
				weapon:FireCallBack( attacker, tr, dmginfo )			
				weapon.FireCallBackImpact.default( weapon, attacker, tr, damageInfo, muzzleAttach )
			end

			for i = 1, numShots do 
				local newSpread = ( ( spread * 0.1 ) / ( random( 1, 100 ) > 75 and 1 or 2 ) )
				fireBulletTbl.Spread = Vector( newSpread, newSpread, 0 )
				weapon:FireBullets( fireBulletTbl )
			end
		end
	end

end