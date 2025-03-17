--[[
MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of
the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE.
]]

script_name = "Вкарай таймингите в рамки"
script_description = "Налага мин. и макс. време на избраните репликите, и мин. отстояние между тях."
script_author = "ShadeSeeker, Matey Krastev"
script_version = "0.0.4"

local default_min_duration = 1600
local default_max_duration = 6500
local default_min_distance = 25

function ms_to_time_string(total_ms)
    local centis_part = math.floor(total_ms % 1000 / 100)
    local total_s = math.floor(total_ms / 1000)
    
    local s_part = total_s % 60
    local total_m = math.floor(total_s / 60)
    
    local m_part = total_m % 60
    local h_part = math.floor(total_m / 60)
    
    return string.format("%d:%.2d:%.2d.%.2d", h_part, m_part, s_part, centis_part)
end

function autoadjust_timing_smart(subs, sel)
    button, result_table = aegisub.dialog.display({
        {x=0, y=0, width=2, height=1, class="label", label="Минимално време (ms):" },
        {x=2, y=0, width=2, height=1, class="intedit", name="min_duration", value=default_min_duration, min=100, max=10000 },
        {x=0, y=2, width=2, height=1, class="label", label="Максимално време (ms):" },
        {x=2, y=2, width=2, height=1, class="intedit", name="max_duration", value=default_max_duration, min=1000, max=60000 },
        {x=0, y=1, width=2, height=1, class="label", label="Мин. време между репликите (ms):" },
        {x=2, y=1, width=2, height=1, class="intedit", name="min_distance", value=default_min_distance, min=0, max=1000 },
    })

    if not button then
        return
    end

    -- Check if values are nil, and if so, use the default value
    local min_duration = result_table.min_duration or default_min_duration
    local max_duration = result_table.max_duration or default_max_duration
    local min_distance = result_table.min_distance or default_min_distance
    
    --aegisub.log(3, "Минималното време " .. min_duration .. "ms, максималното време " .. max_duration .. "ms, мин. време между репликите " .. min_distance .. "ms\n")

    if min_duration > max_duration then
        aegisub.log(1, "Минималното време " .. min_duration .. "ms е повече от максималното време " .. max_duration .. "ms\n")
        return
    end

    local lines_changed = 0
    local lines_not_adjusted = 0

    for i = 1, #sel do
        local current_index = sel[i]
        local line = subs[current_index]

        if line.class == "dialogue" and not line.comment then
            local duration = line.end_time - line.start_time
            local original_end_time = line.end_time

            -- Apply maximum duration
            if duration > max_duration then
                line.end_time = line.start_time + max_duration
                duration = max_duration
            end

            -- Apply minimum duration
            if duration < min_duration then
                line.end_time = line.start_time + min_duration
            end
            
            -- Apply minimum distance
            -- Find the next dialogue line
            -- Might need to change this so that it might find a line that's not overlapping
            for next_line_index = current_index + 1, #subs do
                local next_line = subs[next_line_index]
                if next_line.class == "dialogue" and not next_line.comment then
                    local new_end_time = math.min(line.end_time, next_line.start_time - min_distance)
                    if new_end_time - line.start_time < min_duration then
                        -- Ред започващ от (начално време) не може да бъде обработен автоматично. 
                        if lines_not_adjusted == 0 then
                            aegisub.log(2, "Следните редове не могат да бъдат коригирани автоматично така че да изпълняват зададените рамки:\n")
                        end
                        aegisub.log(2, "- ред започващ на " .. ms_to_time_string(line.start_time) .. "\n")
                        lines_not_adjusted = lines_not_adjusted + 1
                        line.end_time = original_end_time
                    else
                        line.end_time = new_end_time
                    end
                    break
                end
            end
            
            -- If we changed the end_time, write back the change
            if original_end_time ~= line.end_time then
                subs[current_index] = line
                lines_changed = lines_changed + 1
            end
        end
    end
    if lines_not_adjusted > 0 then
        aegisub.log(2, "Брой непроменени редове извън рамките: " .. lines_not_adjusted .. "\n")
    end
    aegisub.log(3, "Брой променени редове: " .. lines_changed .. "\n")
    aegisub.set_undo_point(script_name)
end

aegisub.register_macro(script_name, script_description, autoadjust_timing_smart)
