function create_UIBox_customize_deck()
    local suitTabs = {}

    local index = 1
    for i, suit in ipairs(SMODS.Suit:obj_list(true)) do
        if G.COLLABS.options[suit.key] then
            suitTabs[index] = {
                label = localize(suit.key, 'suits_plural'),
                tab_definition_function = G.UIDEF.custom_deck_tab,
                tab_definition_function_args = suit.key
            }
            index = index + 1
        end
    end

    if suitTabs[1] then
        suitTabs[1].chosen = true
    end
    local t = create_UIBox_generic_options({ back_func = 'options', snap_back = nil, contents = {
        {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
        Unjank.create_tabs(
            {tabs = suitTabs, snap_to_nav = true, no_shoulders = true}
        )}}}
    })

    return t
end

function Unjank.create_tabs(args)
    args = args or {}
    args.colour = args.colour or G.C.RED
    args.tab_alignment = args.tab_alignment or 'cm'
    args.opt_callback = args.opt_callback or nil
    args.scale = args.scale or 1
    args.tab_w = args.tab_w or 0
    args.tab_h = args.tab_h or 0
    args.text_scale = (args.text_scale or 0.5)
    args.tabs = args.tabs or {
        {
        label = 'tab 1',
        chosen = true,
        func = nil,
        tab_definition_function = function() return  {n=G.UIT.ROOT, config={align = "cm"}, nodes={
            {n=G.UIT.T, config={text = 'A', scale = 1, colour = G.C.UI.TEXT_LIGHT}}
        }} end
        },
        {
        label = 'tab 2',
        chosen = false,
        tab_definition_function = function() return  {n=G.UIT.ROOT, config={align = "cm"}, nodes={
            {n=G.UIT.T, config={text = 'B', scale = 1, colour = G.C.UI.TEXT_LIGHT}}
        }} end
        },
        {
        label = 'tab 3',
        chosen = false,
        tab_definition_function = function() return  {n=G.UIT.ROOT, config={align = "cm"}, nodes={
            {n=G.UIT.T, config={text = 'C', scale = 1, colour = G.C.UI.TEXT_LIGHT}}
        }} end
        }
    }

    local tab_buttons = {}
    local tab
    for k, v in ipairs(args.tabs) do
        if v.chosen then args.current = {k = k, v = v}; tab = v end
        --tab_buttons[#tab_buttons+1] = UIBox_button({id = 'tab_but_'..(v.label or ''), ref_table = v, button = 'change_tab', label = {v.label}, minh = 0.8*args.scale, minw = 2.5*args.scale, col = true, choice = true, scale = args.text_scale, chosen = v.chosen, func = v.func, colour = args.colour, focus_args = {type = 'none'}})
    end

    tab_buttons[1] = create_option_cycle({
        w = 6,
        ref_table = tab,
        scale = 0.8,
        options = {
            "a",
            "b",
            "c",
            "d",
        },
        opt_callback = 'unjank_change_suit_tab',
        current_option = 1,
    }) 

    local t = 
    {n=G.UIT.R, config={padding = 0.0, align = "cm", colour = G.C.CLEAR}, nodes={
        {n=G.UIT.R, config={align = "cm", colour = G.C.CLEAR}, nodes = {
        (#args.tabs > 1 and not args.no_shoulders) and {n=G.UIT.C, config={minw = 0.7,align = "cm", colour = G.C.CLEAR,func = 'set_button_pip', focus_args = {button = 'leftshoulder', type = 'none', orientation = 'cm', scale = 0.7, offset = {x = -0.1, y = 0}}}, nodes = {}} or nil,
        {n=G.UIT.C, config={id = args.no_shoulders and 'no_shoulders' or 'tab_shoulders', ref_table = args, align = "cm", padding = 0.15, group = 1, collideable = true, focus_args = #args.tabs > 1 and {type = 'tab', nav = 'wide',snap_to = args.snap_to_nav, no_loop = args.no_loop} or nil}, nodes=tab_buttons},
        (#args.tabs > 1 and not args.no_shoulders) and {n=G.UIT.C, config={minw = 0.7,align = "cm", colour = G.C.CLEAR,func = 'set_button_pip', focus_args = {button = 'rightshoulder', type = 'none', orientation = 'cm', scale = 0.7, offset = {x = 0.1, y = 0}}}, nodes = {}} or nil,
        }},
        {n=G.UIT.R, config={align = args.tab_alignment, padding = args.padding or 0.1, no_fill = true, minh = args.tab_h, minw = args.tab_w}, nodes={
        {n=G.UIT.O, config={id = 'tab_contents', object = UIBox{definition = args.current.v.tab_definition_function(args.current.v.tab_definition_function_args), config = {offset = {x=0,y=0}}}}}
        }},
    }}

    return t
end

--[[ G.FUNCS.change_tab = function(e)
    print(e.UIBox)
end ]]
G.FUNCS.unjank_change_suit_tab = function(arg)
    local a = arg.cycle_config.ref_table
    local b = a.tab_definition_function(a.tab_definition_function_args)
    print(b)
end