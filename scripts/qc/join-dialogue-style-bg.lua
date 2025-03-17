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

script_name = "Обедини реплики с тире"
script_description = "Обедини маркираните реплики с тире пред втората и следващите"
script_author = "ShadeSeeker"
script_version = "0.0.2"

-- change these if you want
local first_line_prefix = ""
local next_line_prefix = "- "

function join_dialoue_style_possible(subtitles, selected_lines, active_line)
    return #selected_lines >= 2
end

function join_dialoue_style(subtitles, selected_lines, active_line)
    if #selected_lines < 2 then
        return
    end
    
    local first_line_index = selected_lines[1]
    local first_line = subtitles[first_line_index]
    local text = first_line_prefix .. first_line.text
    local end_time = first_line.end_time
    local indexes_to_remove = {}
    
    for i = 2, #selected_lines do
        local next_line_index = selected_lines[i]
        local next_line = subtitles[next_line_index]
        text = text .. "\\N" .. next_line_prefix .. next_line.text
        end_time = next_line.end_time
        table.insert(indexes_to_remove, next_line_index)
    end
    
    first_line.text = text
    first_line.end_time = end_time
    
    subtitles[first_line_index] = first_line
    
    subtitles.delete(indexes_to_remove)

    aegisub.set_undo_point(script_name)
    
    return {first_line_index}
end

aegisub.register_macro(script_name, script_description, join_dialoue_style, join_dialoue_style_possible)
