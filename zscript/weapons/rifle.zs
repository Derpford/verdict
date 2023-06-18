class VerdictSamRifle : VerdictWeapon {
    default {
        VerdictWeapon.Pouch "SamRiflePouch";
        Weapon.SlotNumber 4;
        Tag "Ronin Arms 'Ultra Samurai' Combat Rifle";
    }
}

class SamMag : Magazine {
    default {
        Magazine.Capacity 30;
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