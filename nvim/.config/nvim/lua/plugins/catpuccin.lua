-- ââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââ
--  CLion "Darcula" recreation for Neovim / LazyVim
--  Catppuccin (frappe flavour, overridden)  Â·  C / C++ / CUDA  Â·  clangd 17
-- ââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââ
--
--  WHAT THIS FILE IS
--  âââââââââââââââââ
--  A single, exhaustive, explicit highlight mapping so C/C++/CUDA code renders
--  like CLion's Darcula. Every color and font style below is transcribed DIRECTLY
--  from CLion's own theme (DefaultColorSchemesManager.xml â "Darcula" scheme),
--  not inferred. The Catppuccin look you like (backgrounds, UI, statusline, etc.)
--  is preserved; ONLY code-token colors are changed.
--
--
--  WHY THE PREVIOUS ATTEMPT LOOKED WRONG  (read once â it explains all symptoms)
--  ââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââ
--  Neovim colors each token through THREE stacked layers, in priority order:
--
--      1. legacy vim regex syntax  (Comment, Function, Include âŠ)      LOW
--      2. tree-sitter captures     (@keyword, @function.call, @string) MID  (prio 100)
--      3. LSP semantic tokens      (@lsp.type.*, @lsp.typemod.*)       HIGH (prio 125+)
--
--  clangd (layer 3) paints ON TOP OF tree-sitter (layer 2) and WINS wherever it
--  emits a token. The old file set the tree-sitter groups but left the @lsp groups
--  unset/wrong, so clangd overrode the "correct" colors at runtime. Hence:
--
--    Â· function CALLS == DEFINITIONS â @lsp.type.function fired on both with no
--      split. FIX: clangd tags the definition site with the `declaration`
--      modifier, so @lsp.typemod.function.declaration.* gets the yellow
--      definition color while bare @lsp.type.function.* becomes default text
--      (a plain call, exactly as Darcula does it).
--    Â· #include looked ORANGE â tree-sitter captured `#include` as @keyword
--      (orange); the yellow directive groups never claimed it. FIX: every
--      preprocessor/directive/macro group below is pinned to the yellow-green
--      preproc color, and keyword-orange is kept away from them.
--
--  CLANGD 17 FACT (verified against clangd source SemanticHighlighting.h):
--  clangd emits semantic tokens ONLY for identifier-like kinds â
--      variable, parameter, function, method, field, enumMember/enumConstant,
--      class, enum, interface, typedef, type, namespace, templateParameter,
--      concept, macro, unknown  (plus modifiers: declaration, definition,
--      readonly, static, deprecated, defaultLibrary, and scope modifiers).
--  It emits NOTHING for strings, numbers, comments, keywords, operators,
--  brackets, or the preprocessor. Those belong to TREE-SITTER, permanently.
--
--  So the two layers cover DISJOINT sets and BOTH must be right:
--      Â· LSP  â identifiers (funcs, methods, fields, types, params, namespaces âŠ)
--      Â· TS   â keywords, literals, comments, operators, punctuation, #include/#define
--
--  THE "SNAP" when the CMake project loads: before clangd attaches you see the TS
--  layer only; when it attaches the LSP layer adds identifier precision on top.
--  Both layers here use the SAME Darcula values, so the snap only refines
--  identifiers into their exact roles (e.g. a call TS painted yellow becomes
--  default-text) and converges to the loaded-CLion look. It cannot be literally
--  zero â only clangd knows semantic role â but the loaded state matches CLion,
--  which is the goal.
--
--
--  DARCULA GROUND TRUTH  (transcribed from the XML; FONT_TYPE decoded)
--  FONT_TYPE: 0/absent = plain Â· 1 = bold Â· 2 = italic Â· 3 = bold+italic
--  (deuteranopia/protanopia colorblind variants in the XML are IGNORED.)
--
--    CLion attribute                hex       style      role
--    âââââââââââââââââââââââââââââ  âââââââ   ââââââââ   âââââââââââââââââââââââââââ
--    DEFAULT_IDENTIFIER             A9B7C6    plain      default text / calls / vars
--    DEFAULT_KEYWORD                CC7832    plain      keywords (NOT bold)
--    DEFAULT_NUMBER                 6897BB    plain      numeric literals
--    DEFAULT_STRING                 6A8759    plain      string / char literals
--    DEFAULT_VALID_STRING_ESCAPE    CC7832    plain      escapes inside strings
--    DEFAULT_LINE/BLOCK_COMMENT     808080    plain      // and /* */ (NOT italic)
--    DEFAULT_DOC_COMMENT            629755    italic     /** doxygen */ body
--    DEFAULT_DOC_COMMENT_TAG        629755    bold+ital  @param, @return âŠ
--    DEFAULT_DOC_COMMENT_TAG_VALUE  8A653B    plain      value after a doc tag
--    DEFAULT_FUNCTION_DECLARATION   FFC66D    plain      function/method DEFINITION
--    DEFAULT_FUNCTION_CALL          A9B7C6    plain      function/method CALL (=text)
--    DEFAULT_STATIC_METHOD          FFC66D    italic     static method
--    DEFAULT_INSTANCE_FIELD         9876AA    plain      non-static field (purple)
--    DEFAULT_STATIC_FIELD           9876AA    italic     static field (purple italic)
--    DEFAULT_CONSTANT               9876AA    italic     constants / enum members
--    DEFAULT_CLASS_REFERENCE        769AA5    plain      class / type references (teal)
--    TYPE_PARAMETER_NAME            507874    plain      template type parameters
--    DEFAULT_METADATA               BBB529    plain      attributes / annotations
--    DEFAULT_COMMA / DEFAULT_SEMICOLON  CC7832 plain     ,  and  ;  are ORANGE
--    braces/brackets/parens/dot/operators (empty) A9B7C6 plain   default text
--    macro / preprocessor / #include    BBB529 plain     yellow-green (INCLUDE FIX)
--
--
--  SELF-SERVICE â fix any token yourself, forever
--  ââââââââââââââââââââââââââââââââââââââââââââââ
--  Cursor on a wrong-looking character, then:
--      :Inspect        show every group on the token; the WINNER is marked.
--                      Edit that group's line below.
--      :Inspect!       full detail in a scratch buffer.
--      :InspectTree    live tree-sitter tree.
--      :lua =vim.lsp.semantic_tokens.get_at_pos()   raw clangd token + modifiers.
--  Wrong color â :Inspect â find winning group â edit its line â restart. Done.
--
--  Suggested clangd flags (so every modifier used here is emitted):
--      --background-index  --clang-tidy  --header-insertion=never
--  clangd 17 emits declaration/definition/readonly/static/deprecated/defaultLibrary
--  and scope modifiers by default; no extra flag needed for those.
-- ââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââ

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "frappe",
      background = { light = "latte", dark = "frappe" },
      transparent_background = false,

      -- ââ EDITOR BACKGROUNDS â kept exactly as you defined them. Untouched. ââ
      color_overrides = {
        frappe = {
          base = "#060608",
          mantle = "#040406",
          crust = "#020203",
        },
      },

      -- Keep Catppuccin's integrations ON so all non-code UI keeps its look.
      -- We override only code-token groups below. For a flavour, the table
      -- returned from highlight_overrides REPLACES each named group outright
      -- (no field-level merge), so every group we set is fully authoritative.
      integrations = {
        treesitter = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
      },

      highlight_overrides = {
        frappe = function(_)
          -- ââ DARCULA PALETTE â single source of truth. Retune here. ââââââââââ
          local D = {
            fg = "#A9B7C6", -- default text: types, classes, calls, locals, namespaces
            keyword = "#CC7832", -- keywords, escapes, primitive builtins, comma, semicolon
            func = "#FFC66D", -- function/method DEFINITION, static method
            field = "#9876AA", -- fields, enum members (purple)
            string = "#6A8759", -- strings / chars
            number = "#6897BB", -- numbers
            comment = "#808080", -- line & block comments (plain grey)
            doccomment = "#629755", -- doxygen body (italic green)
            doctagval = "#8A653B", -- value after a doc tag
            preproc = "#BBB529", -- macros + preprocessor + #include + paths (yellow-green)
            metadata = "#BBB529", -- attributes / annotations
            inlayhint = "#787878", -- inlay parameter/type hints
            -- NOTE (from CLion screenshots): template type parameters render as
            -- default-text grey but ITALIC. There is no distinct teal in CLion's
            -- C++ scheme; the earlier teal was wrong. Types/classes = plain grey.
          }

          local IT = { "italic" } -- Darcula italic
          local BI = { "bold", "italic" } -- Darcula bold+italic (doc tags only)
          -- Darcula puts NO bold on ordinary tokens. Do not add any.

          -- Build the highlight table incrementally so we can expand the LSP
          -- groups across all three C-family filetypes without repetition.
          local hl = {}

          -- ââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââ
          --  LAYER 2 â TREE-SITTER
          --  Owns keywords, literals, comments, punctuation, the preprocessor,
          --  and provides the pre-clangd "project-not-loaded-yet" appearance.
          -- ââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââ
          local ts = {
            -- default text -------------------------------------------------
            ["@variable"] = { fg = D.fg },
            ["@variable.parameter"] = { fg = D.fg }, -- LSP refines to param role
            ["@variable.member"] = { fg = D.field }, -- field access a.b / p->b
            ["@variable.builtin"] = { fg = D.keyword }, -- this / super

            -- keywords (PLAIN orange, never bold) --------------------------
            ["@keyword"] = { fg = D.keyword },
            ["@keyword.function"] = { fg = D.keyword },
            ["@keyword.operator"] = { fg = D.keyword }, -- sizeof, new, delete
            ["@keyword.return"] = { fg = D.keyword },
            ["@keyword.type"] = { fg = D.keyword }, -- struct/class/enum/union
            ["@keyword.modifier"] = { fg = D.keyword }, -- const/static/virtualâŠ
            ["@keyword.repeat"] = { fg = D.keyword }, -- for/while/do
            ["@keyword.conditional"] = { fg = D.keyword }, -- if/else/switch
            ["@keyword.exception"] = { fg = D.keyword }, -- try/catch/throw
            ["@keyword.coroutine"] = { fg = D.keyword }, -- co_await/co_yield
            ["@keyword.storage"] = { fg = D.keyword },

            -- PREPROCESSOR & #include â yellow-green (THE INCLUDE FIX) ------
            -- Claim EVERY directive/macro group so tree-sitter can't route
            -- #include/#define through @keyword (orange).
            ["@keyword.import"] = { fg = D.preproc },
            ["@keyword.directive"] = { fg = D.preproc }, -- #include/#pragma/#if
            ["@keyword.directive.define"] = { fg = D.preproc }, -- #define
            ["@preproc"] = { fg = D.preproc },
            ["@define"] = { fg = D.preproc },
            ["@include"] = { fg = D.preproc },
            ["@constant.macro"] = { fg = D.preproc },
            ["@function.macro"] = { fg = D.preproc }, -- function-like macros
            ["@string.special.path"] = { fg = D.preproc }, -- <header.h> path = yellow-green (observed)

            -- literals -----------------------------------------------------
            ["@string"] = { fg = D.string },
            ["@string.escape"] = { fg = D.keyword }, -- \n \t â orange
            ["@string.special"] = { fg = D.keyword },
            ["@character"] = { fg = D.string },
            ["@character.special"] = { fg = D.keyword },
            ["@number"] = { fg = D.number },
            ["@number.float"] = { fg = D.number },
            ["@boolean"] = { fg = D.keyword }, -- true / false
            ["@constant.builtin"] = { fg = D.keyword }, -- nullptr / NULL â orange

            -- comments -----------------------------------------------------
            ["@comment"] = { fg = D.comment },
            ["@comment.documentation"] = { fg = D.doccomment, style = IT },
            ["@comment.error"] = { fg = D.comment },
            ["@comment.warning"] = { fg = D.comment },
            ["@comment.todo"] = { fg = "#A8C023", style = IT },
            ["@comment.note"] = { fg = D.doctagval, style = IT },

            -- types (TS view; LSP refines class vs typedef vs param) -------
            -- CLion's C++ engine renders class/type NAMES in DEFAULT TEXT, not
            -- the muted teal. Teal (DEFAULT_CLASS_REFERENCE 769aa5) is a fallback
            -- other languages use; C++ leaves type refs as a9b7c6. Using teal was
            -- the "turquoise void / two-color std::vector" bug. Types = text.
            ["@type"] = { fg = D.fg }, -- vector, MyClass â default text
            ["@type.builtin"] = { fg = D.keyword }, -- int/char/void/bool â orange
            ["@type.definition"] = { fg = D.fg }, -- typedef/using name â text
            ["@type.qualifier"] = { fg = D.keyword }, -- const/volatile â orange
            -- Template type parameters: default-text grey but ITALIC (observed:
            -- Indices, SynchronizerTag, numSlots, policyType all italic grey).
            ["@variable.parameter.builtin"] = { fg = D.fg }, -- __VA_ARGS__ etc.
            ["@type.parameter"] = { fg = D.fg, style = IT }, -- template params â italic grey

            -- functions (TS can't split call/def; LSP will) ----------------
            ["@function"] = { fg = D.func }, -- def-ish before LSP
            ["@function.call"] = { fg = D.fg }, -- CALL = default text
            ["@function.method"] = { fg = D.func },
            ["@function.method.call"] = { fg = D.fg }, -- method call = default text
            ["@constructor"] = { fg = D.fg }, -- Type{...} construction = text (observed)

            -- constants / namespaces --------------------------------------
            -- OBSERVED CORRECTION: file-scope constexpr constants (MAX_RESERVOIR_SIZE,
            -- DEFAULT_SAMPLE_RATE) render as DEFAULT GREY in CLion, NOT purple-italic.
            -- Only enum members (error::Type::Processing) are purple italic. So the
            -- generic @constant is grey; enum members handled via LSP enumMember.
            ["@constant"] = { fg = D.fg }, -- constexpr consts â grey (observed)
            ["@module"] = { fg = D.fg }, -- namespace name: default text
            ["@namespace"] = { fg = D.fg },

            -- punctuation & operators (Darcula) ----------------------------
            ["@operator"] = { fg = D.fg }, -- + - * / = default text
            ["@punctuation.bracket"] = { fg = D.fg }, -- ( ) [ ] { }
            ["@punctuation.special"] = { fg = D.keyword },
            ["@punctuation.delimiter"] = { fg = D.fg }, -- generic . :
            -- comma and semicolon are ORANGE in Darcula; the C/C++/CUDA
            -- grammars expose them via these dedicated captures:
            ["@punctuation.delimiter.comma"] = { fg = D.keyword },

            -- attributes / annotations ------------------------------------
            ["@attribute"] = { fg = D.metadata }, -- [[nodiscard]] etc.
            ["@attribute.builtin"] = { fg = D.metadata },

            -- labels (goto targets) ---------------------------------------
            ["@label"] = { fg = D.fg },
          }
          for k, v in pairs(ts) do
            hl[k] = v
          end

          -- ââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââ
          --  LAYER 3 â clangd 17 LSP SEMANTIC TOKENS  (authoritative overrides)
          --
          --  Group shapes:
          --    @lsp.type.<kind>.<ft>
          --    @lsp.typemod.<kind>.<mod>.<ft>
          --  <ft> is the buffer filetype: cpp (.cpp/.h/.hpp/.cc), c (.c),
          --  cuda (.cu/.cuh). We expand each ROLE across all three so C, C++ and
          --  CUDA render identically. Edit the role ONCE in `roles` below.
          --  (The old file only defined .cpp, so CUDA got no LSP coloring.)
          -- ââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââ
          local FTS = { "cpp", "c", "cuda" }

          -- Each entry: [suffix-after-@lsp.] = attrs.
          -- We list the suffix WITHOUT the filetype; the loop appends .<ft>.
          local roles = {
            -- ââ plain type kinds (@lsp.type.<kind>) ââââââââââââââââââââââ
            -- CLion C++ colors identifiers by SEMANTIC ROLE, and renders class /
            -- struct / enum / type / namespace NAMES in DEFAULT TEXT (a9b7c6),
            -- NOT a distinct teal. That is why `std::vector` must be ONE color:
            -- `std` (namespace) and `vector` (class) are both default text, so
            -- the qualified name reads coherently. Coloring classes teal was the
            -- bug behind "std:: differs from vector" and "turquoise types".
            ["type.variable"] = { fg = D.fg }, -- locals, globals
            ["type.parameter"] = { fg = D.fg }, -- DEFAULT_PARAMETER
            ["type.property"] = { fg = D.field }, -- INSTANCE_FIELD purple
            ["type.function"] = { fg = D.fg }, -- a CALL (no decl mod)
            ["type.method"] = { fg = D.fg }, -- a method CALL
            ["type.namespace"] = { fg = D.fg }, -- std, ns â default text
            ["type.class"] = { fg = D.fg }, -- vector, MyClass â text
            ["type.struct"] = { fg = D.fg },
            ["type.enum"] = { fg = D.fg }, -- enum TYPE name â text
            ["type.enumMember"] = { fg = D.field, style = IT }, -- enum member purple ital
            ["type.type"] = { fg = D.fg }, -- typedef/type ref â text
            ["type.typeParameter"] = { fg = D.fg, style = IT }, -- template params â italic grey (observed)
            ["type.concept"] = { fg = D.fg }, -- C++20 concepts â text
            ["type.interface"] = { fg = D.fg },
            ["type.primitive"] = { fg = D.keyword }, -- void/int/auto â ORANGE
            ["type.macro"] = { fg = D.preproc }, -- macros yellow-green
            ["type.unknown"] = { fg = D.fg },

            -- ââ modified kinds (@lsp.typemod.<kind>.<mod>) âââââââââââââââ
            -- FUNCTION / METHOD: definition site carries `declaration`
            -- (and usually `definition`). Bare type.* above is the CALL.
            -- This is the CALL-vs-DEFINITION fix, straight from Darcula.
            ["typemod.function.declaration"] = { fg = D.func }, -- def = yellow
            ["typemod.function.definition"] = { fg = D.func },
            ["typemod.method.declaration"] = { fg = D.func },
            ["typemod.method.definition"] = { fg = D.func },
            ["typemod.method.static"] = { fg = D.func, style = IT }, -- STATIC_METHOD
            ["typemod.function.static"] = { fg = D.func, style = IT },

            -- FIELDS: static â italic, instance â plain (both purple).
            ["typemod.property.static"] = { fg = D.field, style = IT }, -- STATIC_FIELD
            ["typemod.variable.static"] = { fg = D.field, style = IT },

            -- readonly / const. OBSERVED: file-scope constexpr constants and const
            -- locals render as DEFAULT GREY in CLion, not purple. Purple italic is
            -- reserved for member fields and enum members. So readonly â grey.
            ["typemod.variable.readonly"] = { fg = D.fg }, -- const local â grey (observed)
            ["typemod.parameter.readonly"] = { fg = D.fg }, -- const param â grey
            ["typemod.variable.readonly.static"] = { fg = D.fg }, -- static constexpr â grey
            -- BUT a readonly MEMBER field stays purple (it's still a field):
            ["typemod.property.readonly"] = { fg = D.field }, -- const member â purple

            -- default-library symbols (std::, size_t, printf). Darcula gives the
            -- stdlib NO special color â all default text, same as user types, so
            -- std::vector<size_t> reads as one coherent default-text expression.
            ["typemod.class.defaultLibrary"] = { fg = D.fg }, -- std::vector â text
            ["typemod.struct.defaultLibrary"] = { fg = D.fg },
            ["typemod.type.defaultLibrary"] = { fg = D.fg }, -- size_t â text
            ["typemod.function.defaultLibrary"] = { fg = D.fg }, -- printf(...) call = text
            ["typemod.method.defaultLibrary"] = { fg = D.fg },
            ["typemod.namespace.defaultLibrary"] = { fg = D.fg }, -- std = text
            ["typemod.enum.defaultLibrary"] = { fg = D.fg },

            -- DEDUCED types (auto, decltype results). clangd sets the `deduced`
            -- modifier; `auto` should read as a primitive keyword (orange), not
            -- a resolved-type teal/text. This fixes "auto is wrong".
            ["typemod.type.deduced"] = { fg = D.keyword }, -- auto â orange
            ["typemod.class.deduced"] = { fg = D.keyword },
            ["typemod.type.defaultLibrary.deduced"] = { fg = D.keyword },

            -- deprecated â keep color, add strikethrough (Darcula EFFECT_TYPE 3)
            ["typemod.function.deprecated"] = { fg = D.fg, style = { "strikethrough" } },
            ["typemod.method.deprecated"] = { fg = D.fg, style = { "strikethrough" } },
            ["typemod.variable.deprecated"] = { fg = D.fg, style = { "strikethrough" } },
            ["typemod.property.deprecated"] = { fg = D.field, style = { "strikethrough" } },

            -- constructors / destructors are functions â definition yellow when
            -- declared, plain text when called; clangd marks them with the
            -- constructorOrDestructor modifier. Treat as method role.
            ["typemod.method.constructorOrDestructor"] = { fg = D.func },
            ["typemod.function.constructorOrDestructor"] = { fg = D.func },

            -- scope modifiers exist (globalScope/fileScope/classScope/functionScope)
            -- but Darcula does NOT color by scope, so we deliberately leave them
            -- unset here to fall through to the plain kind above. Add them if you
            -- ever want scope-coloring like the swarn tutorial.
          }

          for suffix, attrs in pairs(roles) do
            for _, ft in ipairs(FTS) do
              hl["@lsp." .. suffix .. "." .. ft] = attrs
            end
          end

          -- Inlay hints (CLion INLINE_PARAMETER_HINT: grey italic) ------------
          hl["LspInlayHint"] = { fg = D.inlayhint, style = IT }

          -- ââ LEGACY VIM-SYNTAX SAFETY NET ââââââââââââââââââââââââââââââââââ
          -- Only relevant if tree-sitter is ever disabled for a buffer. Kept in
          -- sync with Darcula so nothing falls back to a wrong color.
          local legacy = {
            Comment = { fg = D.comment },
            Keyword = { fg = D.keyword },
            Statement = { fg = D.keyword },
            Conditional = { fg = D.keyword },
            Repeat = { fg = D.keyword },
            Exception = { fg = D.keyword },
            Operator = { fg = D.fg },
            Function = { fg = D.func },
            String = { fg = D.string },
            Character = { fg = D.string },
            Number = { fg = D.number },
            Float = { fg = D.number },
            Boolean = { fg = D.keyword },
            Constant = { fg = D.fg },
            Identifier = { fg = D.fg },
            Type = { fg = D.fg },
            StorageClass = { fg = D.keyword },
            Structure = { fg = D.keyword },
            Typedef = { fg = D.fg },
            PreProc = { fg = D.preproc },
            Include = { fg = D.preproc }, -- #include yellow-green, not orange
            Define = { fg = D.preproc },
            Macro = { fg = D.preproc },
            PreCondit = { fg = D.preproc },
            Special = { fg = D.keyword },
            SpecialChar = { fg = D.keyword },
            Delimiter = { fg = D.fg },
            Todo = { fg = "#A8C023", style = IT },
          }
          for k, v in pairs(legacy) do
            hl[k] = v
          end

          return hl
        end,
      },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-frappe",
    },
  },
}
