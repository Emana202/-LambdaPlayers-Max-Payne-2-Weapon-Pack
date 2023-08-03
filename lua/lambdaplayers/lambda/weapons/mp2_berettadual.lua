table.Merge( _LAMBDAPLAYERSWEAPONS, {
    mp2_berettadual = {
        model = "models/MP2TFoMP/Weapons/w_beretta_dual.mdl",
        origin = "Max Payne 2",
        prettyname = "Dual 9mm Pistols",
        holdtype = "duel",
        killicon = "weapon_mp2tfomp_berettadual",
        bonemerge = true,
        islethal = true,
        dropentity = "ent_mp2tfomp_beretta",

        clip = 32,
        keepdistance = 750,
        attackrange = 2000,

        reloadtime = 2.2,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_DUEL,
        reloadanimspeed = 1.5,
        reloadsounds = { { 0, "MP2TFoMP.BerettaReloadDual" } },

        OnDeploy = function( self, wepent )
            LAMBDA_MP2:InitializeWeapon( self, wepent, "weapon_mp2tfomp_berettadual" )

            wepent.MP2Data.Damage = 17
            wepent.MP2Data.Spread = 0.55
            wepent.MP2Data.Force = 2
            wepent.MP2Data.Distance = 7874
            
            wepent.MP2Data.MuzzleAttachment = 1
            wepent.MP2Data.ShellAttachment = 2

            wepent.MP2Data.RateOfFire = 0.25
            wepent.MP2Data.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_DUEL
            wepent.MP2Data.Sound = "MP2TFoMP.BerettaFire"

            LAMBDA_MP2:SetMuzzleName( wepent )
            LAMBDA_MP2:SetMagazineData( wepent )
            LAMBDA_MP2:SetShellEject( wepent )
        end,

        OnReload = function( self, wepent )
            LAMBDA_MP2:DropMagazine( wepent )
            LAMBDA_MP2:DropMagazine( wepent, 6 )
        end,

        OnAttack = function( self, wepent, target )
            if LAMBDA_MP2:FireWeapon( self, wepent, target ) != true then
                wepent.MP2Data.MuzzleAttachment = 4
                wepent.MP2Data.ShellAttachment = 5

                self:SimpleWeaponTimer( 0.065, function()
                    if !self:GetIsDead() then LAMBDA_MP2:FireWeapon( self, wepent, target, true ) end
                    wepent.MP2Data.MuzzleAttachment = 1
                    wepent.MP2Data.ShellAttachment = 2
                end, true )
            end

            return true
        end
    }
} )