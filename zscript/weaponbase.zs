class VerdictWeapon : Weapon {
    // Comes with a defined MagPouch that it uses for reloading, as well as its own magazine.
    Name pouch;
    Property Pouch: pouch;
    int bullets;
    int bullets2; // Just in case I implement altfires.
    Property FirstLoad: bullets, bullets2;
    int chamber; // One in the chamber.
    int chamber2;

    bool safety; // You can toggle the safety on and off. If the gun is on safe it won't fire.

    int firemode; // For weapons that set a firemode.

    Name spawnwith; // For dropping something nearby.
    Property Drop : spawnwith;

    default {
        VerdictWeapon.Pouch "MagPouch";
        VerdictWeapon.FirstLoad 30, 0;
        Weapon.SlotNumber 2;
        Weapon.AmmoUse 1;
    }

    override void PostBeginPlay() {
        // Chamber is always full on a new weapon.
        if (spawnwith) {
            A_SpawnItemEX(spawnwith);
        }
        chamber = 1;
        chamber2 = 1;
    }

    virtual void Cycle(bool alt = false) {
        // Take one from the mag and put it in the chamber.
        if (alt) {
            if (chamber2 == 0 && bullets2 > 0) {
                bullets2--;
                chamber2++;
            }
        } else {
            if (chamber == 0 && bullets > 0) {
                bullets--;
                chamber++;
            }
        }
    }

    action void A_Cycle(bool alt = false) {
        invoker.Cycle(alt);
    }

    virtual int SelectFireMode() {
        // Not used unless the weapon has firemodes.
        // On weapons w/firemodes, this decides the next firemode.
        return 0;
    }

    action void LoadNewMag() {
        let mpouch = MagPouch(invoker.owner.FindInventory(invoker.pouch));
        if (mpouch) {
            vector3 res = mpouch.SwapMag(invoker.bullets,false,true);
            invoker.bullets = res.y;
            if (invoker.chamber < 1) {
                A_Cycle();
            }
        }
    }

    override void AttachToOwner(Actor other) {
        // Make sure the owner has our magpouch!
        let p = other.FindInventory(pouch);
        if (!p) {
            other.GiveInventory(pouch,1);
        }
        super.AttachToOwner(other);
    }

    override void DoEffect() {
        if (owner.player.readyweapon is self.GetClassName()) {
            int btns = owner.GetPlayerInput(INPUT_BUTTONS);
            int oldbtns = owner.GetPlayerInput(INPUT_OLDBUTTONS); // Player can't switch the safety when frozen
            // int justbtns = btns & oldbtns;
            if (btns & BT_USER1 && !(oldbtns & BT_USER1)) { //Safety switch.
                safety = !safety;
            }
            if (btns & BT_USER2 && !(oldbtns & BT_USER2)) { // Fire select.
                firemode = SelectFireMode();
            }
            if (btns & BT_USER3 && !(oldbtns & BT_USER3)) { // Drop a mag.
                MagPouch(owner.FindInventory(pouch)).DropOne();
            }
            if (btns & BT_USER4 && !(oldbtns & BT_USER4)) { // Empty a mag and drop it.
                MagPouch(owner.FindInventory(pouch)).DropOne(true);
            }
        }
    }

    override bool CheckAmmo(int button, bool autoSwitch, bool requireAmmo, int ammoCount) {
        switch (button) {
            case PrimaryFire:
                return chamber >= ammouse1;
                break;
            case AltFire:
                return chamber2 >= ammouse2;
                break;
            case EitherFire:
                return max(chamber,chamber2) >= min(ammouse1,ammouse2);
        }
        // If we got here, something broke.
        return false;
    }

    override bool DepleteAmmo(bool isAlt, bool check, int use) {
        if (safety) { return false; } // Don't forget to turn the safety off before firing!
        if (check) {
            int mode = PrimaryFire;
            if (isAlt) { mode = AltFire; }
            if (!CheckAmmo(mode,false,false,-1)) { return false; } // Failed ammo check.
        }

        // Now we can take ammunition.
        if (isAlt) {
            chamber2 -= ammouse2;
            // bullets2 -= ammouse2;
        } else {
            chamber -= ammouse1;
            // bullets -= ammouse1;
        }
        return true;
    }

    override state GetAtkState(bool hold) {
        if (safety || !CheckAmmo(PrimaryFire,false,false,-1)) {
            // Return the click state if there is one.
            let click = ResolveState("Click");
            if (click) { return click; }
            else { return ResolveState(null); }
        } else {
            return super.GetAtkState(hold); //Normal behavior when safety's not on and we have enough ammo.
        }
    }

    override state GetAltAtkState(bool hold) {
        if (safety || !CheckAmmo(AltFire,false,false,-1)) {
            // Return the click state if there is one.
            let altclick = ResolveState("AltClick");
            let click = ResolveState("Click");
            if (altclick) { return click; }
            else if (click) { return click; }
            else { return ResolveState(null); }
        } else {
            return super.GetAltAtkState(hold); //Normal behavior when safety's not on and we have enough ammo.
        }
    }

    states {
        Select:
            SHTG A 1 A_Raise(24);
            Loop;
        
        Deselect:
            SHTG A 1 A_Lower(24);
            Loop;
        
        Ready:
            SHTG A 1 A_WeaponReady(WRF_ALLOWRELOAD);
            Loop;

        Reload: 
            SHTG A 0 A_StartSound("misc/w_pkup",1);
            SHTG A 5 A_WeaponOffset(-5,10,WOF_ADD);
            SHTG B 6 A_WeaponOffset(-4,2,WOF_ADD);
            SHTG B 0 LoadNewMag();
            SHTG B 4 A_WeaponOffset(5,-10,WOF_ADD);
            SHTG A 2 A_WeaponOffset(4,-2,WOF_ADD);
            Goto Ready;
        
        Fire:
            SHTG A 0 A_StartSound("weapons/pistol");
            SHTG A 0 A_FireProjectile("TestShot");
            SHTG A 0 A_GunFlash();
            SHTG A 2 A_WeaponOffset(0,8,WOF_ADD);
            SHTG A 0 A_Cycle();
            SHTG A 3 A_WeaponOffset(0,-8,WOF_ADD);
            Goto Ready;
        
        Flash:
            SHTF AB Random(1,2) Bright;
            Goto LightDone;
    }
}

class TestShot : VerdictShot {
    default {
        radius 2;
        height 2;
        scale 0.2;
        Speed 75;
        Decal "RedPlasmaScorch";
    }

    states {
        Spawn:
            PLS2 AB 3 Bright;
            Loop;
        Death:
            PLS2 CDE 2 Bright;
            Stop;
    }
}