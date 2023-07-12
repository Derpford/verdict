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

class PartialAmmoHandler : Inventory {
    // For when a thing should be able to give *part* of its contents without disappearing.
    
    override bool HandlePickup(Inventory item) {
        Ammo a = Ammo(item);
        if (!a) { return false; }
        else {
            let base = owner.FindInventory(a.GetParentAmmo());
            if (!base) {console.printf("Starting from scratch");return false;}
            if (item.amount > 0 && base.amount < base.maxamount) {
                int diff = base.maxamount - base.amount;
                diff = min(item.amount, diff); // Can't take more than exists on the item.
                item.amount -= diff;
                base.amount += diff;
                if (item.amount > 0) item.bPickupGood = false;
                return true;
            }
        } 
        
        // If we got to this point, we should give up.
        return false;
    }
}