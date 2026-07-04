-- ════════════════════════════════════════════════════════════════════════════
--  TokyoNight · rich semantic differentiation for C / C++ / CUDA
--  Darcula's DISTINCTION STRUCTURE, painted in TokyoNight's PALETTE
--  LazyVim · Neovim 0.11 · clangd 22
-- ════════════════════════════════════════════════════════════════════════════
--
--  DESIGN INTENT
--  ─────────────
--  Code should read as a MAP: every meaningful token class visually distinct,
--  not grey soup. This file takes the SET of distinctions CLion's Darcula makes
--  (≈11 code color-roles — not a rainbow) and assigns each a TokyoNight hue.
--  Balanced: distinct where it carries information, shared where Darcula shares
--  (e.g. static + instance fields both amber, differing only by italic).
--
--  11 DARCULA CODE ROLES → TokyoNight hue (this file):
--    default text / locals        → fg      #c0caf5
--    keywords, comma, semicolon    → magenta #bb9af7
--    function/method DEFINITION     → blue    #7aa2f7
--    function/method CALL           → cyan    #7dcfff   (distinct from def!)
--    types / classes / structs      → blue1   #2ac3de
--    template type parameters       → teal    #1abc9c
--    member fields / enum members   → amber   #e0af68
--    namespaces                     → purple  #9d7cd8   (distinct from text!)
--    strings                        → green   #9ece6a
--    numbers / constants / builtins → orange  #ff9e64
--    comments                       → comment #565f89
--    doc comments                   → teal-gn #73daca
--    macros / preprocessor          → teal2   #4fd6be
--
--  Darcula makes CALLS the same grey as text — that is the "mush" you disliked.
--  Here CALLS get their own cyan, and NAMESPACES their own purple. Those are the
--  two places this file is deliberately RICHER than Darcula, by request.
--
--  ARCHITECTURE — two independent layers:
--    1. PALETTE (below) — the hues. Edit a hex; everything using it updates.
--    2. ROLE MAP        — which token → which slot. Edit a mapping to recolor
--                         one token class without touching the palette.
--
--  Who colors what:
--    · treesitter → keywords, literals, comments, punctuation, PREPROCESSOR
--    · clangd LSP (@lsp.*) → identifiers; WINS over treesitter; carries the
--        definition-vs-call and static-vs-instance distinctions
--    · clangd emits nothing for keywords/strings/comments/operators → treesitter
--
--  clangd 22 emits declaration/definition/static/readonly/deprecated/
--  defaultLibrary by default. No extra flags needed.
--
--  SELF-SERVICE: cursor on a wrong token → :Inspect → note winning group →
--  edit its line → restart.
-- ════════════════════════════════════════════════════════════════════════════

