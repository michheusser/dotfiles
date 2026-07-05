-- ============================================================================
--  TokyoNight base * FULL explicit token control * C / C++ / CUDA
--  Every treesitter + LSP group listed. Palette swappable (TokyoNight/Darcula).
--  Edit any line: change fg, add italic=true / bold=true / underline=true, etc.
-- ============================================================================
--
--  SWITCH PALETTE: `local ACTIVE = TOKYONIGHT`  ->  `local ACTIVE = DARCULA`
--  STYLING PER TOKEN: every group below is one editable line. Add any of:
--     italic=true  bold=true  underline=true  strikethrough=true  undercurl=true
--  or change fg = P.<slot>  to any palette slot or literal "#rrggbb".
-- ============================================================================

local TOKYONIGHT = {
  text = "#c0caf5",
  keyword = "#bb9af7",
  func_def = "#7aa2f7",
  func_call = "#7dcfff",
  type = "#2ac3de",
  typeparam = "#1abc9c",
  field = "#e0af68",
  param = "#e0af68",
  local_ = "#c0caf5",
  namespace = "#9d7cd8",
  string = "#9ece6a",
  escape = "#bb9af7",
  number = "#ff9e64",
  boolean = "#ff9e64",
  comment = "#565f89",
  doccomment = "#73daca",
  preproc = "#4fd6be",
  macro = "#4fd6be",
  constant = "#ff9e64",
  builtin = "#ff9e64",
  metadata = "#e0af68",
  operator = "#89ddff",
  bracket = "#c0caf5",
  punct = "#9aa5ce",
  label = "#c0caf5",
  enummember = "#e0af68",
  concept = "#2ac3de",
  inlayhint = "#565f89",
  todo = "#e0af68",
  error = "#f7768e",
  warning = "#e0af68",
}

local DARCULA = {
  text = "#A9B7C6",
  keyword = "#CC7832",
  func_def = "#FFC66D",
  func_call = "#A9B7C6",
  type = "#769AA5",
  typeparam = "#507874",
  field = "#9876AA",
  param = "#A9B7C6",
  local_ = "#A9B7C6",
  namespace = "#A9B7C6",
  string = "#6A8759",
  escape = "#CC7832",
  number = "#6897BB",
  boolean = "#CC7832",
  comment = "#808080",
  doccomment = "#629755",
  preproc = "#BBB529",
  macro = "#908B25",
  constant = "#9876AA",
  builtin = "#CC7832",
  metadata = "#BBB529",
  operator = "#A9B7C6",
  bracket = "#A9B7C6",
  punct = "#CC7832",
  label = "#A9B7C6",
  enummember = "#9876AA",
  concept = "#769AA5",
  inlayhint = "#787878",
  todo = "#A8C023",
  error = "#BC3F3C",
  warning = "#BBB529",
}

