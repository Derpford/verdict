class VerdictMagnum : VerdictWeapon replaces Pistol {
    // Standard issue coil magnum.

    default {
        VerdictWeapon.FirstLoad 7,0;
        VerdictWeapon.Pouch "MagnumPouch";
        VerdictWeapon.Drop "MagnumClip";
        Weapon.SlotNumber 2;
        Tag "Std. Issue Verdict Dept. Coil Magnum";
    }

    states {
        Spawn:
            MAGI A -1;
            Stop;
        Select:
            MAGN A 1 A_Raise(24);
            Loop;
        Deselect:
            MAGN A 1 A_Lower(24);
            Loop;
        Ready:
            MAGN A 1 A_WeaponReady(WRF_ALLOWRELOAD);
            Loop;

        Fire:
            MAGN B 0 A_StartSound("weapons/magnumf",4);
            MAGN B 0 Bright A_FireProjectile("MagnumShot");
            MAGN B 3 Bright A_WeaponOffset(0,18,WOF_ADD);
            MAGN CDA 3 Bright A_WeaponOffset(0,-6,WOF_ADD);
            MAGN A 0 A_Cycle();
        
        Hold:
            MAGN A 1;
            MAGN A 0 A_Refire();
            Goto Ready;
        
        Click:
            MAGN A 3 A_WeaponOffset(0,3,WOF_ADD);
            MAGN A 6 A_WeaponOffset(0,-3,WOF_ADD);
            Goto Ready;
        
        Reload:
            MAGN A 10 A_WeaponOffset(12,24,WOF_ADD);
            MAGN A 5 A_WeaponOffset(6,0,WOF_ADD);
            MAGN A 0 LoadNewMag();
            MAGN A 8 A_WeaponOffset(-9,-10,WOF_ADD);
            MAGN A 6 A_WeaponOffset(-9,-14,WOF_ADD);
            Goto Ready;
    }
}

class MagnumShot : VerdictShot {
    default {
        DamageFunction (25 + (random(0,2) * 5));
        Scale 0.2;
        Radius 2;
        Height 2;
        Decal "BulletChip";
        VerdictShot.Pen 1;
        Speed 60;
    }

    override void Tick() {
        super.Tick();
        for (int i = 0; i < 5; i++) {
            int ang = 15 * (GetAge() + i);
            double dis = 2.5;
            A_SpawnParticle("00FFFF",SPF_FULLBRIGHT|SPF_RELATIVE,15,xoff:i*dis,yoff:dis*cos(ang),zoff:dis*sin(ang));
        }
    }

    states {
        Spawn:
            PLSS AB 3 Bright;
            Loop;
        Death:
            PLSE ABCDE 2 Bright;
            Stop;
        
    }
}

class MagnumClip : Magazine {
    // 8 capacity, plus 1 in the chamber.
    default {
        Magazine.Capacity 8;
        Inventory.PickupMessage "Acquired a Coil Magnum clip.";
        Magazine.Pouch "MagnumPouch";
    }

    states {
        Spawn:
            MMAG A -1;
            Stop;
    }
}

class MagnumBullets : Ammo {
    // MAAAAAGNUUUUM, BUULLLLLEEEEEEETS
    mixin LootBeam;
    default {
        Inventory.Amount 1;
        Inventory.MaxAmount 12; // Big chonkin' bullets.
        Inventory.PickupMessage "Acquired a loose Coil Magnum round.";
    }

    states {
        Spawn:
            MMAG B -1;
            Stop;
    }
}

class MagnumBulletBox : MagnumBullets {
    mixin LootBeam;
    default {
        Inventory.Amount 12;
    }
    
    states {
        Spawn:
            BBOX B -1;
            Stop;
    }
}

class MagnumPouch: MagPouch {
    default {
        MagPouch.Type "MagnumClip","MagnumBullets";
        MagPouch.Mags 2;
        MagPouch.Capacity 8;
        MagPouch.Reload 35;
    }
}