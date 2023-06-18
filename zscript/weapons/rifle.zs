class VerdictSamRifle : VerdictWeapon {
    default {
        VerdictWeapon.Pouch "SamRiflePouch";
        Weapon.SlotNumber 4;
        Tag "Ronin Arms 'Ultra Samurai' Combat Rifle";
        Inventory.PickupMessage "Acquired the Ronin Arms 'Ultra Samurai'.";
    }

    states {
        Spawn:
            RIFL I -1;
            Stop;
        
        Select:
            RIFL A 1 A_Raise(12);
            Loop;
        Deselect:
            RIFL A 1 A_Lower(12);
            Loop;
        
        Ready:
            RIFL A 1 A_WeaponReady(WRF_ALLOWRELOAD);
            Loop;
        
        Reload:
            RIFL A 12 A_WeaponOffset(-12,32,WOF_ADD);
            RIFL A 12 A_WeaponOffset(6,8,WOF_ADD);
            RIFL A 0 LoadNewMag();
            RIFL A 6 A_WeaponOffset(-6,0,WOF_ADD);
            RIFL A 6 A_WeaponOffset(12,-40,WOF_ADD);
            Goto Ready;
        
        Fire:
            RIFL B 0 A_FireProjectile("SamShot");
            RIFL B 1 Bright A_WeaponOffset(0,22,WOF_ADD);
            RIFL C 1 Bright;
            RIFL A 2 A_WeaponOffset(0,-22,WOF_ADD);
            RIFL A 0 A_Cycle();
            Goto Ready;
        
        Click:
            RIFL A 1;
            Goto Ready;
    }
}

class SamMag : Magazine {
    default {
        Magazine.Capacity 30;
        Scale 0.3;
    }

    states {
        Spawn:
            RMAG A -1;
            Stop;
    }
}

class SamShot : VerdictShot {
    default {
        radius 2;
        height 2;
        DamageFunction (18+(random(0,2)*6));
        VerdictShot.Pen 3;
        Scale 0.3;
        Decal "RedPlasmaScorch";
        Speed 80;
    }

    override void Tick() {
        A_SpawnItemEX("SamTrail");
        Super.Tick();
    }

    states {
        Spawn:
            PLS2 AB 2 Bright;
            Loop;
        Death:
            PLS2 CDE 2 Bright;
            Stop;
    }
}

class SamTrail : Actor {
    default {
        +NOINTERACTION;
        RenderStyle "Add";
    }

    states {
        Spawn:
            PLS2 ABCDE 3;
            Stop;
    }
}

class SamRound : Ammo {
    default {
        Inventory.Amount 1;
        Inventory.MaxAmount 25;
    }
}

class SamRiflePouch : MagPouch {
    default {
        MagPouch.Capacity 30;
        MagPouch.Type "SamMag", "SamRound";
        MagPouch.Mags 3;
        MagPouch.Reload 25;
    }
}