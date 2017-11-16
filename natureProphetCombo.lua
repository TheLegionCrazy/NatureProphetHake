local prophet = {}

prophet.optionEnable = Menu.AddOption({ "Hero Specific", "Nature's Prophet" }, "Enabled", "Enabled?")
prophet.optionColdSnap = Menu.AddKeyOption({ "Hero Specific", "Nature's Prophet", }, "Combo key", Enum.ButtonCode.KEY_M)

local slow = 0
prophet.enemy = nil
prophet.enemyLocation = nil;

function prophet.OnUpdate()
    if not Menu.IsEnabled(prophet.optionEnable) then
        return
    end
    local myHero = Heroes.GetLocal()
    if myHero == nil then
        return
    end

    if NPC.GetUnitName(myHero) ~= "npc_dota_hero_furion" then
        return
    end

    local sprout = NPC.GetAbilityByIndex(myHero, 1)
    local naturesCall = NPC.GetAbilityByIndex(myHero, 3)
    local myMana = NPC.GetMana(myHero)

    if Menu.IsKeyDownOnce(prophet.optionColdSnap) then
        local enemy = Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY)

        if enemy == nil then
            return
        end

        prophet.enemyLocation = Entity.GetAbsOrigin(enemy)
        prophet.enemy = enemy

        comboProphet(myHero, myMana)
    else
        enemy = nil
        enemyLocation = nil
        slow = 0
    end
end

function comboProphet(myHero, myMana)

    local sprout = NPC.GetAbilityByIndex(myHero, 0)
    local naturesCall = NPC.GetAbilityByIndex(myHero, 2)

    local enemy = prophet.enemy
    local pos_enemy = prophet.enemyLocation

    if sprout ~= nil and GameRules.GetGameTime() >= slow then
        if Ability.IsCastable(sprout, myMana) then
            Ability.CastPosition(sprout, pos_enemy)
            slow = GameRules.GetGameTime() + 2.555 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
        end
    end
    if naturesCall ~= nil and GameRules.GetGameTime() >= slow then
        if Ability.IsCastable(naturesCall, myMana) then
            Ability.CastPosition(naturesCall, pos_enemy)
            slow = GameRules.GetGameTime() + 1.555 + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING)
        end
    end
    if GameRules.GetGameTime() >= slow then
        Player.PrepareUnitOrders(Players.GetLocal(), 4, enemy, Vector(0, 0, 0), enemy, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, myHero)
    end
end

return prophet
