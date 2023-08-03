table.Merge( _LAMBDAPLAYERSWEAPONS, {
    mp2_ingram = {
        model = "models/MP2TFoMP/Weapons/w_ingram.mdl",
        origin = "Max Payne 2",
        prettyname = "Ingram",
        holdtype = "pistol",
        killicon = "weapon_mp2tfomp_ingram",
        bonemerge = true,
        islethal = true,
        dropentity = "ent_mp2tfomp_ingram",

        clip = 32,
        keepdistance = 750,
        attackrange = 2000,

        reloadtime = 2.0,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        reloadanimspeed = 0.7,
        reloadsounds = { { 0, "MP2TFoMP.IngramReload" } },

        OnDeploy = function( self, wepent )
            LAMBDA_MP2:InitializeWeapon( self, wepent, "weapon_mp2tfomp_ingram" )

            wepent.MP2Data.Damage = 12
            wepent.MP2Data.Spread = 1
            wepent.MP2Data.Force = 2
            wepent.MP2Data.Distance = 7874

            wepent.MP2Data.RateOfFire = 0.11
            wepent.MP2Data.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL
            wepent.MP2Data.Sound = "MP2TFoMP.IngramFire"

            LAMBDA_MP2:SetShellEject( wepent )
            LAMBDA_MP2:SetMuzzleName( wepent, "mp2_muzzleflash_ingram" )
            LAMBDA_MP2:SetMagazineData( wepent, "models/mp2tfomp/Weapons/w_ingram_mag.mdl", "MP2TFoMP.ClipRifleRicochet", 100 )
        end,

        OnReload = function( self, wepent )
            LAMBDA_MP2:DropMagazine( wepent )
        end,

        OnAttack = function( self, wepent, target )
            if LAMBDA_MP2:FireWeapon( self, wepent, target ) != true then
                self:SimpleWeaponTimer( 0.055, function() LAMBDA_MP2:FireWeapon( self, wepent, target, true, true ) end )
            end

            return true
        end
    }
} )