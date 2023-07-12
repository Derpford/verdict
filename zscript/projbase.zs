class VerdictShot : Missile {
    // A special projectile that can have various kinds of overpenetration qualities.

    int penclass; // 1 = Always overpen, 2 = overpen on kill, 3 = overpen on gib. 
    Property Pen : penclass;
    bool overpen; // Used by the shotgun slug to determine if damage should be doubled or not.

    vector2 deviate; // How much is this thing deviating? X is angle, Y is pitch
    double deviateRange; // How far does it have to travel before it starts deviating?
    Property Deviate : deviateRange;

    default {
        +MISSILE.HITONCE; // Only does damage once per target.
        VerdictShot.Pen 2; // Default to only overpenetrating on kills. Good middle ground for testing.
        VerdictShot.Deviate 1024;
        DamageFunction (20);
        DeathSound "weapons/riflex";
    }

    override void PostBeginPlay() {
        super.PostBeginPlay();
        pitch = target.pitch;
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
            default:
                // If overpen is set to zero, or above 3, don't set overpen to true.
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

    virtual vector2 GetDeviation(bool repeat) {
        // Returns the angle/pitch that the projectile should deviate by next.
        if (repeat) {
            return deviate;
        } else {
            return (frandom(-1,1) / 35.,frandom(-1,1) / 35.);
        }
    }

    override void Tick() {
        super.Tick();
        if (deviateRange >= 0) {
            deviateRange -= vel.length();
        } else {
            deviate = GetDeviation(deviate != (0,0)); 
            // If the deviation is (0,0), it must not have been set, so if it's not (0,0) this must be the second time
            angle += deviate.x;
            pitch += deviate.y;
            Vel3DFromAngle(vel.length(),angle,pitch); // Default behavior causes the projectile to curve steadily.
        }
    }

}