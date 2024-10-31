-- Lua writer to remove specific minipage environments in marked sections for Quarto/Pandoc

local start_marker = "%% THIS IS THE START OF MY INDICATOR"
local end_marker = "%% HERE IT ENDS"

function Writer(doc, output)
    local output = pandoc.write(doc, "latex")

    local in_filtered_section = false
    local begin_minipage_pattern = "\\begin%{minipage%}%[t%]%{[^}]+%}"
    local end_minipage_pattern = "\\end%{minipage%}"

    local processed_output = {}

    for line in output:gmatch("[^\r\n]+") do
        if line:match(start_marker) then
            in_filtered_section = true
        elseif line:match(end_marker) then
            in_filtered_section = false
        end

        if in_filtered_section then
            if not line:match(begin_minipage_pattern) and not line:match(end_minipage_pattern) then
                table.insert(processed_output, line)
            end
        else
            table.insert(processed_output, line)
        end
    end

    return table.concat(processed_output, "\n")
end
