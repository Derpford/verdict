class LooseAmmo : RandomSpawner {
    default {
        DropItem "MagnumBullets";
    }
}

class LightMags : RandomSpawner {
    default {
        DropItem "MagnumClip";
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