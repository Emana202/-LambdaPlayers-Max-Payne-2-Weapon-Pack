table.Merge( _LAMBDAPLAYERSWEAPONS, {
    mp2_striker = {
        model = "models/MP2TFoMP/Weapons/w_striker.mdl",
        origin = "Max Payne 2",
        prettyname = "Striker",
        holdtype = "smg",
        killicon = "weapon_mp2tfomp_striker",
        bonemerge = true,
        islethal = true,
        dropentity = "ent_mp2tfomp_striker",

        clip = 10,
        keepdistance = 400,
        attackrange = 1000,

        reloadtime = 2.2,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        reloadanimspeed = 1,
        reloadsounds = { { 0, "MP2TFoMP.StrikerReload" } },

        OnDeploy = function( self, wepent )
            LAMBDA_MP2:InitializeWeapon( self, wepent, "weapon_mp2tfomp_striker" )

            wepent.MP2Data.Damage = 9
            wepent.MP2Data.Spread = 1.35
            wepent.MP2Data.Force = 12
            wepent.MP2Data.BulletModel = "models/mp2tfomp/Projectiles/bullet_shotgun.mdl"
            wepent.MP2Data.Pellets = 9
            wepent.MP2Data.IsShotgun = true

            wepent.MP2Data.RateOfFire = { 0.333, 0.5 }
            wepent.MP2Data.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
            wepent.MP2Data.Sound = "MP2TFoMP.StrikerFire"

            LAMBDA_MP2:SetMuzzleName( wepent, "mp2_muzzleflash_striker" )
            LAMBDA_MP2:SetMagazineData( wepent, "models/mp2tfomp/Weapons/w_striker_mag.mdl", "MP2TFoMP.ClipRifleRicochet" )
            LAMBDA_MP2:SetShellEject( wepent, "models/mp2tfomp/Projectiles/shell_shotgun.mdl", "MP2TFoMP.ShellShotgunRicochet", "MP2TFoMP.ShellShotgunFreeze" )
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