local in_calloutlonglist = false

function Div(el)
  if el.classes:includes("calloutlonglist") then
    in_calloutlonglist = true
    local processed_content = {}
    for _, elem in ipairs(el.content) do
      table.insert(processed_content, elem:walk({
        RawBlock = function(raw_el)
          if raw_el.format == 'latex' then
            local start_pattern = "\\begin%{minipage%}%[t%]%{\\textwidth - 5.5mm%}"
            local end_pattern = "\\end%{minipage%}"
            raw_el.text = raw_el.text:gsub(start_pattern, "")
            raw_el.text = raw_el.text:gsub(end_pattern, "")
          end
          return raw_el
        end
      }))
    end
    in_calloutlonglist = false
    return pandoc.Div(processed_content, el.attr)
  end
end