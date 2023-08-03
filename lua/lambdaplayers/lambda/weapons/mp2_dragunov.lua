table.Merge( _LAMBDAPLAYERSWEAPONS, {
    mp2_dragunov = {
        model = "models/MP2TFoMP/Weapons/w_dragunov.mdl",
        origin = "Max Payne 2",
        prettyname = "Dragunov",
        holdtype = "ar2",
        killicon = "weapon_mp2tfomp_dragunov",
        bonemerge = true,
        islethal = true,
        dropentity = "ent_mp2tfomp_dragunov",

        clip = 10,
        keepdistance = 1500,
        attackrange = 3000,

        reloadtime = 2.2,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        reloadanimspeed = 1.0,
        reloadsounds = { { 0, "MP2TFoMP.KalashnikovReload" } },

        OnDeploy = function( self, wepent )
            LAMBDA_MP2:InitializeWeapon( self, wepent, "weapon_mp2tfomp_dragunov" )

            wepent.MP2Data.Damage = 66
            wepent.MP2Data.Spread = 0.075
            wepent.MP2Data.Force = 9
            wepent.MP2Data.BulletModel = "models/mp2tfomp/Projectiles/bullet_sniper.mdl"
            wepent.MP2Data.BulletVelocity = 10000

            wepent.MP2Data.RateOfFire = { 1.0, 2.0 }
            wepent.MP2Data.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
            wepent.MP2Data.Sound = "MP2TFoMP.DragunovFire"
            wepent.MP2Data.EjectShell = false

            LAMBDA_MP2:SetMuzzleName( wepent, "mp2_muzzleflash_dragunov" )
            LAMBDA_MP2:SetMagazineData( wepent, "models/mp2tfomp/Weapons/w_dragunov_mag.mdl", "MP2TFoMP.ClipRifleRicochet", 100 )
            LAMBDA_MP2:SetShellEject( wepent, "models/mp2tfomp/Projectiles/shell_dragunov.mdl", "MP2TFoMP.ShellRifleRicochet", "MP2TFoMP.ShellRifleFreeze" )
        end,

        OnReload = function( self, wepent )
            LAMBDA_MP2:DropMagazine( wepent )
        end,

        OnAttack = function( self, wepent, target )
            LAMBDA_MP2:FireWeapon( self, wepent, target )
            return true
        end
    }
} )