mixin class LootBeam {
    // For when you need something to have a lootbeam.
    override void Tick() {
        if (!owner) {
            // While on the ground, emit a lootbeam.
            A_SpawnParticle("00FFFF",SPF_FULLBRIGHT,5,5,velz:5);
        }
        super.Tick();
    }
}

class MagPouch : Inventory {
    // A pouch which holds Magazines.
    // Internally, these are tracked as an array. Multiple ammo types are out of scope right now, so no arrays of arrays here...
    // MagPouches have an associated Magazine type and an associated Ammo.
    Name mag;
    Name ammotype;
    Property Type: mag, ammotype;
    // They also have a cap on how many mags you can be carrying at once.
    int magSlots;
    Property Mags: magSlots;
    // The max capacity of a mag is kept in the mag, not here.
    // However, GetDefaultByClass is being a butt and I don't wanna deal with it, so...
    int magCapacity;
    Property Capacity: magCapacity;
    // There's also the amount of time it takes for one bullet to get loaded into a spare mag.
    int loadTimer;
    int ticsPerLoad;
    Property Reload: ticsPerLoad;

    bool showLoose; // if true, show spare ammo as a "mag".
    property ShowLoose : showLoose;

    Array<Int> mags;

    default {
        MagPouch.Type "Magazine", "TestAmmo";
        MagPouch.Reload 35;
        MagPouch.Mags 2;
        MagPouch.Capacity 30;
        MagPouch.ShowLoose false;
    }

    virtual int StartMagFill(int slot) {
        // How full should our magazines be when the game starts?
        // Takes the mag slot, so that you can decide how many mags are full to start with.
        return magCapacity;
    }

    override void PostBeginPlay() {
        // Cache our mag capacity.
        mags.Resize(magSlots);
        for (int i = 0; i < magSlots; i++) {
            mags[i] = StartMagFill(i);
        }
        loadTimer = 0;
        super.PostBeginPlay();
    }

    override void DoEffect() {
        // Here's where we look for a half-empty mag to fill.
        if (ticsPerLoad < 0) { return; } // -1 or less means skip reloading.
        if (loadTimer >= ticsPerLoad) {
            for (int i = 0; i < magSlots; i++) {
                if (mags[i] < magCapacity) {
                    if (owner.CountInv(ammotype) > 0) {
                        owner.TakeInventory(ammotype,1);
                        mags[i]++;
                    }
                }
            }
            loadTimer = 0;
        } else {
            loadTimer++;
        }
    }

    int FindHighestMag() {
        int hibullets = -1;
        int himag = -1;
        for (int i = 0; i < magSlots; i++) {
            if (mags[i] > hibullets) { // Note: -1 = no mag in that slot.
                hibullets = mags[i];
                himag = i;
            }
        }
        return himag;
    }

    int FindLowestMag(bool useEmpty = false) {
        int lobullets = -1;
        int lomag = -1;
        for (int i = 0; i < magSlots; i++) {
            if (mags[i] < 0 && !useEmpty) {continue;} // Note: -1 = no mag in that slot.
            if (mags[i] <= lobullets || (lobullets == -1 && !useEmpty)) {
                lobullets = mags[i];
                lomag = i;
            }
        }
        return lomag;

    }

    vector3 SwapMag(int new, bool less = true, bool forced = false) {
        bool swap = false;
        int m;
        if (less) {
            m = FindLowestMag(true); 
            if (m >= 0) {
                swap = mags[m] < new;
            }
        } else {
            m = FindHighestMag();
            if (m >= 0) {
                swap = mags[m] > new;
            }
        }
        if (swap) { // Set less to false for reloads, or true for item pickup.
            // Bingo! Swap the mags and then break the loop.
            int old = mags[m];
            mags[m] = new;
            return (m,old,new);
        }
        
        // If we get here, the swap condition failed...
        if (forced) {
            // But if forced is true, swap anyway.
            int old = mags[0];
            mags[0] = new;
            return (0,old,new);
        } else {
            return (-1,-1,-1); // Don't swap.
        }
    }

    void SpawnMag(int amount, bool setpos = false, vector3 newpos = (0,0,0)) {
        // Convenience function for dropping mags.
        if (!setpos) {
            newpos = owner.Vec3Angle(48,owner.angle);
        }
        let droppedMag = Inventory(Spawn(mag,newpos));
        droppedMag.amount = amount;
        double ang = frandom(0,360);
        if (!setpos) {
            ang = owner.angle + frandom(-45,45);
        }
        droppedMag.velFromAngle(frandom(0.5,4),ang);
        droppedMag.angle = frandom(0,360);
    }

    void DropOne() {
        // Pick the lowest mag in our inventory...
        int m = FindLowestMag();
        if (m < 0) {return;}
        // And drop it.
        int dropped = mags[m];
        mags[m] = -1;
        SpawnMag(dropped);
    }

    override bool HandlePickup(Inventory item) {
        // Here, we intercept any Magazines of our chosen type.
        if (!mag) {return super.HandlePickup(item);} // If we don't have a mag, just don't worry about it
        if (item is mag) {
            // First, check to see if we need to randomize the amount.
            if (item.amount == -1) {
                let m = Magazine(item);
                if (m) {
                    item.amount = m.GetRandAmount();
                }
            }
            // Now check if the amount is more than any of our existing magazines.
            vector3 result = SwapMag(item.amount);
            if (result.x >= 0) {
                if (result.y >= 0) {SpawnMag(result.y,true,item.pos);}
                item.bPickupGood = true;
                // item.GoAwayAndDie();
            }
            return true; // Our mags are ONLY processed by this magpouch.
        } else {
            return false;
        }
    }
}

class Magazine : Inventory {
    mixin LootBeam;
    // Magazines hold ammunition.
    // However, they can either be holding a random amount of ammo, or an amount of ammo that was set by a MagPouch when it was dropped.
    // So, the default Amount is -1...
    // ...but there's also a Capacity value:
    int magCapacity;
    Property Capacity: magCapacity;
    // This doesn't actually contain much logic, though.
    default {
        +FLATSPRITE;
        Inventory.Amount -1;
        Magazine.Capacity 30;
        Inventory.PickupMessage "Acquired a DEV_NULL magazine.";
    }

    virtual int GetRandAmount() {
        // can be overridden, but the default impl is between 25 and 50 percent fill
        return floor(magCapacity * frandom(0.25,0.5));
    }


    states {
        Spawn:
            CLIP A -1;
            Stop;
    }
}

class TestAmmo : Ammo {
    // Ammunition!
    // This stuff is gradually put into mags that aren't full.
    default {
        Inventory.Amount 3;
        Inventory.MaxAmount 25; // Loose ammo is bulky. You usually can't carry a lot. You're lucky if you can carry more than half a mag.
    }
}
