--- STEAMODDED HEADER
--- MOD_NAME: PiJoker
--- MOD_ID: PiJoker
--- MOD_AUTHOR: [Beeks17]
--- MOD_DESCRIPTION: A joker based on Pi

----------------------------------------------
------------MOD CODE -------------------------

PI_DIGITS = {3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5, 8, 9, 7, 9, 3, 2, 3, 8, 4, 6, 2, 6, 4, 3, 3, 8, 3, 2, 7, 9, 5, 0, 2, 8, 8, 4, 1, 9, 7, 1, 6, 9, 3, 9, 9, 3, 7, 5, 1, 0, 5, 8, 2, 0, 9, 7, 4, 9, 4, 4, 5, 9, 2, 3, 0, 7, 8, 1, 6, 4, 0, 6, 2, 8, 6, 2, 0, 8, 9, 9, 8, 6, 2, 8, 0, 3, 4, 8, 2, 5, 3, 4, 2, 1, 1, 7, 0, 6, 7, 9, 8, 2, 1, 4, 8, 0, 8, 6, 5, 1, 3, 2, 8, 2, 3, 0, 6, 6, 4, 7, 0, 9, 3, 8, 4, 4, 6, 0, 9, 5, 5, 0, 5, 8, 2, 2, 3, 1, 7, 2, 5, 3, 5, 9, 4, 0, 8, 1, 2, 8, 4, 8, 1, 1, 1, 7, 4, 5, 0, 2, 8, 4, 1, 0, 2, 7, 0, 1, 9, 3, 8, 5, 2, 1, 1, 0, 5, 5, 5, 9, 6, 4, 4, 6, 2, 2, 9, 4, 8, 9, 5, 4, 9, 3, 0, 3, 8, 1, 9, 6, 4, 4, 2, 8, 8, 1, 0, 9, 7, 5, 6, 6, 5, 9, 3, 3, 4, 4, 6, 1, 2, 8, 4, 7, 5, 6, 4, 8, 2, 3, 3, 7, 8, 6, 7, 8, 3, 1, 6, 5, 2, 7, 1, 2, 0, 1, 9, 0, 9, 1, 4, 5, 6, 4, 8, 5, 6, 6, 9, 2, 3, 4, 6, 0, 3, 4, 8, 6, 1, 0, 4, 5, 4, 3, 2, 6, 6, 4, 8, 2, 1, 3, 3, 9, 3, 6, 0, 7, 2, 6, 0, 2, 4, 9, 1, 4, 1, 2, 7, 3, 7, 2, 4, 5, 8, 7, 0, 0, 6, 6, 0, 6, 3, 1, 5, 5, 8, 8, 1, 7, 4, 8, 8, 1, 5, 2, 0, 9, 2, 0, 9,}

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end


function check_and_increment_pi_index(card_value, expected_digit, ability_extra)
    local is_correct_digit = false

    if card_value == expected_digit then
        is_correct_digit = true
    elseif card_value == 14 and expected_digit == 1 then
        is_correct_digit = true
    elseif card_value >= 11 and card_value <= 13 and expected_digit == 0 then
        is_correct_digit = true
    end


    return is_correct_digit
end





function SMODS.INIT.PiJoker()
    -- Define the localization for the Pi Joker
    G.localization.misc.dictionary.reset = "Reset!"

    local localization = {
        j_pi = {
            name = "Pi Joker",
            text = {
                "This Joker gains {X:mult,C:white}X#1# {} Mult",
                "for every {C:attention}non-scoring played consecutive digit of Pi.",
                "{C:red}Loses {X:mult,C:white}X#1# {C:inactive} on {C:green}incorrect digit",
                "{C:purple}Face cards count as 0s, Aces as 1s",
                "Next five digits of Pi: {C:spectral}#2#",
                "{C:inactive}(Currently {X:mult,C:white} X#3# {C:inactive}){}",
                "Art made by {C:green} Grassy"
            }
        }
    }

-- Update the game's localization with the Pi Joker's data

