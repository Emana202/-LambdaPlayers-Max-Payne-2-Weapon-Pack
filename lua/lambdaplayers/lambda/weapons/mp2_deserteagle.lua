table.Merge( _LAMBDAPLAYERSWEAPONS, {
    mp2_deserteagle = {
        model = "models/MP2TFoMP/Weapons/w_deserteagle.mdl",
        origin = "Max Payne 2",
        prettyname = "Desert Eagle",
        holdtype = "revolver",
        killicon = "weapon_mp2tfomp_deserteagle",
        bonemerge = true,
        islethal = true,
        dropentity = "ent_mp2tfomp_deserteagle",

        clip = 10,
        keepdistance = 750,
        attackrange = 1500,

        reloadtime = 2.0,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        reloadanimspeed = 0.7,
        reloadsounds = { { 0, "MP2TFoMP.DesertEagleReload" } },

        OnDeploy = function( self, wepent )
            LAMBDA_MP2:InitializeWeapon( self, wepent, "weapon_mp2tfomp_deserteagle" )

            wepent.MP2Data.Damage = 41
            wepent.MP2Data.Spread = 0.075
            wepent.MP2Data.Force = 6

            wepent.MP2Data.RateOfFire = 0.333
            wepent.MP2Data.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER
            wepent.MP2Data.Sound = "MP2TFoMP.DesertEagleFire"

            LAMBDA_MP2:SetMuzzleName( wepent, "mp2_muzzleflash_deagle" )
            LAMBDA_MP2:SetMagazineData( wepent, "models/mp2tfomp/Weapons/w_deserteagle_mag.mdl" )
            LAMBDA_MP2:SetShellEject( wepent, "models/mp2tfomp/Projectiles/shell_deserteagle.mdl", "MP2TFoMP.ShellDesertEagleRicochet", "MP2TFoMP.ShellDesertEagleFreeze" )
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