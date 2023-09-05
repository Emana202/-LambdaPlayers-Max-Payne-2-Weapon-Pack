table.Merge( _LAMBDAPLAYERSWEAPONS, {
    mp2_coltcommando = {
        model = "models/MP2TFoMP/Weapons/w_coltcommando.mdl",
        origin = "Max Payne 2",
        prettyname = "M4 Carbine",
        holdtype = "ar2",
        killicon = "weapon_mp2tfomp_coltcommando",
        bonemerge = true,
        islethal = true,
        dropentity = "ent_mp2tfomp_coltcommando",

        clip = 30,
        keepdistance = 750,
        attackrange = 1500,

        reloadtime = 2.2,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        reloadanimspeed = 1.0,
        reloadsounds = { { 0, "MP2TFoMP.ColtCommandoReload" } },

        OnDeploy = function( self, wepent )
            LAMBDA_MP2:InitializeWeapon( self, wepent, "weapon_mp2tfomp_coltcommando" )

            wepent.MP2Data.Damage = 29
            wepent.MP2Data.Spread = 0.039
            wepent.MP2Data.Force = 5
            wepent.MP2Data.BulletModel = "models/mp2tfomp/Projectiles/bullet_rifle.mdl"

            wepent.MP2Data.RateOfFire = 0.166
            wepent.MP2Data.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
            wepent.MP2Data.Sound = "MP2TFoMP.ColtCommandoFire"

            LAMBDA_MP2:SetMuzzleName( wepent, "mp2_muzzleflash_colt" )
            LAMBDA_MP2:SetMagazineData( wepent, "models/mp2tfomp/Weapons/w_coltcommando_mag.mdl", "MP2TFoMP.ClipRifleRicochet", 100 )
            LAMBDA_MP2:SetShellEject( wepent, "models/mp2tfomp/Projectiles/shell_coltcommando.mdl", "MP2TFoMP.ShellRifleRicochet", "MP2TFoMP.ShellRifleFreeze" )
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