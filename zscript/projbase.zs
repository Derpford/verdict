class VerdictShot : Missile {
    // A special projectile that can have various kinds of overpenetration qualities.

    int penclass; // 1 = Always overpen, 2 = overpen on kill, 3 = overpen on gib. 
    Property Pen : penclass;
    bool overpen; // Used by the shotgun slug to determine if damage should be doubled or not.

    default {
        +MISSILE.HITONCE; // Only does damage once per target.
        VerdictShot.Pen 2; // Default to only overpenetrating on kills. Good middle ground for testing.
        DamageFunction (20);
        DeathSound "weapons/riflex";
    }

    override int DoSpecialDamage(Actor tgt, int dmg, name mod) {
        // So, the messy part here is that this happens *before all other damage calculation*, which means that we don't actually know if the target will die yet...
        // But that's okay. There are only a few edge cases where you might get a "free" overpenetration before killing the target, since most people don't use damage resist on monsters.
        overpen = false; // default to not overpenetrating.
        switch (penclass) {
            case 1:
                // Overpenetration is always true.
                overpen = true;
                break;
            case 2:
                // Overpen if the damage would kill the target (before modifiers).
                overpen = ((tgt.health - dmg) <= 0);
                break;
            case 3:
                // Overpen if the damage would gib the target (before modifiers).
                overpen = ((tgt.health - dmg) <= tgt.GetGibHealth());
                break;
        }

        if (!overpen) {
            // Remove +RIPPER and die.
            console.printf("Dying");
            bRIPPER = false;
            vel = (0,0,0);
            SetState(ResolveState("Death"));
        }

        return super.DoSpecialDamage(tgt,dmg,mod); // Does not normally affect damage.
    }

}