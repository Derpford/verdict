class VerdictOfficer : DoomPlayer {
    // A nice way of saying 'rent-a-cop'.
    int healtimer;
    int healdelay;
    default {
        Player.StartItem "VerdictMagnum";
        Player.StartItem "VerdictArmor", 400;
    }

    override int TakeSpecialDamage(Actor inf, Actor src, int damage, name mod) {
        healdelay += damage;
        return super.TakeSpecialDamage(inf,src,damage,mod);
    }

    override void Tick() {
        super.Tick();
        if (healdelay > 0) {
            healdelay--;
        } else {
            if (healtimer > 0) {
                healtimer--;
            } else {
                int amt = ceil((GetMaxHealth(true) - health) * 0.05); // 5% of missing health.
                GiveBody(amt);
                healtimer = 2;
            }
        }
    }
}

class VerdictArmor : Inventory {
    // You start with full armor, but it breaks quickly.
    default {
        Inventory.Amount 400;
        Inventory.MaxAmount 400;
    }

    override bool HandlePickup(Inventory other) {
        if (other is "VerdictArmorGiver") {
            if (amount < maxamount) {
                amount = min(maxamount, amount+other.amount);
                other.bPICKUPGOOD = true;
            }
            return true;
        }

        return false;
    }

    override void AbsorbDamage(int dmg, name mod, out int newdmg, Actor inf, Actor src, int flags) {
        if (flags & DMG_NO_ARMOR || flags & DMG_FORCED) {return;}
        int absorbed = floor(dmg * 0.75);
        int taken = dmg - absorbed;
        newdmg = taken;
        int oldamount = amount;
        amount = max(0,amount - absorbed);
        if (oldamount > 0 && amount < 1) {
            owner.A_StartSound("misc/armbreak",3);
        } else {
            owner.A_StartSound("misc/armhit",3);
        }
    }
}

class VerdictArmorGiver : Inventory {
    Mixin LootBeam;
    // Items of this class turn into VerdictArmor instead of dropping themselves.
    default {
        +FLATSPRITE;
        Inventory.Amount 100;
        Inventory.MaxAmount 400;
    }
}