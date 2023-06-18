class ArmorShard : VerdictArmorGiver replaces Stimpack {
    // A small amount of nanopaste for recovering armor.
    default {
        Inventory.Amount 25;
        Inventory.PickupMessage "Acquired 25 units armor repair paste.";
    }

    states {
        Spawn:
            ARM1 A 15;
            ARM1 A 1 Bright;
            Loop;
    }
}

class ArmorCan : VerdictArmorGiver replaces Medikit {
    // A larger canister of nanopaste.
    default {
        Inventory.Amount 50;
        Inventory.PickupMessage "Acquired 50 units armor repair paste.";
    }

    states {
        Spawn:
            ARM2 A 15;
            ARM2 A 1 Bright;
            Loop;
    }
}

class ArmorMedium : VerdictArmorGiver replaces GreenArmor {
    // A discarded chestplate with some armor nanopaste still in it.
    default {
        Inventory.Amount 100;
        Inventory.PickupMessage "Acquired discarded armor plate carrier.";
    }

    states {
        Spawn:
            ARM3 A 15;
            ARM3 A 1 Bright;
            ARM3 B 15;
            ARM3 B 1 Bright;
            Loop;
    }
}

class ArmorLarge : VerdictArmorGiver replaces BlueArmor {
    // A shiny new chestplate just lying around...?
    default {
        Inventory.Amount 200;
        Inventory.PickupMessage "Acquired factory-condition armor plate carrier.";
    }

    states {
        Spawn:
            ARM4 A 15;
            ARM4 A 1 Bright;
            ARM4 B 15;
            ARM4 B 1 Bright;
            Loop;
    }
}