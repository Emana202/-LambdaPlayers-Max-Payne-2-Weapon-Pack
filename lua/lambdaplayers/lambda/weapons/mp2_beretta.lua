table.Merge( _LAMBDAPLAYERSWEAPONS, {
    mp2_beretta = {
        model = "models/MP2TFoMP/Weapons/w_beretta.mdl",
        origin = "Max Payne 2",
        prettyname = "9mm Pistol",
        holdtype = "pistol",
        killicon = "weapon_mp2tfomp_beretta",
        bonemerge = true,
        islethal = true,
        dropentity = "ent_mp2tfomp_beretta",

        clip = 16,
        keepdistance = 750,
        attackrange = 1500,

        reloadtime = 2.0,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        reloadanimspeed = 0.7,
        reloadsounds = { { 0, "MP2TFoMP.BerettaReload" } },

        OnDeploy = function( self, wepent )
            LAMBDA_MP2:InitializeWeapon( self, wepent, "weapon_mp2tfomp_beretta" )

            wepent.MP2Data.Damage = 17
            wepent.MP2Data.Spread = 0.35
            wepent.MP2Data.Force = 2
            wepent.MP2Data.Distance = 7874

            wepent.MP2Data.RateOfFire = 0.25
            wepent.MP2Data.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL
            wepent.MP2Data.Sound = "MP2TFoMP.BerettaFire"

            LAMBDA_MP2:SetMuzzleName( wepent )
            LAMBDA_MP2:SetMagazineData( wepent )
            LAMBDA_MP2:SetShellEject( wepent )
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