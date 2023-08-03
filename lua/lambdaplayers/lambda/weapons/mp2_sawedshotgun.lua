table.Merge( _LAMBDAPLAYERSWEAPONS, {
    mp2_sawedshotgun = {
        model = "models/MP2TFoMP/Weapons/w_sawedshotgun.mdl",
        origin = "Max Payne 2",
        prettyname = "Sawed-Off Shotgun",
        holdtype = "pistol",
        killicon = "weapon_mp2tfomp_sawedshotgun",
        bonemerge = true,
        islethal = true,
        dropentity = "ent_mp2tfomp_sawedshotgun",

        clip = 2,
        keepdistance = 500,
        attackrange = 1000,

        reloadtime = 1.6,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        reloadanimspeed = 1.66,
        reloadsounds = { { 0, "MP2TFoMP.SawedShotgunReload" } },

        OnDeploy = function( self, wepent )
            LAMBDA_MP2:InitializeWeapon( self, wepent, "weapon_mp2tfomp_sawedshotgun" )

            wepent.MP2Data.Damage = 9
            wepent.MP2Data.Spread = 1.75
            wepent.MP2Data.Force = 15
            wepent.MP2Data.BulletModel = "models/mp2tfomp/Projectiles/bullet_shotgun.mdl"
            wepent.MP2Data.Pellets = 9
            wepent.MP2Data.IsShotgun = true
            wepent.MP2Data.Distance = 7874

            wepent.MP2Data.EjectShell = false
            wepent.MP2Data.RateOfFire = { 0.25, 0.5 }
            wepent.MP2Data.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL
            wepent.MP2Data.Sound = "MP2TFoMP.SawedShotgunFire"

            LAMBDA_MP2:SetMuzzleName( wepent, "mp2_muzzleflash_sawed" )
            LAMBDA_MP2:SetShellEject( wepent, "models/mp2tfomp/Projectiles/shell_shotgun.mdl", "MP2TFoMP.ShellShotgunRicochet", "MP2TFoMP.ShellShotgunFreeze" )
        end,

        OnReload = function( self, wepent )
            self:SimpleWeaponTimer( 0.25, function()
                LAMBDA_MP2:CreateShellEject( wepent )
                if self.l_Clip == 0 then LAMBDA_MP2:CreateShellEject( wepent ) end
            end )
        end,

        OnAttack = function( self, wepent, target )
            LAMBDA_MP2:FireWeapon( self, wepent, target )
            return true
        end
    }
} )