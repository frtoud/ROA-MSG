--[[
USAGE
run as a script using aseprite.exe
ex: aseprite -b --script-param filename="animtest.aseprite" --script 'export.lua'

Animation file will be processed as follows:

- GREEN pixels (0x00FF00) are converted to glitch patterned background
- RED pixels (0xFF0000) are converted to fullbright-green

- ORANGE tags are exported as-is
- RED tags are exported at double size
- GREEN tags are exported with _hurt versions
- other tags are ignored

- HURTBOX layer is used to export the _hurt version of animations
]]--

--EDIT THIS if structure of aseprite changes

local options = {}

options.tagcol_animation = Color(0xf7,0xa5,0x47) --are exported as is
options.tagcol_anim_proj = Color(0xfe,0x5b,0x59) --are exported at double size
options.tagcol_anim_hurt = Color(0x6a,0xcd,0x5b) --are exported with _hurt versions

options.tagname_glitch_bg = "BACKGROUND" --name of glitchbg. there should be ONE cel with the background in it

options.layername_hurtbox = "HURTBOX" --name of hurtbox layer
options.layer_ignore_color  = Color(0xfe,0x5b,0x59) --color of layers to ignore

--for offset calculation: where is the base of the sprite?
options.marker_x =  80
options.marker_y = 127

options.output_folder = "outputs/" --relative path, the "/" is important

----------------------------------------------------------------------
--DEFINITIONS
----------------------------------------------------------------------

--convert green (for convenience) into glitch-bg pattern (for sprite shenanigans)
local function apply_pattern(sprite, options)
    
    --find the glitched background cell.
    local glitch_bg_cel_frame = nil
    local glitch_bg_cel = nil
    for i,t in ipairs(sprite.tags) do
        if t.name == options.tagname_glitch_bg
        and t.fromFrame == t.toFrame then
            glitch_bg_cel_frame = t.fromFrame.frameNumber
        end
    end
    for i,cel in ipairs(sprite.cels) do
        if cel.frameNumber == glitch_bg_cel_frame
        and not cel.image:isEmpty() then
            glitch_bg_cel = cel
        end
    end

    --failed to get glitchbg, abort
    if glitch_bg_cel == nil then return end

    local G = Color(0,255,0)
    local G_pix = nil
    local palette = sprite.palettes[1]
    for i = 0, #palette-1, 1 do
        if (palette:getColor(i) == G) then
            G_pix = i
        end
    end

    for i,cel in ipairs(sprite.cels) do
        if not (cel == glitch_bg_cel )
        and not cel.image:isEmpty() then --pointless otherwise
            
            for it in cel.image:pixels() do
                if it() == G_pix then
                    it(glitch_bg_cel.image:getPixel(it.x + cel.position.x, it.y + cel.position.y))
                end
            end
        end
    end


end

--convert red (for convenience) into green (for hurtbox convention)
local function convert_hurtboxes(sprite, options)
    
    local R = Color(255,0,0) 
    local G = Color(0,255,0) 
    
    local palette = sprite.palettes[1]
    for i = 0, #palette-1, 1 do
        if (palette:getColor(i) == R) then
            palette:setColor(i, G)
        end
    end
end

--assume file is valid open io, spr_name is a string, x/y are numbers
local function write_offset(file, spr_name, x, y, add_true)
    add_true = add_true or false

    local line = 'sprite_change_offset("'.. spr_name .. '", ' .. x .. ', ' .. y 
    if (add_true) then 
        line = line .. ', true'
    end
    line = line .. ');\n'
    io.write(line)
end

--exports a tag as an animation file
--assume offset_file is valid open io, tag is a valid tag
local function export(sprite, tag, offset_file, options)

    do_hurtbox = (tag.color == options.tagcol_anim_hurt) --do extra hurtbox steps
    do_projectile = (tag.color == options.tagcol_anim_proj) --export at 200%
    
    local anim_name = string.lower(tag.name)
    local anim_suffix = "_strip" .. tag.frames .. ".png"


    --remove all frames not inside this animation tag
    app.transaction(function() --"filter-shrinkwrap" transaction 

        if not do_hurtbox then
            --remove hurtbox visibility pre-cropping for optimization on non-hurtboxed sprites
            for i,layer in ipairs(sprite.layers) do
                layer.isVisible = not (layer.name == options.layername_hurtbox)
            end
        end

        local _irrelevantFrames = {}

        for frameIndex, frame in ipairs(sprite.frames) do
            if (tag.toFrame.frameNumber < frameIndex or frameIndex < tag.fromFrame.frameNumber) then
                table.insert(_irrelevantFrames, frame)
            end
        end

        if #_irrelevantFrames > 0 then
            app.range.frames = _irrelevantFrames
            app.command.RemoveFrame()
        end

        --"shrinkwrap" remaining contents
        --this makes it possible to note the offsets as it gets resized
        --EVEN when the resizing puts the reference point out of bounds! amazing!
        sprite.selection = Selection(Rectangle(options.marker_x,options.marker_y,options.marker_x,options.marker_y))
        app.command.AutocropSprite()

        --send the offsets to file
        local scale = (do_projectile and 2) or 1 --ternary lua (careful with those)
        write_offset(offset_file, anim_name, scale * sprite.selection.bounds.x, scale * sprite.selection.bounds.y, do_hurtbox)
    end)
    

    app.transaction(function() --"rest-of-exporting" transaction 
        --remove hurtbox visibility
        for i,layer in ipairs(sprite.layers) do
            layer.isVisible = not (layer.name == options.layername_hurtbox)
        end

        if (do_projectile) then
            app.command.SpriteSize {
                scaleX=2,
                scaleY=2,
            }
        end
        
        app.command.ExportSpriteSheet {
            ui=false,
            askOverwrite=false,
            type=SpriteSheetType.HORIZONTAL,
            textureFilename=options.output_folder .. anim_name .. anim_suffix,
        }
        
        if (do_hurtbox) then
            --switch to hurtbox visibility
            for i,layer in ipairs(sprite.layers) do
                layer.isVisible = (layer.name == options.layername_hurtbox)
            end

            app.command.SpriteSize {
                scaleX=2,
                scaleY=2,
            }

            app.command.ExportSpriteSheet {
                ui=false,
                askOverwrite=false,
                type=SpriteSheetType.HORIZONTAL,
                textureFilename=options.output_folder .. anim_name .. "_hurt" .. anim_suffix,
            }
        end
    end)
    
    
    app.undo() --undo "rest-of-exporting" transaction
    app.undo() --undo "filter-shrinkwrap" transaction

    --reset layer visibility
    for i,layer in ipairs(sprite.layers) do
        layer.isVisible = true
    end

end

----------------------------------------------------------------------
--MAIN SEQUENCE
----------------------------------------------------------------------
local mainsprite = app.open(app.params["filename"])
local offsets_file = io.open("offsets.txt", "w+")
io.output(offsets_file)

app.activeSprite = mainsprite

--general operations
--convert GREENs to glitchBG
apply_pattern(mainsprite, options)
--convert REDs to GREENs (for hurtboxes)
convert_hurtboxes(mainsprite, options)

--remove layers
for i,layer in ipairs(mainsprite.layers) do
    if (layer.color == options.layer_ignore_color) then
        mainsprite:deleteLayer(layer)
    end
end

--export tags
for i,tag in ipairs(mainsprite.tags) do
    if (tag.color == options.tagcol_animation)
    or (tag.color == options.tagcol_anim_proj)
    or (tag.color == options.tagcol_anim_hurt) then
        export(mainsprite, tag, offsets_file, options)
    end
end

--END OF SEQUENCE
io.close(offsets_file)