-- updateLocalizationJelly(localization, "Joker")
-- if supported_languages[G.SETTINGS.language] then
--   local joker_localization = assert(loadstring(love.filesystem.read(SMODS.findModByID("JellyUtil").path .. '/localization/' ..G.SETTINGS.language..'/jokers.lua')))()
--   updateLocalizationJelly(joker_localization, "Joker")
-- end


    -- SMODS.Joker:new(name, slug, config, spritePos, loc_txt, rarity, cost, unlocked, discovered, blueprint_compat, eternal_compat)


    local joker = SMODS.Joker:new(
            "Pi Joker",
            "pi",
            {extra = { current_Xmult = 1, Xmult_mod = .1, pi_index = 1,  } },
            {x = 0, y = 0},
     localization["j_pi"], 3, 7)

    joker:register()

    SMODS.Sprite:new("j_pi", SMODS.findModByID("PiJoker").path, "j_pi(grassy).png", 71, 95, "asset_atli"):register();


    local calculate_jokerref = Card.calculate_joker;
    function Card:calculate_joker(context)

        local ret_val = calculate_jokerref(self, context);
            if self.ability.set == "Joker" and not self.debuff then

                if context.cardarea == G.jokers then

                    if context.before then end
                    if context.joker_main then
                        -- self.ability.pi_index = self.ability.pi_index or 1
                        -- self.ability.pi_multiplier = self.ability.pi_multiplier or 1

                        -- for k, v in ipairs(context.full_hand) do
                        --     local card_value = v:get_id()  -- Assuming this gets the card's value
                        --     local expected_digit = PI_DIGITS[self.ability.extra.pi_index]
                        --     sendDebugMessage("Card value: ")
                        --     sendDebugMessage(tostring(card_value))
                        --     sendDebugMessage(" Expected value: ")
                        --     sendDebugMessage(tostring(expected_digit))
                        --     local is_correct_digit = check_and_increment_pi_index(card_value, expected_digit, self.ability.extra)
                        --     if is_correct_digit then
                        --         if self.ability.extra.pi_index == #PI_DIGITS then
                        --             self.ability.extra.pi_index = 1
                        --         else
                        --             self.ability.extra.pi_index = self.ability.extra.pi_index + 1
                        --         end
                        --         self.ability.extra.current_Xmult = self.ability.extra.current_Xmult + self.ability.extra.Xmult_mod
                        --     else
                        -- -- Incorrect digit played, reset index and multiplier
                        --         --self.ability.extra.pi_index = 1
                        --         if self.ability.extra.current_Xmult > 1 then
                        --             self.ability.extra.current_Xmult = self.ability.extra.current_Xmult - self.ability.extra.Xmult_mod
                        --         end

                        --     end
                        -- end
                        for k, v in ipairs(context.full_hand) do  -- Iterate over played_hand instead of full_hand
                            if not table.contains(context.scoring_hand, v) then  -- Check if the card is not in scoring_hand
                                local card_value = v:get_id()  -- Assuming this gets the card's value
                                local expected_digit = PI_DIGITS[self.ability.extra.pi_index]
                                sendDebugMessage("Card value: " .. tostring(card_value) .. " Expected value: " .. tostring(expected_digit))
                                local is_correct_digit = check_and_increment_pi_index(card_value, expected_digit, self.ability.extra)
                                if is_correct_digit then
                                    if self.ability.extra.pi_index == #PI_DIGITS then
                                        self.ability.extra.pi_index = 1
                                    else
                                        self.ability.extra.pi_index = self.ability.extra.pi_index + 1
                                    end
                                    self.ability.extra.current_Xmult = self.ability.extra.current_Xmult + self.ability.extra.Xmult_mod
                                else
                                    -- Incorrect digit played, reset index and multiplier
                                    --self.ability.extra.pi_index = 1
                                    if self.ability.extra.current_Xmult > 1 then
                                        self.ability.extra.current_Xmult = self.ability.extra.current_Xmult - self.ability.extra.Xmult_mod
                                    end
                                end
                            end
                        end

                        return {
                            message = localize {
                                type = 'variable',
                                key = 'a_xmult',
                                vars = {  self.ability.extra.current_Xmult, self.ability.extra.pi_index }
                            },
                            Xmult_mod = self.ability.extra.current_Xmult,
                            card = self
                        }

                    end
                end
            end
        return ret_val;
    end

    -- SMODS.Jokers.j_pi.calculate = function(self, context)


    --     if SMODS.end_calculate_context(context) then
    --         if self.ability.extra.current_Xmult > 1 then
    --             return {
    --                 message = localize {
    --                     type = 'variable',
    --                     key = 'a_xmult',
    --                     vars = { self.ability.extra.current_Xmult }
    --                 },
    --                 Xmult_mod = self.ability.extra.current_Xmult,
    --                 card = self
    --             }
    --         end
    --     end
    -- end

    local generate_UIBox_ability_tableref = Card.generate_UIBox_ability_table
    function Card.generate_UIBox_ability_table(self)
        local card_type, hide_desc = self.ability.set or "None", nil
        local loc_vars = nil
        local main_start, main_end = nil, nil
        local no_badge = nil

        if self.config.center.unlocked == false and not self.bypass_lock then
            -- For everything that is locked
        elseif card_type == 'Undiscovered' and not self.bypass_discovery_ui then
            -- Any Joker or tarot/planet/voucher that is not yet discovered
        elseif self.debuff then
            -- If the card is a debuff
        elseif card_type == 'Default' or card_type == 'Enhanced' then
            -- For Default or Enhanced cards
        elseif self.ability.set == 'Joker' then
            local customJoker = true

            if self.ability.name == 'Pi Joker' then
                local pi_index = self.ability.extra.pi_index or 1
                local next_digits = table.concat(PI_DIGITS, "", pi_index, pi_index + 4)

                -- Set the localization variables
                loc_vars = {self.ability.extra.Xmult_mod, next_digits, self.ability.extra.current_Xmult}
            else
                customJoker = false
            end

            if customJoker then
                local badges = {}
                if (card_type ~= 'Locked' and card_type ~= 'Undiscovered' and card_type ~= 'Default') or self.debuff then
                    badges.card_type = card_type
                end
                if self.ability.set == 'Joker' and self.bypass_discovery_ui and (not no_badge) then
                    badges.force_rarity = true
                end
                if self.edition then
                    if self.edition.type == 'negative' and self.ability.consumeable then
                        badges[#badges + 1] = 'negative_consumable'
                    else
                        badges[#badges + 1] = (self.edition.type == 'holo' and 'holographic' or self.edition.type)
                    end
                end
                if self.seal then
                    badges[#badges + 1] = string.lower(self.seal) .. '_seal'
                end
                if self.ability.eternal then
                    badges[#badges + 1] = 'eternal'
                end
                if self.pinned then
                    badges[#badges + 1] = 'pinned_left'
                end

                if self.sticker then
                    loc_vars = loc_vars or {}
                    loc_vars.sticker = self.sticker
                end

                return generate_card_ui(self.config.center, nil, loc_vars, card_type, badges, hide_desc, main_start,
                    main_end)
            end
        end

        return generate_UIBox_ability_tableref(self)
    end

end


----------------------------------------------
------------MOD CODE END----------------------
