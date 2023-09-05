table.Merge( _LAMBDAPLAYERSWEAPONS, {
    mp2_mp5 = {
        model = "models/MP2TFoMP/Weapons/w_mp5.mdl",
        origin = "Max Payne 2",
        prettyname = "MP5",
        holdtype = "ar2",
        killicon = "weapon_mp2tfomp_mp5",
        bonemerge = true,
        islethal = true,
        dropentity = "ent_mp2tfomp_mp5",

        clip = 30,
        keepdistance = 750,
        attackrange = 1500,

        reloadtime = 2.2,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        reloadanimspeed = 1.0,
        reloadsounds = { { 0, "MP2TFoMP.MP5Reload" } },

        OnDeploy = function( self, wepent )
            LAMBDA_MP2:InitializeWeapon( self, wepent, "weapon_mp2tfomp_mp5" )

            wepent.MP2Data.Damage = 23
            wepent.MP2Data.Spread = 0.12
            wepent.MP2Data.Force = 2

            wepent.MP2Data.RateOfFire = 0.125
            wepent.MP2Data.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
            wepent.MP2Data.Sound = "MP2TFoMP.MP5Fire"

            LAMBDA_MP2:SetMuzzleName( wepent, "mp2_muzzleflash_mp5" )
            LAMBDA_MP2:SetMagazineData( wepent, "models/mp2tfomp/Weapons/w_mp5_mag.mdl", "MP2TFoMP.ClipRifleRicochet", 150 )
            LAMBDA_MP2:SetShellEject( wepent, "models/mp2tfomp/Projectiles/shell_mp5.mdl" )
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