--local ACTIVE = TOKYONIGHT
local ACTIVE = DARCULA

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
          comments = { italic = true },
          keywords = { italic = false },
          functions = {},
          variables = {},
        },
        on_colors = function(c)
          -- Darken toward CLion when using DARCULA (uncomment):
          -- c.bg = "#2B2B2B"; c.bg_dark = "#1E1E1E"
        end,

        -- == TREESITTER LAYER - every capture group, explicit ==================
        on_highlights = function(hl, c)
          -- variables ------------------------------------------------------
          hl["@variable"] = { fg = P.local_ }
          hl["@variable.builtin"] = { fg = P.keyword }
          hl["@variable.parameter"] = { fg = P.param }
          hl["@variable.parameter.builtin"] = { fg = P.param }
          hl["@variable.member"] = { fg = P.field }
          -- constants ------------------------------------------------------
          hl["@constant"] = { fg = P.constant }
          hl["@constant.builtin"] = { fg = P.builtin }
          hl["@constant.macro"] = { fg = P.macro }
          -- modules / namespaces -------------------------------------------
          hl["@module"] = { fg = P.namespace }
          hl["@module.builtin"] = { fg = P.namespace }
          hl["@label"] = { fg = P.label }
          -- strings --------------------------------------------------------
          hl["@string"] = { fg = P.string }
          hl["@string.documentation"] = { fg = P.doccomment }
          hl["@string.regexp"] = { fg = P.string }
          hl["@string.escape"] = { fg = P.escape }
          hl["@string.special"] = { fg = P.escape }
          hl["@string.special.symbol"] = { fg = P.escape }
          hl["@string.special.path"] = { fg = P.preproc }
          hl["@string.special.url"] = { fg = P.string, underline = true }
          hl["@character"] = { fg = P.string }
          hl["@character.special"] = { fg = P.escape }
          -- numbers --------------------------------------------------------
          hl["@number"] = { fg = P.number }
          hl["@number.float"] = { fg = P.number }
          hl["@boolean"] = { fg = P.boolean }
          -- types ----------------------------------------------------------
          hl["@type"] = { fg = P.type }
          hl["@type.builtin"] = { fg = P.builtin }
          hl["@type.definition"] = { fg = P.type }
          hl["@type.qualifier"] = { fg = P.keyword }
          hl["@type.parameter"] = { fg = P.typeparam }
          -- attributes -----------------------------------------------------
          hl["@attribute"] = { fg = P.metadata }
          hl["@attribute.builtin"] = { fg = P.metadata }
          hl["@property"] = { fg = P.field }
          -- functions ------------------------------------------------------
          hl["@function"] = { fg = P.func_def }
          hl["@function.builtin"] = { fg = P.func_call }
          hl["@function.call"] = { fg = P.func_call }
          hl["@function.macro"] = { fg = P.macro }
          hl["@function.method"] = { fg = P.func_def }
          hl["@function.method.call"] = { fg = P.func_call }
          hl["@constructor"] = { fg = P.type }
          -- keywords -------------------------------------------------------
          hl["@keyword"] = { fg = P.keyword }
          hl["@keyword.coroutine"] = { fg = P.keyword }
          hl["@keyword.function"] = { fg = P.keyword }
          hl["@keyword.operator"] = { fg = P.keyword }
          hl["@keyword.import"] = { fg = P.preproc }
          hl["@keyword.type"] = { fg = P.keyword }
          hl["@keyword.modifier"] = { fg = P.keyword }
          hl["@keyword.repeat"] = { fg = P.keyword }
          hl["@keyword.return"] = { fg = P.keyword }
          hl["@keyword.debug"] = { fg = P.keyword }
          hl["@keyword.exception"] = { fg = P.keyword }
          hl["@keyword.conditional"] = { fg = P.keyword }
          hl["@keyword.conditional.ternary"] = { fg = P.operator }
          hl["@keyword.directive"] = { fg = P.preproc }
          hl["@keyword.directive.define"] = { fg = P.preproc }
          hl["@keyword.storage"] = { fg = P.keyword }
          -- punctuation ----------------------------------------------------
          hl["@punctuation.delimiter"] = { fg = P.punct }
          hl["@punctuation.bracket"] = { fg = P.bracket }
          hl["@punctuation.special"] = { fg = P.escape }
          -- comments -------------------------------------------------------
          hl["@comment"] = { fg = P.comment }
          hl["@comment.documentation"] = { fg = P.doccomment }
          hl["@comment.error"] = { fg = P.error }
          hl["@comment.warning"] = { fg = P.warning }
          hl["@comment.todo"] = { fg = P.todo, bold = true }
          hl["@comment.note"] = { fg = P.doccomment }
          -- preproc (regex/legacy C family) --------------------------------
          hl["@preproc"] = { fg = P.preproc }
          hl["@define"] = { fg = P.preproc }
          hl["@include"] = { fg = P.preproc }
          hl["@operator"] = { fg = P.operator }
          -- legacy vim-syntax safety net -----------------------------------
          -- These are the OLD regex-based syntax groups. They fire when
          -- tree-sitter is NOT attached to the buffer (fallback highlighting).
          -- Exhaustive: standard Vim groups + C/C++-specific regex groups.

          -- ---- standard Vim syntax groups (the :help group-name set) ------
          hl["Comment"] = { fg = P.comment, italic = true }
          hl["Constant"] = { fg = P.constant }
          hl["String"] = { fg = P.string }
          hl["Character"] = { fg = P.string }
          hl["Number"] = { fg = P.number }
          hl["Float"] = { fg = P.number }
          hl["Boolean"] = { fg = P.boolean }
          hl["Identifier"] = { fg = P.local_ }
          hl["Function"] = { fg = P.func_def }
          hl["Statement"] = { fg = P.keyword } -- throw/if/for etc. base
          hl["Conditional"] = { fg = P.keyword } -- if/else/switch/case
          hl["Repeat"] = { fg = P.keyword } -- for/while/do
          hl["Label"] = { fg = P.label } -- case/default labels
          hl["Operator"] = { fg = P.operator }
          hl["Keyword"] = { fg = P.keyword }
          hl["Exception"] = { fg = P.keyword } -- try/catch/throw
          hl["PreProc"] = { fg = P.preproc }
          hl["Include"] = { fg = P.preproc } -- #include
          hl["Define"] = { fg = P.preproc } -- #define
          hl["Macro"] = { fg = P.macro }
          hl["PreCondit"] = { fg = P.preproc } -- #if/#ifdef/#endif
          hl["Type"] = { fg = P.type }
          hl["StorageClass"] = { fg = P.keyword } -- static/register/volatile
          hl["Structure"] = { fg = P.keyword } -- struct/union/enum
          hl["Typedef"] = { fg = P.type }
          hl["Special"] = { fg = P.escape }
          hl["SpecialChar"] = { fg = P.escape } -- escape sequences
          hl["Tag"] = { fg = P.keyword }
          hl["Delimiter"] = { fg = P.punct }
          hl["SpecialComment"] = { fg = P.doccomment, italic = true }
          hl["Debug"] = { fg = P.keyword }
          hl["Underlined"] = { fg = P.local_, underline = true }
          hl["Ignore"] = { fg = P.comment }
          hl["Error"] = { fg = P.error }
          hl["Todo"] = { fg = P.todo, bold = true }

          -- ---- C-specific regex groups (syntax/c.vim) ---------------------
          hl["cType"] = { fg = P.type }
          hl["cStructure"] = { fg = P.keyword }
          hl["cStorageClass"] = { fg = P.keyword }
          hl["cStatement"] = { fg = P.keyword }
          hl["cConditional"] = { fg = P.keyword }
          hl["cRepeat"] = { fg = P.keyword }
          hl["cLabel"] = { fg = P.label }
          hl["cConstant"] = { fg = P.constant }
          hl["cNumber"] = { fg = P.number }
          hl["cFloat"] = { fg = P.number }
          hl["cString"] = { fg = P.string }
          hl["cCharacter"] = { fg = P.string }
          hl["cSpecial"] = { fg = P.escape }
          hl["cSpecialCharacter"] = { fg = P.escape }
          hl["cFormat"] = { fg = P.escape }
          hl["cOperator"] = { fg = P.operator }
          hl["cComment"] = { fg = P.comment, italic = true }
          hl["cCommentL"] = { fg = P.comment, italic = true }
          hl["cCommentString"] = { fg = P.string }
          hl["cUserLabel"] = { fg = P.label }
          hl["cDefine"] = { fg = P.preproc }
          hl["cInclude"] = { fg = P.preproc }
          hl["cPreProc"] = { fg = P.preproc }
          hl["cPreCondit"] = { fg = P.preproc }
          hl["cMacroName"] = { fg = P.macro }
          hl["cTodo"] = { fg = P.todo, bold = true }

          -- ---- C++-specific regex groups (syntax/cpp.vim) -----------------
          hl["cppStatement"] = { fg = P.keyword }
          hl["cppExceptions"] = { fg = P.keyword } -- try/catch/throw (your bug)
          hl["cppModifier"] = { fg = P.keyword }
          hl["cppType"] = { fg = P.type }
          hl["cppStructure"] = { fg = P.keyword }
          hl["cppStorageClass"] = { fg = P.keyword }
          hl["cppAccess"] = { fg = P.keyword } -- public/private/protected
          hl["cppOperator"] = { fg = P.keyword } -- new/delete/sizeof/etc.
          hl["cppCast"] = { fg = P.keyword } -- static_cast etc.
          hl["cppConstant"] = { fg = P.constant }
          hl["cppNumber"] = { fg = P.number }
          hl["cppBoolean"] = { fg = P.boolean }
          hl["cppString"] = { fg = P.string }
          hl["cppRawString"] = { fg = P.string }
          hl["cppSTLnamespace"] = { fg = P.namespace } -- std
          hl["cppSTLtype"] = { fg = P.type }
          hl["cppSTLfunction"] = { fg = P.func_call }
          hl["cppSTLconstant"] = { fg = P.constant }
          hl["cppSTLexception"] = { fg = P.type }
          hl["cppSTLios"] = { fg = P.func_call }
          hl["cppSTLiterator"] = { fg = P.type }
          hl["cppTemplate"] = { fg = P.keyword }

          hl["LspInlayHint"] = { fg = P.inlayhint, italic = true }
        end,
      }
    end,

    -- == LSP SEMANTIC LAYER (clangd) - every type + typemod, un-suffixed =======
    --  Inherited by ALL C-family extensions (.c .h .hpp .cpp .cc .cu .cuh ...).
    --  Applied on ColorScheme + LspAttach + LspTokenUpdate so it never goes stale.
    config = function(_, opts)
      require("tokyonight").setup(opts)
      local P = ACTIVE

      local roles = {
        -- -- @lsp.type.<kind> (plain semantic types) ------------------------
        ["@lsp.type.variable"] = { fg = P.local_ },
        ["@lsp.type.parameter"] = { fg = P.param },
        ["@lsp.type.property"] = { fg = P.field },
        ["@lsp.type.function"] = { fg = P.func_call }, -- a CALL
        ["@lsp.type.method"] = { fg = P.func_call }, -- a method CALL
        ["@lsp.type.namespace"] = { fg = P.namespace },
        ["@lsp.type.class"] = { fg = P.type },
        ["@lsp.type.struct"] = { fg = P.type },
        ["@lsp.type.enum"] = { fg = P.type },
        ["@lsp.type.enumMember"] = { fg = P.enummember, italic = true },
        ["@lsp.type.type"] = { fg = P.type },
        ["@lsp.type.typeAlias"] = { fg = P.type },
        ["@lsp.type.typeParameter"] = { fg = P.typeparam, italic = true },
        ["@lsp.type.concept"] = { fg = P.concept },
        ["@lsp.type.interface"] = { fg = P.type },
        ["@lsp.type.macro"] = { fg = P.macro },
        ["@lsp.type.modifier"] = { fg = P.keyword },
        ["@lsp.type.operator"] = { fg = P.operator },
        ["@lsp.type.comment"] = { fg = P.comment },
        ["@lsp.type.string"] = { fg = P.string },
        ["@lsp.type.number"] = { fg = P.number },
        ["@lsp.type.keyword"] = { fg = P.keyword },
        ["@lsp.type.unknown"] = { fg = P.text },

        -- -- @lsp.typemod.function.* ----------------------------------------
        ["@lsp.typemod.function.declaration"] = { fg = P.func_def }, -- DEFINITION
        ["@lsp.typemod.function.definition"] = { fg = P.func_def },
        ["@lsp.typemod.function.static"] = { fg = P.func_def, italic = true },
        ["@lsp.typemod.function.defaultLibrary"] = { fg = P.func_call },
        ["@lsp.typemod.function.virtual"] = { fg = P.func_def, italic = true },
        ["@lsp.typemod.function.deprecated"] = { fg = P.func_call, strikethrough = true },
        ["@lsp.typemod.function.constructorOrDestructor"] = { fg = P.type },
        -- -- @lsp.typemod.method.* ------------------------------------------
        ["@lsp.typemod.method.declaration"] = { fg = P.func_def },
        ["@lsp.typemod.method.definition"] = { fg = P.func_def },
        ["@lsp.typemod.method.static"] = { fg = P.func_def, italic = true },
        ["@lsp.typemod.method.defaultLibrary"] = { fg = P.func_call },
        ["@lsp.typemod.method.virtual"] = { fg = P.func_def, italic = true },
        ["@lsp.typemod.method.deprecated"] = { fg = P.func_call, strikethrough = true },
        ["@lsp.typemod.method.constructorOrDestructor"] = { fg = P.type },
        -- -- @lsp.typemod.variable.* ----------------------------------------
        ["@lsp.typemod.variable.static"] = { fg = P.field, italic = true },
        ["@lsp.typemod.variable.readonly"] = { fg = P.constant },
        ["@lsp.typemod.variable.readonly.static"] = { fg = P.constant },
        ["@lsp.typemod.variable.globalScope"] = { fg = P.local_ },
        ["@lsp.typemod.variable.fileScope"] = { fg = P.local_ },
        ["@lsp.typemod.variable.functionScope"] = { fg = P.local_ },
        ["@lsp.typemod.variable.defaultLibrary"] = { fg = P.local_ },
        ["@lsp.typemod.variable.deprecated"] = { fg = P.local_, strikethrough = true },
        -- -- @lsp.typemod.parameter.* ---------------------------------------
        ["@lsp.typemod.parameter.readonly"] = { fg = P.param },
        ["@lsp.typemod.parameter.declaration"] = { fg = P.param },
        -- -- @lsp.typemod.property.* ----------------------------------------
        ["@lsp.typemod.property.static"] = { fg = P.field, italic = true },
        ["@lsp.typemod.property.readonly"] = { fg = P.field },
        ["@lsp.typemod.property.declaration"] = { fg = P.field },
        ["@lsp.typemod.property.deprecated"] = { fg = P.field, strikethrough = true },
        -- -- @lsp.typemod.class / struct / enum.* ---------------------------
        ["@lsp.typemod.class.declaration"] = { fg = P.type },
        ["@lsp.typemod.class.defaultLibrary"] = { fg = P.type },
        ["@lsp.typemod.struct.declaration"] = { fg = P.type },
        ["@lsp.typemod.struct.defaultLibrary"] = { fg = P.type },
        ["@lsp.typemod.enum.defaultLibrary"] = { fg = P.type },
        ["@lsp.typemod.enumMember.readonly"] = { fg = P.enummember, italic = true },
        -- -- @lsp.typemod.type.* (incl. auto/deduced) -----------------------
        ["@lsp.typemod.type.declaration"] = { fg = P.type },
        ["@lsp.typemod.type.deduced"] = { fg = P.builtin }, -- auto
        ["@lsp.typemod.type.defaultLibrary"] = { fg = P.type },
        ["@lsp.typemod.type.defaultLibrary.deduced"] = { fg = P.builtin },
        ["@lsp.typemod.class.deduced"] = { fg = P.builtin },
        -- -- @lsp.typemod.namespace.* ---------------------------------------
        ["@lsp.typemod.namespace.declaration"] = { fg = P.namespace },
        ["@lsp.typemod.namespace.defaultLibrary"] = { fg = P.namespace },
        -- -- @lsp.typemod.concept / macro / unknown -------------------------
        ["@lsp.typemod.concept.declaration"] = { fg = P.concept },
        ["@lsp.typemod.macro.declaration"] = { fg = P.macro },
        ["@lsp.typemod.macro.globalScope"] = { fg = P.macro },
        ["@lsp.typemod.unknown.declaration"] = { fg = P.text },
      }

      -- Keywords are treesitter's; re-assert so nothing dims them under LSP.
      local kw = {
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
      }

      local function apply()
        local set = vim.api.nvim_set_hl
        for g, a in pairs(roles) do
          set(0, g, a)
        end
        for _, g in ipairs(kw) do
          set(0, g, { fg = P.keyword })
        end
      end

      apply()
      vim.api.nvim_create_autocmd({ "ColorScheme", "LspAttach", "LspTokenUpdate" }, { callback = apply })
    end,
  },
}
