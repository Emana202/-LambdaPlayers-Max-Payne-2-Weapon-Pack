local coroutine_wait = coroutine.wait
local random = math.random

table.Merge( _LAMBDAPLAYERSWEAPONS, {
    mp2_pumpshotgun = {
        model = "models/MP2TFoMP/Weapons/w_pumpshotgun.mdl",
        origin = "Max Payne 2",
        prettyname = "Pump-Action Shotgun",
        holdtype = "shotgun",
        killicon = "weapon_mp2tfomp_pumpshotgun",
        bonemerge = true,
        islethal = true,
        dropentity = "ent_mp2tfomp_pumpshotgun",

        clip = 7,
        keepdistance = 400,
        attackrange = 1000,

        reloadtime = 2.25,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        reloadanimspeed = 1.0,

        OnDeploy = function( self, wepent )
            LAMBDA_MP2:InitializeWeapon( self, wepent, "weapon_mp2tfomp_pumpshotgun" )

            wepent.MP2Data.Damage = 9
            wepent.MP2Data.Spread = 1.2
            wepent.MP2Data.Force = 10
            wepent.MP2Data.BulletModel = "models/mp2tfomp/Projectiles/bullet_shotgun.mdl"
            wepent.MP2Data.Pellets = 9
            wepent.MP2Data.IsShotgun = true
            wepent.MP2Data.Distance = 7874

            wepent.MP2Data.EjectShell = false
            wepent.MP2Data.RateOfFire = { 0.666, 1.0 }
            wepent.MP2Data.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN
            wepent.MP2Data.Sound = "MP2TFoMP.PumpShotgunFire"

            LAMBDA_MP2:SetMuzzleName( wepent, "mp2_muzzleflash_pump" )
            LAMBDA_MP2:SetShellEject( wepent, "models/mp2tfomp/Projectiles/shell_shotgun.mdl", "MP2TFoMP.ShellShotgunRicochet", "MP2TFoMP.ShellShotgunFreeze" )
        end,

        OnAttack = function( self, wepent, target )
            if LAMBDA_MP2:FireWeapon( self, wepent, target ) != true then
                self:SimpleWeaponTimer( 0.333, function()
                    wepent:EmitSound( "MP2TFoMP.PumpShotgunCock" )
                    LAMBDA_MP2:CreateShellEject( wepent )
                end )
            end

            return true
        end,

        OnReload = function( self, wepent )
            self:RemoveGesture( ACT_HL2MP_GESTURE_RELOAD_AR2 )
            local reloadLayer = self:AddGesture( ACT_HL2MP_GESTURE_RELOAD_AR2 )

            self:SetIsReloading( true )
            self:Thread( function()
                coroutine_wait( 0.133 )

                while ( self.l_Clip < self.l_MaxClip ) do
                    if !self:GetIsReloading() or self.l_Clip > 0 and self:InCombat() and self:IsInRange( self:GetEnemy(), 512 ) and random( 2 ) == 1 and self:CanSee( self:GetEnemy() ) then break end 

                    if !self:IsValidLayer( reloadLayer ) then
                        reloadLayer = self:AddGesture( ACT_HL2MP_GESTURE_RELOAD_AR2 )
                    end                    
                    self:SetLayerCycle( reloadLayer, 0.33 )
                    self:SetLayerPlaybackRate( reloadLayer, 1.8 )

                    self.l_Clip = self.l_Clip + 1
                    wepent:EmitSound( "MP2TFoMP.PumpShotgunReload" )
                    coroutine_wait( 0.3 )
                end

                self:RemoveGesture( ACT_HL2MP_GESTURE_RELOAD_AR2 )
                self:SetIsReloading( false )
            end, "MP2_ShotgunReload" )

            return true
        end
    }
} )