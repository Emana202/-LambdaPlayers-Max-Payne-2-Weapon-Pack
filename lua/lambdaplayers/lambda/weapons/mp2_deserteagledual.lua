table.Merge( _LAMBDAPLAYERSWEAPONS, {
    mp2_deserteagledual = {
        model = "models/MP2TFoMP/Weapons/w_deserteagle_dual.mdl",
        origin = "Max Payne 2",
        prettyname = "Dual Desert Eagles",
        holdtype = "duel",
        killicon = "weapon_mp2tfomp_deserteagledual",
        bonemerge = true,
        islethal = true,
        dropentity = "ent_mp2tfomp_deserteagle",

        clip = 20,
        keepdistance = 750,
        attackrange = 1500,

        reloadtime = 2.2,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_DUEL,
        reloadanimspeed = 1.5,
        reloadsounds = { { 0, "MP2TFoMP.DesertEagleReloadDual" } },

        OnDeploy = function( self, wepent )
            LAMBDA_MP2:InitializeWeapon( self, wepent, "weapon_mp2tfomp_deserteagledual" )

            wepent.MP2Data.Damage = 41
            wepent.MP2Data.Spread = 1
            wepent.MP2Data.Force = 6
            
            wepent.MP2Data.MuzzleAttachment = 1
            wepent.MP2Data.ShellAttachment = 2

            wepent.MP2Data.RateOfFire = 0.333
            wepent.MP2Data.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_DUEL
            wepent.MP2Data.Sound = "MP2TFoMP.DesertEagleFire"

            LAMBDA_MP2:SetMuzzleName( wepent, "mp2_muzzleflash_deagle" )
            LAMBDA_MP2:SetMagazineData( wepent, "models/mp2tfomp/Weapons/w_deserteagle_mag.mdl" )
            LAMBDA_MP2:SetShellEject( wepent, "models/mp2tfomp/Projectiles/shell_deserteagle.mdl", "MP2TFoMP.ShellDesertEagleRicochet", "MP2TFoMP.ShellDesertEagleFreeze" )
        end,

        OnReload = function( self, wepent )
            LAMBDA_MP2:DropMagazine( wepent )
            LAMBDA_MP2:DropMagazine( wepent, 6 )
        end,

        OnAttack = function( self, wepent, target )
            if LAMBDA_MP2:FireWeapon( self, wepent, target ) != true then
                wepent.MP2Data.MuzzleAttachment = 4
                wepent.MP2Data.ShellAttachment = 5

                self:SimpleWeaponTimer( 0.133, function()                    
                    if !self:GetIsDead() then LAMBDA_MP2:FireWeapon( self, wepent, target, true ) end
                    wepent.MP2Data.MuzzleAttachment = 1
                    wepent.MP2Data.ShellAttachment = 2
                end, true )
            end

            return true
        end
    }
} )