class VerdictHUD : BaseStatusBar {
    // All key info is placed near the center of view for maximum readability.

    HUDFont mConFont;

    override void Init() {
        Super.Init();

        SetSize(0,320,240);

        mConFont = HUDFont.Create("Q2SMFONT");
    }

    override void Draw(int state, double frac) {
        Super.Draw(state,frac);
        BeginHud();

        int frameFlags = DI_ITEM_VCENTER|DI_ITEM_HCENTER|DI_SCREEN_VCENTER|DI_SCREEN_HCENTER;
        int magDisFlags = DI_TEXT_ALIGN_RIGHT|DI_ITEM_RIGHT|DI_ITEM_BOTTOM|DI_SCREEN_VCENTER|DI_SCREEN_HCENTER;
        int magDisColor = Font.CR_SAPPHIRE;
        VerdictOfficer vplr = VerdictOfficer(CPlayer.mo);

        double cscale = (1+CrosshairSize) * 0.5;

        DrawImage("FRAME",(0,0),frameFlags,scale:(1,1)*cscale);
        
        // Weapons go on the left.
        let vwep = VerdictWeapon(CPlayer.readyweapon); // Sometimes the player's weapon is not a VerdictWeapon (i.e., their fists)
        let wep = CPlayer.readyweapon; // In those cases, we use this var instead.
        MagPouch pouch;
        if (vwep) {
            pouch = MagPouch(CPlayer.mo.FindInventory(vwep.pouch));
            int currentMag = vwep.bullets;
            int magMax = pouch.magCapacity;
            Vector2 magpos = (-32,-16);
            Vector2 sparepos = (-32,0);
            DrawString(mConFont,FormatNumber(currentMag,3,3,FNF_FILLZEROS),magpos,magDisFlags,magDisColor,scale: (2,2));
            if (vwep.chamber) {
                DrawImage("VERTBAR",(-28,0),frameFlags);
            }
            for (int i = 0; i < pouch.mags.size(); i++) {
                Vector2 p = sparepos;
                p.y += i * 8;
                if (pouch.mags[i] >= 0) {
                    DrawString(mConFont,FormatNumber(pouch.mags[i],3,3,FNF_FILLZEROS),p,magDisFlags,magDisColor);
                } else {
                    DrawString(mConFont,"---",p,magDisFlags,magDisColor);
                }
            }
        }

        // Armor and health goes on the right.
        int hp = CPlayer.Health;
        int arm = GetAmount("VerdictArmor");
        int maxarm = 400;
        if (vplr.healdelay <= 0 || CPlayer.mo.GetAge() % 10 > 4) {
            DrawBar("VERTBAR","VERTBG",hp,100,(28,0),0,SHADER_VERT|SHADER_REVERSE,frameFlags);
        }
        DrawBar("VERTBAR2","VERTBG",arm,maxarm,(32,0),0,SHADER_VERT|SHADER_REVERSE,frameFlags);
    }
}