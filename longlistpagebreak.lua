-- Lua Filter for Quarto: fix long lists in callout boxes for LaTeX and HTML

function Div(el)
  if el.classes:includes("longlistcallout") then
    if quarto.doc.is_format("latex") then
      -- LaTeX format: Add start and end code for longlistcallout
      table.insert(el.content, 1, pandoc.RawBlock("latex", [[
\begin{tcolorbox}[enhanced jigsaw, rightrule=.15mm, breakable, arc=.35mm, leftrule=.75mm, bottomrule=.15mm, colframe=quarto-callout-note-color-frame, colback=white, opacityback=0, left=2mm, toprule=.15mm]
%\begin{minipage}[t]{5.5mm}
{\textcolor{quarto-callout-note-color}{\faInfo\ \ }}
%\end{minipage}%
      ]]))
      table.insert(el.content, pandoc.RawBlock("latex", [[
\end{tcolorbox}
      ]]))
    elseif quarto.doc.is_format("html") or quarto.doc.is_format("epub") then
      -- HTML/EPUB format: Inject start and end divs directly using RawInline
      table.insert(el.content, 1, pandoc.RawInline("html", [[
<div class="callout callout-style-simple callout-note">
<div class="callout-body d-flex">
<div class="callout-icon-container">
<i class="callout-icon"></i>
</div>
<div class="callout-body-container">
      ]]))
      table.insert(el.content, pandoc.RawInline("html", [[
</div>
</div>
</div>
      ]]))
    end
    -- Return modified element to apply changes
    return el
  end
end
