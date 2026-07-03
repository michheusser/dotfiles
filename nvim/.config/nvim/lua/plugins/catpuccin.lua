-- ~/.config/nvim/lua/plugins/catppuccin.lua
-- CLion 2026.1.2 "Darcula" reproduction for LazyVim, layered over Catppuccin (frappe).
--
-- LAYERS (highest priority wins per :Inspect):
--   (1) clangd LSP semantic tokens  -> @lsp.type.* / @lsp.typemod.*  (call/def, static/instance, scope)
--   (2) treesitter captures         -> @*                            (good syntactic base)
--   (3) vim-regex syntax groups     -> Keyword/String/...            (fallback before clangd attaches)
--
-- Neovim priority (":h lsp-semantic-highlight"): @lsp.type.* = vim.hl.priorities.semantic_tokens;
-- @lsp.mod.* is +1; @lsp.typemod.* is +2. So the MOST SPECIFIC typemod group wins (e.g. a readonly
-- static field resolves to @lsp.typemod.*.readonly over @lsp.type.variable).

-------------------------------------------------------------------------------
-- PALETTE  (edit here only; every token references these — never inline hex)
-- Darcula source attribute + font style noted per line.
-------------------------------------------------------------------------------
local d = {
  -- Kept background overrides (UNCHANGED per requirement)
  base = "#060608", -- editor bg
  mantle = "#040406",
  crust = "#020203",

  -- Darcula editor foregrounds (verified: JetBrains intellij-community Darcula palette)
  text = "#A9B7C6", -- TEXT / DEFAULT_IDENTIFIER / operators / labels        | plain
  keyword = "#CC7832", -- DEFAULT_KEYWORD                                        | BOLD
  string = "#6A8759", -- DEFAULT_STRING                                         | plain
  number = "#6897BB", -- DEFAULT_NUMBER                                         | plain
  comment = "#808080", -- DEFAULT_LINE_COMMENT / DEFAULT_BLOCK_COMMENT           | PLAIN (not italic)
  doc_comment = "#629755", -- DEFAULT_DOC_COMMENT                                     | ITALIC
  func_decl = "#FFC66D", -- DEFAULT_FUNCTION_DECLARATION / METHOD_DECLARATION      | plain
  func_call = "#FFC66D", -- DEFAULT_FUNCTION_CALL (CLion = same yellow by default) | plain  <- change to differ
  static_method = "#FFC66D", -- DEFAULT_STATIC_METHOD                                  | ITALIC
  instance_field = "#9876AA", -- DEFAULT_INSTANCE_FIELD                                 | plain (purple)
  static_field = "#9876AA", -- DEFAULT_STATIC_FIELD                                   | ITALIC
  constant = "#9876AA", -- DEFAULT_CONSTANT / enum const                          | ITALIC
  global_var = "#9876AA", -- C++ global variable                                    | ITALIC
  macro = "#BBB529", -- macro / DEFAULT_METADATA                               | plain (olive)
  metadata = "#BBB529", -- annotations / attributes
  type_param = "#507874", -- TYPE_PARAMETER_NAME (template/type param)              | teal
  class_ref = "#769AA5", -- DEFAULT_CLASS_REFERENCE (concepts/builtin types)
  predefined = "#8888C6", -- builtin names (e.g. python self)                       | italic
  keyword_arg = "#AA4926", -- python keyword argument
  todo = "#A8C023", -- TODO/FIXME
  unused = "#808080", -- NOT_USED_ELEMENT (unused symbol grey)
  err_fg = "#BC3F3C", -- error foreground
  err_sp = "#FF0000", -- error undercurl
  warn_fg = "#BBB529", -- warning
  deprecated_fx = "#C3C3C3", -- DEPRECATED_ATTRIBUTES strikethrough color

  -- Darcula editor chrome (tuned to the darker custom base)
  caret_row = "#141418", -- current-line bg
  match_brace = "#3B514D", -- matched brace bg
  ref_read = "#344134", -- identifier-under-caret (read) bg
  ref_write = "#40332B", -- identifier-under-caret (write) bg
  selection = "#214283", -- selection bg
}

