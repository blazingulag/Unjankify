local pos_factor = 6

local orig_main_menu = Game.main_menu
Game.main_menu = function(change_context)
    local ret = orig_main_menu(change_context)
    G.title_top.T.w = G.title_top.T.w * Unjank.config.menu_width
    G.title_top.T.x = G.title_top.T.x + Unjank.config.menu_pos * pos_factor
    return ret
end

function Unjank.update_width()
    G.title_top.T.w = (G.title_top.T.w/Unjank.old_menu_width) * Unjank.config.menu_width
    Unjank.old_menu_width = Unjank.config.menu_width
end
function Unjank.update_pos()
    G.title_top.T.x = G.title_top.T.x - (Unjank.old_menu_pos * pos_factor) + (Unjank.config.menu_pos * pos_factor)
    Unjank.old_menu_pos = Unjank.config.menu_pos
end

function G.FUNCS.unjank_reset()
	Unjank.config.menu_width = 1
	Unjank.config.menu_pos = 0
	Unjank.update_width()
	Unjank.update_pos()
end

function G.FUNCS.unjank_adjust_menu(a)
	if not G.title_top then return end
	G.FUNCS.exit_overlay_menu()

	G.ADJUST_MENU = UIBox({
		definition = unjank_menu_box(),
		config = {
			align = "cm",
			major = G.ROOM_ATTACH,
			offset = {x = 0, y = 3.2},
			bond = "Weak",
			instance_type = "POPUP",
		},
	})

end

function G.FUNCS.exit_menu_box(a)
	SMODS.save_all_config()
	G.ADJUST_MENU:remove()
	G.FUNCS.openModUI_Unjank()
end

function unjank_menu_box()
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
					{ n = G.UIT.T, config = { text = "Change how far apart cards on the logo are", colour = G.C.WHITE, scale = 0.4 }},
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
								ref_table = Unjank.config,
								ref_value = 'menu_width',
								min = 0.001, max = 1,
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
					{ n = G.UIT.T, config = { text = "Change position of the Balatro logo", colour = G.C.WHITE, scale = 0.4 }},
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
								ref_table = Unjank.config,
								ref_value = 'menu_pos',
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
								label = { "Reset Default" },
								button = "unjank_reset",
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
								button = "exit_menu_box",
							},
						}
					},
				}
			}
		},
	})
	return t
end
