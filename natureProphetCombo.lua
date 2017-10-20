local prophet = {}

prophet.optionEnable = Menu.AddOption({ "Hero Specific", "Nature's Prophet" }, "Enabled", "Enabled?")
prophet.optionColdSnap = Menu.AddKeyOption({ "Hero Specific", "Nature's Prophet", }, "Combo key", Enum.ButtonCode.KEY_M)

prophet.nextTick = 0
prophet.usingNow = false
prophet.enemy = nill

function prophet.OnUpdate()
    if not Menu.IsEnabled(prophet.optionEnable) then
        return
    end
    local myHero = Heroes.GetLocal()
    if myHero == nill then
        return
    end

    if NPC.GetUnitName(myHero) ~= "npc_dota_hero_furion" then
        return
    end

    local sprout = NPC.GetAbilityByIndex(myHero, 0)
    local naturesCall = NPC.GetAbilityByIndex(myHero, 2)
    local myMana = NPC.GetMana(myHero)

    if Menu.IsKeyDownOnce(prophet.optionColdSnap) then
        local enemy = Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY)

        if enemy == nil then
            return
        end

        Ability.CastPosition(sprout, Entity.GetAbsOrigin(enemy))
        usingNow = true
        nextTick = os.clock() + 3
        prophet.enemy = enemy
    end

    if os.clock() < prophet.nextTick then
        return
    end
    if not usingNow then
        return
    end

    Ability.CastPosition(naturesCall, Entity.GetAbsOrigin(prophet.enemy))

    usingNow = false
    enemy = nill
end


return prophet