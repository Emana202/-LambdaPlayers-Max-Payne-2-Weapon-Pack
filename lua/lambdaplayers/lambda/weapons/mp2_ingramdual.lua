table.Merge( _LAMBDAPLAYERSWEAPONS, {
    mp2_ingramdual = {
        model = "models/MP2TFoMP/Weapons/w_ingram_dual.mdl",
        origin = "Max Payne 2",
        prettyname = "Dual Ingrams",
        holdtype = "duel",
        killicon = "weapon_mp2tfomp_ingramdual",
        bonemerge = true,
        islethal = true,
        dropentity = "ent_mp2tfomp_ingram",

        clip = 64,
        keepdistance = 750,
        attackrange = 1500,

        reloadtime = 2.2,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_DUEL,
        reloadanimspeed = 1.5,
        reloadsounds = { { 0, "MP2TFoMP.IngramReloadDual" } },

        OnDeploy = function( self, wepent )
            LAMBDA_MP2:InitializeWeapon( self, wepent, "weapon_mp2tfomp_ingramdual" )

            wepent.MP2Data.Damage = 12
            wepent.MP2Data.Spread = 1.4
            wepent.MP2Data.Force = 2
            wepent.MP2Data.Distance = 7874

            wepent.MP2Data.RateOfFire = 0.11
            wepent.MP2Data.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_DUEL
            wepent.MP2Data.Sound = "MP2TFoMP.IngramFireDual"

            LAMBDA_MP2:SetShellEject( wepent )
            LAMBDA_MP2:SetMuzzleName( wepent, "mp2_muzzleflash_ingram" )
            LAMBDA_MP2:SetMagazineData( wepent, "models/mp2tfomp/Weapons/w_ingram_mag.mdl", "MP2TFoMP.ClipRifleRicochet" )
        end,

        OnReload = function( self, wepent )
            LAMBDA_MP2:DropMagazine( wepent )
            LAMBDA_MP2:DropMagazine( wepent, 6 )
        end,

        OnAttack = function( self, wepent, target )
            if LAMBDA_MP2:FireWeapon( self, wepent, target ) != true then
                for i = 2, 4 do
                    self:SimpleWeaponTimer( i * 0.0275, function()
                        if ( self.l_Clip % 2 ) != 1 then
                            wepent.MP2Data.MuzzleAttachment = 1
                            wepent.MP2Data.ShellAttachment = 2
                        else
                            wepent.MP2Data.MuzzleAttachment = 4
                            wepent.MP2Data.ShellAttachment = 5
                        end

                        LAMBDA_MP2:FireWeapon( self, wepent, target, true, true )
                    end )
                end
            end

            return true
        end
    }
} )