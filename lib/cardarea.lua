local pos_factor = 15

local orig_set_screen_positions = set_screen_positions
function set_screen_positions()
    orig_set_screen_positions()

    if G.STAGE == G.STAGES.RUN then
        for k,v in pairs(Unjank.config.cardarea) do
            if G[k] then 
                G[k].T.x = G[k].T.x + v.x*pos_factor
                G[k].T.y = G[k].T.y + v.y*pos_factor
            end
        end
    end
end

function G.FUNCS.unjank_adjust_cardarea(a)
    local areas = {}
	local no_areas = true
	for k,v in pairs(Unjank.config.cardarea) do
		if G[k] then
			areas[k] = G[k]
			no_areas = false
		end
	end
    if not no_areas then
        G.FUNCS.exit_overlay_menu()

        G.ADJUST_AREAS_SELECTION = UIBox({
            definition = unjank_cardarea_selection_box(areas),
            config = {
                align = "cm",
                major = G.ROOM_ATTACH,
                --offset = {x = 0, y = 3.2},
                bond = "Weak",
                instance_type = "POPUP",
            },
        })
    else
        print("[No areas found]")
    end
end

function Unjank.update_area_pos(a)
    local pos = G[a].T
    pos.x = pos.x - (Unjank.old_cardarea[a].x*pos_factor) + (Unjank.config.cardarea[a].x*pos_factor)
    pos.y = pos.y - (Unjank.old_cardarea[a].y*pos_factor) + (Unjank.config.cardarea[a].y*pos_factor)
    Unjank.old_cardarea[a].x = Unjank.config.cardarea[a].x
    Unjank.old_cardarea[a].y = Unjank.config.cardarea[a].y
end

function G.FUNCS.unjank_adjust_area(a)
    G.ADJUST_AREAS_SELECTION:remove()
    G.ADJUST_AREAS = UIBox({
        definition = unjank_cardarea_box(a.config.ref_table),
        config = {
            align = "cm",
            major = G.ROOM_ATTACH,
            offset = {x = 0, y = 3.2},
            bond = "Weak",
            instance_type = "POPUP",
        },
    })
end


function G.FUNCS.unjank_reset_area(a)
	Unjank.config.cardarea[a.config.ref_table].x = 0
    Unjank.config.cardarea[a.config.ref_table].y = 0
	Unjank.update_area_pos(a.config.ref_table)
end

function G.FUNCS.exit_area_box()
	SMODS.save_all_config()
	G.ADJUST_AREAS:remove()
	G.FUNCS.openModUI_Unjank()
end

function unjank_cardarea_selection_box(areas)
	G.E_MANAGER:add_event(Event({
		blockable = false,
		func = function()
			G.REFRESH_ALERTS = true
			return true
		end,
	}))
    local buttons = {}
    for k,v in pairs(areas) do
        buttons[k] = UIBox_button{
            label = { k },
			ref_table = k,
            button = "unjank_adjust_area",
            colour = G.C.CHIPS
        }
    end
	local t = Unjank.create_UIBox_generic_options({
		no_back = true,
        blocking = true,
        blockable = true,
		contents = {
			{
				n = G.UIT.R,
				config = { align = 'cm'},
				nodes = {
					{ n = G.UIT.T, config = { text = "Choose which card area to edit", colour = G.C.WHITE, scale = 0.4 }},
				}
			},
			{
				n = G.UIT.R,
				config = { align = 'cm'},
				nodes = {
					{
						n = G.UIT.C,
						config = { align = 'cm',padding = 0.15},
						nodes = buttons
					},
				}
			},
		},
	})
	return t
end

function unjank_cardarea_box(a)
	G.E_MANAGER:add_event(Event({
		blockable = false,
		func = function()
			G.REFRESH_ALERTS = true
			return true
		end,
	}))
	local t = Unjank.create_UIBox_generic_options({
		no_back = true,
        blocking = true,
        blockable = true,
		contents = {
			{
				n = G.UIT.R,
				config = { align = 'cm'},
				nodes = {
					{ n = G.UIT.T, config = { text = "X", colour = G.C.WHITE, scale = 0.4 }},
				}
			},
			{
				n = G.UIT.R,
				config = { align = 'cm'},
				nodes = {
					{
						n = G.UIT.C,
						config = { align = 'cm'},
						nodes = {
							create_slider{
								id = 'slider_red',
								colour = G.C.RED,
								label_scale = 1,
								w = 8, h = 0.5,
								padding = -0.05,
                                unj_area = a,
								ref_table = Unjank.config.cardarea[a],
								ref_value = 'x',
								min = -1, max = 1,
								decimal_places = 3,
								hide_value = true,
							},
						}
					},
				}
			},
			{
				n = G.UIT.R,
				config = { align = 'cm'},
				nodes = {
					{ n = G.UIT.T, config = { text = "Y", colour = G.C.WHITE, scale = 0.4 }},
				}
			},
			{
				n = G.UIT.R,
				config = { align = 'cm'},
				nodes = {
					{
						n = G.UIT.C,
						config = { align = 'cm'},
						nodes = {
							create_slider{
								id = 'slider_red',
								colour = G.C.RED,
								label_scale = 1,
								w = 8, h = 0.5,
								padding = -0.05,
                                unj_area = a,
								ref_table = Unjank.config.cardarea[a],
								ref_value = 'y',
								min = -1, max = 1,
								decimal_places = 3,
								hide_value = true,
							},
						}
					},
				}
			},
			{
				n = G.UIT.R,
				config = { align = 'cm'},
				nodes = {
					{
						n = G.UIT.C,
						config = { align = 'cm'},
						nodes = {
							UIBox_button{
								ref_table = a,
								label = { "Reset Default" },
								button = "unjank_reset_area",
							},
						}
					},
				}
			},
			{
				n = G.UIT.R,
				config = { align = 'cm'},
				nodes = {
					{
						n = G.UIT.C,
						config = { align = 'cm'},
						nodes = {
							UIBox_button{
								colour = G.C.FILTER,
								label = { "Done" },
								button = "exit_area_box",
							},
						}
					},
				}
			}
		},
	})
	return t
end