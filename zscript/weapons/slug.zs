class VerdictSlugGun : VerdictWeapon replaces Shotgun {
    // Sporting Purpose Marksman Rifled shotgun.
    default {
        Weapon.SlotNumber 3;
        VerdictWeapon.FirstLoad 4,0;
        VerdictWeapon.Pouch "ShellPouch";
        VerdictWeapon.Drop "NanoSlugMix";
        Tag "SPMR Shotgun";
        Inventory.PickupMessage "Acquired a SPMR Shotgun. Non-standard equipment.";
    }

    states {
        Spawn:
            SLGG I -1;
            Stop;
        
        Select:
            SLGG A 1 A_Raise(12);
            Loop;
        DeSelect:
            SLGG A 1 A_Lower(12);
            Loop;

        Ready:
            SLGG A 1 A_WeaponReady(WRF_ALLOWRELOAD);
            Loop;
        
        Fire:
            SLGG B 0 A_StartSound("weapons/sluggf",4);
            SLGG B 0 A_FireProjectile("ShotSlug");
            SLGG B 3 Bright A_WeaponOffset(0,20,WOF_ADD);
            SLGG C 3 Bright A_WeaponOffset(0,6,WOF_ADD);
            SLGG D 3 Bright A_Cycle();
            SLGG A 8 A_WeaponOffset(0,-26,WOF_ADD);
            Goto Ready;

        Reload:
            SLGG A 4 A_WeaponOffset(-16,24,WOF_ADD);
            SLGG A 8;
        ReloadLoop:
            SLGG A 0 {
                if (invoker.bullets >= 4 || invoker.owner.CountInv("NanoSlug") < 1) {
                    return ResolveState("ReloadEnd");
                } else {
                    return ResolveState(null);
                }
            }
            SLGG A 3 A_WeaponOffset(0,4,WOF_ADD);
            SLGG A 2 A_WeaponOffset(0,-4,WOF_ADD);
            SLGG A 0 {
                A_TakeInventory("NanoSlug",1);
                invoker.bullets++;
            }
            Loop;
        ReloadEnd:
            SLGG A 0 A_Cycle();
            SLGG A 4 A_WeaponOffset(16,-24,WOF_ADD);
            Goto Ready;
    }
}

class NanoSlug : Ammo replaces Shell {
    mixin LootBeam;
    // A nanite slug waiting to be reshaped.
    default {
        Inventory.Amount 1;
        Inventory.MaxAmount 16; 
        Inventory.PickupMessage "Acquired 1 nanite slug.";
    }

    states {
        Spawn:
            SHL1 A -1;
            Stop;
    }
}

class NanoSlugPack : NanoSlug replaces ShellBox {
    default {
        Inventory.Amount 4;
        Inventory.PickupMessage "Acquired a pack of nanite slugs.";
    }

    states {
        Spawn:
            SHEL A -1;
            Stop;
    }
}

class NanoSlugMix : RandomSpawner {
    default {
        DropItem "NanoSlugPack", 255, 1;
        DropItem "NanoSlug", 255, 3;
    }
}

class ShotSlug : VerdictShot {
    default {
        DamageFunction (45 + (random(0,2) * 15));
        VerdictShot.Pen 2;
        VerdictShot.Trail "NanoTrail", 1;
        VerdictShot.TrailVel 0,0,0;
        speed 75;
        scale 0.3;
        radius 4;
        height 4;
        Decal "RedPlasmaScorch";
        DeathSound "weapons/sluggx";
    }

    override int DoSpecialDamage(Actor tgt, int dmg, name mod) {
        int newdmg = super.DoSpecialDamage(tgt,dmg,mod);
        if (!overpen) {
            newdmg = ceil(newdmg * 2.5);
            // console.printf("Doubled damage! "..newdmg);
        }
        return newdmg;
    }

    states {
        Spawn:
            BAL1 AB 2 Bright;
            Loop;
        
        Death:
            BAL1 CDE 2 Bright;
            Stop;
    }
}

class NanoTrail : Actor {
    default {
        +NOINTERACTION;
        RenderStyle "Add";
        Scale 0.1;
    }

    states {
        Spawn:
            BAL1 CDEDC 3;
            Stop;
    }
}

class ShellPouch : MagPouch {
    // An unusual case of a pouch being shared between two weapons, and also not using mags.
    default {
        MagPouch.Type "", "NanoSlug";
        MagPouch.Capacity 1;
        MagPouch.Mags 0;
        MagPouch.Reload -1;
        MagPouch.ShowLoose true;
    }
}