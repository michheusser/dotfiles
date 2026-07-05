-- ════════════════════════════════════════════════════════════════════════════
--  TokyoNight · rich semantic differentiation for C / C++ / CUDA
--  Two palettes (TokyoNight + CLion Darcula), one-line switch, shared structure
--  LazyVim · Neovim 0.11 · clangd 22
-- ════════════════════════════════════════════════════════════════════════════
--
--  HOW TO SWITCH PALETTES
--  ──────────────────────
--  Change ONE line, `local ACTIVE = TOKYONIGHT`  →  `local ACTIVE = DARCULA`.
--  Both palettes define the SAME role keys, so the entire token map, the
--  distinction structure (definition vs call, static vs instance, etc.), and
--  every downstream reference stay identical. Only the hues change.
--
--  The role STRUCTURE (≈11 code roles, balanced, not a rainbow) was extracted
--  from CLion's Darcula scheme. TokyoNight recolors those roles in its warmer
--  palette; DARCULA reproduces CLion's own hues. Same skeleton, two skins.
--
--  ARCHITECTURE — two layers you tune independently:
--    1. PALETTE (below)  — the hues. Two provided; pick one via ACTIVE.
--    2. ROLE MAP         — which token → which slot. Edit to recolor a class
--                          without touching either palette.
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

-- ══════════════════════════════════════════════════════════════════════════
--  PALETTES — both define identical role keys. Switch via ACTIVE below.
-- ══════════════════════════════════════════════════════════════════════════

-- TokyoNight Night hues (warm, rich, balanced).
local TOKYONIGHT = {
  text = "#c0caf5", -- default text, local variables, parameters
  keyword = "#bb9af7", -- keywords, comma, semicolon, escapes (magenta)
  func_def = "#7aa2f7", -- function / method DEFINITION (blue)
  func_call = "#7dcfff", -- function / method CALL (cyan) — distinct from def
  type = "#2ac3de", -- types, classes, structs, enums (bright blue)
  typeparam = "#1abc9c", -- template type parameters (teal)
  field = "#e0af68", -- member fields, enum members (amber)
  namespace = "#9d7cd8", -- namespaces (soft purple) — distinct from text
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

-- CLion Darcula hues (exact values from CLion's scheme).
-- NOTE: authentic Darcula makes CALLS and NAMESPACES the same grey as text,
-- which reads flatter. Two options below — pick per taste:
--   func_call = "#A9B7C6"  → authentic Darcula (call == text, no distinction)
--   func_call = "#A9B7C6"  keep, OR set to something distinct to keep the split.
-- Left AUTHENTIC here; uncomment the alt lines to keep the extra distinctions.
local DARCULA = {
  text = "#A9B7C6", -- DEFAULT_IDENTIFIER
  keyword = "#CC7832", -- DEFAULT_KEYWORD (+comma/semicolon/escape)
  func_def = "#FFC66D", -- DEFAULT_FUNCTION_DECLARATION
  func_call = "#A9B7C6", -- DEFAULT_FUNCTION_CALL (authentic: == text)
  -- alt (keep the split): "#B5CEA8" or "#7DCFFF"
  type = "#769AA5", -- DEFAULT_CLASS_REFERENCE (muted teal)
  typeparam = "#507874", -- TYPE_PARAMETER_NAME (dark teal)
  field = "#9876AA", -- DEFAULT_INSTANCE_FIELD / STATIC_FIELD / CONSTANT
  namespace = "#A9B7C6", -- authentic: namespaces == text
  -- alt (keep distinct): "#B5B6E3"
  string = "#6A8759", -- DEFAULT_STRING
  number = "#6897BB", -- DEFAULT_NUMBER
  comment = "#808080", -- DEFAULT_LINE_COMMENT / BLOCK_COMMENT
  doccomment = "#629755", -- DEFAULT_DOC_COMMENT
  preproc = "#BBB529", -- macros / preprocessor / #include / paths
  constant = "#9876AA", -- DEFAULT_CONSTANT (purple; italic added in role map)
  builtin = "#CC7832", -- primitive types void/int/auto → keyword orange
  metadata = "#BBB529", -- DEFAULT_METADATA (annotations)
  inlayhint = "#787878", -- INLINE_PARAMETER_HINT
  todo = "#A8C023", -- TODO_DEFAULT_ATTRIBUTES
}

-- ══════════════════════════════════════════════════════════════════════════
--  THE SWITCH — flip this one line to change palettes.
-- ══════════════════════════════════════════════════════════════════════════
-- local ACTIVE = TOKYONIGHT
local ACTIVE = DARCULA

-- ══════════════════════════════════════════════════════════════════════════
--  Optional: also swap TokyoNight's STYLE variant with the palette. Darcula is
--  darkest; TokyoNight "night" pairs well with its own palette. Aesthetic only.
-- ══════════════════════════════════════════════════════════════════════════
local STYLE = "night" -- night | storm | moon

return {
  { "LazyVim/LazyVim", opts = { colorscheme = "tokyonight" } },

  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = function()
      local P = ACTIVE
      return {
        style = STYLE,
        transparent = false,
        styles = {
          comments = { italic = true }, -- set false for plain comments
          keywords = { italic = false },
          functions = {},
          variables = {},
        },

        on_colors = function(c)
          -- Backgrounds/UI kept as TokyoNight. To approximate CLion's near-black
          -- when using the DARCULA palette, uncomment:
          -- c.bg = "#2B2B2B"; c.bg_dark = "#1E1E1E"
        end,

        -- ════════════════════════════════════════════════════════════════════
        --  TREESITTER LAYER — keywords, literals, comments, punctuation, preproc.
        -- ════════════════════════════════════════════════════════════════════
        on_highlights = function(hl, c)
          hl["@variable"] = { fg = P.text }
          hl["@variable.parameter"] = { fg = P.text }
          hl["@variable.member"] = { fg = P.field }
          hl["@variable.builtin"] = { fg = P.keyword }

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
          hl["@type.builtin"] = { fg = P.builtin }
          hl["@type.definition"] = { fg = P.type }
          hl["@type.qualifier"] = { fg = P.keyword }
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
    -- ══════════════════════════════════════════════════════════════════════
    config = function(_, opts)
      require("tokyonight").setup(opts)
      local P = ACTIVE

      local roles = {
        ["type.variable"] = { fg = P.text },
        ["type.parameter"] = { fg = P.text },
        ["type.property"] = { fg = P.field },
        ["type.function"] = { fg = P.func_call }, -- CALL
        ["type.method"] = { fg = P.func_call }, -- method CALL
        ["type.namespace"] = { fg = P.namespace },
        ["type.class"] = { fg = P.type },
        ["type.struct"] = { fg = P.type },
        ["type.enum"] = { fg = P.type },
        ["type.enumMember"] = { fg = P.field, italic = true },
        ["type.type"] = { fg = P.type },
        ["type.typeParameter"] = { fg = P.typeparam, italic = true },
        ["type.concept"] = { fg = P.type },
        ["type.interface"] = { fg = P.type },
        ["type.primitive"] = { fg = P.builtin }, -- void/int/auto
        ["type.macro"] = { fg = P.preproc },

        ["typemod.function.declaration"] = { fg = P.func_def }, -- def
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
        ["typemod.type.defaultLibrary"] = { fg = P.type },
        ["typemod.function.defaultLibrary"] = { fg = P.func_call },
        ["typemod.method.defaultLibrary"] = { fg = P.func_call },
        ["typemod.namespace.defaultLibrary"] = { fg = P.namespace },
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
