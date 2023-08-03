table.Merge( _LAMBDAPLAYERSWEAPONS, {
    mp2_sniperrifle = {
        model = "models/MP2TFoMP/Weapons/w_sniper.mdl",
        origin = "Max Payne 2",
        prettyname = "Sniper Rifle",
        holdtype = "rpg",
        killicon = "weapon_mp2tfomp_sniper",
        bonemerge = true,
        islethal = true,
        dropentity = "ent_mp2tfomp_sniper",

        clip = 5,
        keepdistance = 1500,
        attackrange = 3000,

        reloadtime = 1.6,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        reloadanimspeed = 1.4,
        reloadsounds = { { 0, "MP2TFoMP.SteyrSSGReload" } },

        OnDeploy = function( self, wepent )
            LAMBDA_MP2:InitializeWeapon( self, wepent, "weapon_mp2tfomp_sniper" )

            wepent.MP2Data.Damage = 71
            wepent.MP2Data.Spread = 0.05
            wepent.MP2Data.Force = 10
            wepent.MP2Data.BulletModel = "models/mp2tfomp/Projectiles/bullet_sniper.mdl"
            wepent.MP2Data.BulletVelocity = 10000

            wepent.MP2Data.RateOfFire = { 1.5, 3.0 }
            wepent.MP2Data.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
            wepent.MP2Data.Sound = "MP2TFoMP.SteyrSSGFire"
            wepent.MP2Data.EjectShell = false

            LAMBDA_MP2:SetMuzzleName( wepent, "mp2_muzzleflash_sniper" )
            LAMBDA_MP2:SetMagazineData( wepent, "models/mp2tfomp/Weapons/w_sniper_mag.mdl", "MP2TFoMP.ClipRifleRicochet", 50 )
            LAMBDA_MP2:SetShellEject( wepent, "models/mp2tfomp/Projectiles/shell_sniper.mdl", "MP2TFoMP.ShellRifleRicochet", "MP2TFoMP.ShellRifleFreeze" )
        end,

        OnReload = function( self, wepent )
            LAMBDA_MP2:DropMagazine( wepent )
        end,

        OnAttack = function( self, wepent, target )
            if LAMBDA_MP2:FireWeapon( self, wepent, target ) != true then
                self:SimpleWeaponTimer( 0.333, function()
                    wepent:EmitSound( "MP2TFoMP.SniperChamber" )
                    LAMBDA_MP2:CreateShellEject( wepent )
                end )
            end

            return true
        end
    }
} )