return {
  { "LazyVim/LazyVim", opts = { colorscheme = "tokyonight" } },

  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = function()
      -- ══════════════════════════════════════════════════════════════════════
      --  PALETTE — TokyoNight Night hues. Edit any hex; roles below follow.
      -- ══════════════════════════════════════════════════════════════════════
      local P = {
        text = "#c0caf5", -- default text, local variables, parameters
        keyword = "#bb9af7", -- keywords, comma, semicolon, escapes (magenta)
        func_def = "#7aa2f7", -- function / method DEFINITION (blue)
        func_call = "#7dcfff", -- function / method CALL (cyan) — distinct!
        type = "#2ac3de", -- types, classes, structs, enums (bright blue)
        typeparam = "#1abc9c", -- template type parameters (teal)
        field = "#e0af68", -- member fields, enum members (amber)
        namespace = "#9d7cd8", -- namespaces (soft purple) — distinct!
        string = "#9ece6a", -- strings / chars (green)
        number = "#ff9e64", -- numbers (orange)
        comment = "#565f89", -- comments (muted blue-grey)
        doccomment = "#73daca", -- doc comments (teal-green)
        preproc = "#4fd6be", -- macros, preprocessor, #include, paths (teal2)
        constant = "#ff9e64", -- constexpr constants (orange)
        builtin = "#ff9e64", -- primitive types void/int/auto, nullptr, bools
        metadata = "#e0af68", -- attributes / annotations
        inlayhint = "#565f89", -- inlay hints
        todo = "#e0af68", -- TODO markers
      }

      return {
        style = "night", -- night | storm | moon (aesthetic only)
        transparent = false,
        styles = {
          comments = { italic = true }, -- set false for plain comments
          keywords = { italic = false },
          functions = {},
          variables = {},
        },

        on_colors = function(c)
          -- Backgrounds/UI kept as TokyoNight. Uncomment to darken toward CLion:
          -- c.bg = "#16161e"; c.bg_dark = "#101014"
        end,

        -- ════════════════════════════════════════════════════════════════════
        --  TREESITTER LAYER — keywords, literals, comments, punctuation, preproc.
        --  Also the pre-clangd look. Every group explicit for editing.
        -- ════════════════════════════════════════════════════════════════════
        on_highlights = function(hl, c)
          hl["@variable"] = { fg = P.text }
          hl["@variable.parameter"] = { fg = P.text }
          hl["@variable.member"] = { fg = P.field } -- a.b / p->b field
          hl["@variable.builtin"] = { fg = P.keyword } -- this / super

          for _, g in ipairs({
            "@keyword",
            "@keyword.function",
            "@keyword.operator",
            "@keyword.return",
            "@keyword.type",
            "@keyword.modifier",
            "@keyword.repeat",
            "@keyword.conditional",
            "@keyword.exception",
            "@keyword.coroutine",
            "@keyword.storage",
          }) do
            hl[g] = { fg = P.keyword }
          end

          for _, g in ipairs({
            "@keyword.import",
            "@keyword.directive",
            "@keyword.directive.define",
            "@preproc",
            "@define",
            "@include",
            "@constant.macro",
            "@function.macro",
            "@string.special.path",
          }) do
            hl[g] = { fg = P.preproc }
          end

          hl["@string"] = { fg = P.string }
          hl["@string.escape"] = { fg = P.keyword }
          hl["@string.special"] = { fg = P.keyword }
          hl["@character"] = { fg = P.string }
          hl["@character.special"] = { fg = P.keyword }
          hl["@number"] = { fg = P.number }
          hl["@number.float"] = { fg = P.number }
          hl["@boolean"] = { fg = P.builtin }
          hl["@constant.builtin"] = { fg = P.builtin }

          hl["@comment"] = { fg = P.comment }
          hl["@comment.documentation"] = { fg = P.doccomment }
          hl["@comment.todo"] = { fg = P.todo, bold = true }
          hl["@comment.note"] = { fg = P.doccomment }
          hl["@comment.warning"] = { fg = P.number }
          hl["@comment.error"] = { fg = c.red }

          hl["@type"] = { fg = P.type }
          hl["@type.builtin"] = { fg = P.builtin } -- int/char/void → orange
          hl["@type.definition"] = { fg = P.type }
          hl["@type.qualifier"] = { fg = P.keyword } -- const/volatile
          hl["@type.parameter"] = { fg = P.typeparam }

          hl["@function"] = { fg = P.func_def }
          hl["@function.call"] = { fg = P.func_call }
          hl["@function.method"] = { fg = P.func_def }
          hl["@function.method.call"] = { fg = P.func_call }
          hl["@constructor"] = { fg = P.type }

          hl["@constant"] = { fg = P.constant }
          hl["@module"] = { fg = P.namespace }
          hl["@namespace"] = { fg = P.namespace }

          hl["@operator"] = { fg = P.text }
          hl["@punctuation.bracket"] = { fg = P.text }
          hl["@punctuation.delimiter"] = { fg = P.text }
          hl["@punctuation.special"] = { fg = P.keyword }
          hl["@punctuation.delimiter.comma"] = { fg = P.keyword }

          hl["@attribute"] = { fg = P.metadata }
          hl["@attribute.builtin"] = { fg = P.metadata }
          hl["@label"] = { fg = P.text }
          hl["LspInlayHint"] = { fg = P.inlayhint, italic = true }
        end,
      }
    end,

    -- ══════════════════════════════════════════════════════════════════════
    --  SEMANTIC LAYER (@lsp.*) — CLion distinctions, applied last (unbeatable).
    --  Edit a ROLE once; it expands across cpp/c/cuda.
    -- ══════════════════════════════════════════════════════════════════════
    config = function(_, opts)
      require("tokyonight").setup(opts)

      -- Mirror of PALETTE (keep in sync if you retune above).
      local P = {
        text = "#c0caf5",
        keyword = "#bb9af7",
        func_def = "#7aa2f7",
        func_call = "#7dcfff",
        type = "#2ac3de",
        typeparam = "#1abc9c",
        field = "#e0af68",
        namespace = "#9d7cd8",
        preproc = "#4fd6be",
        constant = "#ff9e64",
        builtin = "#ff9e64",
      }

      local roles = {
        ["type.variable"] = { fg = P.text },
        ["type.parameter"] = { fg = P.text },
        ["type.property"] = { fg = P.field },
        ["type.function"] = { fg = P.func_call }, -- CALL → cyan
        ["type.method"] = { fg = P.func_call }, -- method CALL → cyan
        ["type.namespace"] = { fg = P.namespace }, -- namespace → purple
        ["type.class"] = { fg = P.type },
        ["type.struct"] = { fg = P.type },
        ["type.enum"] = { fg = P.type },
        ["type.enumMember"] = { fg = P.field, italic = true },
        ["type.type"] = { fg = P.type },
        ["type.typeParameter"] = { fg = P.typeparam, italic = true },
        ["type.concept"] = { fg = P.type },
        ["type.interface"] = { fg = P.type },
        ["type.primitive"] = { fg = P.builtin }, -- void/int/auto → orange
        ["type.macro"] = { fg = P.preproc },

        ["typemod.function.declaration"] = { fg = P.func_def }, -- def → blue
        ["typemod.function.definition"] = { fg = P.func_def },
        ["typemod.method.declaration"] = { fg = P.func_def },
        ["typemod.method.definition"] = { fg = P.func_def },
        ["typemod.method.static"] = { fg = P.func_def, italic = true },
        ["typemod.function.static"] = { fg = P.func_def, italic = true },

        ["typemod.property.static"] = { fg = P.field, italic = true },
        ["typemod.variable.static"] = { fg = P.field, italic = true },
        ["typemod.property.readonly"] = { fg = P.field },

        ["typemod.variable.readonly"] = { fg = P.constant },
        ["typemod.parameter.readonly"] = { fg = P.text },
        ["typemod.variable.readonly.static"] = { fg = P.constant },

        ["typemod.type.deduced"] = { fg = P.builtin },
        ["typemod.class.deduced"] = { fg = P.builtin },
        ["typemod.type.defaultLibrary.deduced"] = { fg = P.builtin },

        ["typemod.class.defaultLibrary"] = { fg = P.type },
        ["typemod.struct.defaultLibrary"] = { fg = P.type },
        ["typemod.type.defaultLibrary"] = { fg = P.type }, -- size_t → blue
        ["typemod.function.defaultLibrary"] = { fg = P.func_call }, -- printf() → cyan
        ["typemod.method.defaultLibrary"] = { fg = P.func_call },
        ["typemod.namespace.defaultLibrary"] = { fg = P.namespace }, -- std → purple
        ["typemod.enum.defaultLibrary"] = { fg = P.type },

        ["typemod.function.deprecated"] = { fg = P.func_call, strikethrough = true },
        ["typemod.method.deprecated"] = { fg = P.func_call, strikethrough = true },
        ["typemod.variable.deprecated"] = { fg = P.text, strikethrough = true },
        ["typemod.property.deprecated"] = { fg = P.field, strikethrough = true },

        ["typemod.method.constructorOrDestructor"] = { fg = P.type },
        ["typemod.function.constructorOrDestructor"] = { fg = P.type },
      }

      local FTS = { "cpp", "c", "cuda" }
      local function apply()
        local set = vim.api.nvim_set_hl
        for suffix, attrs in pairs(roles) do
          for _, ft in ipairs(FTS) do
            set(0, "@lsp." .. suffix .. "." .. ft, attrs)
          end
        end
        for _, g in ipairs({
          "@keyword",
          "@keyword.function",
          "@keyword.operator",
          "@keyword.return",
          "@keyword.type",
          "@keyword.modifier",
          "@keyword.repeat",
          "@keyword.conditional",
          "@keyword.exception",
          "@keyword.coroutine",
        }) do
          set(0, g, { fg = P.keyword })
        end
      end

      apply()
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "tokyonight*",
        callback = apply,
      })
    end,
  },
}
