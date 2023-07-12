# Verdict
A fast-paced tactical weapon mod for Doom 2

## The Basics
- Your weapons are incredibly deadly and accurate. However, you are only human, and can only carry a couple of magazines at a time for each of your weapons.
- Tapping reload drops the current mag and inserts a new one. Holding reload retains the old mag.
- You can still maneuver and fire easily thanks to high-tech implants.
- Your health regenerates over time thanks to rapid regeneration compound dispensers built into your body. Regeneration pauses based on damage taken.
- Armor, on the other hand, does not regenerate. Armor absorbs 75% of incoming damage and you can have up to 400 points of it (represented on the HUD as 4 quadrants next to your health bar). Armor plates replace stimpacks and medikits (giving 25 and 50 armor each). Green/Blue Armor is replaced with larger armor plates that give 100 or 200 armor.
- Loose ammunition can be found in place of armor bonuses and health bonuses. Your armor includes mechanized mag pouches that automatically fill mags with loose ammo from your inventory over time.
- Weapons can overpenetrate to varying degrees:
    - Class 1 weapons overpenetrate all targets.
    - Class 2 weapons overpenetrate any target they kill.
    - Class 3 weapons overpenetrate any target they gib.
    - Some weapons do bonus damage against targets they *don't* overpenetrate.
    - Impl details: It *looks* like missiles dying on impact is handled in Tick(). Possible workaround: everything is +RIPPER and handle overpen check in DoSpecialDamage?
## The Weapons
### Pocket Fusion Caster
A small energy weapon with theoretically infinite ammo but a lengthy recharge. Additional PFCs essentially function as extra mags. Replaces Chainsaw. C3 overpenetration.
### Verdict Department Standard Issue Coil Magnum
Your starting weapon. 8+1 capacity. Fires a hypersonic slug that pierces enemies; for best results, position yourself to strike multiple targets with one shot. Fires .500 Coil Slugs. C1 overpenetration.
### SP-MR Shotgun
The SP-MR stands for "Sporting Purpose Marksman Rifled", but a gun is a gun. 4+1 capacity shotgun. Fires a patented 8ga. multi-purpose "shapeshifter" nanotech round that can function as pellets or a slug depending on the firing computer in the weapon, but since this one doesn't *have* a firing computer, it defaults to a slug. Like the Coil Magnum, overpenetrates enemies, but is best used against larger targets. Replaces Shotgun. C2 overpenetration, does double damage against enemies it can't penetrate.
### Ronin Arms "Ultra Samurai" Combat Rifle
Marketed as "the katana of the modern age" by people who have never picked up a gun *or* a sword. 30+1 capacity rifle. Fires 5mm frangible rifle rounds that deal enough damage to kill most human-sized targets in under 3 shots. Licensed to the Verdict Dept. after public relations issues stemming from unavoidable collateral damage caused by the SI Coil Magnum's ability to penetrate solid surfaces and targets. Comes with both semi and full auto firing modes. Replaces Chaingun. C3 overpenetration.
### RD-MST Shotgun
RD-MST stands for Riot Dispersion, Multiple Scattered Targets. This shotgun does technically disperse rioters. Across the nearest wall. 3+1 capacity shotgun firing the same "shapeshifter" nanotech shells as the SP-MR. However, the RD-MST's fire control computer shapes the shell into a cluster of evenly-spaced flechettes, tearing through small crowds with ease. Regrettably, the flechettes have subpar flight characteristics past a 256 unit range, causing them to begin deviating from their flightpath. Replaces SSG. C1 overpenetration.
### 40mm Grenade Launcher
Despite all the advances that have been made in weapons tech, the grenade launcher continues to be a simple favorite. Loads 40mm shaped charge grenades that do impressive damage on impact as well as enough splash damage to kill human-sized targets in a wide radius. Replaces RL. Note: Grenades are hard to come by. Rocket *boxes* are replaced with one grenade, and regular rockets are typically replaced with shells instead. After 256MU, does not overpenetrate due to contact detonation system. Before 256MU, C2 overpen, limited damage, does not detonate.
### "Vajra" Plasma Bolt Weapon
The Vajra uses a specialized cartridge containing both a dense metal sphere and an even denser capacitor. Firing the weapon discharges the capacitor in order to magnetize the sphere and surround it with ionized gases, creating plasma. The resulting "plasma bolt" does splash damage in a small radius, making it highly effective against individual targets. C2 overpenetration.
### Smart Laser Cannon
An experimental weapon which uses nanotech to create, essentially, homing lasers. Recharges using an internal fusion core, over a lengthy period of time.