-------------------------------------------------------------------------------
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "frappe", -- only the four built-ins are selectable; we recolor frappe's base
      -- Keep dark backgrounds; only base/mantle/crust are overridden (rest inherited from frappe).
      color_overrides = {
        frappe = { base = d.base, mantle = d.mantle, crust = d.crust },
      },
      -- Catppuccin v2+ ALWAYS integrates treesitter + native_lsp + semantic_tokens
      -- (they are no longer opt-in under `integrations`). We drive styles per-group below,
      -- so clear the hard-coded global styles to avoid conflicts:
      no_italic = false,
      no_bold = false,
      styles = { comments = {}, keywords = {}, functions = {}, types = {}, booleans = {} },
      highlight_overrides = {
        -- The function receives the resolved frappe palette; we ignore it and use `d`.
        frappe = function(_)
          return {
            ---------------------------------------------------------------
            -- LAYER 3: BASE VIM SYNTAX (regex fallback, pre-clangd)
            ---------------------------------------------------------------
            Normal = { fg = d.text, bg = d.base },
            Keyword = { fg = d.keyword, style = { "bold" } },
            Statement = { fg = d.keyword, style = { "bold" } },
            Conditional = { fg = d.keyword, style = { "bold" } },
            Repeat = { fg = d.keyword, style = { "bold" } },
            Exception = { fg = d.keyword, style = { "bold" } },
            StorageClass = { fg = d.keyword, style = { "bold" } },
            Structure = { fg = d.keyword, style = { "bold" } },
            Operator = { fg = d.text },
            String = { fg = d.string },
            Character = { fg = d.string },
            Number = { fg = d.number },
            Float = { fg = d.number },
            Boolean = { fg = d.keyword, style = { "bold" } },
            Comment = { fg = d.comment },
            SpecialComment = { fg = d.doc_comment, style = { "italic" } },
            Function = { fg = d.func_decl },
            Identifier = { fg = d.text },
            Type = { fg = d.text },
            Constant = { fg = d.constant, style = { "italic" } },
            PreProc = { fg = d.keyword, style = { "bold" } },
            Macro = { fg = d.macro },
            Define = { fg = d.keyword, style = { "bold" } },
            Include = { fg = d.keyword, style = { "bold" } },
            Label = { fg = d.text },
            Todo = { fg = d.base, bg = d.todo, style = { "bold" } },
            Error = { fg = d.err_fg },

            ---------------------------------------------------------------
            -- LAYER 2: TREESITTER BASE (@* — current canonical names, 2024+ hierarchy)
            ---------------------------------------------------------------
            ["@keyword"] = { fg = d.keyword, style = { "bold" } },
            ["@keyword.function"] = { fg = d.keyword, style = { "bold" } },
            ["@keyword.operator"] = { fg = d.keyword, style = { "bold" } },
            ["@keyword.return"] = { fg = d.keyword, style = { "bold" } },
            ["@keyword.conditional"] = { fg = d.keyword, style = { "bold" } },
            ["@keyword.repeat"] = { fg = d.keyword, style = { "bold" } },
            ["@keyword.exception"] = { fg = d.keyword, style = { "bold" } },
            ["@keyword.import"] = { fg = d.keyword, style = { "bold" } },
            ["@keyword.modifier"] = { fg = d.keyword, style = { "bold" } }, -- const/static/etc
            ["@keyword.type"] = { fg = d.keyword, style = { "bold" } }, -- struct/class/enum
            ["@keyword.directive"] = { fg = d.keyword, style = { "bold" } }, -- #include etc
            ["@keyword.directive.define"] = { fg = d.keyword, style = { "bold" } }, -- #define
            ["@string"] = { fg = d.string },
            ["@string.escape"] = { fg = d.keyword, style = { "bold" } },
            ["@string.special"] = { fg = d.keyword, style = { "bold" } },
            ["@character"] = { fg = d.string },
            ["@character.special"] = { fg = d.keyword, style = { "bold" } },
            ["@number"] = { fg = d.number },
            ["@number.float"] = { fg = d.number },
            ["@boolean"] = { fg = d.keyword, style = { "bold" } },
            ["@comment"] = { fg = d.comment },
            ["@comment.documentation"] = { fg = d.doc_comment, style = { "italic" } },
            ["@comment.todo"] = { fg = d.base, bg = d.todo, style = { "bold" } },
            ["@comment.note"] = { fg = d.base, bg = d.number, style = { "bold" } },
            ["@comment.warning"] = { fg = d.base, bg = d.warn_fg, style = { "bold" } },
            ["@comment.error"] = { fg = d.base, bg = d.err_fg, style = { "bold" } },
            ["@operator"] = { fg = d.text },
            ["@punctuation.bracket"] = { fg = d.text },
            ["@punctuation.delimiter"] = { fg = d.text },
            ["@punctuation.special"] = { fg = d.keyword, style = { "bold" } },
            ["@function"] = { fg = d.func_decl },
            ["@function.call"] = { fg = d.func_call },
            ["@function.method"] = { fg = d.func_decl },
            ["@function.method.call"] = { fg = d.func_call },
            ["@function.macro"] = { fg = d.macro },
            ["@function.builtin"] = { fg = d.func_decl },
            ["@constructor"] = { fg = d.func_decl },
            ["@variable"] = { fg = d.text },
            ["@variable.builtin"] = { fg = d.predefined, style = { "italic" } },
            ["@variable.parameter"] = { fg = d.text },
            ["@variable.member"] = { fg = d.instance_field }, -- struct/class fields
            ["@property"] = { fg = d.instance_field },
            ["@constant"] = { fg = d.constant, style = { "italic" } },
            ["@constant.builtin"] = { fg = d.constant, style = { "italic" } },
            ["@constant.macro"] = { fg = d.macro },
            ["@type"] = { fg = d.text },
            ["@type.builtin"] = { fg = d.keyword, style = { "bold" } }, -- int/char/void
            ["@type.definition"] = { fg = d.text }, -- typedef name
            ["@type.qualifier"] = { fg = d.keyword, style = { "bold" } }, -- const/volatile
            ["@module"] = { fg = d.text },
            ["@namespace"] = { fg = d.text },
            ["@label"] = { fg = d.text },
            ["@preproc"] = { fg = d.keyword, style = { "bold" } },
            ["@attribute"] = { fg = d.metadata },

            ---------------------------------------------------------------
            -- LAYER 2b: TREESITTER C/C++ specifics
            ---------------------------------------------------------------
            ["@type.qualifier.cpp"] = { fg = d.keyword, style = { "bold" } },
            ["@keyword.storage.cpp"] = { fg = d.keyword, style = { "bold" } },
            ["@variable.member.cpp"] = { fg = d.instance_field },
            ["@function.macro.cpp"] = { fg = d.macro },
            ["@constant.macro.cpp"] = { fg = d.macro },
            ["@type.qualifier.c"] = { fg = d.keyword, style = { "bold" } },
            ["@variable.member.c"] = { fg = d.instance_field },

            ---------------------------------------------------------------
            -- LAYER 1: LSP SEMANTIC TOKENS — TYPE  (@lsp.type.<type>[.<ft>])
            ---------------------------------------------------------------
            ["@lsp.type.class"] = { fg = d.text },
            ["@lsp.type.struct"] = { fg = d.text },
            ["@lsp.type.enum"] = { fg = d.text },
            ["@lsp.type.enumMember"] = { fg = d.constant, style = { "italic" } },
            ["@lsp.type.interface"] = { fg = d.text },
            ["@lsp.type.type"] = { fg = d.text },
            ["@lsp.type.typeParameter"] = { fg = d.type_param },
            ["@lsp.type.namespace"] = { fg = d.text },
            ["@lsp.type.macro"] = { fg = d.macro },
            ["@lsp.type.function"] = { fg = d.func_decl },
            ["@lsp.type.method"] = { fg = d.func_decl },
            ["@lsp.type.property"] = { fg = d.instance_field },
            ["@lsp.type.variable"] = { fg = d.text },
            ["@lsp.type.parameter"] = { fg = d.text },
            ["@lsp.type.comment"] = { fg = d.comment },
            ["@lsp.type.operator"] = { fg = d.text },
            ["@lsp.type.concept"] = { fg = d.class_ref }, -- clangd C++20 concept
            ["@lsp.type.modifier"] = { fg = d.keyword, style = { "bold" } }, -- override/final
            ["@lsp.type.unknown"] = { fg = d.text }, -- dependent names

            ---------------------------------------------------------------
            -- LAYER 1: LSP SEMANTIC TOKENS — TYPEMOD  (the CLion-parity magic)
            -- Format: @lsp.typemod.<type>.<modifier>[.<ft>]
            ---------------------------------------------------------------
            -- call vs. declaration/definition
            ["@lsp.typemod.function.declaration"] = { fg = d.func_decl },
            ["@lsp.typemod.function.definition"] = { fg = d.func_decl },
            ["@lsp.typemod.method.declaration"] = { fg = d.func_decl },
            ["@lsp.typemod.method.definition"] = { fg = d.func_decl },
            -- static vs. instance (static = italic, per Darcula)
            ["@lsp.typemod.function.static"] = { fg = d.static_method, style = { "italic" } },
            ["@lsp.typemod.method.static"] = { fg = d.static_method, style = { "italic" } },
            ["@lsp.typemod.property.static"] = { fg = d.static_field, style = { "italic" } },
            ["@lsp.typemod.variable.static"] = { fg = d.static_field, style = { "italic" } },
            -- scope-based coloring (globals italic; class scope = member purple)
            ["@lsp.typemod.variable.globalScope"] = { fg = d.global_var, style = { "italic" } },
            ["@lsp.typemod.variable.fileScope"] = { fg = d.global_var, style = { "italic" } },
            ["@lsp.typemod.variable.classScope"] = { fg = d.instance_field },
            ["@lsp.typemod.variable.functionScope"] = { fg = d.text }, -- local vars = default text
            -- readonly / const
            ["@lsp.typemod.variable.readonly"] = { fg = d.constant, style = { "italic" } },
            ["@lsp.typemod.property.readonly"] = { fg = d.instance_field },
            ["@lsp.typemod.parameter.readonly"] = { fg = d.text },
            -- default library (std::) rendered like a class reference / function
            ["@lsp.typemod.class.defaultLibrary"] = { fg = d.class_ref },
            ["@lsp.typemod.type.defaultLibrary"] = { fg = d.class_ref },
            ["@lsp.typemod.function.defaultLibrary"] = { fg = d.func_decl },
            ["@lsp.typemod.variable.defaultLibrary"] = { fg = d.constant, style = { "italic" } },
            -- constructors/destructors (clangd extension: constructorOrDestructor)
            ["@lsp.typemod.method.constructorOrDestructor"] = { fg = d.func_decl },
            -- mutable-reference emphasis (clangd usedAsMutableReference/Pointer) — optional accent
            ["@lsp.typemod.variable.usedAsMutableReference"] = { fg = d.text, style = { "underline" } },
            ["@lsp.typemod.parameter.usedAsMutableReference"] = { fg = d.text, style = { "underline" } },
            -- deprecated crossed out everywhere (mod-level so it applies to all types)
            ["@lsp.mod.deprecated"] = { style = { "strikethrough" }, sp = d.deprecated_fx },

            ---------------------------------------------------------------
            -- PER-LANGUAGE (JSON / XML / Python / Bash / YAML / TOML / INI)
            ---------------------------------------------------------------
            -- JSON: keys purple like Darcula property keys, strings green, numbers blue
            ["@property.json"] = { fg = d.instance_field },
            ["@label.json"] = { fg = d.instance_field },
            ["@string.json"] = { fg = d.string },
            -- XML/HTML
            ["@tag.xml"] = { fg = d.keyword, style = { "bold" } },
            ["@tag.attribute.xml"] = { fg = d.metadata },
            ["@tag.delimiter.xml"] = { fg = d.text },
            ["@tag"] = { fg = d.keyword, style = { "bold" } },
            ["@tag.attribute"] = { fg = d.metadata },
            -- Python
            ["@function.call.python"] = { fg = d.func_call },
            ["@variable.parameter.python"] = { fg = d.keyword_arg },
            ["@variable.builtin.python"] = { fg = d.predefined, style = { "italic" } },
            ["@type.python"] = { fg = d.class_ref },
            ["@lsp.type.class.python"] = { fg = d.class_ref },
            -- Bash/shell
            ["@function.call.bash"] = { fg = d.func_call },
            ["@variable.bash"] = { fg = d.instance_field },
            ["@variable.parameter.bash"] = { fg = d.instance_field },
            -- YAML / TOML / INI (config files): keys purple, values default
            ["@property.yaml"] = { fg = d.instance_field },
            ["@field.yaml"] = { fg = d.instance_field },
            ["@property.toml"] = { fg = d.instance_field },
            ["@type.toml"] = { fg = d.instance_field }, -- [table] headers
            ["@property.ini"] = { fg = d.instance_field },
            ["@label.ini"] = { fg = d.metadata }, -- [section]

            ---------------------------------------------------------------
            -- INLAY HINTS / DIAGNOSTICS / UI ENHANCEMENTS (CLion-signature)
            ---------------------------------------------------------------
            LspInlayHint = { fg = d.comment, bg = d.mantle, style = { "italic" } }, -- param/type hints
            DiagnosticUnnecessary = { fg = d.unused }, -- CLion greys unused code
            DiagnosticError = { fg = d.err_fg },
            DiagnosticWarn = { fg = d.warn_fg },
            DiagnosticUnderlineError = { style = { "undercurl" }, sp = d.err_sp },
            DiagnosticUnderlineWarn = { style = { "undercurl" }, sp = d.warn_fg },
            CursorLine = { bg = d.caret_row }, -- current-line highlight
            MatchParen = { bg = d.match_brace, style = { "bold" } }, -- matching brackets
            LspReferenceText = { bg = d.ref_read }, -- occurrence-under-cursor
            LspReferenceRead = { bg = d.ref_read },
            LspReferenceWrite = { bg = d.ref_write },
            Visual = { bg = d.selection },
          }
        end,
      },
    },
  },

  -- FALLBACK: re-assert the highest-value typemod/deprecated groups AFTER any
  -- LSP dynamic re-registration or colorscheme reload. Uses nvim_set_hl (italic=true
  -- form here, not `style={}`, because this is the raw API not Catppuccin's wrapper).
  {
    "catppuccin/nvim",
    optional = true,
    init = function()
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "catppuccin*",
        callback = function()
          local set = vim.api.nvim_set_hl
          set(0, "@lsp.typemod.variable.globalScope", { fg = "#9876AA", italic = true })
          set(0, "@lsp.typemod.variable.fileScope", { fg = "#9876AA", italic = true })
          set(0, "@lsp.typemod.variable.static", { fg = "#9876AA", italic = true })
          set(0, "@lsp.typemod.property.static", { fg = "#9876AA", italic = true })
          set(0, "@lsp.typemod.function.static", { fg = "#FFC66D", italic = true })
          set(0, "@lsp.typemod.method.static", { fg = "#FFC66D", italic = true })
          set(0, "@lsp.typemod.variable.readonly", { fg = "#9876AA", italic = true })
          set(0, "@lsp.mod.deprecated", { strikethrough = true, sp = "#C3C3C3" })
        end,
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-frappe",
    },
  },
}
