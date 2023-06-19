class LooseAmmo : RandomSpawner {
    default {
        DropItem "MagnumBullets", 255, 8;
        DropItem "NanoSlug", 255, 2;
        DropItem "SamRound", 255, 2;
    }
}

class LightMags : RandomSpawner {
    default {
        DropItem "MagnumClip", 255, 10;
        DropItem "SamMag", 255, 2;
    }
}

class ClipReplacer : RandomSpawner replaces Clip {
    default {
        DropItem "LooseAmmo";
        DropItem "LightMags";
    }
}

class BonusReplacer1 : RandomSpawner replaces HealthBonus {
    default {
        DropItem "LooseAmmo";
    }
}

class BonusReplacer2 : RandomSpawner replaces ArmorBonus {
    default {
        DropItem "LooseAmmo";
    }
}