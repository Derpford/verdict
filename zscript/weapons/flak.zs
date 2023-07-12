class VerdictSSG : VerdictWeapon replaces SuperShotgun {
    // Riot Dispersion/Multiple Scattered Targets shotgun.
    default {
        Weapon.SlotNumber 3;
        VerdictWeapon.FirstLoad 3,0;
        VerdictWeapon.Pouch "ShellPouch";
        Tag "RD/MST Shotgun";
        Inventory.PickupMessage "Acquired a RD/MST Shotgun.";
    }

    double GetFireAngle(double spread, int i, int count) {
        return (spread * (i / float(count - 1))) - (spread * 0.5);
    }

    action void FireFlak() {
        A_StartSound("weapons/flakf",4);
        // does 150 damage if all pellets hit one target (just enough to kill a Pinky)
        // spread across 20 pellets, in a 7/6/7 pattern

        double spread1 = 21.;
        double spread2 = 18.;

        // top/bottom layers
        for (int i = 0; i < 7; i++) {
            double ang = invoker.GetFireAngle(spread1,i,7);
            double pit = 2;
            A_FireProjectile("VerdictFlak",ang,false,pitch:-pit);
            A_FireProjectile("VerdictFlak",ang,false,pitch:pit);
        }
        // middle layer
        for (int i = 0; i < 6; i++) {
            // Similar logic, but different angle.
            double ang = invoker.GetFireAngle(spread1,i,6);
            A_FireProjectile("VerdictFlak",ang,(i == 0)); // Take ammo on exactly one of these.
        }
    }

    states {
        Spawn:
            SHRA A -1;
            Stop;
        
        Select:
            SHRP A 1 A_Raise(15);
            Loop;
        DeSelect:
            SHRP A 1 A_Lower(8);
            Loop;
        
        Ready:
            SHRP A 1 A_WeaponReady(WRF_ALLOWRELOAD);
            Loop;
        
        Fire:
            SHRP B 0 FireFlak();
            SHRP B 3 Bright A_WeaponOffset(0,12,WOF_ADD);
            SHRP C 2 Bright A_WeaponOffset(0,-2,WOF_ADD);
            SHRP D 2;
            SHRP E 2 A_WeaponOffset(0,12,WOF_ADD);
            SHRP F 3 Bright A_WeaponOffset(0,-10,WOF_ADD);
            SHRP G 3 Bright A_WeaponOffset(0,-12,WOF_ADD);
            SHRP H 4 Bright A_Cycle();
            Goto Ready;

        Reload:
            SHRP A 4 A_WeaponOffset(-16,24,WOF_ADD);
            SHRP A 8;
        ReloadLoop:
            SHRP A 0 {
                if (invoker.bullets >= 3 || invoker.owner.CountInv("NanoSlug") < 1) {
                    return ResolveState("ReloadEnd");
                } else {
                    return ResolveState(null);
                }
            }
            SHRP A 3 A_WeaponOffset(0,4,WOF_ADD);
            SHRP A 2 A_WeaponOffset(0,-4,WOF_ADD);
            SHRP A 0 {
                A_TakeInventory("NanoSlug",1);
                invoker.bullets++;
            }
            Loop;
        ReloadEnd:
            SHRP A 0 A_Cycle();
            SHRP A 4 A_WeaponOffset(16,-24,WOF_ADD);
            Goto Ready;
    }
}

class VerdictFlak : VerdictShot {
    default {
        DamageFunction (7 + random(0,1)); // total comes out to between 140 and 160
        VerdictShot.Pen 1;
        VerdictShot.Deviate 256; // Deviates rapidly!
        Speed 55;
        Scale 0.3;
        radius 2;
        height 2;
        Decal "RedPlasmaScorch";
        DeathSound "weapons/riflex";
    }

    states {
        Spawn:
            PLS2 AB 2 Bright;
            Loop;
        
        Death:
            PLS2 CDE 2 Bright;
            Stop;
    }

    override vector2 GetDeviation(bool repeat) {
        // Tumbles wildly.
        return (frandom(-2,2),frandom(0,0.5));
    }
}